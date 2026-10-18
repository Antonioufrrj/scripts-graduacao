/* ============================================================
   Título:    Lista Duplamente Encadeada
   Autor:     Seu Nome
   Data:      2024
   Descrição: Lista duplamente encadeada com nós que possuem ponteiros
              para o nó anterior (ant) e próximo (prox). Permite navegação
              bidirecional. Operações: inserir/retirar no início e no fim,
              exibir na ordem direta e inversa, troca de valores e ordenação
              por Bubble Sort.
   Compilar:  gcc duplaencadeadaeu.c -o dupla && ./dupla
   ============================================================ */

#include <stdio.h>
#include <stdlib.h>

struct Node{
	int num;
	struct Node *ant;
	struct Node *prox;
}; 
typedef struct Node node;

void inicia(node *LISTA);
int menu(void);
void opcao(node *LISTA, int op);
void exibe(node *LISTA);
void ordenar(node *LISTA, int final);
void exibeInversa(node *LISTA);
void trocarproximo(node *LISTA);
void trocarfinal(node *LISTA);
node * busca(node *LISTA, int x);
void insereFim(node *LISTA, int x);
void insereInicio(node *LISTA, int x);
void retiraFim(node *LISTA);
void retiraInicio(node *LISTA);
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
	}while(opt!=7);

	free(LISTA);
	return 0;
}

void inicia(node *LISTA)
{
	LISTA->ant = NULL;
	LISTA->prox = NULL;
	LISTA->num = -1;
}

int menu(void)
{
	int opt;
	
	printf("Escolha a opcao\n");	
	printf("0. Exibir lista\n");
    printf("1. Exibir lista Inversa\n");
	printf("2. Adicionar node no inicio\n");
	printf("3. Adicionar node no final\n");
	printf("4. Retirar node no inicio\n");
	printf("5. Retirar node no final\n");	
	printf("6. troca proximo\n");
	printf("7. Sair\n");
	printf("Opcao: "); scanf("%d", &opt);
	
	return opt;
}

void opcao(node *LISTA, int op)
{   int x, cont = 0;
	switch(op){	
			
        case 0:
        	system("cls");
			exibe(LISTA);
			break;
			
		case 1:
			exibeInversa(LISTA);
			break;
		
		case 2:
			system("cls");
			printf("%d", cont);
		    printf("Novo elemento: "); 
		    scanf("%d", &x);
			insereInicio(LISTA,x);
			break;
		
		case 3:
			system("cls");
			cont ++;
		    printf("Novo elemento: "); 
		    scanf("%d", &x);
			insereFim(LISTA,x);
			break;	
			
		case 4:
			system("cls");
			retiraInicio(LISTA);
			break;	
			
		case 5:
			system("cls");
			trocarfinal(LISTA);
			break;
		
		case 6:
			system("cls");
			trocarproximo(LISTA);
			break;
			
		case 7:
			system("cls");
			libera(LISTA);
			break;
		case 8:
			ordenar(LISTA, cont);
			break;
		default:
			system("cls");
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

void exibe(node *LISTA){  
	if(vazia(LISTA)){
		printf("lista vazia\n");
		return ;
	}  
	node *aux;
	aux = LISTA->prox;
	while(aux->prox->prox != NULL){
		printf("%3d", aux->num);
		aux = aux->prox;
	}
	printf("\n\n\n");
	system("pause");
	system("cls");
}

void exibeInversa(node *LISTA){
	if(vazia(LISTA)){
		printf("Lista vazia!\n\n");
		return ;
	}
	
	node *tmp;
	tmp = LISTA->ant;
	
	while( tmp != LISTA){
		printf("%5d", tmp->num);
		tmp = tmp->ant;
	}
	printf("\n\n\n");
	system("pause");
	system("cls");
}

void insereFim(node *LISTA,int x){
	node *novo = (node *) malloc(sizeof(node));
	if(!novo){
		printf("sem memoria disponivel\n");
		exit(1);
	}
	
	novo->num = x;
	if(LISTA->prox == LISTA){
		LISTA->prox = novo;
		LISTA->ant = novo ;
		novo->ant = LISTA ; 
		novo->prox = LISTA;
	}
	else{
	node *aux = LISTA->ant;
	aux->prox = novo;   //  lista->ant e o ultimo q recebe o novo q a aponta pro ultimo e se tornado ultimo novo aponta pra lista q e null lista aponta pra ele//
	novo->ant = aux;
	novo->prox = LISTA;
	LISTA->ant = novo;
}
}

void insereInicio(node *LISTA, int x){
	node *novo = (node *) malloc(sizeof(novo));
	if(!novo){
		printf("sem memoria disponivel\n");
		exit(1);
	}
	novo->num = x;
	if(vazia(LISTA)){
		LISTA->prox = novo;
		LISTA->ant = novo;
		novo->ant = LISTA;
		novo->prox = LISTA;
	}
	else{
		node *aux = LISTA->prox;     //   [null][-1][lista->prox]     [lista ][novo][prox aux ]     [ ][aux][ ]
		LISTA->prox = novo;
		novo->ant = LISTA;
		novo->prox = aux;
		aux->ant = novo;
	}
	
}
void trocarproximo(node *LISTA){
	int x;
	node *auxp = LISTA->prox;
	node *auxs = auxp->prox;//   [segun prox][pri][terc]   [NULL][segun][prox]     [ant prime][ter][]
	x = auxp->num;
	auxp->num = auxs->num; 
	auxs->num = x;
	system("pause");
}
void trocarfinal(node *LISTA){
	int x;
	node *auxp = LISTA->prox;
	node *auxs = LISTA->ant;
	x = auxp->num;
	auxp->num = auxs->num;
	auxs->num = x;
	
}

void ordenar(node *LISTA, int final){
	int x, i, cont = 0;
	if(vazia(LISTA)){
		printf("lista vazia\n");
		return ;
	}
	node *aux = LISTA->prox;
	node *auxs = aux->prox;
	printf("%d", final);
	while(aux->prox != LISTA){
		cont ++;
	//	printf("%d", cont);
		aux = aux->prox;
	}
	for(i = 0; i < cont; i++){
		aux = LISTA->prox;
		auxs = aux->prox;
		while(aux->prox != LISTA){
			if(aux->num > auxs->num){
				x = aux->num;
				aux->num = auxs->num;
				auxs->num = x;
			}
			auxs = auxs->prox;
			aux = aux->prox;
		}
	}
}

void retiraFim(node *LISTA){
	
	
	
}

void retiraInicio(node *LISTA){
	
	
	
}


node * busca(node *LISTA, int x)
{

}


void libera(node *LISTA) 
{
	
}

