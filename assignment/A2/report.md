# Assignment 2
+ 2023-11-20
+ Honggang Chen, CID: chenhon 
---
### 2 Calibrated vs. Uncalibrated Reconstruction.
####  Theoratical exercise 1
+ (1)

For estimated points $X$ in 3D space and camera P, the projtective points in P is:
```math
  {\lambda}x = PX
```
For any projective transformation $T$ of 3D space to $X$, we have:
```math
  X' = TX
```
Then:
```math
  {\lambda}x = PX = PT^{-1}TX = (PT^y{-1})(TX)
```
Where $PT^{-1}$ is the new camera for the new 3D points $X'$.

####  Computer Exercise 1
code file "run1.m" is for this task.
+ (1) 
plot the 3D points of the reconstruction.  
No, the physical properties doesn't look realistic.  
![](./c1_1.png)  

+ (2)  
plot the image, the projtective points and the image points in the same figure.  
(**Here I plot the first image**)  
red + are projtective points from 3D points **X**. blue o are image points from **x**  
These points are matched very well.
![](c1_2/../c1_2.png)  

+ (3)  
$T_1X$ with cameras.  
![](./c1_T1.png)  
$T_2X$ with cameras.  
![](./c1_T2.png)  
<!-- Todo: answer for: what happened to the 3D points? Does any of them appear reasonable? -->

+ (4)  
Project $T_1X$  and $T_2X$ into new corresponding cameras. (Here we still choose the first view. Red '+' are projtective points from $T_iX$)  
$T_1X$ projtective points  
![](./c1_4_T1.png)  
$T_2X$ projtective points  
![](./c1_4_T2.png)


####  Theoratical exercise 2
<!-- TODO: what is the same projective distortions mean? the distortions in images? or the reconstructions? -->
+ (1)  

When we use calibrated camera, $P=(R|T)$. If ${\lambda}x = (R|T)X$, then for any similarity transformation:
```math
  \~{X} = 
\begin{pmatrix}
sQ & v \\
0 & 1
\end{pmatrix}^{-1}X
``` 
we have
```math 
  \frac{{\lambda}}{s}x = (R|T) 
  \begin{pmatrix}
    sQ & v \\
    0 & 1
  \end{pmatrix}^{-1} \~X = 
  (RQ|\frac{1}{s}(RV+T))X
```
Since RQ is a rotaion, so the new camera $(RQ|\frac{1}{s}(RV+T))$ is still calibrated. So there will not be projective distortions to the reconstruction.
And the projective ambiguity is elimiated, but there is still similarity ambiguity to the reconstruction. 

---
### 3 Camera Calibration
+ (1)
Because $T*T^{-1}=I$, we can esaIly verify it like:
```math 
  K*K^{-1} = 
\begin{pmatrix}
f & 0 & x_0 \\
0 & f & y_0 \\
0 & 0 & 1 
\end{pmatrix} 
\begin{pmatrix}
1/f & 0 & -x_0/f \\
0 & 1/f & -y_0/f \\
0 & 0 & 1 
\end{pmatrix} =
\begin{pmatrix}
1 & 0 & 0 \\
0 & 1 & 0 \\
0 & 0 & 1 
\end{pmatrix} = I  
```

+ (2) 
Similary as above, we have:
```math 
  A * B = 
\begin{pmatrix}
1/f & 0 & 0 \\
0 & 1/f & 0 \\
0 & 0 & 1 
\end{pmatrix}
\begin{pmatrix}
1 & 0 & -x_0 \\
0 & 1 & -y_0 \\
0 & 0 & 1 
\end{pmatrix}
= 
\begin{pmatrix}
1/f & 0 & -x_0/f \\
0 & 1/f & -y_0/f \\
0 & 0 & 1 
\end{pmatrix} = K^{-1}
```
+ (3)
The geometric interpretation of the transformations A and B is to
move a point $(x,y)$ by adding vercotr $(-x_0,-y_0)$ then scale it with factor $1/f$ in both x and y directions.

+ (4)
The interprtation of this operation is to conver the points from sensor coordination system back to image coordination system. the principal point $(x_0,y_0)$ ended up at $(0, 0, 1)$ . A point with distance f to the pricipal point ended up at the cycle whoes center is at $(0,0,1)$ and r = 1.
<!-- todo, meaning the point is at a cycle? -->


+ (5)

We can get $K^{-1}$:
```math 
K^{-1} = 
\begin{pmatrix}
1/400 & 0 & -1 \\
0 & 1/400 & -0.75 \\
0 & 0 & 1 
\end{pmatrix}
```
So the normalize points are:
```math 
(0,300) \sim (-1, 0,1) \\
(800,300) \sim (1,0,1)
 ```
let A denote $(-1, 0,1)$, B denote $(1,0,1)$,$\theta$ denote the angle of two viewing rays:
``` math 
\theta = arcos(\frac{A \cdot B}{\|A\|\|B\|}) = \frac{\pi}{2}
```

+ (6)
<!-- Todo: how to prove it? -->
For camera $[R|t]$, assuming its center is $C$, then we have:
```math 
  [R|t]C = 0
```
Now, for camera $K[R|t]$, apply it to $C$, we have:
```math
  K[R|t]C = K ([R|t] C) = K 0 = 0 
```
So camera $K[R|t]$ has same camera center as camera $[R|t]$.

As for the principal axis of camera $[R|t]$, we have
```math
  RX = (0,0,1)^T
```
Thus:
```math
  X = R^T(0,0,1)^T =  (R_{3,1}, R_{3,2}, R_{3,3})^T
```
Where $i,j$ is the index of rows and colums of R.

Then for camera $P=K[R|t]$, we have
```math
  P_{3,3} = KR
```
because $K$ is an up triangle metric, so we have:
```math
  P_{3,3} = 
\begin{pmatrix}
K_{11} & K_{12}  & K_{13} \\
0 & K_{22} & K_{23} \\
0 & 0 & 1 
\end{pmatrix}
\begin{pmatrix}
R_{11} & R_{12} & R_{13} \\
R_{21} & R_{22} & R_{23} \\
R_{31} & R_{32} & R_{33} 
\end{pmatrix}
=
\begin{pmatrix}
P_{11} & P_{12} & P_{13} \\
P_{21} & P_{22} & P_{23} \\
R_{31} & R_{32} & R_{33} 
\end{pmatrix}
```
We can notice that the last row of P still same as R, thus
the solution for $P_{33}X=(0,0,1)^T$ is same as above. So, both camera (normalzed or not) have the same principle axis.