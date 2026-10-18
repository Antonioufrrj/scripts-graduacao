# ============================================================
# Título:    Krigagem Ordinária para Granulometria do Solo
# Autor:     Seu Nome
# Data:      2024
# Descrição: Predição espacial de Argila, Silte e Areia até 100 cm de
#            profundidade via média ponderada por espessura de horizonte
#            e Krigagem Ordinária com três modelos de semivariograma.
#            Inclui análise de correlação, separação treino/validação e
#            métricas de qualidade (R², MAE, RMSE, MSE, Bias).
# Pacotes:   sp, gstat, tidyverse, corrplot, Cairo, Metrics, writexl, zoo
# ============================================================

## Carregando os pacotes necessários
library(tidyverse)
library(sp)
library(rgdal)
library(tmap)
library(corrplot)
library(gstat)
library(gvlma)
library(lmtest)
library(nortest)
library(Metrics)
library(zoo)
library(writexl)
library(Cairo)    # Exportação de gráficos em alta resolução

# ============================================================
# 1. CARREGAMENTO DOS DADOS
# ============================================================

# Perfis completos e parciais de solo
dados   <- readxl::read_xlsx("../data/data_completo.xlsx",      skip = 15)
dados_p <- readxl::read_xlsx("../data/data_parciais_final.xlsx")

# Dados de Água Disponível (ADT) com covariáveis topográficas
ADT <- readxl::read_xlsx("../data/ADT1m_cov.xlsx", skip = 15)

# Criando variável de interação espacial X*Y (normalizada)
ADT$XY <- (ADT$X^2 + ADT$Y^2 + ADT$X * ADT$Y) / (10^6)

# ============================================================
# 2. MATRIZ DE CORRELAÇÃO — ADT vs. COVARIÁVEIS
# ============================================================

cor_mat <- cor(ADT[c(2:5, 12, 13, 16:26, 35)])

nomes_var <- c("AWC", "Sand", "Silt", "Clay",
               "DEM", "SLOPE", "PLANC", "PROFC", "CONV", "CATA",
               "TWI", "LSFACTOR", "RSP", "CHND", "CHNB",
               "MRVBF", "MRRTF", "XY")

colnames(cor_mat) <- nomes_var
rownames(cor_mat) <- nomes_var

Cairo(file = "../figures/AWC_correlation.png",
      type = "png", units = "px",
      width = 12000, height = 10000, pointsize = 30, dpi = 500)
corrplot::corrplot(cor_mat, method = "number")
dev.off()

# ============================================================
# 3. PRÉ-PROCESSAMENTO — HARMONIZAÇÃO DAS UNIDADES
# ============================================================

# Convertendo dados parciais para a mesma escala dos dados completos
dados_p$Argila <- dados_p$Argila * 10
dados_p$Silte  <- dados_p$Silte  * 10
dados_p$ARG    <- dados_p$ARG    * 10
dados_p$AF     <- dados_p$AF     * 10
dados_p$AM     <- dados_p$AM     * 10
dados_p$AT     <- dados_p$AT     * 10

# ============================================================
# 4. MÉDIA PONDERADA POR ESPESSURA DE HORIZONTE ATÉ 100 cm
# ============================================================

prof <- 100  # profundidade limite em cm

# Função de cálculo aplicada para perfis parciais
dados1 <- dados_p %>%
  filter(top < prof) %>%
  mutate(
    thickness2 = ifelse(bottom > prof, thickness - (bottom - prof), thickness),
    bottom2    = ifelse(bottom > prof, prof, bottom)
  ) %>%
  mutate(media_argila = Argila * thickness2 / 100) %>% drop_na(media_argila) %>%
  mutate(media_AT     = AT     * thickness2 / 100) %>% drop_na(media_AT)     %>%
  mutate(media_Silte  = Silte  * thickness2 / 100) %>% drop_na(media_Silte)  %>%
  group_by(perfil) %>%
  mutate(
    media_argila = cumsum(media_argila),
    media_AT     = cumsum(media_AT),
    media_Silte  = cumsum(media_Silte)
  ) %>%
  filter(bottom2 == 100) %>%
  drop_na(X)

