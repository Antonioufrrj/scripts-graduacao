# Solução de EDO de Primeira Ordem com Redes Neurais

Implementação de uma rede neural artificial para resolver uma **Equação
Diferencial Ordinária (EDO) de primeira ordem**, usando backpropagation
e os algoritmos de otimização **SGD** e **Levenberg-Marquardt**.

---

## Arquivos

### `solucao_edo_1_ordem.ipynb`

**Problema:**
Resolver a EDO de primeira ordem:

```
dy/dx = x³ + 2x + x²·(1 + 3x²)/(1 + x + x³) − (x + (1 + 3x²)/(1 + x + x³))·(1 + x·y)
```

Com solução analítica: `y = x/(1 + x + x³)`

**Abordagem:**
A solução aproximada é parametrizada como:
```
y_t(x) = y(0) + x · N(x, θ)
```
onde `N(x, θ)` é a saída de uma rede neural com parâmetros `θ` (pesos e biases).
O treinamento minimiza o resíduo da EDO em vez do erro quadrático médio clássico.

**Arquitetura da Rede:**
- Camada de entrada: 1 neurônio
- Camada oculta: 10 neurônios com ativação Sigmoide
- Camada de saída: 1 neurônio (linear)

**Algoritmos de Treinamento:**

| Algoritmo | Descrição |
|---|---|
| **SGD** (Stochastic Gradient Descent) | Atualização estocástica dos pesos usando gradiente |
| **Levenberg-Marquardt** | Otimização de segunda ordem, mais eficiente para redes pequenas |

**Fluxo de análise:**
1. Definição do domínio `x ∈ [0, 1]` com 10 pontos de treinamento
2. Inicialização aleatória dos pesos (distribuição gaussiana)
3. Feedforward: cálculo da saída e do resíduo da EDO
4. Backpropagation: cálculo dos gradientes analíticos
5. Atualização dos parâmetros (SGD ou Levenberg-Marquardt)
6. Convergência quando o erro < 10⁻⁶ para todos os pontos

**Pacotes:** `numpy`, `matplotlib`, `random`

---

### `euler.ipynb`

Implementação do **Método de Euler** para resolução numérica de EDO de primeira ordem.

**Problema:**
```
dy/dx = 1/(1 + x²) − 2y²,    y(0) = 0
```

Solução analítica: `y = x/(1 + x²)`

**Método de Euler:**
```
y[i] = y[i-1] + f(x[i-1], y[i-1]) · h
```

**Parâmetros:** `t₀ = 0`, `t = 2`, `n = 50 passos`

**Fluxo:**
1. Definição da EDO `dydx(x, y)`
2. Implementação da função `euler(t0, y0, t, n)`
3. Cálculo da solução analítica para comparação
4. Plotagem comparando solução numérica e analítica

**Pacotes:** `numpy`, `matplotlib`

---

### `rungekuta4.ipynb`

Implementação do **Método de Runge-Kutta de 4ª Ordem** para sistema de EDOs.

**Problema (pêndulo não-linear amortecido):**
```
dx₀/dt = x₁
dx₁/dt = −9·sin(x₀) − (1/5)·x₁
```

**Método Runge-Kutta 4:**
```
k₁ = f(t, y)
k₂ = f(t + h/2, y + h/2·k₁)
k₃ = f(t + h/2, y + h/2·k₂)
k₄ = f(t + h,   y + h·k₃)
y_k = y + (h/6)·(k₁ + 2k₂ + 2k₃ + k₄)
```

**Fluxo:**
1. Definição do sistema de EDOs `ff(t, x)`
2. Implementação do RK4 com vetores numpy
3. Visualização do plano de fase e da solução temporal

**Pacotes:** `numpy`, `matplotlib`

---

## Comparativo dos Métodos

| Método | Ordem | Erro Global | Casos de Uso |
|---|---|---|---|
| Euler | 1ª | O(h) | Didático, passos pequenos |
| Runge-Kutta 4 | 4ª | O(h⁴) | Boa precisão com passos maiores |
| Rede Neural | — | Depende do treinamento | Abordagem sem malha (mesh-free) |

---

## Conceitos Abordados

- Métodos numéricos para EDOs: Euler e Runge-Kutta de 4ª ordem
- Resolução de EDOs com redes neurais (Physics-Informed Neural Networks)
- Backpropagation com gradientes analíticos derivados da EDO
- Algoritmos de otimização: SGD e Levenberg-Marquardt
- Sistemas de EDOs (pêndulo não-linear amortecido)
- Comparação entre solução numérica e solução analítica
