#include <stdio.h>
#include <stdlib.h>

const int INF = (int)2e9;

typedef struct Node{
	int vertex;
    	int dist;
    	int prev;
}Node;

typedef struct Graph{
    	int size;
    	Node* nodes;
    	int** matrix;
}Graph;

typedef struct Heap{
   	int capacity;
   	int size;
   	Node* elements;
}Heap;


Graph* createGraph(int X){
	Graph* G = (Graph*)malloc(sizeof(Graph));
    	G->size = X;

    	G->nodes = (Node*)malloc(sizeof(Node) * (G->size+1));
    
    	G->matrix = (int**)malloc(sizeof(int*) * (G->size+1));

    	for(int i = 1; i <= G->size; i++){
        	G->matrix[i] = (int*)malloc(sizeof(int) * (G->size+1));
    	}
    
	for(int i = 1; i <= G->size; i++){
        	for(int j = 1; j <= G->size; j++){
            		G->matrix[i][j] = 0;
        	}
	}

	for(int i = 1; i <= G->size; i++){
        	G->nodes[i].vertex = i;
        	G->nodes[i].dist = INF;
        	G->nodes[i].prev = i;
    	}

    	return G;
}

Heap* createMinHeap(int X){
	Heap* heap = (Heap*)malloc(sizeof(Heap));
    	heap->capacity = X;
    	heap->size = 0;
    	heap->elements = (Node*)malloc(sizeof(Node) * (heap->capacity+1));
    	return heap;
}

void insert(Heap* H, Node N){
	int i;

    	if(H->size >= H->capacity){
        	printf("Heap is full.\n");
   		return;
    	}

    	for(i = ++H->size; H->elements[i/2].dist > N.dist; i/=2){
        	H->elements[i] = H->elements[i/2];
    	}
    	H->elements[i] = N;
}

Node deleteMin(Heap* H){
	int i, child;
	Node min_element = H->elements[1];
	Node last_element = H->elements[H->size--];

    	for(i = 1; i*2 <= H->size; i = child){
        	child = i*2;
        	
		if(child != H->size && H->elements[child+1].dist < H->elements[child].dist){
            		child++;
        	}
        
		if(last_element.dist > H->elements[child].dist){
            		H->elements[i] = H->elements[child];
        	} 
   		else{
            		break;
        	}
    	}
    	H->elements[i] = last_element;

    	return min_element;
}

void decreaseKey(Heap* H, Node N){
	int i;
    	for(i = 1; i <= H->size; i++){
        	if(H->elements[i].vertex == N.vertex){
            		H->elements[i] = N;
            		break;
        	}
    	}

    	while(i > 1 && H->elements[i/2].dist > H->elements[i].dist){
        	Node temp = H->elements[i/2];
        	H->elements[i/2] = H->elements[i];
        	H->elements[i] = temp;
    	}
}

Graph* findShortestPath(Graph* G, int s);
void printShortestPath(Graph* G);

int main(int argc, char* argv[]){
    	FILE *fi = fopen(argv[1], "r");
    	int size;

    	fscanf(fi, "%d", &size);
	Graph* G = createGraph(size);

	int node_s, node_d, weight;

    	while(fscanf(fi, "%d %d %d", &node_s, &node_d, &weight) != EOF){
        	G->matrix[node_s][node_d] = weight;
    	}

    	G = findShortestPath(G, 1);
    	printShortestPath(G);

    	for(int i = 1; i <= G->size; i++){
       		free(G->matrix[i]);
    	}
    	free(G->matrix);
    	free(G->nodes);
    	free(G);

    	return 0;
}


Graph* findShortestPath(Graph* G, int s){                               Heap* H = createMinHeap(G->size);                               G->nodes[s].dist = 0;                                                                                                           for(int i = 1; i < G->size+1; i++){
                insert(H, G->nodes[i]);
        }

        while(H->size > 0){
                Node u = deleteMin(H);

                for(int v = 1; v < G->size+1; v++){
                        int path_length = u.dist + G->matrix[u.vertex][v];
                        if(G->matrix[u.vertex][v] != 0 && path_lenvoid printShortestPath(Graph* G){
        for(int i=1; i<G->size+1; i++){
                if(i != 1){
                        for (int j=i; j != 1; j=G->nodes[j].prev){
                                printf("%d<-", j);
                        }
                        printf("1 cost: %d\n", G->nodes[i].dist);
                }
        }
}gth < G->nodes[v].dist){
                                G->nodes[v].dist = path_length;
                                G->nodes[v].prev = u.vertex;
                                decreaseKey(H, G->nodes[v]);
                        }
                }
        }

        free(H->elements);
        free(H);

        return G;
}

void printShortestPath(Graph* G){
        for(int i=1; i<G->size+1; i++){
		if(i != 1){
			for (int j=i; j != 1; j=G->nodes[j].prev){
				printf("%d<-", j);
			}
			printf("1 cost: %d\n", G->nodes[i].dist);
		}
	}
}

