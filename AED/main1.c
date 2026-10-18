/* ============================================================
   Título:    Lista Sequencial com Busca Binária e Ordenação
   Autor:     Seu Nome
   Data:      2024
   Descrição: Lista sequencial de clientes com array estático (TAM=100).
              Implementa busca linear, busca binária (requer lista ordenada)
              e ordenação por Bubble Sort comparando CPFs. Inclui operações
              de inserir, remover e retirar saldo com validação.
   Compilar:  gcc main1.c -o lista_seq && ./lista_seq
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

void criarLista(TCliente P[], int n);
int busca(TCliente P[], int n , int cpf);
int retirarSaldo(TCliente P[], int n , int cpf, float quantia);
int inserirCliente(TCliente P[], int *n , TCliente c);
int retirarCliente(TCliente P[], int *n ,int cpf);
void imprimeCliente(TCliente P[], int n);
int buscaBinaria(TCliente P[],int inicio, int fim, int cpf);
void ordenar(TCliente P[],int n) ;

int main() // melhorar o principal
{ TCliente C[TAM], cli  ;
	int n ;
	printf("\n n: ");
	scanf("%d", &n);
	criarLista(C,n);
	imprimeCliente(C,n);
	
	ordenar(C,n);
	imprimeCliente(C,n);
	printf("\n busca = %d",buscaBinaria(C,0,n,2));
	// printf("\n busca = %d",busca(C,n,2));
	//retirarSaldo(C,  n , 2, 500);
	//retirarCliente(C,&n,1);
	//imprimeCliente(C,n);
	return(1);
}

   void criarLista(TCliente P[], int n){
    int i ;
    for (i=0;i<n;i++)
    {   printf("\n CPF: ");
		scanf("%d", &P[i].cpf);
		printf("\n NOME: ");
        scanf("%s", P[i].nome);
        printf("\n ENDERECO: ");
        scanf("%s", P[i].endereco);
        printf("\n TELEFONE: ");
        scanf("%s", P[i].tel);  
        printf("\n SALDO: "); 
        scanf("%f", &P[i].saldo);
         printf("\n \n ");
    }  
 }
 
int busca(TCliente P[], int n , int cpf) { 
int i = 0 , res = -1 ;
    for (i=0;i<n;i++)
        if (P[i].cpf == cpf ) 
                { res = i ;
				  
                  break ;
				}  
				  		
	return (res) ;
}	
	
// a funcao retorna 1 se a retirada foi possivel , -1 se nao encontrou o cliente e -2 caso nao tenha saldo	
int retirarSaldo(TCliente P[], int n , int cpf, float quantia) {
    int i = 0, res ;
    res = busca(P,n,cpf);
    if (res == -1) return -1;
                  else 
                  if (P[res].saldo >= quantia) 
                         { P[res].saldo -= quantia ;   
						   return(1);}
						   else return(-2);
}						   
	
int inserirCliente(TCliente P[], int *n , TCliente c) {	
	if (*n>=TAM) return -1 ;
	         else { (*n)++ ; 
				    P[*n] = c ;
				    return (1);
				   }
}				   
				     
int retirarCliente(TCliente P[], int *n ,int cpf) {		
	int i = 0, res ;
    res = busca(P,*n,cpf);
    if (res == -1) return -1;
                  else 
                  { for (i=res;i<*n-1;i++)
                        P[i] = P[i+1];	
                        (*n)--;
                        return 1 ;                        
                  }				       
}

void imprimeCliente(TCliente P[], int n) {
    int i ;
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

void ordenar(TCliente P[],int n) {
    int i , j ;
    TCliente aux ;
    if (n>1){ 
	 printf("\n");	
            for(j=0;j<n-1;j++) 
              for(i=0;i<n-1;i++) 
              if(P[i].cpf >P[i+1].cpf) { aux = P[i];
				                P[i] = P[i+1];
				                P[i+1] = aux ;
				                
							  }    
     	           
   }                   
                
 }   
 
 int buscaBinaria(TCliente P[],int inicio, int fim, int cpf) {
    int meio ;
       
                   while  (inicio<=fim)                    
                   {
                   meio = (int) (inicio+fim)/2 ;
                   if (cpf == P[meio].cpf) break ;
					                        
                                      else 
                                      if (cpf < P[meio].cpf) fim = meio -1 ;
                                                         else  
	 		                                              inicio = meio + 1 ;
                     
                   }
                   
                   if (inicio<= fim) return (meio) ;
                                  else return -1 ; 
 }   

