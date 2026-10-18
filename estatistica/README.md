# Portfólio de Estatística Aplicada em R

Scripts desenvolvidos durante a graduação/mestrado, aplicando métodos estatísticos a dados de solo e séries temporais. O foco principal é a predição e mapeamento espacial
de atributos do solo usando geoestatística, machine learning e análise de séries temporais.

---

## Estrutura do Repositório

```
estatistica/
├── geostatistica_machine_learning/
│   ├── krigagem_agua_disponivel.R   # Krigagem Ordinária para Água Disponível no Solo
│   ├── krigagem_granulometria.R     # Krigagem para Granulometria do Solo
│   └── random_forest_argila.R       # Random Forest para Predição de Argila
│
└── series_temporais/
    ├── arima_conceitos.R            # Conceitos de AR, MA, ARMA com exemplos simulados
    ├── arima_aplicado.R             # ARIMA aplicado a dados reais de equipamentos elétricos
    └── sarima.R                     # SARIMA aplicado a dados de varejo europeu
```

---

## Resumo dos Projetos

| Pasta | Script | Técnica | Variável Alvo | Produto |
|---|---|---|---|---|
| `geostatistica_machine_learning` | `krigagem_agua_disponivel.R` | Krigagem Ordinária + IDW | Água Disponível (ADT) | Mapa raster + métricas |
| `geostatistica_machine_learning` | `krigagem_granulometria.R` | Krigagem Ordinária | Argila, Silte, Areia | Mapas raster por fração |
| `geostatistica_machine_learning` | `random_forest_argila.R` | Random Forest | Argila | Mapa raster + importância de variáveis |
| `series_temporais` | `arima_conceitos.R` | AR, MA, ARMA | Exportações Egito | Previsão + diagnóstico |
| `series_temporais` | `arima_aplicado.R` | ARIMA com diferenciação | Equipamentos elétricos | Decomposição + previsão |
| `series_temporais` | `sarima.R` | SARIMA | Índice de varejo | Previsão com sazonalidade |

---

## Principais Pacotes Utilizados

- **Espacial:** `sp`, `gstat`, `raster`, `sf`, `tmap`, `mapview`
- **Estatística:** `MASS`, `nortest`, `Metrics`, `caret`
- **Machine Learning:** `randomForest`, `vip`, `usdm`
- **Séries Temporais:** `fpp2`, `fpp3`, `tseries`, `forecast`
- **Visualização:** `ggplot2`, `corrplot`, `ggcorrplot`, `Cairo`

---

## Como Executar

1. Instale os pacotes listados no cabeçalho de cada script
2. Ajuste os caminhos dos dados (`../data/`, `../raster/`, `../shape/`) para o seu diretório local
3. Execute o script no RStudio ou via `Rscript nome_do_script.R`

---

## Autor

**Antonio Carlos**

