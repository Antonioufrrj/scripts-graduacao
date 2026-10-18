/* ============================================================
   Título:    Fila Circular com Array — Cadastro de Clientes
   Autor:     Seu Nome
   Data:      2024
   Descrição: Implementação de fila circular usando array estático de
              tamanho TAM. Gerencia clientes com CPF, nome, endereço,
              telefone e saldo. Índices f (front) e r (rear) controlam
              a posição da fila com aritmética de módulo.
   Compilar:  gcc main.c -o fila && ./fila
   ============================================================ */

#include <stdio.h>
#include <stdlib.h>


#define TAM 3

typedef struct {
    int cpf ; 
    char nome[50];
    char endereco[50];
    char tel[10];
    float saldo;
}TCliente; 

TCliente clienteNovo(void);
int inserirCliente(TCliente P[], int *f ,int *r ,TCliente c);
int retirarCliente(TCliente P[], int *f , int *r );
void imprimeCliente(TCliente P[], int f, int r);
void menu(void);


int main() // melhorar o principal
{ TCliente C[TAM], cli  ;
	int f=-1 , r=-1 , op ;
	
	do{
menu();
printf("\n OEPERACAO: ");
scanf("\n %d",&op);
switch(op){

case 1: cli = clienteNovo();
        inserirCliente(C, &f , &r ,  cli);
        printf("\n f= %d r = %d",f,r);
        imprimeCliente(C,f,r );

        break;

case 2: retirarCliente(C, &f, &r );
        printf("\n f= %d r = %d ",f,r);
        imprimeCliente(C,f,r);
        break;


}

} while(op!= 3);

	return(1);
}

   
 

TCliente clienteNovo(void)
{	 TCliente c ;
	    printf("\n CPF: ");
		scanf("%d", &c.cpf);
		/* printf("\n NOME: ");
        scanf("%s", c.nome);
        printf("\n ENDERECO: ");
        scanf("%s", c.endereco);
        printf("\n TELEFONE: ");
        scanf("%s", c.tel);  
        printf("\n SALDO: "); 
        scanf("%f", &c.saldo);*/
        return(c);
         printf(" \n ");
}						   
	
int inserirCliente(TCliente P[], int *f ,int *r ,TCliente c) {	
	int prov ;
	if ((*f == 0) && (*r == (TAM-1)) )   return -1 ;
	
	if (((*r % (TAM-1))==0)&&(*r!=0))  prov = 0 ;
	                 else
	                prov = (*r % (TAM-1)) + 1 ;
	// printf("\n prov= %d  f = %d r = %d ",prov, *f, *r);
	if (prov != *f ) { *r =  prov ;
		              P[*r] = c ;
	                  if (*f == -1 ) *f = 0 ;
	                  return 1 ;
	                 }
	                 else 
	         
				    return (-1);
				   
}				   
				     
int retirarCliente(TCliente P[], int *f , int *r ) {		
	
    
    if (*f == -1) return -1;
                  else 
                    { if (*f==*r) { *f = -1 ; *r = -1 ; }
						       else 
						       if (((*f % (TAM-1))==0)&&(*f!=0)) *f = 0 ; else  *f = (*f % (TAM-1)) + 1 ;
				     return (1);                     
                    }				       
}

void imprimeCliente(TCliente P[], int f,int r) {
    int i ;
    
    if (f==-1 ) printf("\n PILHA VAZIA");
               else
              {
			   if (f<=r) {
				   printf("\n IMPRIME CLIENTE");      
                   for (i=f;i<r+1;i++) 
                 { printf("\n %d", P[i].cpf);  
	              // printf("\n %s", P[i].nome) ;
	              // printf("\n %s", P[i].endereco);
	              // printf("\n %s", P[i].tel);
	              // printf("\n %f", P[i].saldo);  
	               printf("\n  "); }
	           }    
			           else {
			      
	           printf("\n IMPRIME CLIENTE");      
               for (i=f;i<TAM;i++) 
                 { printf("\n %d", P[i].cpf);  
	              // printf("\n %s", P[i].nome) ;
	              // printf("\n %s", P[i].endereco);
	              // printf("\n %s", P[i].tel);
	              // printf("\n %f", P[i].saldo);  
	               printf("\n ");  
                 }
                 
                 for (i=0;i<r+1;i++) 
                 { printf("\n %d", P[i].cpf);  
	              // printf("\n %s", P[i].nome) ;
	              // printf("\n %s", P[i].endereco);
	              // printf("\n %s", P[i].tel);
	              // printf("\n %f", P[i].saldo);  
	               printf("\n  ");  
                 }
               }
		   }
}

void menu(void){
     printf("\n  FILA ");
     printf("\n  1. INSERIR");
     printf("\n  2. RETIRAR");
     printf("\n  3. SAIR");
    
     }

