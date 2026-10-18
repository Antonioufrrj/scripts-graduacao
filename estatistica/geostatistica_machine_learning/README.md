# Geoestatística e Machine Learning Aplicados ao Solo

Scripts de predição e mapeamento espacial de atributos do solo usando
Krigagem Ordinária e Random Forest. Todos os scripts trabalham com dados
geoespaciais referenciados em UTM e geram mapas raster como produto final.

---

## Scripts

### `krigagem_agua_disponivel.R`
Predição espacial da **Água Disponível Total no Solo (ADT)** até 1 metro de profundidade.

**Fluxo de análise:**
1. Carregamento e conversão dos dados para `SpatialPointsDataFrame`
2. Análise exploratória da dependência espacial (variograma de nuvem e experimental)
3. Separação treino/validação (`set.seed(2021)`)
4. Testes de normalidade — Shapiro-Wilk e Shapiro-Francia
5. Transformação Box-Cox e back-transformation
6. Ajuste de semivariogramas: Esférico, Exponencial e Gaussiano
7. Comparação com IDW (Inverse Distance Weighting)
8. Validação externa e cruzada — R², MAE, RMSE, MSE, Bias
9. Predição no grid raster e exportação de mapas (`.tif` / `.tiff`)

**Pacotes principais:** `sp`, `gstat`, `MASS`, `forecast`, `tmap`, `mapview`, `Metrics`

---

### `krigagem_granulometria.R`
Predição espacial das frações granulométricas (**Argila, Silte e Areia**) até 100 cm.

**Fluxo de análise:**
1. Carregamento de perfis completos e parciais de solo
2. Cálculo da **média ponderada por espessura de horizonte** até 100 cm (`dplyr`)
3. Análise de correlação entre atributos e covariáveis topográficas
4. Separação treino/validação (`set.seed(1000)`)
5. Ajuste de semivariogramas e Krigagem Ordinária para cada fração
6. Validação com R², MAE, RMSE, MSE, Bias — modelos Sph, Exp e Gau
7. Exportação dos resultados para Excel e geração de mapas raster

**Pacotes principais:** `sp`, `gstat`, `tidyverse`, `corrplot`, `Cairo`, `Metrics`, `writexl`

---

### `random_forest_argila.R`
Predição espacial de **Argila** usando Random Forest com covariáveis topográficas.

**Fluxo de análise:**
1. Carregamento dos dados de pontos com covariáveis topográficas
2. Estatística descritiva e teste de normalidade (Kolmogorov-Smirnov)
3. Matriz de correlação e análise de multicolinearidade via VIF (`usdm`)
4. Seleção de covariáveis (remoção de variáveis com VIF > 10)
5. Treinamento do Random Forest (`ntree = 500`, `mtry = 4`)
6. Importância das variáveis (`vip`, `varImpPlot`)
7. Métricas no treino e validação: R², RMSE, MAE
8. Gráficos de dispersão predito vs. observado
9. Predição no grid e exportação do mapa raster
10. Mapas temáticos com `tmap`

**Pacotes principais:** `randomForest`, `caret`, `vip`, `usdm`, `ggcorrplot`, `tmap`, `raster`

---

## Dados de Entrada

| Arquivo | Conteúdo | Usado em |
|---|---|---|
| `ADT1m_cov.xlsx` | Pontos de ADT + covariáveis topográficas | Krigagem ADT |
| `data_completo.xlsx` | Perfis completos de solo com granulometria | Krigagem Granulometria |
| `data_parciais_final.xlsx` | Perfis parciais de solo | Krigagem Granulometria |
| `MDEHC1.tif` | Modelo Digital de Elevação (grid de referência) | Krigagem ADT e Granulometria |
| `atributos_cov.csv` | Pontos de argila + covariáveis topográficas | Random Forest |
| `grid.csv` | Grid de covariáveis para predição espacial | Random Forest |
| `Limite.shp` | Shapefile do limite da área de estudo | Todos |

---

## Modelos Avaliados

| Método | Tipo | Variável Alvo |
|---|---|---|
| Esférico (Sph) | Geoestatístico | ADT, Argila, Silte, Areia |
| Exponencial (Exp) | Geoestatístico | ADT, Argila, Silte, Areia |
| Gaussiano (Gau) | Geoestatístico | ADT, Argila, Silte, Areia |
| IDW | Determinístico | ADT |
| Random Forest | Machine Learning | Argila |

---

## Sistema de Coordenadas

Todos os dados estão referenciados em **UTM zona 24S / WGS84**
(`+proj=utm +zone=24 +south +datum=WGS84 +units=m`).
