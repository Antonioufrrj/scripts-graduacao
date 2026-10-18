/* ============================================================
   Título:    Lista Simplesmente Encadeada
   Autor:     Seu Nome
   Data:      2024
   Descrição: Lista encadeada com nós alocados dinamicamente via malloc.
              Cada nó armazena um inteiro e um ponteiro para o próximo.
              Operações: inserir no início, inserir no fim, exibir e
              liberar toda a memória alocada com free.
   Compilar:  gcc mainlistaencadeada.c -o lista_enc && ./lista_enc
   ============================================================ */

#include <stdio.h>
#include <stdlib.h>

struct Node{
	int num;
	struct Node *prox;
}; 
typedef struct Node node;

void inicia(node *LISTA);
int menu(void);
void opcao(node *LISTA, int op);
node *criaNo();
void insereFim(node *LISTA, int x);
void insereInicio(node *LISTA, int x);
void exibe(node *LISTA);
void libera(node *LISTA);


int main(void)
{
	node *LISTA = (node *) malloc(sizeof(node));
	if(!LISTA){
		printf("Sem memoria disponivel!\n");
		exit(1);
	}
	inicia(LISTA);
	int opt;
	
	do{
		opt=menu();
		opcao(LISTA,opt);
	}while(opt!=5);

	free(LISTA);
	return 0;
}

void inicia(node *LISTA)
{
	LISTA->prox = NULL;
}

int menu(void)
{
	int opt;
	
	printf("Escolha a opcao\n");
	
	printf("1. Exibir lista\n");
	printf("2. Adicionar node no inicio\n");
	printf("3. Adicionar node no final\n");
	printf("4. Zerar lista\n");
	printf("5. Sair\n");
	printf("Opcao: "); scanf("%d", &opt);
	
	return opt;
}

void opcao(node *LISTA, int op)
{   int x ;
	switch(op){	
			
		case 1:
			exibe(LISTA);
			break;
		
		case 2:
		    printf("Novo elemento: "); 
		    scanf("%d", &x);
			insereInicio(LISTA,x);
			break;
		
		case 3:
		    printf("Novo elemento: "); 
		    scanf("%d", &x);
			insereFim(LISTA,x);
			break;		
			
		case 4:
			libera(LISTA);
			break;
			
		case 5:
			libera(LISTA);
			break;
		
		default:
			printf("Comando invalido\n\n");
	}
}

int vazia(node *LISTA)
{
	if(LISTA->prox == NULL)
		return 1;
	else
		return 0;
}


void insereFim(node *LISTA,int x)
{
	node *novo=(node *) malloc(sizeof(node));
	if(!novo){
		printf("Sem memoria disponivel!\n");
		exit(1);
	}
	
	novo->prox = NULL;
	novo->num = x ;
	if(vazia(LISTA))
		LISTA->prox=novo;
	else{
		node *tmp = LISTA->prox;
		
		while(tmp->prox != NULL)
			tmp = tmp->prox;
		
		tmp->prox = novo;
	}
}

void insereInicio(node *LISTA, int x)
{
	node *novo=(node *) malloc(sizeof(node));
	if(!novo){
		printf("Sem memoria disponivel!\n");
		exit(1);
	}
	
	
	node *oldHead = LISTA->prox;
	
	LISTA->prox = novo;
	novo->num = x ;
	novo->prox = oldHead;
}

void exibe(node *LISTA)
{
	if(vazia(LISTA)){
		printf("Lista vazia!\n\n");
		return ;
	}
	
	node *tmp;
	tmp = LISTA->prox;
	
	while( tmp != NULL){
		printf("%5d", tmp->num);
		tmp = tmp->prox;
	}
	printf("\n\n");
}

void libera(node *LISTA)
{
	if(!vazia(LISTA)){
		node *proxNode,
			  *atual;
		
		atual = LISTA->prox;
		while(atual != NULL){
			proxNode = atual->prox;
			free(atual);
			atual = proxNode;
		}
	}
}


