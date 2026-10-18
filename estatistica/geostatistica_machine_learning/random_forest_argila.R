# ============================================================
# Título:    Random Forest para Predição de Argila no Solo
# Autor:     Seu Nome
# Data:      2024
# Descrição: Modelagem preditiva de Argila (g.kg-1) usando Random Forest
#            com covariáveis topográficas. Inclui análise de correlação,
#            seleção de variáveis por VIF, validação e geração de mapa.
# Pacotes:   randomForest, caret, vip, usdm, ggcorrplot, tmap, raster, sp
# ============================================================

## Carregando os pacotes necessários
library(vip)          # Importância de variáveis
library(caret)        # Framework de machine learning
library(foreach)
library(doParallel)   # Processamento paralelo
library(readxl)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(raster)
library(sf)           # Simple Features
library(tmap)         # Mapas temáticos
library(tmaptools)
library(RColorBrewer)
library(sp)
library(psych)        # Estatística descritiva detalhada

# ============================================================
# 1. CARREGAMENTO DOS DADOS
# ============================================================

# Dataset completo com todos os pontos e covariáveis
pontosTotal <- read.csv("./DADOS/atributos_cov.csv")

# Visão geral do dataset
names(pontosTotal)
summary(pontosTotal)
str(pontosTotal)

# Dados pré-separados em treino e teste
treino <- read.csv2("./DADOS/treino.csv")
treino[is.na(treino)] <- 0  # Imputação simples: substituição de NA por 0

teste <- read.csv2("./DADOS/teste.csv")
teste[is.na(teste)] <- 0

# ============================================================
# 2. ESTATÍSTICA DESCRITIVA
# ============================================================

# Conjunto completo
pontosTotalstat <- psych::describe(pontosTotal[c(4)])
print(pontosTotalstat)

# Conjunto de treino
DADOSTREINO <- psych::describe(treino[c(5)])
print(DADOSTREINO)

# Conjunto de teste/validação
DADOSTESTE <- psych::describe(teste[c(5)])
print(DADOSTESTE)

# ============================================================
# 3. ANÁLISE EXPLORATÓRIA — DISTRIBUIÇÃO DE ARGILA
# ============================================================

# Boxplot
boxplot(pontosTotal$ARGILA,
        main = "Distribuição de Argila",
        xlab = "Argila (g.kg-1)",
        col  = "orange",
        border = "brown",
        horizontal = TRUE,
        notch = TRUE)

# Teste de normalidade — Kolmogorov-Smirnov (n > 50)
ks.test(pontosTotal$ARGILA, "pnorm",
        mean(pontosTotal$ARGILA), sd(pontosTotal$ARGILA), exact = TRUE)
ks.test(treino$ARGILA, "pnorm", mean(treino$ARGILA), sd(treino$ARGILA), exact = TRUE)
ks.test(teste$ARGILA,  "pnorm", mean(teste$ARGILA),  sd(teste$ARGILA),  exact = TRUE)

# Histograma com densidade
ggplot(data = pontosTotal, aes(ARGILA)) +
  geom_histogram(aes(y = ..density..), breaks = seq(0, 900, by = 50),
                 col = "blue", fill = "red", alpha = 0.2) +
  geom_density(col = 4) +
  labs(title = "Distribuição de Argila — Conjunto Completo",
       x = "Argila (g.kg-1)", y = "Densidade")

# ============================================================
# 4. ANÁLISE DE CORRELAÇÃO E MULTICOLINEARIDADE (VIF)
# ============================================================

# Removendo colunas não preditoras para a análise de correlação
DADOSCOR_VIF <- treino[, -c(1:4, 6, 7)]

library(corrplot)
cor_mat <- cor(DADOSCOR_VIF)

# Visualização da matriz de correlação
corrplot(cor_mat, method = "number")

library(ggcorrplot)
ggcorrplot(cor_mat,
           type = "lower", show.legend = TRUE, show.diag = TRUE,
           lab = TRUE, lab_size = 3, tl.cex = 13,
           tl.col = "black", method = "circle", outline.col = "white",
           colors = c("blue", "white", "red"))

