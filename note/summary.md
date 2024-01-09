### Knonw X and x 
if we knows X (3d-points of a kown project) and x corresponding projections

we have 
```math
{\lambda}_1 x_1 = P X_1 \\ 
{\lambda}_2 x_2 = P X_2 \\
... \\
{\lambda}_N x_N = P X_N \\  
```
There are 3N equations and 11 ($P \in R^{3,4} $, the last elements/scale can be 1.) + N (N $\lambda$) unknonws. -> at least 6 points to get P.

#### how to solve P (simple)? 

```math
{\lambda}_1 x_1 - P X_1 = 0 \\ 
{\lambda}_2 x_2 - P X_2 = 0\\
... \\
{\lambda}_N x_N - P X_N = 0 \\  
```
slove Mv = 0. $v$ is the P and $\lambda$ we need. (PPT lecture 3 page 42.)

#### how to avoid $\lambda$ (standard)?
+ considering the cross product of $x$ and $PX$.
  because in $R^3$,  vector $\lambda x $ and $PX$ are collinear.

#### Thus we can eassily get $y = Hx $, if given corresponding points y and x, by solving the same problem. !!!

