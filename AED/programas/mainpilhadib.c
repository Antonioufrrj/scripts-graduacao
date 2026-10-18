/* ============================================================
   Título:    Pilha com Array Estático (Stack)
   Autor:     Seu Nome
   Data:      2024
   Descrição: Pilha LIFO de clientes usando array de tamanho TAM=100.
              O ponteiro "topo" controla a posição atual.
              Push incrementa topo antes de inserir;
              Pop decrementa topo sem apagar o dado.
   Compilar:  gcc mainpilhadib.c -o pilha && ./pilha
   ============================================================ */

#include <stdio.h>


#define TAM 100

typedef struct {
    int cpf ; 
    char nome[50];
    char endereco[50];
    char tel[10];
    float saldo;
}TCliente; 


TCliente clienteNovo(void);
int inserirCliente(TCliente P[], int *topo , TCliente c);
int retirarCliente(TCliente P[], int *topo );
void imprimeCliente(TCliente P[], int n);
void menu(void);


int main() // melhorar o principal
{ TCliente C[TAM], cli  ;
	int topo=-1  , op ;
	
	do{
menu();
printf("\n OEPERACAO: ");
scanf("\n %d",&op);
switch(op){

case 1: cli = clienteNovo();
        inserirCliente(C, &topo ,  cli);
        imprimeCliente(C, topo +1 );

        break;

case 2: retirarCliente(C, &topo );
        imprimeCliente(C, topo +1 );
        break;


}

} while(op!= 3);

	return(1);
}

  

TCliente clienteNovo(void)
{	 TCliente c ;
	    printf("\n CPF: ");
		scanf("%d", &c.cpf);
		printf("\n NOME: ");
        scanf("%s", c.nome);
        printf("\n ENDERECO: ");
        scanf("%s", c.endereco);
        printf("\n TELEFONE: ");
        scanf("%s", c.tel);  
        printf("\n SALDO: "); 
        scanf("%f", &c.saldo);
        return(c);
         printf("\n \n ");
}						   
	
int inserirCliente(TCliente P[], int *topo , TCliente c) {	
	if (*topo>=TAM) return -1 ;
	         else { (*topo)++ ; 
				    P[*topo] = c ;
				    return (1);
				   }
}				   
				     
int retirarCliente(TCliente P[], int *topo ) {		
	
    
    if (*topo == -1) return -1;
                  else 
                    { (*topo)-- ; 
				    return (1);                     
                    }				       
}

void imprimeCliente(TCliente P[], int n) {
    int i ;
    
    if (n==0 ) printf("\n PILHA VAZIA");
               else
              {
	           printf("\n IMPRIME CLIENTE");      
               for (i=0;i<n;i++) 
                 { printf("\n %d", P[i].cpf);  
	               printf("\n %s", P[i].nome) ;
	               printf("\n %s", P[i].endereco);
	               printf("\n %s", P[i].tel);
	               printf("\n %f", P[i].saldo);  
	               printf("\n \n ");  
                 }
               }
}

void menu(void){
     printf("\n  PILHA ");
     printf("\n  1. INSERIR");
     printf("\n  2. RETIRAR");
     printf("\n  3. SAIR");
    
     }