# Mesma função para perfis completos
dados2 <- dados %>%
  filter(top < prof) %>%
  mutate(
    thickness2 = ifelse(bottom > prof, thickness - (bottom - prof), thickness),
    bottom2    = ifelse(bottom > prof, prof, bottom)
  ) %>%
  mutate(media_argila = Argila * thickness2 / 100) %>% drop_na(media_argila) %>%
  mutate(media_AT     = AT     * thickness2 / 100) %>% drop_na(media_AT)     %>%
  mutate(media_Silte  = Silte  * thickness2 / 100) %>% drop_na(media_Silte)  %>%
  group_by(perfil) %>%
  mutate(
    media_argila = cumsum(media_argila),
    media_AT     = cumsum(media_AT),
    media_Silte  = cumsum(media_Silte)
  ) %>%
  filter(bottom2 == 100) %>%
  drop_na(X)

# Unindo os dois conjuntos e filtrando valores válidos
data_projir <- merge(dados1, dados2, all = TRUE) %>%
  filter(media_argila > 0, media_AT > 0)

# ============================================================
# 5. ESTATÍSTICA DESCRITIVA E HISTOGRAMAS
# ============================================================

Cairo(file = "../figures/hist_granulometria.png",
      type = "png", units = "px",
      width = 4000, height = 2000, pointsize = 30, dpi = 500)

p_awc <- ggplot(data = ADT, aes(ADT)) +
  geom_histogram(aes(y = ..density..), breaks = seq(0, 300, by = 20),
                 col = "blue", fill = "red", alpha = 0.2) +
  geom_density(col = 4) +
  labs(title = "AWC", x = "AWC (mm)", y = "Densidade")

p_clay <- ggplot(data = data_projir, aes(media_argila)) +
  geom_histogram(aes(y = ..density..), breaks = seq(0, 900, by = 50),
                 col = "blue", fill = "red", alpha = 0.2) +
  geom_density(col = 4) +
  labs(title = "Argila", x = "Argila (g.kg-1)", y = "Densidade")

p_sand <- ggplot(data = data_projir, aes(media_AT)) +
  geom_histogram(aes(y = ..density..), breaks = seq(0, 900, by = 50),
                 col = "blue", fill = "red", alpha = 0.2) +
  geom_density(col = 4) +
  labs(title = "Areia", x = "Areia (g.kg-1)", y = "Densidade")

library(patchwork)
p_awc + p_clay + p_sand
dev.off()

# Resumos estatísticos
summary(data_projir$media_argila)
summary(data_projir$media_AT)
summary(data_projir$media_Silte)

# Testes de normalidade (Shapiro-Wilk)
shapiro.test(data_projir$media_argila)
shapiro.test(data_projir$media_AT)
shapiro.test(data_projir$media_Silte)
# Nota: dados não apresentam normalidade; transformações (log, Box-Cox)
# foram testadas mas não resolveram — análise prosseguiu sem transformação.

# ============================================================
# 6. SEPARAÇÃO TREINO / VALIDAÇÃO
# ============================================================

set.seed(1000)
data_projir$ID <- 1:nrow(data_projir)
valida    <- data_projir[sample(1:nrow(data_projir), 132), ]
treino    <- data_projir[-valida$ID, ]

# Convertendo para SpatialPointsDataFrame
WGS84_24S <- CRS("+proj=utm +zone=24 +south +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")

coordinates(treino) <- ~X + Y
sp::proj4string(treino) <- WGS84_24S

coordinates(valida) <- ~X + Y
sp::proj4string(valida) <- WGS84_24S

# Grid de referência para predição espacial
raster_ref <- raster::raster("../raster/MDEHC1.tif")
sp::proj4string(raster_ref) <- WGS84_24S
grid <- as(raster_ref, "SpatialPixelsDataFrame")

# ============================================================
# 7. KRIGAGEM PARA ARGILA
# ============================================================

v <- variogram(media_argila ~ 1, treino, cutoff = 16000, width = 1800)
print(plot(v, plot.numbers = FALSE, main = "Semivariograma — Argila"))

# Modelos iniciais
vm1 <- vgm(psill = 9000,  model = "Sph", range = 12000, nugget = 21800)
vm2 <- vgm(psill = 10000, model = "Exp", range = 5500,  nugget = 21500)
vm3 <- vgm(psill = 7500,  model = "Gau", range = 6000,  nugget = 23500)

