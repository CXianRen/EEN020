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