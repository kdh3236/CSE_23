#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include "nr.h"
#include "nrutil.h"

int main(int argc, char *argv[]) {
    int n, m, i, j, *indx;
    float **a, *b, d;
    float **gauss_b, **gauss_a;
    float **lu_a, *lu_b;
    float **svd_a, **svd_v, *svd_w, *svd_b, *svd_x;
    float **mprove_a, *mprove_b, **alud, *mprove_x;
    float **inv_a, **det_a, det_value;
    clock_t start, end;

    // File load and Set matrix, vector
    if (argc < 2) {
        printf("Need to input file name.\n");
        return 1;
    }

    FILE *fp = fopen(argv[1], "r");

    if (fp == NULL) {
        printf("File not found.\n");
        return 1;
    }

    // Read m, n
    fscanf(fp, "%d %d", &m, &n);

    // Allocate memory for a and b (1-based indexing)
    a = (float **)malloc((m+1) * sizeof(float *));
    for (i = 0; i <= m; i++) {
        a[i] = (float *)malloc((n+1) * sizeof(float));
    }
    b = (float *)malloc((n+1) * sizeof(float));

    // Read matrix a and vector b
    for (i = 1; i <= m; i++) {
        for (j = 1; j <= n; j++) {
            fscanf(fp, "%f", &a[i][j]);
        }
    }
    for (i = 1; i <= n; i++) {
        fscanf(fp, "%f", &b[i]);
    }
    fclose(fp);

    // 1. Gauss-Jordan Elimination
    printf("---------------------------------------------------------\n");
    printf("1. Gauss-Jordan Elimination\n\n");
    // gaussj용 복사본 생성
    gauss_a = (float **)malloc((m+1) * sizeof(float *));
    for (i = 0; i <= m; i++) {
        gauss_a[i] = (float *)malloc((n+1) * sizeof(float));
        for (j = 0; j <= n; j++) {
            gauss_a[i][j] = a[i][j];
        }
    }
    
    // 행렬 형태의 b가 필요함.
    gauss_b = (float **)malloc((n+1) * sizeof(float *));
    for (i = 0; i <= n; i++) {
        gauss_b[i] = (float *)malloc(2 * sizeof(float));
        gauss_b[i][1] = b[i];
    }
    
    start = clock();
    gaussj(gauss_a, n, gauss_b, 1);
    end = clock();
    
    printf("x: [");
    for (i = 1; i <= n; i++) {
        printf("%10.6f ", gauss_b[i][1]);
    }
    printf("]\n\n");

    printf("Time taken: %10.8f seconds\n", (float)(end - start) / CLOCKS_PER_SEC);

    // gaussj용 메모리 해제
    for (i = 0; i <= n; i++) {
        free(gauss_a[i]);
        free(gauss_b[i]);
    }
    free(gauss_a);
    free(gauss_b);

    printf("---------------------------------------------------------\n\n\n");


    // 2. LU Decomposition
    printf("---------------------------------------------------------\n");
    printf("2. LU Decomposition\n\n");
    
    // LU용 복사본 생성
    lu_a = (float **)malloc((m+1) * sizeof(float *));
    for (i = 0; i <= m; i++) {
        lu_a[i] = (float *)malloc((n+1) * sizeof(float));
        for (j = 0; j <= n; j++) {
            lu_a[i][j] = a[i][j];
        }
    }
    lu_b = (float *)malloc((n+1) * sizeof(float));
    for (i = 0; i <= n; i++) {
        lu_b[i] = b[i];
    }
    
    indx = (int *)malloc((n+1) * sizeof(int));
    start = clock();
    ludcmp(lu_a, n, indx, &d);
    lubksb(lu_a, n, indx, lu_b);
    end = clock();

    printf("x: [");
    for (i=1; i<=n; i++) {
        printf("%10.6f ", lu_b[i]);
    }
    printf("]\n\n");

    printf("Time taken: %10.8f seconds\n", (float)(end - start) / CLOCKS_PER_SEC);

    // LU용 메모리 해제
    for (i = 0; i <= m; i++) {
        free(lu_a[i]);
    }
    free(lu_a);
    free(lu_b);
    free(indx);

    printf("---------------------------------------------------------\n\n\n");


    // 3. SVD Decomposition
    printf("---------------------------------------------------------\n");
    printf("3. SVD Decomposition\n\n");
    
    // SVD용 복사본 생성
    svd_a = (float **)malloc((m+1) * sizeof(float *));
    for (i = 0; i <= m; i++) {
        svd_a[i] = (float *)malloc((n+1) * sizeof(float));
        for (j = 0; j <= n; j++) {
            svd_a[i][j] = a[i][j];
        }
    }
    svd_b = (float *)malloc((n+1) * sizeof(float));
    for (i = 0; i <= n; i++) {
        svd_b[i] = b[i];
    }
    
    // SVD 계산에 추가로 필요한 배열 
    svd_w = (float *)malloc((n+1) * sizeof(float));
    svd_v = (float **)malloc((n+1) * sizeof(float *));
    for (i = 0; i <= n; i++) {
        svd_v[i] = (float *)malloc((n+1) * sizeof(float));
    }
    svd_x = (float *)malloc((n+1) * sizeof(float));
    
    start = clock();
    svdcmp(svd_a, m, n, svd_w, svd_v);
    svbksb(svd_a, svd_w, svd_v, m, n, svd_b, svd_x);
    end = clock();
    
    printf("x: [");
    for (i=1; i<=n; i++) {
        printf("%10.6f ", svd_x[i]);
    }
    printf("]\n\n");

    printf("Time taken: %10.8f seconds\n", (float)(end - start) / CLOCKS_PER_SEC);
    
    // SVD용 메모리 해제
    for (i = 0; i <= m; i++) {
        free(svd_a[i]);
    }
    for (i = 0; i <= n; i++) {
        free(svd_v[i]);
    }
    free(svd_a);
    free(svd_v);
    free(svd_w);
    free(svd_b);
    free(svd_x);
    
    printf("---------------------------------------------------------\n\n\n");


    // 4. LU Decomposition + Iterative Improvement (mprove)
    printf("---------------------------------------------------------\n");
    printf("4. Method of Iterative improvement\n\n");
    
    // mprove용 복사본 생성 
    mprove_a = (float **)malloc((m+1) * sizeof(float *));
    for (i = 0; i <= m; i++) {
        mprove_a[i] = (float *)malloc((n+1) * sizeof(float));
        for (j = 0; j <= n; j++) {
            mprove_a[i][j] = a[i][j];
        }
    }
    mprove_b = (float *)malloc((n+1) * sizeof(float));
    for (i = 0; i <= n; i++) {
        mprove_b[i] = b[i];
    }
    
    // LU 분해용 복사본 
    alud = (float **)malloc((m+1) * sizeof(float *));
    for (i = 0; i <= m; i++) {
        alud[i] = (float *)malloc((n+1) * sizeof(float));
        for (j = 0; j <= n; j++) {
            alud[i][j] = a[i][j];
        }
    }
    mprove_x = (float *)malloc((n+1) * sizeof(float));
    for (i = 0; i <= n; i++) {
        mprove_x[i] = mprove_b[i];
    }
    
    indx = (int *)malloc((n+1) * sizeof(int));
    ludcmp(alud, n, indx, &d);
    lubksb(alud, n, indx, mprove_x);
    mprove(mprove_a, alud, n, indx, mprove_b, mprove_x);
    
    printf("x: [");
    for (i=1; i<=n; i++) {
        printf("%10.6f ", mprove_x[i]);
    }
    printf("]\n");
    
    // mprove용 메모리 해제
    for (i = 0; i <= m; i++) {
        free(mprove_a[i]);
        free(alud[i]);
    }
    free(mprove_a);
    free(alud);
    free(mprove_b);
    free(mprove_x);
    free(indx);
    
    printf("---------------------------------------------------------\n\n\n");


    // 5. Inverse Matrix and Determinant
    printf("---------------------------------------------------------\n");
    printf("5. Inverse Matrix and Determinant\n\n");
    
    // 역행렬 계산용 복사본 생성
    inv_a = (float **)malloc((n+1) * sizeof(float *));
    for (i = 0; i <= n; i++) {
        inv_a[i] = (float *)malloc((n+1) * sizeof(float));
        for (j = 0; j <= n; j++) {
            inv_a[i][j] = a[i][j];
        }
    }
    
    // 단위 행렬 생성 
    gauss_b = (float **)malloc((n+1) * sizeof(float *));
    for (i = 0; i <= n; i++) {
        gauss_b[i] = (float *)malloc((n+1) * sizeof(float));
        for (j = 0; j <= n; j++) {
            if (i == j) {
                gauss_b[i][j] = 1.0;
            } else {
                gauss_b[i][j] = 0.0;
            }
        }
    }
    
    // Gauss-Jordan Elimination로 역행렬 계산
    gaussj(inv_a, n, gauss_b, n);
    
    printf("Inverse Matrix of A:\n");
    for (i = 1; i <= n; i++) {
        for (j = 1; j <= n; j++) {
            printf("%10.6f ", gauss_b[i][j]);
        }
        printf("\n");
    }
    printf("\n");
    
    // determinant 계산용 복사본 생성
    det_a = (float **)malloc((n+1) * sizeof(float *));
    for (i = 0; i <= n; i++) {
        det_a[i] = (float *)malloc((n+1) * sizeof(float));
        for (j = 0; j <= n; j++) {
            det_a[i][j] = a[i][j];
        }
    }
    
    // LU Decomposition로 determinant 계산
    indx = (int *)malloc((n+1) * sizeof(int));
    ludcmp(det_a, n, indx, &det_value);
    
    for (i = 1; i <= n; i++) {
        det_value *= det_a[i][i];
    }
    
    printf("Determinant of A: %10.6f\n", det_value);
    
    // Inverse Matrix와와 determinant용 메모리 해제
    for (i = 0; i <= n; i++) {
        free(inv_a[i]);
        free(det_a[i]);
        free(gauss_b[i]);
    }
    free(inv_a);
    free(det_a);
    free(gauss_b);
    free(indx);
    
    printf("---------------------------------------------------------\n\n\n");

    // 원본 a, b 메모리 해제
    for (i = 0; i <= m; i++) {
        free(a[i]);
    }
    free(a);
    free(b);

    return 0;
}
