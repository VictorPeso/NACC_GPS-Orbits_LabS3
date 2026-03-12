% Compute current time and date and download almanac (if necessary)

function[baseweek, esec, NS, Eph] = almanac(DD, MM, YYYY, hh, mm, ss)	% OPTIONAL arguments to override current time (hh must be UTC !)

ToAlist = [061440, 147456, 233472, 319488, 405504, 503808, 589824];		% list of possible ToA (secs.) within the GPS week according to Celestrak web page
timelapse = 3600;									% time interval in seconds (starting from NOW) for which the almanac should be valid

% Find GPS time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%/

if (nargin == 0)
    unixepoch = 2440587.5;                            % JD at unix epoch: 0h (UTC) 1/1/1970
    ntime = clock();								  % Matlab and clock() give local time
    YYYY = ntime(1);
    unixmillis = java.lang.System.currentTimeMillis;  % milliseconds from unix epoch
    JD = unixepoch + unixmillis / 1000 / 86400;       % Julian Date now in UTC
    % fprintf("computing 'esec' for NOW\n");
else
    JD = JDfromUTC(hh, mm, ss, DD, MM, YYYY);         % OVERRIDE CURRENT TIME
    % fprintf("computing 'esec' for %d/%d/%d %02d:%02d:%02d\n", DD, MM, YYYY, hh, mm, ss);
end

gpsepoch = 2444244.5;                               % JD at GPS epoch: 0h (UTC) 6/1/1980
leapseconds = 18;                                   % leap seconds added to UTC since the GPS epoch. Currently (28/9/2020) 18
gpst = JD - gpsepoch + leapseconds / 86400;         % GPS time (accounting for the leap seconds introduced to UTC time since the GPS epoch)
gpsw = fix(gpst / 7);                               % GPS week
gpstw = gpsw * 7;                                   % GPS time (in days) at week epoch
gpstime = 86400 * (gpst - gpstw);                   % elapsed seconds from last week epoch
roll = fix(gpsw / 1024);                            % number of gps week rollovers that have happened (first rollover: 23:59:47 (UTC) 21/8/1999)
gpsw = mod(gpsw, 1024);

fprintf('GPS week number = %4.0f (%4.0f + %2.0f rolls)\n', gpsw + 1024 * roll, gpsw, roll);
fprintf('elapsed seconds from GPS week epoch = %010.3f\n', gpstime);

% Download current GPS almanac
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%/
limit = 7200;										% obsolescence limit of the ephemeris (secs.)
baseurl = ['http://celestrak.com/GPS/almanac/YUMA/', num2str(YYYY), '/almanac.yuma.week'];
baseweek = gpsw;
esec = gpstime;

for(i = 1:10)
   j = mod(i - 1, 7) + 1;                            % j = 1,2,3,4,5,6,7,1,2,3
   if (j < i)
      baseweek = gpsw + 1;                           % we compute for current week but using an almanac from next week !!
      esec = gpstime - 7 * 86400;                    % esec = seconds from now until start of next week (< 0 !!)
   end
   if (esec + timelapse >= ToAlist(j) + limit)
      continue
   else
      sufix = sprintf('%04.0f.%06.0f', baseweek, ToAlist(j));
      break
   end
end

url = [baseurl sufix '.txt'];					% build complete URL to download almanac
filename = ['almanac_week_' sufix '.txt'];		% build file name for almanac
% if (~exist(filename, 'file'))                  % this looks at all path !! (not only current directory)
if (~size(dir(filename), 1))                    % this looks in current folder only
   urlwrite(url, filename);                     % download current almanac and store it with filename
end
fid = fopen(filename, 'r');						% read ephemeris from almanac

% fprintf("exporting ephemeris from ""%s""\n\n", filename);
NS = 0;
while (true)
  [~, count] = fscanf(fid, '%c', 45);		% read label
  if (count == 0) break; end;
  for (i = 1:13)
    fscanf(fid, '%c', 25);
    [Eph(NS + 1, i), count] = fscanf(fid, '%f');
  end
  if (Eph(NS + 1, 2) == 0) NS = NS + 1; end;
end

fclose(fid);
end

