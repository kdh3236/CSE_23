2025-1학기 수강

**Instructor**: 한양대학교 이성윤 교수님

____

1. AI의 한 축은 **인간 지능을 모방**하는 것이다.

2. 인간 지능이 만드는 입력→출력 매핑은 **매우 복잡한 비선형 함수**로 볼 수 있다.

3. 이 함수를 다루기 위해 **미분(미적분)을** 사용해 기울기/야코비안 등의 정보를 구한다.

4. 그 결과, 한 점 근처에서 **Linear approximation**를 형성한다(1차 테일러 전개).

5. 이 **Linear approximation는 Linear transformation**이고, **각 축에 대한 Linear transformation은** **Matrix**로 표현된다.

    - Matrix는 Linear function이다.
  
6. Matrix를 다루기 위해 **Linear algebra**도 필요하다. 

___

**Machine Learning**이란?

Computer가 Data를 이용하여 특정 Task를 하는 방법을 배우는 과정이다. 배움의 정도를 P를 통해 검증할 수 있다.

- Task는 Function H (Hypothesis)를 배우는 것이다.
- Performance measure P: Posterior이다.
- Prior와 Data를 기반으로 가장 좋은 Hypothesis를 알아내는 방법에 MAP를 사용한다.
    - Data에 Data가 표현하지 못 하는 Noise가 끼어있어 Hypothesis가 Gaussian distribution 형태를 띈다. MAP를 사용하는 이유는 이 분포에서 가장 좋은 값을 찾기 위함이다.
 
ML은 Bayesianist 관점에서 말도 안되는 것이다.
- ML은 Prior가 존재하지 않는 MAP이며, 이 경우에는 Data만을 가장 잘 설명하는 Hypothesis를 찾는 것으로 생각하면 된다.

**P((x, y)|H): H라는 가설, 세계 위에서 (x, y)라는 데이터 쌍이 관측될 확률**

- Machine Learning에서 최대화할 대상이다.

**p((x, y)|H) = p(y|x, H)p(x|H)이다.**

- 여기서 **p(x|H)는 H가 데이터의 분포에는 영향을 미치지 않는다고 가정하고 무시**하자.

즉, **Machine learning의 목표는 p(y|x, H)를 최대화하는 것과 동일**해진다.  


____

Regression은 **Gaussian distribution과 비슷**하다.

- Factor x에 의해 결정되는 y를 예측하는데 y를 결정하는데는 **x뿐만이 아니라 다른 수많은 요소들도 들어가기 때문에 p(y|x, H)는 CLT에 의해 Gaussian distribution을 따른다.**
- 이때, **Gaussian distribution은 평균을 h(X)로 갖는 분포**이다.
- **p(y|x, H)에서 x와 평균 h(x)가 주어졌을 때, y와 h(x)의 거리의 차이를 최대한 가깝게 해야 p(y|x, H)가 커진다.**
- NLL을 p(y|x, H), Gaussian에 적용하면 MSE 형태가 된다.
- **H(X)를 선형 함수로만 한정하면 Linear regression**이라고 할 수 있다.
- H(X) = ax + b의 형식으로 나타낼 수 있고, a, b를 조절하여 가장 좋은 H(x)를 찾는다.


때문에 NLL을 하면 **Gaussian distribution을 NLL하는 것과 동일하고 평균이 h(x)인 MSE를 수행**하게 된다.

Classification은 **Bernoulli/Categorical distribution**과 비슷하다.

- h(x)는 x라는 Input이 특정 Class일 확률을 나타내주는 함수로 생각할 수 있다.
- Bern(y|theta)에서 theta 대신에 h(x)를 사용하는 것이다.

Logistic regression에서는 살짝 달라진다.

- Decision boundary h(x) = Wx
- h(x)는 x가 주어졌을 때, **Decision boundary와 데이터 사이의 거리를 측정**한다.
- **거리를 Sigmoid, Softmax에 넣어 해당 데이터가 특정 Class일 확률(0 ~ 1)을 측정**한다.
- NLL을 적용하면 $\text{NLL} = - [ y \log(h(x)) + (1-y) \log(1 - h(x)) ]$ 형태로 나온다.
- 위 값이 클수록 Classification이 정확하지 않음을 의미한다.
- 이때 L(x)를 미분해서 W를 찾는 것은 비교적 어렵다.