# Análise de VIF — remoção de variáveis com VIF > 10
library(usdm)
VIF_M <- usdm::vifstep(DADOSCOR_VIF, th = 10)
print(VIF_M)

# ============================================================
# 5. SELEÇÃO DAS COVARIÁVEIS PARA MODELAGEM
# ============================================================

# Removendo variáveis com alta multicolinearidade e baixa correlação com Argila
TREINO_ARGILA <- treino[, -c(1:3, 5, 6, 7, 11, 8, 9, 10, 17:19, 14)]
TESTE_ARGILA  <- teste[,  -c(1:3, 5, 6, 7, 11, 8, 9, 10, 17:19, 14)]

names(TREINO_ARGILA)  # Verificar variáveis selecionadas

# ============================================================
# 6. TREINAMENTO DO MODELO RANDOM FOREST
# ============================================================

library(randomForest)
set.seed(100)

MODELARGILA <- randomForest(
  ARGILA ~ .,
  data      = TREINO_ARGILA,
  importance = TRUE,
  proximity  = TRUE,
  ntree      = 500,
  mtry       = 4  # aproximadamente 1/3 do número de variáveis
)

print(MODELARGILA)

# Importância das variáveis
round(importance(MODELARGILA), 1)

par(mfrow = c(1, 2))
varImpPlot(MODELARGILA, pch = 19, main = "Importância das Variáveis — RF Argila")
par(mfrow = c(1, 1))

plot(MODELARGILA, main = "Erro OOB em função do número de árvores")

# Método alternativo de visualização da importância
vip::vip(MODELARGILA, num_features = 13L)

# ============================================================
# 7. AVALIAÇÃO NO CONJUNTO DE TREINO
# ============================================================

estima_treino          <- predict(MODELARGILA, TREINO_ARGILA)
TREINO_ARGILA$estima   <- estima_treino
metrics_treino         <- caret::postResample(estima_treino, TREINO_ARGILA$ARGILA)
print(metrics_treino)

r2_treino  <- summary(lm(ARGILA ~ estima, data = TREINO_ARGILA))
RMSE_treino <- sqrt(mean((TREINO_ARGILA$ARGILA - estima_treino)^2))
MAE_treino  <- mean(abs(TREINO_ARGILA$ARGILA - estima_treino))

# Gráfico predito vs. observado — Treino
ggplot(TREINO_ARGILA, aes(x = ARGILA, y = estima)) +
  geom_point() +
  stat_smooth(method = "lm", col = "red") +
  ggtitle("Random Forest — Treino") +
  xlab("Argila Observada (g.kg-1)") +
  ylab("Argila Estimada (g.kg-1)") +
  annotate("text", x = 250, y = 660,
           label = paste("R² =", signif(r2_treino$r.squared, 2)),
           color = "black", size = 4) +
  annotate("text", x = 250, y = 630,
           label = paste("RMSE =", round(RMSE_treino, 2)),
           color = "black", size = 4) +
  annotate("text", x = 250, y = 600,
           label = paste("MAE =", round(MAE_treino, 2)),
           color = "black", size = 4) +
  theme(plot.title = element_text(color = "black", size = 12, face = "bold"))

# ============================================================
# 8. AVALIAÇÃO NO CONJUNTO DE VALIDAÇÃO (TESTE)
# ============================================================

estima_teste         <- predict(MODELARGILA, TESTE_ARGILA)
TESTE_ARGILA$estima  <- estima_teste
metrics_teste        <- caret::postResample(estima_teste, TESTE_ARGILA$ARGILA)
print(metrics_teste)

r2_teste   <- summary(lm(ARGILA ~ estima, data = TESTE_ARGILA))
RMSE_teste <- sqrt(mean((TESTE_ARGILA$ARGILA - estima_teste)^2))
MAE_teste  <- mean(abs(TESTE_ARGILA$ARGILA - estima_teste))

