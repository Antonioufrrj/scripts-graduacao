# Programas — Estruturas de Dados com Alocação Dinâmica

Esta pasta contém as implementações que utilizam **alocação dinâmica de memória**
(`malloc`/`free`) e estruturas mais avançadas. Os arquivos da raiz (`main.c` e `main1.c`)
usam arrays estáticos e servem como ponto de partida para os conceitos básicos.

---

## Arquivos

### `mainpilhadib.c` — Pilha com Array
Pilha estática de clientes com ponteiro `topo`.

| Operação | Comportamento |
|---|---|
| `inserirCliente` | Incrementa `topo`, insere no índice atual (Push) |
| `retirarCliente` | Decrementa `topo` sem apagar o dado (Pop) |
| `imprimeCliente` | Percorre do índice 0 até `topo` |

Campos do cliente: CPF, nome, endereço, telefone, saldo.

---

### `mainfilaeu.c` — Fila com Array
Fila de CPFs com array de tamanho `tammax = 5`.

| Operação | Comportamento |
|---|---|
| `inserir` | Insere na posição `tamlista` atual |
| `remover` | Desloca todos os elementos uma posição à esquerda (FIFO) |
| `printa` | Exibe posição e CPF de cada elemento |

---

### `listasequencialeu.c` — Lista Sequencial
Lista de clientes (CPF + nome) com array de tamanho `tammax = 5`.

| Operação | Comportamento |
|---|---|
| `inserir` | Adiciona no índice indicado por `tamlista` |
| `remover` | Busca por CPF e remove (implementação incompleta) |
| `consulta` | Busca por CPF usando `strcmp` |
| `printatudo` | Imprime CPF e nome de todos os elementos |
| `ordenar` | Ordenação por CPF (implementação em progresso) |

---

### `mainlistaencadeada.c` — Lista Simplesmente Encadeada

Estrutura do nó:
```c
struct Node {
    int num;
    struct Node *prox;
};
```

| Operação | Comportamento |
|---|---|
| `insereInicio` | Aloca novo nó, aponta para o antigo head |
| `insereFim` | Percorre até o último nó e encadeia o novo |
| `exibe` | Percorre do head até `NULL` imprimindo valores |
| `libera` | Percorre a lista liberando cada nó com `free` |

---

### `duplaencadeadaeu.c` — Lista Duplamente Encadeada

Estrutura do nó:
```c
struct Node {
    int num;
    struct Node *ant;   // ponteiro para o anterior
    struct Node *prox;  // ponteiro para o próximo
};
```

| Operação | Comportamento |
|---|---|
| `insereInicio` | Encadeia nos dois sentidos no início |
| `insereFim` | Encadeia nos dois sentidos no final |
| `exibe` | Percorre `prox` do início ao fim |
| `exibeInversa` | Percorre `ant` do fim ao início |
| `trocarproximo` | Troca valores entre o primeiro e segundo nós |
| `trocarfinal` | Troca valores entre o primeiro e último nós |
| `ordenar` | Bubble Sort percorrendo a lista pelos valores |

---

### `arvore_binaria.c` — Árvore Binária de Busca (BST)

Estrutura do nó (usa `prox` = filho direito, `ant` = filho esquerdo):
```c
struct no {
    int info;
    struct no *prox;   // filho direito (maior)
    struct no *ant;    // filho esquerdo (menor)
};
```

| Operação | Comportamento |
|---|---|
| `inserir` | Percorre a árvore comparando valores; insere na folha correta |
| `remover` | Localiza o nó e chama `remove_atual` para tratar os casos |
| `remove_atual` | Trata: (1) nó folha, (2) sem filho esquerdo, (3) substitui pelo maior da subárvore esquerda |
| `printar` | Exibe a raiz e chama `printe` para os demais níveis |

**Propriedade BST:** `filho_esquerdo < nó_pai < filho_direito`

---

### `hash.cpp` — Tabela Hash com Encadeamento

Tabela com `tam = 7` posições. Cada posição armazena uma lista ligada para tratar colisões.

**Função hash:** `chave = num % 7`

| Operação | Comportamento |
|---|---|
| `insereHash` | Calcula chave, percorre a lista da posição para evitar duplicata |
| `removeHash` | Localiza posição e elemento na lista encadeada, remove e libera memória |
| `buscaHash` | Exibe todos os elementos de uma posição (chave) |
| `imprimeHash` | Exibe todas as posições não nulas com suas listas |
| `porcentagemHash` | Retorna `(posições ocupadas / tam) * 100` |
| `indiceColisao` | Lista posições que têm mais de um elemento (colisão) |
| `quantidadeColisao` | Conta total de elementos em posições com colisão |
| `quantidadeElementos` | Conta todos os elementos em toda a tabela |
| `posicoesVazias` | Lista posições `NULL` e o total |
