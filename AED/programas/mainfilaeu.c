/* ============================================================
   Título:    Fila com Array Estático (Queue)
   Autor:     Seu Nome
   Data:      2024
   Descrição: Fila FIFO de clientes (apenas CPF) com array de
              tamanho tammax=5. Inserção no final do array;
              remoção no início com deslocamento de todos os
              elementos uma posição à esquerda.
   Compilar:  gcc mainfilaeu.c -o fila && ./fila
   ============================================================ */

#include <stdio.h>
#include <stdlib.h>
#define tammax 5
int inserir(cliente cli[], int *tamlista, cliente clien),
	remover(cliente cli[], int *tamlista),
	sair(),
	menu(),
	printa(cliente cli[], int *tamlista),
	listapequena(int x),
	listagrande(int x);
cliente novocliente(int *tamlista);

int main() {
	int op, tam = 0;
	cliente aux, clitotal[tammax];
	
	do{
		menu();
		scanf("%d", &op);
		system("cls");
		switch(op){
			case 1:
				aux = novocliente(&tam);
				inserir(clitotal, &tam, aux);
				tam++;
				break;
			case 2:
				remover(clitotal, &tam);
				tam--;
				break;
			case 3:
				printa(clitotal, &tam);
				break;
			case 4:
				break;
			case 5:
				break;
			default:
				sair();
		}
	
	}while(op!=0);
	
	
	return 0;
}
int menu(){
	 printf("\n  FILA ");
     printf("\n  1. INSERIR");
     printf("\n  2. RETIRAR");
     printf("\n  3. PRINTA");
     printf("\n  4. CONSULTA");
     printf("\n  5. SAIR");
	 printf("\n");
}
int listagrande(int x){
	if(x < tammax){
		return 0;
	}
	else
		return 1;
}
cliente novocliente(int *tamlista){
	if(listagrande(*tamlista) != 1){
		cliente c;
		printf("\n CPF: ");
		scanf("%s", &c.cpf);
		return (c);
	}
	else
		printf("lista cheia\n");
        		
}
int inserir(cliente cli[], int *tamlista, cliente clien){
	cli[*tamlista] = clien;
}
int printa(cliente cli[], int *tamlista){
	int i;
	for(i = 0; i < *tamlista; i++){
		printf("posicao: %d\ncpf:     %s\n", i, cli[i].cpf);
	}
}
int sair(){
	
}
int listapequena(int x){
	if(x > 0){
		return 0;
	}
	else 
		return 1;
}
int remover(cliente cli[], int *tamlista){
	int i;
	if(listapequena(*tamlista) != 1){
		 for(i = 0; i < *tamlista; i++){
		 	cli[i]= cli[i+1];
		 }
		 
	}
	else
		printf("lista vazia\n");
}































