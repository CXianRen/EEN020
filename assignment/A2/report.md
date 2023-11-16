# Assignment 2
+ 2023-11-20
+ Honggang Chen, CID: chenhon 
---
### 2 Calibrated vs. Uncalibrated Reconstruction.
####  Theoratical exercise 1
+ (1)

For estimated points $X$ in 3D space and camera P, the projected points in P is:
```math
  {\lambda}x = PX
```
For any projective transformation $T$ of 3D space to $X$, we have:
```math
  X' = TX
```
Then:
```math
  {\lambda}x = PX = PT^{-1}TX = (PT^{-1})(TX)
```
Where $PT^{-1}$ is the new camera for the new 3D points $X'$.

