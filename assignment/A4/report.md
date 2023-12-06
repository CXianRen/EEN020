## Assignment 2
+ 2023-12-3
+ Honggang Chen, CID: chenhon 
---
### Roubust Epipolar Geometry and Two-View Reconstruction
####  Theoratical exercise 1

+ (1)

First, we can apply a similary transformation $H$ to $P_1$ and $P_2$ to make $P_1' = P_1' H = [I|0]$, where $I$ is the identity matrix, and H:
```math
  H = \begin{pmatrix}
  R_1^T & -R_1^Tt_1 \\
  0 & 1
  \end{pmatrix}
```
Thus, $P_2' = P_2 H = [R_2 R_1^T | -R_2 R_1^T t_1 + t_2]$.
Let $R_2'$ denotes $R_2 R_1^T$, $t_2'$ denotes $-R_2 R_1^T t_1 + t_2$. The essential matrix will be $E=[t_2']_x R_2' = [-R_2 R_1^T t_1 + t_2]_x R_2R_1^T$.

####  Theoratical exercise 2
+ (1)
  
An essential matrix has 5 degrees of freedom.

+ (2)

we need at least 7 point correspondences to determine E. But by the eight point solver we need 8 point correspondences. 

+ (3)

44 iterations we need.