# Gráfico predito vs. observado — Validação
ggplot(TESTE_ARGILA, aes(x = ARGILA, y = estima)) +
  geom_point() +
  stat_smooth(method = "lm", col = "red") +
  ggtitle("Random Forest — Validação") +
  xlab("Argila Observada (g.kg-1)") +
  ylab("Argila Estimada (g.kg-1)") +
  annotate("text", x = 180, y = 580,
           label = paste("R² =", signif(r2_teste$r.squared, 2)),
           color = "black", size = 4) +
  annotate("text", x = 180, y = 560,
           label = paste("RMSE =", round(RMSE_teste, 2)),
           color = "black", size = 4) +
  annotate("text", x = 180, y = 540,
           label = paste("MAE =", round(MAE_teste, 2)),
           color = "black", size = 4) +
  theme(plot.title = element_text(color = "black", size = 12, face = "bold"))

# ============================================================
# 9. PREDIÇÃO NO GRID E GERAÇÃO DO MAPA
# ============================================================

# Carregando o grid de covariáveis para predição espacial
grid <- read.csv2("./DADOS/grid.csv", sep = ",", dec = ".")
grid[is.na(grid)] <- 0

# Selecionando apenas as colunas que o modelo espera
gridT <- grid[, -c(1:3, 8, 10)]
names(gridT)

# Predição
predicao_grid <- predict(MODELARGILA, gridT)
predicao_df   <- cbind(pred = predicao_grid, gridT[, 1:2])

summary(predicao_df$pred)

# Convertendo para SpatialPixelsDataFrame e depois para raster
library(spsurvey)
gridded(predicao_df) <- ~X + Y

r_argila <- raster::raster(predicao_df["pred"])
plot(r_argila, main = "Argila Predita — Random Forest (g.kg-1)")

# Exportando o raster
library(rgdal)
writeGDAL(predicao_df["pred"], "MAPA_ARGILA_RF.tif")

# ============================================================
# 10. MAPA TEMÁTICO COM tmap
# ============================================================

# Convertendo pontos para objeto espacial
WGS84_24S <- CRS("+proj=utm +zone=24 +south +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")
coordinates(pontosTotal) <- ~X + Y
sp::proj4string(pontosTotal) <- WGS84_24S

# Shapefiles de apoio
limite <- rgdal::readOGR("./LIMITE", "Limite")
ARGILA <- rgdal::readOGR("./LIMITE", "ARGILA")
hidro1 <- rgdal::readOGR("./LIMITE", "hidro1")
hidro2 <- rgdal::readOGR("./LIMITE", "hidro2")

# Mapa de pontos com escala proporcional ao teor de argila
mapa_pontos <- tmap::tm_shape(limite) +
  tmap::tm_polygons(col = "darkgrey") +
  tmap::tm_shape(hidro1) +
  tmap::tm_lines(col = "blue", scale = 0.2, alpha = 0.2) +
  tmap::tm_shape(hidro2) +
  tmap::tm_polygons(col = "blue", alpha = 1) +
  tmap::tm_shape(ARGILA) +
  tmap::tm_symbols(col = "ARGILA", palette = "YlOrRd",
                   size = "ARGILA", scale = 1,
                   legend.size.show = FALSE,
                   legend.col.show  = TRUE,
                   title.col = "Argila (g.kg-1)") +
  tmap::tm_compass(position = c("center", "top"), size = 4) +
  tmap::tm_grid(alpha = 0.2, labels.size = 1, labels.rot = c(0, 90),
                n.x = 5, n.y = 6) +
  tmap::tm_scale_bar(position = c("right", "bottom"), text.size = 1) +
  tmap::tm_layout(legend.position = c("left", "top"), legend.text.size = 1)

mapa_pontos

# Exportando
tmap::tmap_save(mapa_pontos, filename = "./figures/MAPA_ARGILA_RF.tiff",
                width = 15, height = 20, units = "cm", dpi = 300)
