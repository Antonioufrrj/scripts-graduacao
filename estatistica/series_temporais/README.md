# Séries Temporais — ARIMA e SARIMA

Scripts com implementação progressiva de modelos para análise e previsão de séries
temporais, desde os conceitos básicos de AR/MA/ARMA até modelos sazonais (SARIMA).

---

## Scripts

### `arima_conceitos.R`
Introdução aos fundamentos de séries temporais com simulações e aplicação real.

**Conteúdo:**
- Função de Autocorrelação (FAC) e FAC Parcial (FACP)
- Cálculo manual do coeficiente r₁
- Simulação e visualização de processos AR(1), AR(4), MA(q) e ARMA(p,q)
- Aplicação: exportações do Egito (dados `global_economy` do `fpp3`)
- Seleção automática de modelo com `auto.arima()` + previsão 10 anos à frente

### `arima_aplicado.R`
ARIMA com diferenciação aplicado a dado real da indústria.

**Conteúdo:**
- Decomposição da série de equipamentos elétricos da Zona do Euro
- Ajuste sazonal via STL (`stl` + `seasadj`)
- Identificação da ordem do modelo via FAC/FACP na série diferenciada
- Ajuste e comparação de ARIMA(3,1,1), ARIMA(3,1,0), ARIMA(4,1,0)
- Seleção por AICc
- Diagnóstico de resíduos (`checkresiduals`, Shapiro-Wilk)
- Previsão com intervalos de confiança

### `sarima.R`
Modelo SARIMA para dados com padrão sazonal explícito.

**Conteúdo:**
- Visualização do índice de varejo europeu (`euretail`)
- Diferenciação sazonal e não-sazonal
- Ajuste de SARIMA(0,1,1)(0,1,1) e SARIMA(0,1,3)(0,1,1)
- Diagnóstico e previsão 12 períodos à frente
- Seleção automática com `auto.arima()`

---

## Dados Utilizados

| Dataset | Descrição | Pacote |
|---|---|---|
| `beer` | Produção mensal de cerveja | `fpp2` |
| `global_economy` | Exportações por país (1960–2017) | `fpp3` |
| `elecequip` | Índice de pedidos de equipamentos elétricos | `fpp2` |
| `euretail` | Índice de varejo europeu trimestral | `fpp2` |

---

## Conceitos Abordados

- Estacionariedade e diferenciação
- FAC e FACP como ferramentas de identificação de ordem
- Critério de informação AICc para seleção de modelos
- Diagnóstico de resíduos e teste de normalidade
- Previsão com intervalos de confiança
