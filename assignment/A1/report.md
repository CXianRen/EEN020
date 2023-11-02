# Assignment 1
+ 2023-11-13
+ Honggang Chen, CID: chenhon 
---
### 2 Points in Homogeneours  Coordinates
####  Theoratical exercise 1
+ (1)
```math
x1=
\begin{pmatrix}
2 \\
-8
\end{pmatrix}
\;\;

x2=
\begin{pmatrix}
2 \\
-8
\end{pmatrix}
\;\;


x3=
\begin{pmatrix}
1.5 \\
-0.5
\end{pmatrix}
\;\;

```

+ (2)
it means $x_4$ is an infinitely distant point.

+ (3)
$x_5$ is not the same point as $x_4$, but it is an infinitely distant point.

####  Computer exercise 1
+ pflat
```matlab
function [x_output] = pflat(x_input)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x_n = x_input(end,:);
x_output = x_input./x_n;
end
```
![x2D](./2_x2d.png)
![x3d](./2_x3d.png)

---
### 3 Lines
####  Theoratical exercise 2
+ (1)
  We can get the intersection point by calculating the cross production of two lines.
  ```math 
  cross(l_1^T, l_2^T) = 
  \begin{vmatrix}
  i  & j & k \\
  -1 & 1 & 1 \\
  6  & 3 & 1 
  \end{vmatrix} \\
  \begin{align}
   &= (1*1-1*3)*i + (1*6-(-1)*1)*j + ((-1)*3-1*6)*k  \;\;\;\;\;\\
   &= (-2)i + 7j + (-9)k
  \end{align}
  ```
  Thus. homogeneous poit of interstion is $(-2,7,-9)^T$, or equivalently, $(\frac{2}{9},\frac{7}{9},1)^T$, by dividing out the third coordinate. And the corresponding point int $\R^2$ is $(\frac{2}{9},\frac{7}{9})^T$.

+ (2) 
  Same as (1), we the corss production of tow lines is: $0i+(-17)j+0k$, thus the interstion point is $(0,-17,0)$. It meant the two lines do not intersect at a finite point on the Euclidean plane.

+ (3)
  Let $l=(a,b,c)^T$ denotes the line passing through point $x_1$ and $x_2$ (in homogeneous coordination). Then $x_1$ and $x_2$ must lie on the line. Thus, $x_1^Tl=0$ and $x_2^Tl=0$. The vector represnted by $l$ must be orthogonal to both $x_1$ and $x_2$. And such a vector is the cross production of the vectors represented by $x_1$ and $x_2$. So, the line is:
  ```math
  x_1 \times x_2 = (-1,1,1)^T \times (6,3,1)^T = (-2)i+7j+(-9)k
  ```
  Thus the homogeneous representation of $l$ is $(-2,7,-9)^T$, or equivalently,  $(\frac{2}{9},\frac{7}{9},1)^T$, by dividing out the third coordinate. 
  <!-- https://cseweb.ucsd.edu/classes/sp06/cse152/hw1sol.pdf -->