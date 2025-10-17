#include <stdio.h>
#include <stdlib.h>

struct CircularQueueStruct{
	int* key; //array 역할
	int front;
	int rear;
	int qsize; //현재 queue에 있는 element의 개수
	int max_queue_size; //max size
};

typedef struct CircularQueueStruct* CircularQueue; //구조체 포인터를 사용하여 element들을 동적으로 관리하겠다.

CircularQueue MakeEmpty(int max);
int IsEmpty(CircularQueue Q);
int IsFull(CircularQueue Q);
void Dequeue(CircularQueue Q);
void Enqueue(CircularQueue Q, int X);
void PrintFirst(CircularQueue Q);
void PrintRear(CircularQueue Q);
void DeleteQueue(CircularQueue Q);

int main(int argc, char* argv[]){
	char command;
	FILE* input;
	CircularQueue queue;
	int queueSize;
	int tmpNum;

	input = fopen(argv[1], "r");

	while(1){
		command = fgetc(input);
		if(feof(input)) 
			break;
		switch(command){
			case 'n':
				fscanf(input, "%d", &queueSize);
				queue = MakeEmpty(queueSize);
				break;
			case 'e':
				fscanf(input, "%d", &tmpNum);
				Enqueue(queue, tmpNum);
				break;
			case 'd':
				Dequeue(queue);
				break;
			case 'f':
				PrintFirst(queue);
				break;
			case 'r':
				PrintRear(queue);
				break;
			default:
				break;
			}
	}
	DeleteQueue(queue);
	fclose(input);

	return 0;
}

CircularQueue MakeEmpty(int max){
	CircularQueue q = (CircularQueue)malloc(sizeof(struct CircularQueueStruct));
	q->key = (int*)malloc(max * sizeof(int));
	
	q->front = 0;
	q->rear = -1;
	q->qsize = 0;
	q->max_queue_size = max;
	
	return q;
}

int IsEmpty(CircularQueue Q){
	return (Q->qsize == 0);
}

int IsFull(CircularQueue Q){
	return (Q->qsize == Q->max_queue_size);
}

void Dequeue(CircularQueue Q){
        if (IsEmpty(Q)){
                printf("Dequeue failed: Queue is Empty!\n");
        } else{
		printf("Dequeue %d\n", Q->key[Q->front]);
                Q->front = (Q->front + 1) % Q->max_queue_size;
                Q->qsize--;
        }
} //DEQUEUE는 처음 것(first)을 지우고 first를 1 늘림

void Enqueue(CircularQueue Q, int X){
        if (IsFull(Q)){
                printf("Enqueue failed: Queue is Full!\n");
        } else{
		Q->rear = (Q->rear + 1) % Q->max_queue_size;
		Q->key[Q->rear] = X;
		Q->qsize++;
		printf("Enqueue %d\n", X);
	}
}

void PrintFirst(CircularQueue Q){
	if(IsEmpty(Q)){
		printf("Queue is Empty!\n");
	} else{
		printf("Element in the front: %d\n", Q->key[Q->front]);
	}
}

void PrintRear(CircularQueue Q){
	if(IsEmpty(Q)){
		printf("Queue is Empty!\n");
	} else{
		printf("Element in the rear: %d\n", Q->key[Q->rear]);
	}
}

void DeleteQueue(CircularQueue Q){
	if (Q != NULL){
		if(Q->key != NULL){
			free(Q->key);
			Q->key = NULL;
		}
		free(Q);
	}
}

