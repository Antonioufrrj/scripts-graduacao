# Matemática Computacional — Python

Notebooks desenvolvidos durante a graduação, aplicando métodos numéricos
e algoritmos de otimização para resolver problemas matemáticos.
Implementações em Python usando `numpy`, `matplotlib` e redes neurais.

---

## Estrutura do Repositório

```
matemática/
├── diferencas_finitas/
│   └── Diferenças_finitas.ipynb    # Equação do calor (EDP) — métodos explícito e implícito
│
├── solucao_edo_1_ordem/
│   ├── solucao_edo_1_ordem.ipynb   # EDO via rede neural (SGD e Levenberg-Marquardt)
│   ├── euler.ipynb                 # Método de Euler para EDO de 1ª ordem
│   └── rungekuta4.ipynb            # Runge-Kutta 4ª ordem para sistema de EDOs
│
└── ProblemaMochilaGenetico.ipynb   # Problema da Mochila com Algoritmo Genético
```

---

## Resumo dos Notebooks

| Arquivo | Tema | Técnica | Problema |
|---|---|---|---|
| `Diferenças_finitas.ipynb` | EDP | Diferenças finitas (explícito/implícito) | Equação do calor em 1D |
| `solucao_edo_1_ordem.ipynb` | EDO | Rede neural (Physics-Informed NN) | EDO de 1ª ordem |
| `euler.ipynb` | EDO | Método de Euler | EDO de 1ª ordem |
| `rungekuta4.ipynb` | Sistema de EDOs | Runge-Kutta 4ª ordem | Pêndulo não-linear amortecido |
| `ProblemaMochilaGenetico.ipynb` | Otimização | Algoritmo Genético | Problema da Mochila 0/1 |

---

## Descrição Detalhada

### `diferencas_finitas/`
Solução numérica da **equação do calor** (EDP parabólica) usando diferenças finitas.
Compara o método **explícito** (FTCS) — condicional à condição CFL — com o método
**implícito** (BTCS), que é incondicionalmente estável. Gera visualizações 3D da
evolução temporal da temperatura.

### `solucao_edo_1_ordem/`
Três abordagens para resolução de EDOs:
- **Rede Neural:** minimiza o resíduo da EDO em vez do erro clássico — sem malha (mesh-free)
- **Euler:** método de primeira ordem, simples e didático
- **Runge-Kutta 4:** método de quarta ordem, alta precisão para sistemas de EDOs

### `ProblemaMochilaGenetico.ipynb`
Solução do **Problema da Mochila 0/1** (NP-difícil) usando um **Algoritmo Genético**.
Implementa: representação binária dos indivíduos, função de fitness, seleção por roleta
proporcional, crossover de ponto único e mutação. Aplicado a dois cenários:
itens com pesos/valores inteiros e seleção de carteira de ações com risco/retorno.

---

## Pacotes Utilizados

- `numpy` — operações matriciais e vetoriais
- `matplotlib` — visualização 2D e 3D
- `mpl_toolkits` — gráficos 3D (superfícies)
- `random` — aleatoriedade para algoritmos genéticos

---

## Como Executar

1. Abra os notebooks no **Google Colab** ou **Jupyter Notebook**
2. Execute as células em ordem sequencial
3. Os notebooks são autocontidos — não precisam de dados externos

---

## Autor

**Antonio Carlos**