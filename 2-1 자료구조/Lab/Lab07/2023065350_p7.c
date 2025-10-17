#include <stdio.h>
#include <stdlib.h>

struct TreeStruct{
	int size; //max_size
	int numOfNode; //index
	int* element; //array
};

typedef struct TreeStruct* Tree;

Tree CreateTree(int size){
	Tree tree = (Tree)malloc(sizeof(struct TreeStruct));
	if (tree == NULL) {
		printf("Memory error!\n");
		return NULL;
	}
        tree->element = (int*)malloc(sizeof(int)*(size+1));
        tree->size = size;
        tree->numOfNode = 0;
	return tree;
}

void Insert(Tree tree, int value){
	if (tree == NULL){
		printf("Memory error!");
		return;
	} else{
		if(tree->size <= tree->numOfNode){
               		printf("Error with node %d! Tree is already full so we cannot insert any node in the tree!\n", value);
               		return;	
		}
		tree->element[++tree->numOfNode] = value; //initialize > numOfNode = 0이기 때문에 prefix 사용
	}
}

void PrintPreorder(Tree tree, int index){
	if (index <= tree->numOfNode) { //매번 out of index인지 체크
       		printf("%d ", tree->element[index]); //root = index 1
        	PrintPreorder(tree, 2 * index);	//Left subtree
		PrintPreorder(tree, 2 * index + 1); //Right subtree
	}
}
void PrintInorder(Tree tree, int index){
	if (index <= tree->numOfNode) {
     		PrintInorder(tree, 2 * index); //Left subtree
		printf("%d ", tree->element[index]); //root
        	PrintInorder(tree, 2 * index + 1); //Right subtree
	}
}
void PrintPostorder(Tree tree, int index){
	if (index <= tree->numOfNode) {
     		PrintPostorder(tree, 2 * index); //Left subtree
     		PrintPostorder(tree, 2 * index + 1); //right subtree
     		printf("%d ", tree->element[index]); //root
    }
}
void PrintTree(Tree tree){
	printf("Preorder: ");
	PrintPreorder(tree, 1);
	printf("\n");

	printf("Inorder: ");
	PrintInorder(tree, 1);
	printf("\n");
	
	printf("Postorder: ");
	PrintPostorder(tree, 1);
	printf("\n");	
}

void DeleteTree(Tree tree){
	free(tree->element); //*element > 배열의 한 node, element > 배열 전체를 가리킴
	free(tree);
}

int main(int argc, char* argv[]){
	FILE* fi;
	Tree tree;
	int treeSize;
	int input, tmpNum;

	fi = fopen(argv[1], "r");
	fscanf(fi, "%d", &treeSize);

	tree = CreateTree(treeSize);

	while(fscanf(fi, "%d", &tmpNum) == 1){ //fscanf를 한 값이 있을 때 진행
		Insert(tree, tmpNum);
	}

	PrintTree(tree);
	DeleteTree(tree);

	fclose(fi);

	return 0;
}


