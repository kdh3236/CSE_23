#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]){
	if(argc == 1){
                printf("Please input the number of student\n");
	}
        else if(strcmp(argv[1], "0") == 0 || strcmp(argv[1], "1") == 0){
                printf("Please input the number of students more than one!\n");
        }
        else{
                int n = atoi(argv[1]);
                printf("please enter %d names\n", n);

                char** name_array = malloc(sizeof(char*) * n);
                for (int i = 0; i<n; i++){
                        name_array[i] = malloc(sizeof(char) * 31);
                        scanf("%s", name_array[i]);
                }

		printf("The names you entered are\n");

                for (int i = 0; i < n; i++) {
                        printf("%s\n", name_array[i]);
                        free(name_array[i]);
                }
                free(name_array);
        }
        return 0;
}
