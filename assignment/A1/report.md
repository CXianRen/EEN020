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

  Thus, homogeneous poit of interstion is $(-2,7,-9)^T$, or equivalently, $(\frac{2}{9},\frac{7}{9},1)^T$, by dividing out the third coordinate. And the corresponding point int $\R^2$ is $(\frac{2}{9},\frac{7}{9})^T$.

+ (2) 
  Same as (1), we the corss production of tow lines is: $0i+(-17)j+0k$, thus the interstion point is $(0,-17,0)$. It meant the two lines do not intersect at a finite point on the Euclidean plane.

+ (3)
  Let $l=(a,b,c)^T$ denotes the line passing through point $x_1$ and $x_2$ (in homogeneous coordination). Then $x_1$ and $x_2$ must lie on the line. Thus, $x_1^Tl=0$ and $x_2^Tl=0$. The vector represnted by $l$ must be orthogonal to both $x_1$ and $x_2$. And such a vector is the cross production of the vectors represented by $x_1$ and $x_2$. So, the line is:

  ```math
  x_1 \times x_2 = (-1,1,1)^T \times (6,3,1)^T = (-2)i+7j+(-9)k
  ```

  Thus, the homogeneous representation of $l$ is $(-2,7,-9)^T$, or equivalently,  $(\frac{2}{9},\frac{7}{9},1)^T$, by dividing out the third coordinate. 
  <!-- https://cseweb.ucsd.edu/classes/sp06/cse152/hw1sol.pdf -->

---
####  Theoratical exercise 3
+ (1)
  Lex $x$ denotes the intersection point, and $l_1,l_2$ denote the homogeneous representations of the two lines. Tthe intersection point of two line must lie on both line (obviously). Thus, $l_1^Tx=0,l_2^Tx=0$, then $x$ must be orthogonal to both lines. Such vector, represented by the point $x$, should be the cross production. So there will be only one result in $P^2$, just the intersection point. 


####  Computer exercise 2
+ Plotted figure for (1)(2)(3)
  ![img](./ce_2.png)

+ for (2)
  these lines appear to beparallel in 3D. 

+ for (4), the code of (point_line_distance_2D) is below:
  ```matlab
  function [dist] = point_line_distance_2D(p,line)
  %POINT_LINE_DISTANCE_2D Summary of this function goes here
  %   Detailed explanation goes here
  a=line(1);
  b=line(2);
  c=line(3);
  x1=p(1);
  x2=p(2);

  dist =abs(a*x1+b*x2+c)/sqrt(a*a+b*b);
  end
  ```
+ for (5), the distance between $l_1$ and the interescetion point is 8.2695, not close to 0 in purely numerical terms. It is because the size of the image is up to (1300,1900). After being normalized, the distance is quite small. So three lines can be considered as intersecting at a single point.


---
### 4 Projective Transformations
####  Theoratical exercise 4

+ (1) 
  ```math
  y_1= \begin{pmatrix} 1 & 1 & 1\end{pmatrix}^T \\
  y_2= \begin{pmatrix} 1 & 2 & 0\end{pmatrix}^T \\

  ```
+ (2)
  ```math
  l_1=\begin{pmatrix} -1 & -1 & 1\end{pmatrix}^T \\
  l_2=\begin{pmatrix} -2 & 1 & 1\end{pmatrix}^T \\
  ```
+ (3)
  ```math
    (H^{-1})^Tl_1 = \begin{pmatrix} -1 & 0.5 & 0.5 \end{pmatrix}^T = 
    \begin{pmatrix} -2 & 1 & 1\end{pmatrix}^T = l_2 
  ```

####  Theoratical exercise 5
+ (1)
  ```math
   0 = l_1^Tx = l_1^TIx=l_1^TH^{-1}Hx = ((H^{-T}l_1)^T)(Hx) = l_2^Ty
  ```
  After transformation, $y=Hx$ lie on $l_2$ when $l_2=H^{-T}l_1$.

####  Theoratical exercise 6
+ (a) $H_1$ $H_2$ $H_3$  $H_4$
+ (b) $H_1$
+ (c) None of them is similarity transformations.
+ (d) None of them is Euclidean.
+ (e) None (Euclidean)
+ (f) $H_1$ $H_2$ $H_3$  $H_4$
+ (g) $H_1$ (Affine, Similarity, Euclidean)


---
### 5 The Pinhole Camera
####  Theoratical exercise 7
  + (1)
  ```math 
    X_1^{*} = \begin{pmatrix} \frac{1}{5} & \frac{2}{5} & 0 & 1 \end{pmatrix}^T \\
    X_2^{*} = \begin{pmatrix} \frac{1}{6} & \frac{1}{6} & \frac{1}{3} & 1 \end{pmatrix}^T \\
    X_3^{*} = \begin{pmatrix} \frac{1}{2} & \frac{1}{4} & \frac{-1}{2} & 1 \end{pmatrix}^T
  ```
  the projection of $X_1$ means : ? 
  <!-- todo -->
  + (2)
  The center of camera is:
  ```math
  C = \begin{pmatrix} 0 & 0 & 1 \end{pmatrix}^T
  ```
  The principle aix is: 
  <!-- todo which direction it should be? how to determinate it? -->
  