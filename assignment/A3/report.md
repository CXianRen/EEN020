# Assignment 2
+ 2023-12-3
+ Honggang Chen, CID: chenhon 
---
### The Fundamental Matrix
####  Theoratical exercise 1
+ (1)
```math
F= [t]_xA = 
\begin{pmatrix}
 0 & 0 & 2 \\
 0 & 0 & -2 \\
 -2 & 2 & 0
\end{pmatrix}
\begin{pmatrix}
1 & 1 & 0 \\
0 & 1 & 0 \\
0 & 0 & 1
\end{pmatrix}
=
\begin{pmatrix}
0 & 0 & 2 \\
0 & 0 & -2 \\
-2 & 0 & 0
\end{pmatrix}
```
+ (2)
```math
l_2 = F \begin{pmatrix} x^T \\ 1 \end{pmatrix} =  (2,-2,0)^T
```

+ (3)
(1,1) could be a projection of the same point X into $P_2$, because $y^TFx=0$

####  Theoratical exercise 2
+ （1）

We can get $P_2$ camera center $C_2$:
```math 
  C_2 = -P_{2_{3,3}}^{-1}*P_{2_4} =  (1,-2,0)^T 
```
Thus epopoles $e_1$:
```math 
  e_1 = P_1 \begin{pmatrix} C_2 \\ 1 \end{pmatrix} = (I|0)
  \begin{pmatrix} C_2 \\ 1 \end{pmatrix} = C_2 = (1,-2,0)^T
```
And $C_1= 0$,thus
```math 
  e_2 = P_2  \begin{pmatrix} C_1 \\ 1 \end{pmatrix} = P_{2_4} = (2,1,0)^T
```

+ (2)

```math 
F= [t]_xA= [P_{2_4}]_xP_{2_{3,3}} = \\
\begin{pmatrix}
 0 & 0 & 1 \\
 0 & 0 & -2 \\
 -1 & 2 & 0
\end{pmatrix}
\begin{pmatrix}
0 & 1 & 1 \\
3 & 2 & 0 \\
0 & 0 & 3
\end{pmatrix}
=
\begin{pmatrix}
0 & 0 & 3 \\
0 & 0 & -6 \\
6 & 3 & -1
\end{pmatrix}
```
verify $e_2^TF=0$
```math 
e_2^TF = (2,1,0) \begin{pmatrix}
0 & 0 & 3 \\
0 & 0 & -6 \\
6 & 3 & -1
\end{pmatrix}
= (0, 0, 0)
```
verify $Fe_1=0$
```math 
Fe_1 =\begin{pmatrix}
0 & 0 & 3 \\
0 & 0 & -6 \\
6 & 3 & -1
\end{pmatrix} (1,-2,0)^T
= (0, 0, 0)^T
```

####  Theoratical exercise 3（optional）
+ (1)
Because
```math
P_2 (C_2^T|1)^T = (A|t)(C_2^T|1)^T = 0 
```
Thus
```math
 C_2 = -A^{-1}t 
```
Thus
```math
 e_1 \sim P_1 (C_2^T|1)^T = (I|0)(C_2^T|1)^T = C_2 = -A^{-1}t
```
And because $C_1 = 0$
```math 
e_2 \sim P_2 (0^T|1)^T = (A|t)(0^T|1)^T = t
```
+ (2)
  
Because
```math
\begin{align} 
F^Te_2 &= ([t]_xA)^Te_2 = A^T[t]_x^Te_2 \\
&= -A^T[t]_xe_2= -A^T[e_2]_xe_2 = -A^T([e_2]_xe_2) \\
&= -A^T(e_2 \times e_2) = -A^T (0) = 0
\end{align}
```
Thus:
```math 
e_2^TF = (F^Te_2)^T = 0
```
And
``` math 
Fe_1 = [t]_xAe_1 = [t]_xA (-{\lambda} A^{-1}t)  = [t]_xAA^{-1}t = t \times t = 0
```

+ (3)
Because we know $e_1!=0$, and only when $det(F) = 0$, which means $F$ is a singluar matrix, there exist non-zero soultion for problem $Fe_1 = 0$.
<!-- todo -->

####  Theoratical exercise 4
+ (1)

```math
F = N_2^T\~FN_1
```

####  Computer exercise 1

####  Theoratical exercise 5

let $x_1$,$x_2$ denotes the prjection of the scene point into $P_1$ and $P_2$ respectively.
Then we have 
```math 
x_1 \sim  P_1 [X^T|1]^T = [I|0][X^T|1]^T = X
```
```math
x_2 \sim P_2 [X^T|1]^T = [[e_2]_xF | e_2] [X^T|1]^T =
[e_2]_xFX + e_2  
```
Therefore:
```math 
\begin{align}
x_2^TFx_1 &\sim ([e_2]_xFX + e_2 )^T FX \\ 
 &= ([e_2]_xFX)^T FX + e_2^TFX \\
 &= -(FX)^T[e_2]_x(FX) + (F^Te_2)^TX

\end{align}
```
Because $F^Te_2=0$, and $(FX)^T[e_2]_x(FX) = 0$, Thus
```math 
x_2^TFx_1  = 0
```
The projection of these points will fulfill the epipolar constraints.

let $C_2$ denotes $P_2$ camera center:
```math
P_2 \begin{pmatrix} C_2 \\ \mu \end{pmatrix} = [e_2]_xFC_2 + {\mu}e_2 = 0 
```
Because $e_1 \sim C_2$, Then 
```math
[e_2]_xFC_2 + {\mu}e_2 \sim [e_2]_xFe_1 + {\mu}e_2 = 0
```
Because $Fe_1 = 0$, then $\mu=0$, and $P_2$ camera center is
```math
 \begin{pmatrix}e_1 \\ 0\end{pmatrix}
``` 
<!-- todo how to get e_1? -->
We can get $e_2$ by computing the null space of $F^T$.
First apply elimination to $F^T$, we get 
```math 
  U \sim 
  \begin{pmatrix}
  0 & 2 & 0 \\
  1 & 0 & 1 \\
  1 & 4 & 1 
  \end{pmatrix} \sim  
  \begin{pmatrix}
  1 & 0 & 1 \\
  0 & 1 & 0 \\
  0 & 0 & 0
  \end{pmatrix}
```
Thus $e_2 = (-1,0,1)^T$.
Same, we can get $e_1$, because $e_1 \in null(F)$. $e_1 = (-2,-1,1)^T$

