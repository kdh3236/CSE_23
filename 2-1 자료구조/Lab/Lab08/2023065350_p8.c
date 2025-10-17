#include <stdio.h>
#include <stdlib.h>

struct AVLNode;
typedef struct AVLNode* Position;
typedef struct AVLNode* AVLTree;
typedef int ElementType;

struct AVLNode{
        ElementType Element;
        AVLTree Left;
        AVLTree Right;
        int Height;
};

int Max(ElementType num1, ElementType num2){
        int max;
        if (num1 >= num2)
                max = num1;
        else
                max = num2;
        return max;
}

int Height(Position P){
        if(P==NULL)
                return -1;
        else
                return P->Height;
}

Position SingleRotateWithLeft(Position node){
        Position k1; //root가 될 node
	k1 = node->Left;
	
	node->Left = k1->Right; //height가 2만큼 차이가 난다면 k1의 right subtree의 node는 1개만 존재
	k1->Right = node;

	node->Height = Max(Height(node->Left), Height(node->Right))+1;
	k1->Height = Max(Height(k1->Left), Height(k1->Right))+1;

	return k1;
} //rotate right direction

Position SingleRotateWithRight(Position node){
	Position k1; //root가 될 node
	k1 = node->Right;

	node->Right=k1->Left;
	k1->Left = node;

	node->Height = Max(Height(node->Left), Height(node->Right))+1;
	k1->Height = Max(Height(k1->Left), Height(k1->Right))+1;

	return k1;
} //rotate left direction

Position DoubleRotateWithLeft(Position node){
	node->Left = SingleRotateWithRight(node->Left); //node의 left subtree에서 left rotation
	return SingleRotateWithLeft(node); //node에서 right rotation
} //Left-Right

Position DoubleRotateWithRight(Position node){
	node->Right = SingleRotateWithLeft(node->Right); //node의 right subtree 에서 right rotation
	return SingleRotateWithRight(node); //node에서 left rotation
} //Right-Left

AVLTree Insert(ElementType X, AVLTree T){
	if(T==NULL){
                T = malloc(sizeof(struct AVLNode));
                if(T == NULL)
                        printf("Out of space!!!");
                else{
                        T->Element = X;
                        T->Left = T->Right = NULL;
                }
        } else if (X < T->Element){
                T->Left = Insert(X, T->Left);
                if(Height(T->Left) - Height(T->Right) == 2){
                        if (X<T->Left->Element){
                                printf("There's node(%d) to be balanced! Do SingleRotateWithLeft!\n", T->Element);
				T = SingleRotateWithLeft(T);
			} //LL
                        else{
				printf("There's node(%d) to be balanced! Do DoubleRotateWithLeft!\n", T->Element);
                                T = DoubleRotateWithLeft(T);
			} //LR
                } //삽입 과정에서 Height가 2만큼 차이 나면 바로 rebalancing + Left subtree에 넣는 과정이기 때문에 Height(T->Right) - Height(T->Left) 는 고려할 필요가 없다
        } else if (X > T->Element){
                T->Right = Insert(X, T->Right);
                if(Height(T->Right) - Height(T->Left) == 2){
                        if(X>T->Right->Element){
                                printf("There's node(%d) to be balanced! Do SingleRotateWithRight!\n", T->Element);
				T = SingleRotateWithRight(T);
			} //RR
                        else{
				printf("There's node(%d) to be balanced! Do DoubleRotateWithRight!\n", T->Element);
                                T = DoubleRotateWithRight(T);
			} //RL
		}
        } else
                printf("Insertion Error: %d is already in the tree!\n", X);

	T->Height = Max(Height(T->Left), Height(T->Right))+1; //Height 수정
	return T;
}

void PrintInorder(AVLTree T){
	if (T != NULL) {
        	PrintInorder(T->Left);
        	printf("%d(%d) ", T->Element, T->Height);
        	PrintInorder(T->Right);
        }
}

void DeleteTree(AVLTree T){
	if(T->Left != NULL)
		DeleteTree(T->Left);
	if(T->Right != NULL)
		DeleteTree(T->Right);
	free(T);
}

int main(int argc, char* argv[]){
	AVLTree myTree = NULL;
	int key;

	FILE* fi = fopen(argv[1], "r");
	while (fscanf(fi, "%d", &key) != EOF){
		myTree = Insert(key, myTree);
	}
	fclose(fi);

	PrintInorder(myTree);
	printf("\n");

	DeleteTree(myTree);
	return 0;
}
