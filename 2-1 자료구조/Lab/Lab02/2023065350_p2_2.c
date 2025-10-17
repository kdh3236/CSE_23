#include <stdio.h>
#include <stdlib.h> 

typedef struct student {
    char* name;
    char* major;
    int student_id;
} student;

int main(int argc, char* argv[]) {
    if (argc < 3) {
        printf("Please enter the input file or output file!\n");
    } else {
        char *input_path, *output_path;
        FILE *fi, *fo;

        int num, i;

        input_path = argv[1];
        output_path = argv[2];

        fi = fopen(input_path, "r");
        fo = fopen(output_path, "w");

	fscanf(fi, "%d", &num);

        student* students = malloc(num * sizeof(student));

        for (i = 0; i < num; i++) {
            students[i].name = malloc(31 * sizeof(char)); 
            students[i].major = malloc(31 * sizeof(char));
        }

	char line[1000];
	
	fgets(line, 1000, fi);

        for (i = 0; i < num; i++) {
            fgets(line, 1000, fi);
            sscanf(line, "%s %s %d", students[i].name, students[i].major, &students[i].student_id);
        }

        for (i = 0; i < num; i++) {
            fprintf(fo, "%s\t%s\t%d\n", students[i].name, students[i].major, students[i].student_id);
        }

        for (i = 0; i < num; i++) {
            free(students[i].name);
            free(students[i].major);
        }
        free(students);

        fclose(fi);
        fclose(fo);
    }

    return 0;
}

		


