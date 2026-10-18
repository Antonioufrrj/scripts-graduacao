/* ============================================================
   Título:    Árvore Binária de Busca (BST)
   Autor:     Seu Nome
   Data:      2024
   Descrição: Árvore binária de busca com nós alocados dinamicamente.
              Propriedade BST: valores maiores à direita (prox),
              menores à esquerda (ant). A remoção trata os três casos:
              nó folha, nó com um filho e nó com dois filhos (substitui
              pelo maior da subárvore esquerda).
   Compilar:  gcc arvore_binaria.c -o bst && ./bst
   ============================================================ */

#include <stdio.h>
#include <stdlib.h> // ponteiro 
typedef struct no{
	int info;
	struct no *prox;
	struct no *ant;
};

arv* criararv();

int inserir(arv *raiz, int valor),
	remover(arv *raiz, int valor),
	printar(arv *raiz);
	
struct no* remove_atual(struct no* atual);

void menu();

int main() {
	int op, valor;
	arv* raiz = criararv();
	
	do{
		menu();
		scanf("%d", &op);
		system("cls");
		switch (op){
			case 1:
				printf("digite um valor para inserir\n");
				scanf("%d", &valor);
				inserir(raiz, valor);
				break;
			case 2:
				printf("digite o valor para remover\n");
				scanf("%d", &valor);
				remover(raiz, valor);
				break;
			case 3:
				printar(raiz);
				break;	
		}
	}while(op != 5);
	return 0;
}

void menu(){
	system("cls");
	printf("\n		OPERACAO\n\n");
	printf("(1)inserir\n");
	printf("(2)remover\n");
	printf("(3)printa\n");
	printf("(4)buscar\n");
	printf("(5)sair\n");
}
arv* criararv(){
	arv* raiz = (arv*) malloc(sizeof(arv));
	if(raiz == NULL){
		return raiz;
	}
	else 
		*raiz = NULL;
	return raiz;
}
int inserir(arv *raiz, int valor){
	if(raiz == NULL)
		return 0;
	struct no* novo =(struct no*) malloc(sizeof(struct no));// criar um novo elemento
	if(novo == NULL)// verificar se criou certo o novo elemento
		return 0;
	novo->info = valor;
	novo->prox = NULL;
	novo->ant = NULL;
	if(*raiz == NULL)// adicionar qnd a arvore e vazia
		*raiz = novo;
	else{
		struct no* atual = *raiz;
		struct no* ant = NULL;
		while(atual != NULL){// achar o no folha para adicionar o novo
			ant = atual;
			if(valor == atual->info){// se ja existe na arvore
				free(novo);
				return 0;
			}
			if(valor > atual->info)
				atual = atual->prox;//vai pra direita
			else
				atual = atual->ant;//vai pra esquerda
		}
		if(valor > ant->info)
			ant->prox = novo;
		else
			ant->ant = novo;
	}
	return 1;
}

int remover(arv *raiz, int valor){
	struct no* atual = *raiz;
	struct no* ant = NULL;
	if(*raiz == NULL) // qnd n tem nada na arvore
		return 0;
	while(atual != NULL){
		if(valor == atual->info){
			if(atual == *raiz)// qnd so tem um elemento na arvore
				*raiz = remove_atual(atual);
			
			if(ant->prox = atual)  // qnd o no(valor) ta do lado direito do anterior
				ant->prox = remove_atual(atual);
					
			if(ant->ant = atual) 
					ant->ant = remove_atual(atual);// qnd o no(valor) ta do lado esquerdo do anterior
					
					//printf("%d", ant->ant);
					//system("pause");
			
			
			return 1;
		}
		ant = atual;
		if(valor > atual->info)// continua procurando o no a se removido
			atual = atual->prox;
		else
			atual = atual->ant;	
	}
}
struct no* remove_atual(struct no* atual){
	struct no *no1, *no2;
	if(atual->ant == NULL){// trata qnd e no folha ou qndo n tem filho a esquerda
	
		no2 = atual->prox;
		
		free(atual);
		return no2;
	}
	no1 = atual;
	no2 = atual->ant;
	while(no2->prox != NULL){
		no1 = no2;
		no2 = no2->prox;
	}
	if(no1 != atual){
		no1->prox = no2->ant;
		no2->ant = atual->ant;
	}
	no2->prox = atual->prox;
	free(atual);
	return no2;
}

int printar(arv *raiz){
	struct no* atual = *raiz;
	if(atual == NULL){
		printf("coe");
		system("pause");
		return 0;
	}
	printf("%60d\n", atual->info);
	printe(atual);
}
int printe(arv atual){
	int i, n = 0;
	while(atual != NULL){
		if(atual->ant != NULL){
			printf("%55d", atual->ant->info);
		}
		if(atual->prox != NULL){
			printf("%10d\n", atual->prox->info);
		}
		atual = atual->prox;
		n = n + 1;
		for(i = 0; i < n; i++){
			printf("     ");
		}
	}
	system("pause");
}



















