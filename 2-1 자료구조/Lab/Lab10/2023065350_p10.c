#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef struct _DisjointSet{
	int size;
	int* ptr_arr;
} DisjointSets;

typedef struct _PrintDisjointSet{
	int size;
	int* ptr_arr;
} PrintDisjointSets;

void init(DisjointSets* sets, PrintDisjointSets* maze, int n){
	sets->size = n * n;
	maze->size = n * n * 2;

	sets->ptr_arr = (int*)malloc(sizeof(int) * (sets->size+1));		
	maze->ptr_arr = (int*)malloc(sizeof(int) * maze->size);
	
	for(int i=0; i<sets->size+1; i++){
		sets->ptr_arr[i] = -1;
	}

	for(int i=0; i<maze->size+1; i++){
		maze->ptr_arr[i] = 1;
	}

	maze->ptr_arr[n*n] = 0;
}

int find(DisjointSets* sets, int x){
	if (sets->ptr_arr[x] < 0){
		return x;
	} else{
		return sets->ptr_arr[x] = find(sets, sets->ptr_arr[x]);
	}
}

void union_(DisjointSets* sets, int i, int j){
	int root1 = find(sets, i);
    	int root2 = find(sets, j);

    	if (root1 != root2){
		sets->ptr_arr[root2] = root1;
	}        	
}

void createMaze(DisjointSets* sets, PrintDisjointSets* maze, int n){
	srand(time(NULL));
	int wall_num = (2*n-1) * n;

	while(find(sets, 1) != find(sets, n*n)){                                      
		int wall = rand()%wall_num;            
		
		if(wall != n*n && wall < n*n){ //수직 벽
			if(wall%n != 0 && find(sets, wall) != find(sets, wall+1)){
				union_(sets, wall, wall+1);
				maze->ptr_arr[wall] = 0;
			}
		} 
		else if(wall != n*n && wall > n*n){
			if(find(sets, wall%(n*n)) != find(sets, (wall%(n*n))+n)){
				union_(sets, wall%(n*n), wall%(n*n)+n);
				maze->ptr_arr[wall] = 0;
			}
		}
	}	
}

void printMaze(PrintDisjointSets* maze, int n){
	printf("*");
	for(int i=0; i<n; i++){
		printf("-*");
	}
	printf("\n");

        printf("  ");
        for(int j = 1; j < n+1; j++){
        	if(maze->ptr_arr[j] == 1){
                	printf("| ");
               	}else{
                	printf("  ");
                }
	}
                printf("\n");

        printf("*");
        for(int k = 1; k < n+1; k++){
        	if(maze->ptr_arr[k + (n * n)] == 1){
        		printf("-*");
        	}else{
        		printf(" *");
        	}
        }
        printf("\n");
       

	for(int i = 1; i < n; i++){
        	printf("| ");
        	for(int j = 1; j < n+1; j++){
            		if(maze->ptr_arr[i * n + j] == 1){
                		printf("| ");
            		}else{
                		printf("  ");
            		}
        	}
        	printf("\n");

        	printf("*");
        	for(int k = 1; k < n+1; k++){
            		if(maze->ptr_arr[i * n + k + (n * n)] == 1){
                		printf("-*");
            		}else{
                		printf(" *");
            		}
        	}
        	printf("\n");
	}

}

void freeMaze(DisjointSets* sets, PrintDisjointSets* maze){
	free(sets->ptr_arr);
	free(maze->ptr_arr);
}

int main(int argc, char* argv[]){
	int num;
	FILE* fi = fopen(argv[1], "r");
	fscanf(fi, "%d", &num);
	fclose(fi);

	DisjointSets* sets;
	PrintDisjointSets* maze;

	sets = (DisjointSets*)malloc(sizeof(DisjointSets));
	maze = (PrintDisjointSets*)malloc(sizeof(PrintDisjointSets));

	init(sets, maze, num);
	createMaze(sets, maze, num);
	printMaze(maze, num);
	freeMaze(sets, maze);

	return 0;
}