# Ajuste automático
vmf1 <- fit.variogram(v, vm1); print(plot(v, pl = FALSE, model = vmf1))
vmf2 <- fit.variogram(v, vm2); print(plot(v, pl = FALSE, model = vmf2))
vmf3 <- fit.variogram(v, vm3); print(plot(v, pl = FALSE, model = vmf3))

# Predição nos pontos de validação
ARG_pred1 <- as.data.frame(krige(media_argila ~ 1, treino, valida, vmf1, nmax = 8))
ARG_pred2 <- as.data.frame(krige(media_argila ~ 1, treino, valida, vmf2, nmax = 8))
ARG_pred3 <- as.data.frame(krige(media_argila ~ 1, treino, valida, vmf3, nmax = 8))

valida$pred1 <- ARG_pred1$var1.pred
valida$pred2 <- ARG_pred2$var1.pred
valida$pred3 <- ARG_pred3$var1.pred

valida1 <- na.omit(as.data.frame(valida)[c(16, 35:37)])

# Métricas — função auxiliar
calc_metrics <- function(obs, pred) {
  list(
    R2   = summary(lm(obs ~ pred))$r.squared,
    MAE  = Metrics::mae(obs,  pred),
    RMSE = Metrics::rmse(obs, pred),
    MSE  = Metrics::mse(obs,  pred),
    Bias = Metrics::bias(obs, pred)
  )
}

m1 <- calc_metrics(valida1$media_argila, valida1$pred1)
m2 <- calc_metrics(valida1$media_argila, valida1$pred2)
m3 <- calc_metrics(valida1$media_argila, valida1$pred3)

df_argila <- as.data.frame(cbind(
  Model = c("Sph", "Exp", "Gau"),
  R2    = round(c(m1$R2,   m2$R2,   m3$R2),   2),
  MAE   = round(c(m1$MAE,  m2$MAE,  m3$MAE),  2),
  RMSE  = round(c(m1$RMSE, m2$RMSE, m3$RMSE), 2),
  MSE   = round(c(m1$MSE,  m2$MSE,  m3$MSE),  2),
  Bias  = round(c(m1$Bias, m2$Bias, m3$Bias), 2)
))
write_xlsx(df_argila, "../results/ARGILA1m.xlsx")

# ============================================================
# 8. KRIGAGEM PARA SILTE
# ============================================================

v2 <- variogram(media_Silte ~ 1, treino, cutoff = 35000, width = 1800)
print(plot(v2, plot.numbers = FALSE, main = "Semivariograma — Silte"))

vm1 <- vgm(psill = 9000,  model = "Sph", range = 20000, nugget = 14500)
vm2 <- vgm(psill = 10000, model = "Exp", range = 10500, nugget = 14000)
vm3 <- vgm(psill = 8500,  model = "Gau", range = 10000, nugget = 15000)

vmf1 <- fit.variogram(v2, vm1)
vmf2 <- fit.variogram(v2, vm2)
vmf3 <- fit.variogram(v2, vm3)

SILT_pred1 <- as.data.frame(krige(media_Silte ~ 1, treino, valida, vmf1, nmax = 8))
SILT_pred2 <- as.data.frame(krige(media_Silte ~ 1, treino, valida, vmf2, nmax = 8))
SILT_pred3 <- as.data.frame(krige(media_Silte ~ 1, treino, valida, vmf3, nmax = 8))

valida$pred1 <- SILT_pred1$var1.pred
valida$pred2 <- SILT_pred2$var1.pred
valida$pred3 <- SILT_pred3$var1.pred

valida2 <- na.omit(as.data.frame(valida)[c(18, 35:37)])

m1 <- calc_metrics(valida2$media_Silte, valida2$pred1)
m2 <- calc_metrics(valida2$media_Silte, valida2$pred2)
m3 <- calc_metrics(valida2$media_Silte, valida2$pred3)

df_silte <- as.data.frame(cbind(
  Model = c("Sph", "Exp", "Gau"),
  R2    = round(c(m1$R2,   m2$R2,   m3$R2),   2),
  MAE   = round(c(m1$MAE,  m2$MAE,  m3$MAE),  2),
  RMSE  = round(c(m1$RMSE, m2$RMSE, m3$RMSE), 2),
  MSE   = round(c(m1$MSE,  m2$MSE,  m3$MSE),  2),
  Bias  = round(c(m1$Bias, m2$Bias, m3$Bias), 2)
))
write_xlsx(df_silte, "../results/SILTE1m.xlsx")

