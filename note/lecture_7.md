# what is the problem we are gonna solve in this lecture ?

We learnt:
  + Camera module: P = K(R|T),x = P K(R|T)X
  + Apply H to both camera, we can make $P_1=(I|0)$, $P_2=(A|t)$ 
  + using matched point to estimated camera: $y^TFx=0$, P can be extracted from $F$ (no very dietals about this step).
  + actually, we use $E$ to elimated projective ambiguity. (so we have to calibrate the camaera first. what if we don't know K? then how we can calibate it?)
  + we get P1 and P2, then using triangle DLT to get X.

The whole system (ppt page 6):
  + first compute the first pair of cameras and scene points.
  + for the rest cameras, using matching points and scene points to compute P directly (DLT).
  + compute new scene poit using triangulation (DLT).


So the problem is: If there are many mismatched point, the result will not be quite as precise. (Outlier problem)

(should there any labs here to show it?)

(Todo how to elimate projective ambiguity?)(using calibrated camera!).

## RANdom Sampling Consensus
  + based on the proportion of outliers is samll.
  
  + compute E with a subset of matched points.
  + evaluate the result  (how to ?, 计算后，重投)
    + the code should like:
    ```cpp
    ?
    ```

### here, the slide proposaled a line fitting example. (why is line nor other?)
  + each time, compute a line with 2 random picked points.
  + do many time.
  + get the result. 

#### Question：
  + how do we know how many iterations we need? (can be formulated by probility)
    + let $\epsilon$ be the fraction of the inliers.
    + let S be the number of points we need for estimating.
    + $(1-\epsilon)^S$ is the probability of containing at least one outlier.
    + Then, we do it for $T$ times, $((1-\epsilon)^S)^T$ is the probability of $T$ itersions all contain at least one outlier.
    + then the probality of T times do not contain outlier is $1- ((1-\epsilon)^S)^T = \alpha$
    Then
    ```math 
    (1-\alpha) = ((1-\epsilon)^S)^T
    ```
    ```math 
    (1-\alpha) = ((1-\epsilon)^S)^T
    ```
    ```math 
    log_{(1-\epsilon)^S}(1-\alpha) = T
    ```
    Because (换底公式)
    ```math
    log_ab = \frac{log_cb}{log_ca}
    ```
    Thus:
    ```math
    T =  \frac{log(1-\alpha)}{\log(1-\epsilon)^S}
    ```

#### Question
  + How many iterations do we really need? (we don't kow $\epsilon$) 
    + in the slide: using initial $\epsilon = 0.1$, and update it during the iterations. (how?) (see the ppt page 33)
      + calculate an estimated result, evaluted the consesus set, then update $\epsilon$. (what if, a bad result, the  $\epsilon$ comes to be lower? PPT 35, just skip it?)
    + and it also stated: the number of iterations acutally 3-4x higher. (why?)


### Model Fitting
  From equation above, we can knows, T decreases as s dreacres.

  (how faster it will be if we use 7-points algorithm vs 8-points algortihm).

#### 7-points Algorithm. 
  + $Mf = 0$ 
  + $f = u_2 + t(u_1-u_2)$
  + $u_1, u_2 \in null(M)$
  + get t from a CAS(Maxima)