/* ============================================================
   Título:    Tabela Hash com Encadeamento por Colisão
   Autor:     Seu Nome
   Data:      2024
   Descrição: Tabela hash de tamanho tam=7 com tratamento de colisão
              por encadeamento (chaining). Função hash: num % 7.
              Operações: inserir, remover, buscar, imprimir, calcular
              percentual de ocupação, índice de colisões, quantidade
              de elementos e posições vazias.
   Compilar:  g++ hash.cpp -o hash && ./hash
   ============================================================ */

# include <stdio.h>

# include <stdlib.h>

# include <string.h>

# define tam 7



struct dados

{

  int info;

  struct dados *prox;

};



typedef struct dados Dados;

typedef Dados* Hash[tam];



int funcaoHash(int num);

void inicializaHash(Hash tab); 

void insereHash(Hash tab,int num);

void buscaHash(Hash tab, int num);

void imprimeHash(Hash tab);

void removeHash(Hash tab, int num);

float porcentagemHash(Hash tab);

void indiceColisao(Hash tab);

int quantidadeColisao(Hash tab);

int quantidadeElementos(Hash tab);

void posicoesVazias(Hash tab);

void imprimeColisao(Hash tab, int pos);

void opcao(Hash tab, int op);

int menu(void);





int funcaoHash(int num)

{

  return(num%tam);

}





void inicializaHash(Hash tab)

{

 int i;

 for(i = 0; i < tam; i++)

 {

  tab[i] = NULL;

 }

}

//O procedimento insererHash insere os elementos na tabela atraves da funcaoHash 



void insereHash(Hash tab, int num)

{

 

 int chave = funcaoHash(num);

 Dados* aux = tab[chave];

 while(aux != NULL)

 {

  if(aux->info == num)

  {

   break;

  }

  aux = aux->prox;

 }

 if(aux == NULL)

 {

  aux = (Dados*)malloc(sizeof(Dados));

  aux->info = num;

  aux->prox = tab[chave];

  tab[chave] = aux;

  

 }

}



/*O procedimento buscaHash determina a posicao da

 tabela que o usuario deseja visualizar*/

void buscaHash(Hash tab,int num)

{

 int pos = num;

 if(num > tam || num < 0)

 {

  printf("\nPosicao nao encontrada!");

  return;

 }else

 {

  imprimeColisao(tab,pos);



}}

/*O procedimento imprimeHash recebe como parametro uma variavel do tipo Hash.

Sua funcao e imprimir todos os elementos da variavel do tipo Hash*/

void imprimeHash(Hash tab)

{

 int  i = 0;

 for(i = 0; i < tam; i++)

 {

  if(tab[i] != NULL)

  {

   printf("\n %d",tab[i]->info);

   Dados* aux =tab[i]->prox;

   while(aux!=NULL)

   {

    printf(" -> %3d",aux->info);

     aux=aux->prox;

   }

  }

 }

}





void removeHash(Hash tab, int num){
	int pos = num;
	int ex ;
	if(num > tam){
		printf("\nEsta posicao nao existe na tabela!");
	}
  	if(tab[pos] == NULL){
		printf("Esta chave esta vazia!");
  	}else{
		printf("\n\n\n");
		imprimeColisao(tab,pos);
   		printf("\n\nQual registro deseja apagar =  ");
		scanf("%d",&ex);
		if(tab[pos]->info == ex){
			if(tab[pos]->prox == NULL){
				tab[pos] = NULL;
				return;
    		}
			if(tab[pos]->prox != NULL){
		    	tab[pos]->info = tab[pos]->prox->info;
     			tab[pos]->prox = tab[pos]->prox->prox;
     			return;
			}
   		}
   		if(tab[pos]->info != ex){
			if(tab[pos]->prox == NULL){
			    printf("\nRegistro nao encontrado!");
     			return;
			}else{
				Dados* ant = NULL;
			    Dados* aux = tab[pos]->prox;
			    while(aux->prox != NULL  && aux->info != ex){
    			ant = aux;
				aux = aux->prox;
			}
    		if(aux->info != ex){
    			printf("\nRegistro nao encontrado!\n");
				return;
			}
			if(ant == NULL){
				tab[pos]->prox = aux->prox;
			}else{
				ant->prox = aux->prox;
			}
        	aux = NULL;
        	free(aux);
        	}
		}
    }
}

  



