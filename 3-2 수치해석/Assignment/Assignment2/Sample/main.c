#include <stdio.h>
#include <math.h>
#include <time.h>
#include "nr.h"
#include "nrutil.h"

#define XACC 1e-6

void derivative_bessel(float x, float *y, float *dy) {
    *y  = bessj0(x);  // f(x)
    *dy = -bessj1(x); // f'(x)
}

float finding_root(float (*func)(float), float (*method)(float (*func_)(float), float, float, float), 
                float *xb1, float *xb2, int nb) {
	int count = 1;
	float time = 0.f;
	clock_t start, end;
	float root;
	
	for (int i = 1; i < nb+1; i++) {
		start = clock();
		root = method(func, xb1[i], xb2[i], XACC); // Root_finding 함수 호출
		end = clock();

		printf("\tRoot %d is %0.5f\n", count, root);
		count ++;
		time += (float)(end - start) / CLOCKS_PER_SEC;
	}

	return time / nb; // 평균값으로
}

float finding_root_for_newton(void (*func)(float, float *, float *), float (*method)(void (*funcd_)(float, float *, float *), float, float, float), 
                float *xb1, float *xb2, int nb) { // Newton method는 미분한 값을 사용해야 한다.

	int count = 1;
	float time = 0.f;
	clock_t start, end;
	float root;
	
	for (int i = 1; i < nb+1; i++) {
		start = clock();
		root = method(func, xb1[i], xb2[i], XACC); // Root_finding 함수 호출
		end = clock();

		printf("\tRoot %d is %0.5f\n", count, root);
		count ++;
		time += (float)(end - start) / CLOCKS_PER_SEC;
	}

	return time / nb; // 평균값으로 return
}

float nonlinear(float x) {
    return (x-1)*(x-5)*(x-7);
}

void derivative_nonlinear(float x, float *y, float *dy) {
    *y  = nonlinear(x); // f(x)
    *dy = 3*x*x - 26*x + 47; // f'(x)
}


int main() {
	int nb = 100;
	float xb1[100], xb2[100], time;

	// 1. [1, 10]을 1000개 구간으로 나누어 그 중 Root가 있을 만한 구간을 반환 - Homework 1
	zbrak(bessj0, 1.0f, 10.0f, 1000, xb1, xb2, &nb);
	printf("Interval where root is likely to exist\n");
	for (int i = 1; i < nb+1; i++) {
		printf("Interval [a, b] a: %0.5f, b: %0.5f\n", xb1[i], xb2[i]);
	}
	printf("\n---------------------------------------------------------\n\n");

	// 2. Root finding - Homework 1
	printf("1. Find the roots using Bisection (rtbis.c)\n");
	time = finding_root(bessj0, rtbis, xb1, xb2, nb);
	printf("Average convergence speed is %0.10f\n\n", time);

	printf("2. Find the roots using Linear Interpolation (rtflsp.c)\n");
	time = finding_root(bessj0, rtflsp, xb1, xb2, nb);
	printf("Average convergence speed is %0.10f\n\n", time);

	printf("3. Find the roots using Secant (rtsec.c)\n");
	time = finding_root(bessj0, rtsec, xb1, xb2, nb);
	printf("Average convergence speed is %0.10f\n\n", time);

	printf("4. Find the roots using Newton-Raphson (rtnewt.c)\n");
	time = finding_root_for_newton(derivative_bessel, rtnewt, xb1, xb2, nb);
	printf("Average convergence speed is %0.10f\n\n", time);

	printf("5. Find the roots using Newton with bracketing (rtsafe.c)\n");
	time = finding_root_for_newton(derivative_bessel, rtsafe, xb1, xb2, nb);
	printf("Average convergence speed is %0.10f\n", time);
	printf("\n---------------------------------------------------------\n\n");

	// 3. Muller 함수 - Homework 2
	printf("Find the roots using Muller (muller.c)\n");
	time = finding_root(bessj0, muller, xb1, xb2, nb);
	printf("Average convergence speed is %0.10f\n\n", time);
	printf("\n---------------------------------------------------------\n\n");


	// 4. Nonlinear 함수의 Root finding - sin^2(x)
	zbrak(nonlinear, 1.0f, 10.0f, 1000, xb1, xb2, &nb);
	printf("Interval of nonlinear equation where root is likely to exist\n");
	for (int i = 1; i < nb+1; i++) {
		printf("Interval [a, b] a: %0.5f, b: %0.5f\n", xb1[i], xb2[i]);
	}
	printf("\n---------------------------------------------------------\n\n");

	printf("Find the roots of nonlinear equation using rtsafe.c\n");
	time = finding_root_for_newton(derivative_nonlinear, rtsafe, xb1, xb2, nb);
	printf("Average convergence speed is %0.10f\n", time);
	printf("\n---------------------------------------------------------\n\n");

	return 0;

}
