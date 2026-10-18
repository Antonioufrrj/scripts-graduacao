# Diferenças Finitas para Equações Diferenciais Parciais

Implementação do método de diferenças finitas para a resolução numérica da
**Equação do Calor** (EDP parabólica) em Python, comparando as abordagens
explícita e implícita.

---

## Arquivo

### `Diferenças_finitas.ipynb`

**Problema:**
Resolver a equação de difusão de calor em 1D:

```
∂u/∂t = α² · ∂²u/∂x²
```

Com condições de contorno homogêneas e condição inicial `g(x) = sin(πx/2)`.

**Métodos implementados:**

| Método | Fórmula | Estabilidade |
|---|---|---|
| **Explícito** | `u_i^{k+1} = u_i^k + D·(ht/hx²)·(u_{i+1}^k − 2u_i^k + u_{i-1}^k)` | Condicional (r ≤ 0.5) |
| **Implícito** | `(1 + 2D·ht/hx²)u_i^k − D·ht/hx²·(u_{i+1}^k + u_{i-1}^k) = u_i^{k-1}` | Incondicional |

**Parâmetros utilizados:**
- Domínio espacial: `[0, 2]` m com passo `hx = 0.05`
- Domínio temporal: `[0, 2]` s com passo `ht = 0.001`
- Difusividade: `D = 1`

**Fluxo de análise:**
1. Definição das condições de contorno e condição inicial
2. Verificação da condição de convergência do método explícito (`D·ht/hx² ≤ 0.5`)
3. Construção da malha espaço-temporal
4. Iteração temporal com o método explícito
5. Visualização 3D da solução `u(x, t)` com `matplotlib` e `mpl_toolkits`

**Pacotes:** `numpy`, `matplotlib`, `mpl_toolkits`

---

## Conceitos Abordados

- Discretização por diferenças finitas (forward, backward e central differences)
- Estabilidade numérica e condição de Courant-Friedrichs-Lewy (CFL)
- Método explícito (FTCS — Forward Time, Centered Space)
- Método implícito (BTCS — Backward Time, Centered Space)
- Visualização de soluções em superfícies 3D