// Exercicio 5 

float porcentagemHash(Hash tab)

{

 int i;

 float porcent = 0, cont  = 0;

 for(i = 0; i < tam; i++)

 {

  if(tab[i] != NULL)

  {

   cont++;

  }

 }

 porcent = (cont*100)/tam;

 return(porcent);

}



// Exercicio6

void indiceColisao(Hash tab)

{

 int i;

 printf("\nOcorreram colisoes nas posicoes\n");

 for(i = 0 ; i< tam; i++)

 {

  if(tab[i] != NULL && tab[i]->prox)

  {

   printf("%d\t",i);

  }

 }

 return;

}



// Exercicio7

int quantidadeColisao(Hash tab)

{

 int i, cont = 0;

 for(i = 0; i < tam; i++)

 {

  Dados* aux = tab[i];

  if(aux != NULL)

  {

    while(aux->prox != NULL)

    {

     cont++;

     aux = aux->prox;

    }

  }

 }

 return cont;

}



// Exercicio8

int quantidadeElementos(Hash tab)

{

 int i, cont = 0;

 for(i = 0; i < tam; i++)

 {

  Dados* aux = tab[i];

  if(aux != NULL)

  { cont++;

    while(aux->prox != NULL)

    {

     cont++;

     aux = aux->prox;

    }

  }

 }

 return cont;

}





/*O procedimento posicaoVazias mostra todas as posicoes que apos a insercao

continuam nulas.*/

void posicoesVazias(Hash tab)

{

 int i, cont = 0;

 printf("Posicoes Vazias\n");

 for(i = 0; i < tam; i++)

 {

  if(tab[i] == NULL)

  {

   printf("%d\t",i);

   cont++;



  }

 }

 printf("\nTotal de posicoes vazias = %d",cont);

}



/*O procedimento imprimeColisaon mostra uma posicao

e todas as suas colisoes.*/

void imprimeColisao(Hash tab, int pos)

{

 Dados* aux = tab[pos];

 if(aux == NULL)

 {

  printf("Esta posicao esta vazia!");

  return;

 }else

 {

  if(aux != NULL)

  {

   printf("%3d",aux->info);

   while(aux->prox != NULL)

   {

    printf(" -> %d",aux->prox->info);

    aux = aux->prox;

   }

  }

 }

}





 int main(void)

{

	Hash HASH ;

	int opt;

	inicializaHash(HASH);

	

	do{

		opt=menu();

		opcao(HASH,opt);

	}while(opt!=5);



	return 0;

}







int menu(void)

{

	int opt;

	printf("\n\n\n");

	printf("Escolha a opcao\n");

	

	printf("1. Exibir Tabela Hash\n");

	printf("2. Adicionar node no inicio\n");

	printf("3. Remover No\n");

	printf("4. Qtde de Elementos\n");

	printf("5. Sair\n");

	printf("Opcao: "); scanf("%d", &opt);

	

	return opt;

}



void opcao(Hash tab, int op)

{   int x ;

	switch(op){	

			

		case 1:

			imprimeHash(tab);

			break;

		

		case 2:

		    printf("Novo elemento: "); 

		    scanf("%d", &x);

			insereHash(tab,x);

			break;

		

		case 3:

		    printf("Posicao na Tabela Hash: "); 

		    scanf("%d", &x);

			removeHash(tab,x);

			break;		

			

		case 4:

			printf("\n Qtde de Elementos :%d ",quantidadeElementos(tab));

			break;

			

		case 5:

			//libera(LISTA);

			break;

		

		default:

			printf("Comando invalido\n\n");

	}

}



