# GPS Satellite Visibility from a User Position

This project computes which GPS satellites are visible from a fixed user position on Earth at a given time using MATLAB.

## Overview

The objective is to determine the **Line of Sight (LoS)** coverage between a user receiver and GPS satellites.  
For each satellite, the code computes:

- **ECEF position**
- **Pointing vector** from user to satellite
- **Local NED coordinates**
- **Distance**
- **Azimuth**
- **Elevation**

A satellite is considered visible if its elevation is greater than **10° above the horizon**.

## Repository Structure

```text
.
├── main4.m
├── almanac.m
...
├── kepler2ecef.m
├── lla2xyz.m
├── ecef2ned.m
├── ned2spherical.m
├── viewsat.m
├── FOTOS/
│   └── (result images)
└── README.md
```
## Method

The program follows these steps:

1. Read GPS almanac data.
2. Define the user position in latitude, longitude, and height.
3. Convert the user position from **LLA** to **ECEF**.
4. Compute the ECEF position of each GPS satellite.
5. Build the pointing vector from the user to each satellite.
6. Transform the vector from **ECEF** to **NED** coordinates.
7. Convert NED coordinates into:
   - distance
   - azimuth
   - elevation
8. Select satellites with **elevation ≥ 10°**.
9. Plot visible satellites in the user sky view.

## User Position

The current implementation uses the **EETAC** position as the receiver location.

## Visibility Criterion

A satellite is considered usable only if:

```matlab
elevation >= 10
```
This threshold reduces low-elevation satellites, which usually provide poorer signal quality.

## Results

The folder [`FOTOS`](./FOTOS) contains example images of the obtained results and sky visibility plots.

## Notes

- Angles are handled in **degrees** when checking visibility and plotting.
- The code uses the **WGS84 ellipsoid** for Earth coordinates.
- The local reference frame used is **NED (North-East-Down)**.
