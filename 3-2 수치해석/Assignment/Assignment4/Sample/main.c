#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "nr.h"
#include "nrutil.h"

int main() {
    int a = -3;
    int b = 4;
    int n;
    int arr[] = {1000, 100, 10000, 100000}; 
    float m = 0.5;
    float s = 1.5;

    long idum = -time(NULL); 
    
    FILE *fp_uni, *fp_gas; 
    char uni_name[100];
    char gas_name[100];

    for (int i = 0; i < 4; i++) {
        n = arr[i];
        
        sprintf(uni_name, "uniform_%d.txt", n);
        sprintf(gas_name, "gaussian_%d.txt", n);

        fp_uni = fopen(uni_name, "w");
        fp_gas = fopen(gas_name, "w");
        
        if (fp_uni == NULL || fp_gas == NULL) {
            printf("File open error\n");
            return 1;
        }

        for (int j = 0; j < n; j++) {
            fprintf(fp_uni, "%f\n", (b-a)*ran2(&idum)+a); 
        }

        for (int j = 0; j < n; j++) {
            fprintf(fp_gas, "%f\n", gasdev(&idum)*s+m);
        }
        
        fclose(fp_uni);
        fclose(fp_gas);
        
        printf("Data for %d samples are saved to %s and %s\n\n", n, uni_name, gas_name);
    }

    return 0;
}