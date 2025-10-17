#include <stdio.h>
#include <stdlib.h>

typedef struct HeapStruct* Heap;

struct HeapStruct{
	int Capacity;
	int Size;
	int* Element;
};

Heap CreateHeap(int heapSize){
	Heap heap = (Heap)malloc(sizeof(struct HeapStruct));
    	heap->Capacity = heapSize;
    	heap->Size = 0;
    	heap->Element = (int*)malloc((heapSize+1)*sizeof(int));
    	heap->Element[0] = 0; 
	return heap;
}


void Insert(Heap heap, int value){
	if (heap->Size == heap->Capacity){
        	printf("Insertion Error : Max Heap is full!\n");
        	return;
    	}
    	for (int i = 1; i <= heap->Size; i++){
        	if (heap->Element[i] == value){
            		printf("%d is already in the heap.\n", value);
            		return;
        	}
    	}
	int i;
    	for (i = ++heap->Size; i > 1 && heap->Element[i / 2] < value; i /= 2){
        	heap->Element[i] = heap->Element[i / 2];
    	}
    	heap->Element[i] = value;
    	printf("Insert %d\n", value);
}

int Find(Heap heap, int value){
	for (int i = 1; i <= heap->Size; i++){
        	if (heap->Element[i] == value){
            		return 1;
        	}
    	}
    	return 0;
}

void DeleteMax(Heap heap){
	if (heap->Size == 0){
        	printf("Deletion Error : Max Heap is empty!\n");
        	return;
    	}
	int i, child;
    	int maxElement = heap->Element[1];
    	int lastElement = heap->Element[heap->Size--];
    	

    	for (i = 1; i * 2 <= heap->Size; i = child){
        	child = i * 2;
        	if (child != heap->Size && heap->Element[child + 1] > heap->Element[child]){
            		child++;
        	}
        	if (lastElement < heap->Element[child])
            		heap->Element[i] = heap->Element[child];
        	else
            		break;
        	
    	}
    	heap->Element[i] = lastElement;
    	printf("Max Element %d is deleted.\n", maxElement);
}

void PrintHeap(Heap heap){
	if (heap->Size == 0){
        	printf("Print Error : Max Heap is empty!\n");
        	return;
    	}
    	for (int i = 1; i <= heap->Size; i++){
        	printf("%d ", heap->Element[i]);
    	}
    	printf("\n");
}

void FreeHeap(Heap heap){
	free(heap->Element);
	free(heap);
}

int main(int argc, char* argv[]){
	FILE* fi = fopen(argv[1], "r");

	char cv;
	Heap maxHeap;
	int value, MaxValue;
	char line[100];

	while(!feof(fi)){
		fscanf(fi, "%c", &cv);
		switch(cv){
			case 'n':
				fscanf(fi, "%d", &value);
				maxHeap = CreateHeap(value);
				break;
			case 'i':
				fscanf(fi, "%d", &value);
				Insert(maxHeap, value);
				break;
			case 'd':
				DeleteMax(maxHeap);
				break;
			case 'f':
				fscanf(fi, "%d", &value);
				if(Find(maxHeap, value))
					printf("%d is in the heap.\n", value);
				else 
					printf("%d is not in the heap.\n", value);
				break;
			case 'p':
				PrintHeap(maxHeap);
		}
	
	}
	FreeHeap(maxHeap);
	return 0;
}
