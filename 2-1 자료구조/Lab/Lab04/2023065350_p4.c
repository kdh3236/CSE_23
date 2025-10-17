#include <stdio.h>
#include <stdlib.h>

typedef struct Stack{
	int* key;
	int top;
	int max_stack_size;
}Stack;

Stack* CreateStack(int max);
void Push(Stack* s, int x);
int Pop(Stack* s);
int Top(Stack* s);
void DeleteStack(Stack* s);
int IsEmpty(Stack *s);
int IsFull(Stack *s);
void Postfix(Stack* s, char input_str);


int main(int argc, char* argv[]){
	if (argc == 1){
		printf("Please enter an input file.");
		return 0;
	}

	FILE *fi = fopen(argv[1], "r");

	Stack* stack = CreateStack(10);

	char c;
	printf("Top numbers: ");
	while(1){
		fscanf(fi, "%c", &c);
		if (c == '!'){
			printf("\nCalculatinf Done!");
			break;
		}
		Postfix(stack, c);
		printf("%d ", Top(stack));
	}
	printf("\n");
	printf("evaluation result: %d\n", Pop(stack));

	fclose(fi);
	DeleteStack(stack);

	return 0;
}

Stack* CreateStack(int max){
	Stack* S;
	S = malloc(sizeof(struct Stack*));

	(*S).key = malloc(max * sizeof(int));
	(*S).top = -1;
	(*S).max_stack_size = max;
	
	return S;
}

void Push(Stack* s, int x){
	if(IsFull(s)){
        	printf("Stack Overflow\n");
        	exit(0);
    	}
	else{
		(*s).key[++(*s).top] = x;
	}
}

int Pop(Stack* s){
	if(IsEmpty(s)){
        	printf("Stack Underflow\n");
        	exit(0);
    	}
	return (*s).top--;
}

int Top(Stack* s){
	if(!IsEmpty(s)){
		return (*s).key[(*s).top];
	}
	return 0;
}

void DeleteStack(Stack* s){
	free(s);
}

int IsFull(Stack *s){
	if(s->top == (*s).max_stack_size - 1){
		return 1;
	}
	else return 0;
}

int IsEmpty(Stack *s){
	if(s->top == -1){
		return 1;
	}
	else return 0;
}

void Postfix(Stack* s, char input_str){
	if(input_str >= '1' && input_str <= '9'){
		Push(s, input_str - '0');
	}
	else if(input_str == '+' || input_str == '-' || input_str == '*' || input_str == '/' || input_str == '%'){
		int operand2 = Top(s);
		Pop(s);
		int operand1 = Top(s);
		Pop(s);
		int result;
		switch(input_str){
			case '+':
				result = operand1 + operand2;
				break;
			case '-':
				result = operand1 - operand2;
				break;
			case '*':
				result = operand1 * operand2;
		       		break;
		 	case '%':
				result = operand1 % operand2;
				break;
			case '/':
				result = operand1 / operand2;
				break;
			default:
				break;
		}		
		Push(s, result);
	}
	else{
		printf("Wrong Operator\n");
		exit(0);
	}
}
