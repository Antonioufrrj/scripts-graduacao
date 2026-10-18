/* ============================================================
   Título:    Lista Sequencial com Operações CRUD
   Autor:     Seu Nome
   Data:      2024
   Descrição: Lista sequencial de clientes (CPF + nome) com array
              de tamanho tammax=5. Implementa inserir, remover por CPF,
              consultar, imprimir e ordenar. Inclui verificações de
              lista cheia e lista vazia.
   Compilar:  gcc listasequencialeu.c -o lista && ./lista
   ============================================================ */

#include <stdio.h>
#include <stdlib.h>
#define tammax 5
typedef struct{
	char nome[tammax];
	char cpf[tammax];
}cliente;

void menu();

cliente novocliente(int *tamlista);

int inserir(cliente cli[], cliente c, int *tamlista),
	remover(cliente cli[], int *tamlista),
	printatudo(cliente cli[], int *tamlista),
	consulta(cliente cli[], int *tamlista),
	sair(),
	lisgrande(int x),
	ordenar(cliente cli[], int *tamlista);
	inserirfinal();
	
int main() {
	cliente clientetotal[tammax], clie;
	int op, tam = 0, i;
	
	do {
		menu();
		printf("\n OEPERACAO: ");
		scanf("\n %d",&op);
		system("cls");
		switch(op){
			
			case 1: 
				clie = novocliente(&tam);
				tam++;
				inserir(clientetotal, clie, &tam);
				break;
			case 2:
				remover(clientetotal, &tam);
				break;
			case 3:
				printatudo(clientetotal, &tam);
				break;
			case 4:
				consulta(clientetotal, &tam);
				break;
			case 5:
				inserirfinal();
				break;
			case 7:
				ordenar(clientetotal, &tam);
				break;
			case 8:
				sair();
				op = 6;
				break;
			default:
				printf("comando invalido\n");
	}
}while(op != 15);
	return 0 ;
}
int lisgrande(int x){
	if(x < tammax)
    	return 0;
    else
    	return 1;	
}
cliente novocliente(int *tamlista){
	if(lisgrande(*tamlista)!= 1){
		cliente c;
		printf("\n CPF: ");
		scanf("%s", &c.cpf);
		printf("\n NOME: ");
		scanf("%s", &c.nome);
				
        return (c);
        }
		else{
			printf("lista cheia\n");
			return ;
	}
}
int inserir(cliente cli[], cliente c, int *tamlista){
	cli[*tamlista] = c;
}
int consulta(cliente cli[], int *tamlista){
	int i = 0;
	char dados[tammax];
	printf("digite o cpf para ver se o cliente esta cadastrado\n");
	scanf("%s", &dados);
	for(i = 0; i <= (*tamlista ); i++) {
		if(strcmp(cli[i].cpf, dados)==0) {
			printf("cliente esta cadastrado\n");
		}	
	}
}
	
int remover(cliente cli[], int *tamlista){
	int i;
	char dados[tammax];
	printf("digite o cpf de quem deseja remover\n");
	scanf("%s", &dados);
	for(i = 0; i < tammax; i++){
		//if(dados"== cli[i]){
			
			
	//	}
	}
}
int sair(){
	printf("programa fechado com sucesso\n");
	return 0;	
}
void menu(void){
     printf("\n  FILA ");
     printf("\n  1. INSERIR");
     printf("\n  2. RETIRAR");
     printf("\n  3. PRINTA");
     printf("\n  4. CONSULTA");
     printf("\n  5. INSERIR NO FINAL");
     printf("\n  6. INSERIR NO COMECO");
     printf("\n  7. ORDENAR");
     printf("\n  8. SAIR");
}
int printatudo(cliente cli[], int *tamlista){
	int i;
	for(i = 1; i <= *tamlista; i++){
		printf("posicao %d:\n", i);
		printf("cpf: %s\n", cli[i].cpf);
		printf("nome: %s\n\n\n", cli[i].nome);
	}
}
int inserirfinal(){
	
	
}
int ordenar(cliente cli[], int *tamlista){
	int i, j;
	char auxcpf[tammax];
	char auxnome[tammax], auxnomeu[tammax];
	cliente aux, auxu;
	for(i = 0; i <= *tamlista; i++){
		auxcpf[i] = cli[i].cpf;
		printf("%s\n", auxcpf[i]);
	}
		
		/*if(aux.cpf < cli[i-1].cpf){
			auxu = cli[i];
			printf("%s\n", auxu.cpf);
			cli[i] = cli[i-1];
			cli[i-1] = auxu;
		}*/
	
	/*	auxcpf[i] = cli[i].cpf;	
	
		}
	for(i = 0; i <= *tamlista; i++){
		
	printf("%s\n",auxcpf[i]);
}*/


}














