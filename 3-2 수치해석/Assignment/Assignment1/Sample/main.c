#include <stdio.h>
#include "nr.h"

int get_float_eps(float *eps){
	*eps = 0.5f;
	int n = 1;

	while (1 + *eps > 1) {
		n++;
		*eps *= 0.5;
	}
		
	*eps *= 2.0;

	return n;
}	

int get_double_eps(double *eps){
	*eps = 0.5f;
	int n = 1;

	while (1 + *eps > 1) {
		n++;
		*eps *= 0.5;
	}

	*eps *= 2.0;

	return n;
}
			

int main() {
	int ibeta, it, irnd, ngrd, machep, negep, iexp, minexp, maxexp, fn, dn;
	float feps, fepsneg, fxmin, fxmax;
	double deps, depsneg, dxmin, dxmax;
	
	// For float
	machar(&ibeta, &it, &irnd, &ngrd, &machep, &negep, &iexp, &minexp, &maxexp, &feps, &fepsneg, &fxmin, &fxmax);
	printf("Machine Accuracy for float (machar): \t%0.20f\n", feps);
	
	fn = get_float_eps(&feps);
	printf("Machine Accuracy for float (get_eps): \t%0.20f\n", feps);
	
	printf("The value of n for float is: %d\n\n", fn);

	// For double
	d_machar(&ibeta, &it, &irnd, &ngrd, &machep, &negep, &iexp, &minexp, &maxexp, &deps, &depsneg, &dxmin, &dxmax);
	printf("Machine Accuracy for double (machar): \t%0.20f\n", deps);

        dn = get_double_eps(&deps);
        printf("Machine Accuracy for double (get_eps): \t%0.20f\n", deps);

        printf("The value of n for double is: %d\n\n", dn);

	return 0;
}
