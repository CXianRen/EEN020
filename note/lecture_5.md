+ lecture 5 note : https://www.maths.lth.se/matematiklth/personal/calle/datorseende19/notes/forelas5.pdf

#### For section 1.1

For $P_1$ and $P_2$, we can apply H to both camera.
``` math 
\~x = P_1 \bar{X} = (P_1 H) (H^{-1} \bar{X})
```
```math 
\~y = P_2 \bar{X} =  (P_2 H) (H^{-1} \bar{X})
```
We can always find an H like 
``` math
H = 
[\begin{matrix} 
A_1^-{-1} & -A_1^{-1}t_1 \\
0 & 1
\end{matrix}]
```
to make $P_1H = [I | 0]$
```math
P_1H = [A_1 | t_1] 
[\begin{matrix} 
A_1^-{-1} & -A_1^{-1}t_1 \\
0 & 1
\end{matrix}]
= [I | 0]
```
So, there are new cameras $P_1'=[I|0]$ and $P_2'=P_2H$ and new struction $\~{X'}= H^{-1}\~{X}$ we need to estimated. 

#### for section 2 exercise 1



#### for PPT page 11
+ line-plane relation 
  
```math 
x^Tl = 0 = (PX)^Tl=0 = X^TP^Tl = 0 = X^T\Pi = 0
```
So 
```math
\Pi = P^Tl
```


### What problem in lecture 5 we are trying to solve.
+ estimate P2 with just matching points. 

The problem:
given 2 images, and the matched points x,y in 2 images. How to get P1, P2, and X

+ convert P1 and P2 into cameras $P_1 = [I|0]$ and $P_2=[A|t]$, then the problem became find $P_2$

+ then we have $y^TFx=0$ (we can get this equation by three ways.), where $F= [t]_xA$. The problem became find F.

+ build the matrix M and solve MF=0 (SVD)


### QA
(1) why $Fe_1=0$
+ $e_2$ is $e_1$ matching point in image 2. And $e_2 F e_1 = 0$, $e_2 !=0$ thus $Fe_1=0$
``