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

####  Computer exercise 1

####  Computer exercise 2

### Levenberg-Marquardt for Structure from Motion Problems

####  Theoratical exercise 3

+ (1)

let $Z_{ij}=P_iX_j$, then

``` math
r_i(X_j) = (x_{ij,1} - \frac{Z_i^1}{Z_i^3},
x_{ij,2} - \frac{Z_i^2}{Z_i^3})
```

Because $J_i(X_j) = \nabla r_i(X_j)$ and:
```math
\nabla r_i(X_j) = (\frac{\partial{r_{i,1}}}{\partial{X_j}}, \frac{\partial{r_{i,2}}}{\partial{X_j}})
```

For $\frac{\partial{r_{i,1}}}{\partial{X_j}}$, we have:
```math 
\frac{\partial{r_{i,1}}}{\partial{X_j}} = \frac{\partial{r_{i,1}}}{\partial{Z_{ij}}} * \frac{\partial{Z_{ij}}}{\partial{X_j}}
```
And,
```math
\frac{\partial{r_{i,1}}}{\partial{Z_{ij}}} = \frac{\partial{}}{\partial{Z_{ij}}}(-\frac{Z_{ij}^1}{Z_{ij}^3}) = - \frac{
  Z_{ij}^3 \frac{\partial{Z_{ij}^1}}{\partial{Z_ij}} -  Z_{ij}^1 \frac{\partial{Z_{ij}^3}}{\partial{Z_ij}}
}{(Z_{ij}^3)^2}
= -\frac{Z_{ij}^3 *[1,0,0] - Z_{ij}^1 *[0,0,1] }{(Z_{ij}^3)^2}
```
Because $\frac{\partial{Z_{ij}}}{\partial{X_j}} = P_i = [P_i^1, P_i^2, P_i^3]^T$
Then:
```math
-\frac{Z_{ij}^3 *[1,0,0] - Z_{ij}^1 *[0,0,1] }{(Z_{ij}^3)^2} *  [P_i^1, P_i^2, P_i^3]^T = -\frac{Z_{ij}^3 P_i^1 - Z_{ij}^1 P_i^3 }{(Z_{ij}^3)^2}
```
Thus:
``` math 
\frac{\partial{r_{i,1}}}{\partial{X_j}} =  \frac{-P_{i}^3X_j P_i^1 + P_{i}^1X_j P_i^3 }{(P_i^3X_j)^2} = 
\frac{P_{i}^1X_j P_i^3 }{(P_i^3X_j)^2} - \frac{P_i^1}{P_i^3X_j}
```
Similar we can prove:
```math
\frac{\partial{r_{i,2}}}{\partial{X_j}} =  \frac{P_{i}^2X_j P_i^3 }{(P_i^3X_j)^2} - \frac{P_i^2}{P_i^3X_j}
```
+ (2)

for any given $i$, we have:
```math 
\|r_i(X_j)+J_i(X_j){\delta} X_j \|^2 = \|[r_{i,1}(X_j)+J_{i,1}(X_j){\delta} X_j, r_{i,2}(X_j)+J_{i,2}(X_j){\delta} X_j]^T\|^2
```

let $e_{2k-1}=r_{i,1}(X_j)+J_{i,1}(X_j){\delta} X_j, e_{2k}=r_{i,2}(X_j)+J_{i,2}(X_j){\delta} X_j $, $k\in [1,m]$ we have:
```math 
\|r_i(X_j)+J_i(X_j){\delta} X_j \|^2 =  \| [e_{2k-1},e_{2k}]^T \|^2 = [e_{2k-1},e_{2k}]^T [e_{2k-1},e_{2k}] = e_{2k-1}^2+e_{2k}^2
```
Thus we have:

```math
\sum^{m}_{i=1} \|r_i(X_j)+J_i(X_j){\delta} X_j \|^2 = \sum^{m}_{i=1} e_{2i-1}^2+e_{2i}^2 = [e_1,e_2,...,e_{2k-1},e_{2k}]^T [e_1,e_2,...,e_{2k-1},e_{2k}] = \|r(X_j)+J(X_j){\delta} X_j \|^2
```
diemnsions of $r(X_j)$ and $J(X_j)$ is $2m$.


####  Computer exercise 3

####  Computer exercise 4 (Optional)

####  Theoratical exercise 4 (Optional)

+ (1)

```math
\nabla F(v)^T d = \nabla F(v)^T M \nabla F(v) = - \nabla F(v)^T M \nabla F(v) < 0
```

+ (2)

from (10), we know
```math 
d = −(J(v)^T J(v) + \mu I)^{-1} J(v)^Tr(v)
```

Then:
```math
-\nabla r(v)^T (J(v)^T J(v) + \mu I)^{-1}J(v)^Tr(v)
```
