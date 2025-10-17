#include <stdio.h>
#include <stdlib.h>

typedef struct Node* PtrToNode; //구조체 포인터 변수 설정
typedef PtrToNode List; //Node*형 LIST > Header를 가리킴
typedef PtrToNode Position; //Node*형 Position > ElementType을 가지는 위치
typedef int ElementType; //값

struct Node{
	ElementType element;
	Position next;
};

List MakeEmptyList();
int isLast(Position p);
void Delete(ElementType x, List l);
Position FindPrevious(ElementType x, List l);
Position Find(ElementType x, List l);
void Insert(ElementType x, Position p, List l);
void DeleteList(List l);
void PrintList(List l);


int main(int argc, char* argv[]){
	char command;
	int key1, key2;
	FILE *input, *output;
	Position header = NULL, tmp = NULL;

	if(argc <= 1){
		printf("please enter an input File.\n");
		return 0;	
	}
	else
		input = fopen(argv[1], "r");

	header = MakeEmptyList();
	while(1){
		command = fgetc(input);
		if(feof(input)) break;
		switch(command){
			case 'i':
				fscanf(input, "%d %d", &key1, &key2);
				if(key2 == -1){
					Insert(key1, header, header);
					break;
				}
				else{
					tmp = Find(key2, header);
					Insert(key1, tmp, header);
					break;
				}
			case 'd':
				fscanf(input, "%d", &key1);
				Delete(key1, header);
				break;
			case 'f':
				fscanf(input, "%d", &key1);
				tmp = FindPrevious(key1, header);
				if(isLast(tmp))
					printf("Could not find %d in the list.\n", key1);
				else if(tmp->element > 0)
					printf("Key of the previous node of %d is %d.\n", key1, tmp->element);
			        else
					printf("Key of the previous node of %d is header.\n", key1);
				break;
			case 'p':
				PrintList(header);
				break;
			default:
				;
		}	

	}

	fclose(input);
	DeleteList(header);
	return 0;
}

List MakeEmptyList(){
	List l = (List)malloc(sizeof(List));
	l->element = -1; //헤더 설정, Header의 ElementType은 -1로 설정
	l->next = NULL;
	return l;
}

int isLast(Position p){
	return p->next == NULL; //p->next == NULL > Last Element
}

Position FindPrevious(ElementType x, List l){
	Position p = l; //FindPrevious은 p가 header부터 시작
    	while(p->next != NULL && p->next->element != x){
        	p = p->next;
    	}
    	if (p == NULL){
        	return 0;
    	}
    	return p;
}

Position Find(ElementType x, List l){
    	Position p = l->next; //Find는 header 다음 node부터
    	while (p != NULL && p->element != x) {
        	p = p->next;
    	}
    	if (p == NULL) {
        	return 0;
    	}
    	return p;
}

void Insert(ElementType x, Position p, List l){
	Position tmpCell;
    	tmpCell = (Position)malloc(sizeof(struct Node)); //어떤 것이 들어갈지 모르니 Node 크기로 동적할당
    	if (p == NULL) {
        	printf("Insertion(%d) Failed: cannot find the location to be inserted\n", x);
        	return;
    	}
    	tmpCell->element = x;
    	tmpCell->next = p->next;
    	p->next = tmpCell;
}

void Delete(ElementType x, List l){
	Position p, tmpCell;
    	p = FindPrevious(x, l);
    	if (!isLast(p)){
        	tmpCell = p->next;
        	p->next = tmpCell->next;
        	free(tmpCell);
    	}else{
        	printf("Deletion Failed: element %d is not in the list.\n", x);
    	}	
}

void DeleteList(List l){
	Position p, tmp;
    	p = l->next;
    	l->next = NULL;
    	while (p != NULL){
        	tmp = p->next;
        	free(p);
        	p = tmp;
    	}
}

void PrintList(List l){
	PtrToNode tmp = NULL;
	tmp = l->next;
	if(tmp==NULL){
		printf("your list is empty!\n");
		return;
	}
	while(tmp!=NULL){
		printf("key: %d\t", tmp->element);
		tmp = tmp -> next;
	}
	printf("\n");
}