# ============================================================
# 9. KRIGAGEM PARA AREIA
# ============================================================

v1 <- variogram(media_AT ~ 1, treino, cutoff = 16000, width = 1800)
print(plot(v1, plot.numbers = FALSE, main = "Semivariograma — Areia"))

vm1 <- vgm(psill = 24500, model = "Sph", range = 15000, nugget = 46500)
vm2 <- vgm(psill = 31000, model = "Exp", range = 7000,  nugget = 44000)
vm3 <- vgm(psill = 22500, model = "Gau", range = 7000,  nugget = 49000)

vmf1 <- fit.variogram(v1, vm1)
vmf2 <- fit.variogram(v1, vm2)
vmf3 <- fit.variogram(v1, vm3)

ARG_pred1 <- as.data.frame(krige(media_AT ~ 1, treino, valida, vmf1, nmax = 8))
ARG_pred2 <- as.data.frame(krige(media_AT ~ 1, treino, valida, vmf2, nmax = 8))
ARG_pred3 <- as.data.frame(krige(media_AT ~ 1, treino, valida, vmf3, nmax = 8))

valida$pred1 <- ARG_pred1$var1.pred
valida$pred2 <- ARG_pred2$var1.pred
valida$pred3 <- ARG_pred3$var1.pred

valida3 <- na.omit(as.data.frame(valida)[c(16, 17, 35:37)])

m1 <- calc_metrics(valida3$media_AT, valida3$pred1)
m2 <- calc_metrics(valida3$media_AT, valida3$pred2)
m3 <- calc_metrics(valida3$media_AT, valida3$pred3)

df_areia <- as.data.frame(cbind(
  Model = c("Sph", "Exp", "Gau"),
  R2    = round(c(m1$R2,   m2$R2,   m3$R2),   2),
  MAE   = round(c(m1$MAE,  m2$MAE,  m3$MAE),  2),
  RMSE  = round(c(m1$RMSE, m2$RMSE, m3$RMSE), 2),
  MSE   = round(c(m1$MSE,  m2$MSE,  m3$MSE),  2),
  Bias  = round(c(m1$Bias, m2$Bias, m3$Bias), 2)
))
write_xlsx(df_areia, "../results/AREIA1m.xlsx")

# ============================================================
# 10. PREDIÇÃO NO GRID COM O CONJUNTO COMPLETO
# ============================================================

coordinates(data_projir) <- ~X + Y
sp::proj4string(data_projir) <- WGS84_24S

# Variogramas com conjunto completo
v  <- variogram(media_argila ~ 1, data_projir, cutoff = 16000, width = 1800)
v1 <- variogram(media_AT     ~ 1, data_projir, cutoff = 16000, width = 1800)
v2 <- variogram(media_Silte  ~ 1, data_projir, cutoff = 16000, width = 1800)

# Ajuste do modelo de Argila e predição no grid
vm1  <- vgm(psill = 9300,  model = "Sph", range = 10000, nugget = 21500)
vm2  <- vgm(psill = 12000, model = "Exp", range = 4800,  nugget = 20000)
vm3  <- vgm(psill = 8000,  model = "Gau", range = 4500,  nugget = 22500)
vmf1 <- fit.variogram(v, vm1)
vmf2 <- fit.variogram(v, vm2)
vmf3 <- fit.variogram(v, vm3)

# Predição com interpolação de NA (na.approx para bordas)
pred1 <- krige(media_argila ~ 1, data_projir, grid, vmf1, nmax = 8)
pred1@data$var1.pred <- zoo::na.approx(pred1@data$var1.pred, rule = 2)

pred2 <- krige(media_argila ~ 1, data_projir, grid, vmf2, nmax = 8)
pred2@data$var1.pred <- zoo::na.approx(pred2@data$var1.pred, rule = 2)

pred3 <- krige(media_argila ~ 1, data_projir, grid, vmf3, nmax = 8)
pred3@data$var1.pred <- zoo::na.approx(pred3@data$var1.pred, rule = 2)

# Convertendo para raster e exportando
gridded(pred1) <- TRUE
r_argila_sph <- raster::raster(pred1)
raster::writeRaster(r_argila_sph, "../raster/argila_sph.tif", overwrite = TRUE)
plot(r_argila_sph, main = "Argila — Modelo Esférico (g.kg-1)")
