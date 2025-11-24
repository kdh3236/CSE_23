#include <stdio.h>
#include <stdlib.h>
#include "nr.h"
#include "nrutil.h"

#define MAX 100

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Missing file name %s\n", argv[0]);
        return 1;
    }

    int n = 0;

    FILE *fp = fopen(argv[1], "r");
    if (fp == NULL) {
        fprintf(stderr, "File open error %s\n", argv[1]);
        return 1;
    }

    float *x  = vector(1, MAX);
    float *y  = vector(1, MAX);
    float *xp = vector(1, MAX);
    float *yp = vector(1, MAX);

    while (fscanf(fp, "%f %f %f %f", &x[n+1], &y[n+1], &xp[n+1], &yp[n+1]) == 4 && n < MAX)  {
        n++;    
    }
    fclose(fp);

    int m = 2 * n;

    float **A = matrix(1, m, 1, 6);
    float *b  = vector(1, m);

    // A, b 채우기
    for (int i = 1; i <= n; i++) {
        int first = 2*i - 1;
        int second = 2*i;

        A[first][1] = x[i];
        A[first][2] = y[i];
        A[first][3] = 1.0f;
        A[first][4] = 0.0f;
        A[first][5] = 0.0f;
        A[first][6] = 0.0f;
        b[first] = xp[i];

        A[second][1] = 0.0f;
        A[second][2] = 0.0f;
        A[second][3] = 0.0f;
        A[second][4] = x[i];
        A[second][5] = y[i];
        A[second][6] = 1.0f;
        b[second] = yp[i];
    }

    // ATA, ATb 생성
    float **ATA = matrix(1, 6, 1, 6);
    float **ATb = matrix(1, 6, 1, 1);

    // ATA, ATb 계산
    for (int i = 1; i <= 6; i++) {
        for (int j = 1; j <= 6; j++) {
            float sum1 = 0.0f;
            for (int k = 1; k <= m; k++)
                sum1 += A[k][i] * A[k][j];
            ATA[i][j] = sum1;
        }

        float sum2 = 0.0f;
        for (int k = 1; k <= m; k++)
            sum2 += A[k][i] * b[k];
        ATb[i][1] = sum2;
    }

    // ATA * x = ATb 풀기
    gaussj(ATA, 6, ATb, 1);

    // a1 ~ a6 출력
    for (int i = 1; i <= 6; i++)
        printf("a%d = %f\n", i, ATb[i][1]);

    // 메모리 해제
    free_matrix(A, 1, m, 1, 6);
    free_matrix(ATA, 1, 6, 1, 6);
    free_matrix(ATb, 1, 6, 1, 1);
    free_vector(x, 1, MAX);
    free_vector(y, 1, MAX);
    free_vector(xp, 1, MAX);
    free_vector(yp, 1, MAX);
    free_vector(b, 1, m);
    
    return 0;
}
