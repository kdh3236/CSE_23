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

Machine Learning이란?

Computer가 Data를 이용하여 특정 Task를 하는 방법을 배우는 과정이다. 배움의 정도를 P를 통해 검증할 수 있다.

- Task는 Function H (Hypothesis)를 배우는 것이다.
- Performance measure P: Posterior이다.
- Prior와 Data를 기반으로 가장 좋은 Hypothesis를 알아내는 방법에 MAP를 사용한다.
    - Data에 Data가 표현하지 못 하는 Noise가 끼어있어 Hypothesis가 Gaussian distribution 형태를 띈다. MAP를 사용하는 이유는 이 분포에서 가장 좋은 값을 찾기 위함이다.
 
ML은 Bayesianist 관점에서 말도 안되는 것이다.
- ML은 Prior가 존재하지 않는 MAP이며, 이 경우에는 Data만을 가장 잘 설명하는 Hypothesis를 찾는 것으로 생각하면 된다.
