# Algoritmos e Estruturas de Dados em C/C++

Implementações das principais estruturas de dados lineares e não-lineares,
desenvolvidas durante a disciplina de Algoritmos e Estruturas de Dados.
Todos os programas são interativos via menu no terminal e usam alocação
dinâmica de memória com `malloc` e `free`.

---

## Estrutura do Repositório

```
AED/
├── main.c                        # Fila circular com array — cadastro de clientes
├── main1.c                       # Lista sequencial com busca binária e ordenação
└── programas/
    ├── mainpilhadib.c            # Pilha com array estático
    ├── mainfilaeu.c              # Fila com array estático
    ├── listasequencialeu.c       # Lista sequencial com operações CRUD
    ├── mainlistaencadeada.c      # Lista simplesmente encadeada com ponteiros
    ├── duplaencadeadaeu.c        # Lista duplamente encadeada com ponteiros
    ├── arvore_binaria.c          # Árvore binária de busca (BST)
    └── hash.cpp                  # Tabela hash com encadeamento por colisão
```

---

## Resumo dos Programas

| Arquivo | Estrutura | Técnica de Armazenamento | Operações Implementadas |
|---|---|---|---|
| `main.c` | **Fila Circular** | Array estático | Inserir, Retirar, Imprimir |
| `main1.c` | **Lista Sequencial** | Array estático | Criar, Busca linear, Busca binária, Ordenação (Bubble Sort), Inserir, Remover |
| `mainpilhadib.c` | **Pilha** | Array estático | Push, Pop, Imprimir (LIFO) |
| `mainfilaeu.c` | **Fila** | Array estático | Enqueue, Dequeue, Imprimir (FIFO) |
| `listasequencialeu.c` | **Lista Sequencial** | Array estático | Inserir, Remover, Consultar, Imprimir, Ordenar |
| `mainlistaencadeada.c` | **Lista Simplesmente Encadeada** | Alocação dinâmica | Inserir início, Inserir fim, Exibir, Liberar |
| `duplaencadeadaeu.c` | **Lista Duplamente Encadeada** | Alocação dinâmica | Inserir início/fim, Remover início/fim, Exibir, Exibir inversa, Ordenar |
| `arvore_binaria.c` | **Árvore Binária de Busca (BST)** | Alocação dinâmica | Inserir, Remover, Imprimir |
| `hash.cpp` | **Tabela Hash** | Encadeamento por colisão | Inserir, Buscar, Remover, Imprimir, % ocupação, índice de colisão |

---

## Descrição Detalhada

### `main.c` — Fila Circular
Implementação de uma **fila circular** usando array de tamanho fixo (`TAM = 3`).
Gerencia cadastro de clientes com os campos: CPF, nome, endereço, telefone e saldo.
A lógica circular é feita com aritmética de módulo nos índices `f` (front) e `r` (rear).

### `main1.c` — Lista Sequencial com Busca Binária
Lista sequencial de clientes com as operações:
- **Busca linear** — percorre sequencialmente procurando o CPF
- **Busca binária** — requer lista ordenada; divide o espaço de busca pela metade a cada passo
- **Ordenação** — algoritmo Bubble Sort comparando CPFs
- Retirada de saldo com validação de existência e suficiência

### `mainpilhadib.c` — Pilha (Stack)
Pilha com array e ponteiro `topo`. Comportamento **LIFO** (Last In, First Out).
Armazena clientes completos (CPF, nome, endereço, telefone, saldo).

### `mainfilaeu.c` — Fila (Queue)
Fila com array e controle por tamanho. Comportamento **FIFO** (First In, First Out).
Inserção no final, remoção com deslocamento dos elementos.

### `listasequencialeu.c` — Lista Sequencial CRUD
Lista com array de tamanho `tammax = 5`. Operações: inserir, remover por CPF,
consultar, imprimir e ordenar. Inclui verificação de lista cheia/vazia.

### `mainlistaencadeada.c` — Lista Simplesmente Encadeada
Lista com **nós alocados dinamicamente** via `malloc`. Cada nó contém um inteiro
e um ponteiro para o próximo nó. Operações: inserir no início, inserir no fim,
exibir e liberar toda a memória alocada.

### `duplaencadeadaeu.c` — Lista Duplamente Encadeada
Lista com nós que possuem ponteiros `prox` e `ant` (bidirecional). Permite
navegação nos dois sentidos. Operações: inserir/retirar no início e no fim,
exibir na ordem direta e inversa, ordenação por Bubble Sort.

### `arvore_binaria.c` — Árvore Binária de Busca (BST)
Árvore binária de busca com nós alocados dinamicamente. A inserção segue a
propriedade BST: valores maiores vão para a direita, menores para a esquerda.
A remoção trata os três casos: nó folha, nó com um filho e nó com dois filhos.

### `hash.cpp` — Tabela Hash com Encadeamento
Tabela hash de tamanho `tam = 7` com **tratamento de colisão por encadeamento**
(chaining com lista ligada em cada posição). Função hash: `num % tam`.
Operações extras: percentual de ocupação, índice de colisões, quantidade de
elementos e posições vazias.

---

## Como Compilar e Executar

**Arquivos `.c` (GCC):**
```bash
gcc nome_do_arquivo.c -o programa
./programa
```

**Arquivo `.cpp` (G++):**
```bash
g++ hash.cpp -o hash
./hash
```

**No Windows (MinGW):**
```cmd
gcc nome_do_arquivo.c -o programa.exe
programa.exe
```

---

## Conceitos Abordados

- Estruturas de dados lineares: **Pilha**, **Fila**, **Lista Sequencial**, **Lista Encadeada**
- Estruturas de dados não-lineares: **Árvore Binária de Busca**, **Tabela Hash**
- Alocação dinâmica de memória: `malloc`, `free`
- Algoritmos de busca: **Busca Linear** e **Busca Binária**
- Algoritmos de ordenação: **Bubble Sort**
- Tratamento de colisão em tabelas hash: **Encadeamento (Chaining)**
- Ponteiros simples e duplos em C

---

## Autor

**Antonio Carlos**