#include <stdio.h>
#include <math.h>

#define MAXIT 100

float muller(float (*func)(float), float p0, float p2, float xacc) {
    float p1, p3, t0, t1, f0, f1, f2, a, b, c, denominator, dx;

    p1 = (p0 + p2) / 2;

    // p0 ~ p2 사이에서 Root를 찾을 때까지 반복
    for (int i = 0; i < MAXIT; i++) {
        t0 = p0 - p2;
        t1 = p1 - p2;

        f0 = (*func)(p0);
        f1 = (*func)(p1);
        f2 = (*func)(p2);

        denominator = (p0-p2) * (p1-p2) * (p0-p1);
        if (fabs(denominator) < 1e-10) {
            printf("0으로 나누는 것은 불가능합니다.\n");
            return p2; // 0으로 나누는 것을 방지하기 위함
        }

        a = ((p1-p2) * (f0-f2) / denominator) - ((p0-p2) * (f1-f2) / denominator);
        b = ((p0-p2) * (p0-p2) * (f1-f2) / denominator) - ((p1-p2) * (p1-p2) * (f0 - f2) / denominator);
        c = f2;

        if (b > 0.f) {
            dx = -2 * c / (b + sqrt(b*b - 4*a*c));
            p3 = p2 + dx;
        }
        else {
            dx = -2 * c / (b - sqrt(b*b - 4*a*c));
            p3 = p2 + dx;
        }

        if (fabs(dx) < xacc || (*func)(p3) == 0.0) {
            return p3;
        }

        p0 = p1;
        p1 = p2;
        p2 = p3;
    }
    
    return 0.f;
}