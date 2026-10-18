# ============================================================
# Título:    Krigagem Ordinária para Água Disponível no Solo (ADT)
# Autor:     Seu Nome
# Data:      2024
# Descrição: Ajuste de semivariogramas (Esférico, Exponencial, Gaussiano)
#            e IDW para predição espacial de ADT até 1 metro.
#            Inclui transformação Box-Cox, validação externa, validação
#            cruzada e geração de mapas temáticos com tmap e mapview.
# Pacotes:   sp, gstat, MASS, forecast, tmap, mapview, Metrics, sf, raster
# ============================================================

## Carregando os pacotes necessários
library(readxl)    # Leitura de arquivos Excel
library(tidyverse) # Organização de dados
library(moments)   # Assimetria e curtose
library(ggplot2)   # Gráficos
library(gvlma)     # Avaliação de pressupostos estatísticos
library(lmtest)    # Testes para modelos de regressão linear
library(nortest)   # Testes de normalidade
library(sp)        # Manipulação de dados espaciais
library(gstat)     # Geoestatística
library(Metrics)   # Métricas de avaliação de modelos
library(MASS)      # Transformação Box-Cox
library(forecast)  # Back-transformation do Box-Cox
library(writexl)   # Salvar arquivos Excel
library(sf)        # Simple Features para dados vetoriais
library(tmap)      # Mapas temáticos
library(mapview)   # Visualização interativa de mapas

# ============================================================
# 1. CARREGAMENTO DOS DADOS
# ============================================================

# Lendo os dados de ADT (pulando as 15 primeiras linhas de metadados)
data_projir    <- readxl::read_xlsx("../data/ADT1m_cov.xlsx", skip = 15)
data_fazendinha <- readxl::read_xlsx("../data/Faze0010.xlsx")

# Definindo o sistema de coordenadas (UTM zona 24S / WGS84)
WGS24S <- sp::CRS("+proj=utm +zone=24 +south +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")
WGS23S <- sp::CRS("+proj=utm +zone=23 +south +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")

# Convertendo dataframes em objetos espaciais (SpatialPointsDataFrame)
sp::coordinates(data_projir)     <- ~X + Y
sp::proj4string(data_projir)     <- WGS24S

sp::coordinates(data_fazendinha) <- ~X + Y
sp::proj4string(data_fazendinha) <- WGS23S

# Carregando raster do MDE para usar como grid de referência na interpolação
mde <- raster::raster("../raster/MDEHC1.tif")
sp::proj4string(mde) <- WGS24S

# Convertendo raster em SpatialPixelsDataFrame para uso na Krigagem
grid <- methods::as(mde, "SpatialPixelsDataFrame")

# ============================================================
# 2. ANÁLISE EXPLORATÓRIA DA DEPENDÊNCIA ESPACIAL
# ============================================================

# Visualização qualitativa — tamanho do ponto proporcional ao valor de ADT
plot(data_projir,    asp = 1, cex = 4 * data_projir$ADT / max(data_projir$ADT),    pch = 1)
plot(data_fazendinha, asp = 1, cex = 4 * data_fazendinha$CapCa / max(data_fazendinha$CapCa), pch = 2)

# Número total de pares de pontos possíveis
n <- base::length(data_projir$ADT)
n * (n - 1) / 2

# Exemplo didático: semivariância entre os dois primeiros pontos
sp::coordinates(data_projir)[1, ]  # coordenadas do ponto 1
sp::coordinates(data_projir)[2, ]  # coordenadas do ponto 2
sep   <- proxy::dist(sp::coordinates(data_projir)[1:2, ])    # distância entre pontos
gamma <- 0.5 * (data_projir$ADT[1] - data_projir$ADT[2])^2  # semivariância

# Distância máxima (limite recomendado = 2/3 da distância máxima)
base::max(proxy::dist(data_projir@coords)) * 2 / 3
base::min(proxy::dist(data_projir@coords))  # distância mínima (referência para o lag)

# Variograma de nuvem (todos os pares)
variograma <- gstat::variogram(ADT ~ 1, data_projir, cloud = TRUE, cutoff = Inf)
plot(variograma, ylab = "Semivariância", xlab = "Distância (m)")

# Variograma experimental (cutoff = 11.000 m, lag = 1.800 m)
v <- gstat::variogram(object = ADT ~ 1, locations = data_projir, cutoff = 11000, width = 1800)
print(plot(v, plot.numbers = FALSE))

# Modelos de variograma disponíveis no pacote gstat
print(show.vgms())

# ============================================================
# 3. SEPARAÇÃO TREINO / VALIDAÇÃO
# ============================================================

data_projir <- readxl::read_xlsx("../data/ADT1m_cov.xlsx", skip = 15)
set.seed(2021)  # Fixar aleatoriedade para reprodutibilidade

data_projir$ID <- 1:nrow(data_projir)

valida <- data_projir[sample(1:nrow(data_projir), size = 41), 1:ncol(data_projir)]
treino <- data_projir[-c(valida$ID), 1:ncol(data_projir)]

base::summary(valida$ADT)
base::summary(treino$ADT)

# Histogramas dos conjuntos de treino e validação
ggplot(data = valida, aes(ADT)) +
  geom_histogram(aes(y = ..density..), breaks = seq(0, 300, by = 30),
                 col = "blue", fill = "red", alpha = 0.2) +
  geom_density(col = 4) +
  labs(title = "Histograma de ADT — Validação", x = "ADT", y = "Densidade")

ggplot(data = treino, aes(ADT)) +
  geom_histogram(aes(y = ..density..), breaks = seq(0, 300, by = 30),
                 col = "blue", fill = "red", alpha = 0.2) +
  geom_density(col = 4) +
  labs(title = "Histograma de ADT — Treino", x = "ADT", y = "Densidade")

# Testes de normalidade
nortest::sf.test(treino$ADT)     # Shapiro-Francia
shapiro.test(treino$ADT)         # Shapiro-Wilk

# ============================================================
# 4. TRANSFORMAÇÃO BOX-COX
# ============================================================

result <- MASS::boxcox(treino$ADT ~ 1, lambda = seq(-5, 5, 0.5))
lambda <- result$x[which.max(result$y)]
lambda

treino$boxADT <- (treino$ADT^lambda - 1) / lambda

# Verificando o resultado da transformação
hist(treino$boxADT)

ggplot(data = treino, aes(boxADT)) +
  geom_histogram(aes(y = ..density..), breaks = seq(4, 20, by = 2),
                 col = "blue", fill = "red", alpha = 0.2) +
  geom_density(col = 4) +
  labs(title = "Histograma de ADT transformado (Box-Cox)", x = "ADT (Box-Cox)", y = "Densidade")

nortest::sf.test(treino$boxADT)
shapiro.test(treino$boxADT)

# ============================================================
# 5. AJUSTE DOS SEMIVARIOGRAMAS (dados transformados)
# ============================================================

# Convertendo treino e validação para objetos espaciais
sp::coordinates(treino) <- ~X + Y
sp::proj4string(treino) <- WGS24S

sp::coordinates(valida) <- ~X + Y
sp::proj4string(valida) <- WGS24S

# Variograma experimental com dados transformados
v <- gstat::variogram(boxADT ~ 1, treino, cutoff = 10000, width = 1800)
plot(v, plot.numbers = FALSE, main = "Semivariograma ADT",
     xlab = "Distância (m)", ylab = "Semivariância")

# --- Modelo Esférico ---
vm1 <- gstat::vgm(psill = 6.7, model = "Sph", range = 6300, nugget = 0.9)
base::plot(v, pl = FALSE, model = vm1,
           xlab = "Distância (m)", ylab = "Semivariância", main = "Semivariograma ADT — Esférico")

# --- Modelo Exponencial ---
vm2 <- gstat::vgm(psill = 7.7, model = "Exp", range = 2350, nugget = 0.0)
plot(v, pl = FALSE, model = vm2,
     xlab = "Distância (m)", ylab = "Semivariância", main = "Semivariograma ADT — Exponencial")

# --- Modelo Gaussiano ---
vm3 <- gstat::vgm(psill = 5.5, model = "Gau", range = 3200, nugget = 2.1)
plot(v, pl = FALSE, model = vm3,
     xlab = "Distância (m)", ylab = "Semivariância", main = "Semivariograma ADT — Gaussiano")

# Ajuste automático dos parâmetros tendo como ponto de partida os modelos acima
vmf1 <- gstat::fit.variogram(v, vm1, fit.sills = FALSE, fit.ranges = FALSE, fit.method = 7)
vmf1 <- vm1

vmf2 <- gstat::fit.variogram(v, vm2)
vmf2 <- vm2

vmf3 <- gstat::fit.variogram(v, vm3)
vmf3 <- vm3

# ============================================================
# 6. VALIDAÇÃO EXTERNA
# ============================================================

# Predição nos pontos de validação com cada modelo
ADT_pred1 <- gstat::krige(boxADT ~ 1, locations = treino, newdata = valida, model = vmf1, nmax = 8)
ADT_pred1 <- as.data.frame(ADT_pred1)

ADT_pred2 <- gstat::krige(boxADT ~ 1, locations = treino, newdata = valida, model = vmf2, nmax = 8)
ADT_pred2 <- as.data.frame(ADT_pred2)

ADT_pred3 <- gstat::krige(boxADT ~ 1, locations = treino, newdata = valida, model = vmf3, nmax = 8)
ADT_pred3 <- as.data.frame(ADT_pred3)

ADT_pred4 <- gstat::idw(boxADT ~ 1, locations = treino, nmax = 8, idp = 2, newdata = valida)
ADT_pred4 <- as.data.frame(ADT_pred4)

# Back-transformation: devolvendo para a unidade original (mm)
valida <- as.data.frame(valida)
valida$predADT1 <- forecast::InvBoxCox(ADT_pred1$var1.pred, lambda = lambda)
valida$predADT2 <- forecast::InvBoxCox(ADT_pred2$var1.pred, lambda = lambda)
valida$predADT3 <- forecast::InvBoxCox(ADT_pred3$var1.pred, lambda = lambda)
valida$predADT4 <- forecast::InvBoxCox(ADT_pred4$var1.pred, lambda = lambda)

# --- Métricas por modelo ---
# Esférico
R2_sph   <- base::summary(lm(ADT ~ predADT1, data = valida))$r.squared
mae_sph  <- Metrics::mae(valida$ADT, valida$predADT1)
rmse_sph <- Metrics::rmse(valida$ADT, valida$predADT1)
mse_sph  <- Metrics::mse(valida$ADT, valida$predADT1)
bias_sph <- Metrics::bias(valida$ADT, valida$predADT1)

# Exponencial
R2_exp   <- base::summary(lm(ADT ~ predADT2, data = valida))$r.squared
mae_exp  <- Metrics::mae(valida$ADT, valida$predADT2)
rmse_exp <- Metrics::rmse(valida$ADT, valida$predADT2)
mse_exp  <- Metrics::mse(valida$ADT, valida$predADT2)
bias_exp <- Metrics::bias(valida$ADT, valida$predADT2)

# Gaussiano
R2_gau   <- base::summary(lm(ADT ~ predADT3, data = valida))$r.squared
mae_gau  <- Metrics::mae(valida$ADT, valida$predADT3)
rmse_gau <- Metrics::rmse(valida$ADT, valida$predADT3)
mse_gau  <- Metrics::mse(valida$ADT, valida$predADT3)
bias_gau <- Metrics::bias(valida$ADT, valida$predADT3)

# IDW
R2_idw   <- base::summary(lm(ADT ~ predADT4, data = valida))$r.squared
mae_idw  <- Metrics::mae(valida$ADT, valida$predADT4)
rmse_idw <- Metrics::rmse(valida$ADT, valida$predADT4)
mse_idw  <- Metrics::mse(valida$ADT, valida$predADT4)
bias_idw <- Metrics::bias(valida$ADT, valida$predADT4)

# Consolidando métricas em um dataframe
mods   <- c("Sph", "Exp", "Gau", "IDW")
df <- base::as.data.frame(base::cbind(
  Model = mods,
  R2    = round(c(R2_sph,   R2_exp,   R2_gau,   R2_idw),   2),
  MAE   = round(c(mae_sph,  mae_exp,  mae_gau,  mae_idw),  2),
  RMSE  = round(c(rmse_sph, rmse_exp, rmse_gau, rmse_idw), 2),
  MSE   = round(c(mse_sph,  mse_exp,  mse_gau,  mse_idw),  2),
  Bias  = round(c(bias_sph, bias_exp, bias_gau, bias_idw), 2)
))
print(df)

writexl::write_xlsx(df, "../results/valida_externa.xlsx")

# Gráficos predito vs. observado para cada modelo
g1 <- ggplot(valida, aes(x = ADT, y = predADT1)) +
  geom_point(shape = 1) +
  geom_smooth(method = lm) +
  labs(x = "Observado", y = "Predito", title = "Esférico") +
  theme(text = element_text(size = 20)) +
  annotate("text", x = 175, y = 75,  label = deparse(bquote(~R2   == ~.(round(R2_sph,   2)))), colour = "black", size = 5, parse = TRUE) +
  annotate("text", x = 175, y = 60,  label = deparse(bquote(~MAE  == ~.(round(mae_sph,  2)))), colour = "black", size = 5, parse = TRUE) +
  annotate("text", x = 175, y = 45,  label = deparse(bquote(~RMSE == ~.(round(rmse_sph, 2)))), colour = "black", size = 5, parse = TRUE)

g2 <- ggplot(valida, aes(x = ADT, y = predADT2)) +
  geom_point(shape = 1) +
  geom_smooth(method = lm) +
  labs(x = "Observado", y = "Predito", title = "Exponencial") +
  theme(text = element_text(size = 20)) +
  annotate("text", x = 175, y = 75,  label = deparse(bquote(~R2   == ~.(round(R2_exp,   2)))), colour = "black", size = 5, parse = TRUE) +
  annotate("text", x = 175, y = 60,  label = deparse(bquote(~MAE  == ~.(round(mae_exp,  2)))), colour = "black", size = 5, parse = TRUE) +
  annotate("text", x = 175, y = 45,  label = deparse(bquote(~RMSE == ~.(round(rmse_exp, 2)))), colour = "black", size = 5, parse = TRUE)

g3 <- ggplot(valida, aes(x = ADT, y = predADT3)) +
  geom_point(shape = 1) +
  geom_smooth(method = lm) +
  labs(x = "Observado", y = "Predito", title = "Gaussiano") +
  theme(text = element_text(size = 20)) +
  annotate("text", x = 175, y = 75,  label = deparse(bquote(~R2   == ~.(round(R2_gau,   2)))), colour = "black", size = 5, parse = TRUE) +
  annotate("text", x = 175, y = 60,  label = deparse(bquote(~MAE  == ~.(round(mae_gau,  2)))), colour = "black", size = 5, parse = TRUE) +
  annotate("text", x = 175, y = 45,  label = deparse(bquote(~RMSE == ~.(round(rmse_gau, 2)))), colour = "black", size = 5, parse = TRUE)

g4 <- ggplot(valida, aes(x = ADT, y = predADT4)) +
  geom_point(shape = 1) +
  geom_smooth(method = lm) +
  labs(x = "Observado", y = "Predito", title = "IDW") +
  theme(text = element_text(size = 20)) +
  annotate("text", x = 175, y = 75,  label = deparse(bquote(~R2   == ~.(round(R2_idw,   2)))), colour = "black", size = 5, parse = TRUE) +
  annotate("text", x = 175, y = 60,  label = deparse(bquote(~MAE  == ~.(round(mae_idw,  2)))), colour = "black", size = 5, parse = TRUE) +
  annotate("text", x = 175, y = 45,  label = deparse(bquote(~RMSE == ~.(round(rmse_idw, 2)))), colour = "black", size = 5, parse = TRUE)

ggpubr::ggarrange(g1, g2, g3, g4, labels = c("A", "B", "C", "D"))
ggsave(filename = "valida_externa.tiff", path = "../figures/",
       width = 30, height = 20, units = "cm", device = "tiff", dpi = 300)

# ============================================================
# 7. PREDIÇÃO NO GRID E EXPORTAÇÃO DOS MAPAS
# ============================================================

# Predição Exponencial no grid completo
grid_exp <- gstat::krige(boxADT ~ 1, locations = treino, newdata = grid, model = vmf2, nmax = 8)
grid_exp$var1.pred <- forecast::InvBoxCox(grid_exp$var1.pred, lambda = lambda)
grid_exp$var1.var  <- forecast::InvBoxCox(grid_exp$var1.var,  lambda = lambda)
grid_exp <- raster::stack(grid_exp)
raster::writeRaster(grid_exp, filename = "../raster/grid_exp.tif", overwrite = TRUE)

# Predição Esférica
grid_sph <- gstat::krige(boxADT ~ 1, locations = treino, newdata = grid, model = vmf1, nmax = 8)
grid_sph$var1.pred <- forecast::InvBoxCox(grid_sph$var1.pred, lambda = lambda)
grid_sph$var1.var  <- forecast::InvBoxCox(grid_sph$var1.var,  lambda = lambda)
grid_sph <- raster::stack(grid_sph)
raster::writeRaster(grid_sph, filename = "../raster/grid_sph.tif", overwrite = TRUE)

# Predição Gaussiana
grid_gau <- gstat::krige(boxADT ~ 1, locations = treino, newdata = grid, model = vmf3, nmax = 8)
grid_gau$var1.pred <- forecast::InvBoxCox(grid_gau$var1.pred, lambda = lambda)
grid_gau$var1.var  <- forecast::InvBoxCox(grid_gau$var1.var,  lambda = lambda)
grid_gau <- raster::stack(grid_gau)
raster::writeRaster(grid_gau, filename = "../raster/grid_gau.tif", overwrite = TRUE)

# Predição IDW
grid_idw <- gstat::idw(boxADT ~ 1, locations = treino, nmax = 8, idp = 2, newdata = grid)
grid_idw$var1.pred <- forecast::InvBoxCox(grid_idw$var1.pred, lambda = lambda)
grid_idw$var1.var  <- forecast::InvBoxCox(grid_idw$var1.var,  lambda = lambda)
grid_idw <- raster::stack(grid_idw)
raster::writeRaster(grid_idw, filename = "../raster/grid_idw.tif", overwrite = TRUE)

# Painel com os quatro mapas
results <- raster::addLayer(
  grid_sph$var1.pred,
  grid_exp$var1.pred,
  grid_gau$var1.pred,
  grid_idw$var1.pred
)

spplot(results,
       scales = list(draw = TRUE),
       xlab = "Leste", ylab = "Norte",
       col.regions = terrain.colors(100),
       names.attr = c("Sph", "Exp", "Gau", "IDW"),
       par.settings = list(fontsize = list(text = 18)))

# Mapas temáticos com tmap
limite <- sf::read_sf(dsn = "../shape", layer = "Limite")
ADT_sf <- sf::read_sf(dsn = "../shape", layer = "pontos_ADT1m")

results <- raster::mask(results, limite)

m1 <- tmap::tm_shape(results$var1.pred.1) +
  tmap::tm_raster(title = "ADT-Sph (mm)", style = "cont",
                  breaks = c(0, 50, 100, 150, 200, 250, 300, 350)) +
  tmap::tm_shape(limite) +
  tmap::tm_polygons(col = "black", alpha = 0, border.col = "black") +
  tmap::tm_shape(ADT_sf) +
  tmap::tm_symbols(col = "black", alpha = 0, border.col = "black",
                   size = "ADT", legend.size.show = FALSE) +
  tmap::tm_compass(position = c("center", "top"), size = 4) +
  tmap::tm_grid(alpha = 0.2, labels.size = 1, labels.rot = c(0, 90), n.x = 5, n.y = 6) +
  tmap::tm_scale_bar(position = c("right", "bottom"), text.size = 1) +
  tmap::tm_layout(legend.position = c("left", "top"), legend.text.size = 1)

m2 <- tmap::tm_shape(results$var1.pred.3) +
  tmap::tm_raster(title = "ADT-Gau (mm)", style = "cont",
                  breaks = c(0, 50, 100, 150, 200, 250, 300, 350)) +
  tmap::tm_shape(limite) +
  tmap::tm_polygons(col = "black", alpha = 0, border.col = "black") +
  tmap::tm_shape(ADT_sf) +
  tmap::tm_symbols(col = "black", alpha = 0, border.col = "black",
                   size = "ADT", legend.size.show = FALSE) +
  tmap::tm_compass(position = c("center", "top"), size = 4) +
  tmap::tm_grid(alpha = 0.2, labels.size = 1, labels.rot = c(0, 90), n.x = 5, n.y = 6) +
  tmap::tm_scale_bar(position = c("right", "bottom"), text.size = 1) +
  tmap::tm_layout(legend.position = c("left", "top"), legend.text.size = 1)

maps <- tmap::tmap_arrange(m1, m2)
maps

tmap::tmap_save(maps, filename = "../figures/maps.tiff",
                width = 30, height = 20, units = "cm", dpi = 300)

# ============================================================
# 8. VALIDAÇÃO CRUZADA (leave-one-out)
# ============================================================

data_projir <- readxl::read_xlsx("../data/ADT1m_cov.xlsx", skip = 15)

# Transformação Box-Cox para o conjunto completo
result  <- MASS::boxcox(data_projir$ADT ~ 1, lambda = seq(-5, 5, 0.5))
lambda  <- result$x[which.max(result$y)]
data_projir$boxADT <- (data_projir$ADT^lambda - 1) / lambda

sp::coordinates(data_projir) <- ~X + Y
sp::proj4string(data_projir) <- WGS24S

v <- gstat::variogram(boxADT ~ 1, data_projir, cutoff = 10000, width = 1800)

# Re-ajuste dos modelos com o conjunto completo
vm1  <- gstat::vgm(psill = 14,   model = "Sph", range = 7000, nugget = 2.2)
vm2  <- gstat::vgm(psill = 17,   model = "Exp", range = 2700, nugget = 0)
vm3  <- gstat::vgm(psill = 11.5, model = "Gau", range = 3500, nugget = 4.5)
vmf1 <- gstat::fit.variogram(v, vm1)
vmf2 <- gstat::fit.variogram(v, vm2)
vmf3 <- gstat::fit.variogram(v, vm3)

# Krige cross-validation (leave-one-out)
cv_sph <- as.data.frame(gstat::krige.cv(boxADT ~ 1, locations = data_projir, model = vmf1))
cv_exp <- as.data.frame(gstat::krige.cv(boxADT ~ 1, locations = data_projir, model = vmf2))
cv_gau <- as.data.frame(gstat::krige.cv(boxADT ~ 1, locations = data_projir, model = vmf3))

# Métricas de validação cruzada
calc_metrics <- function(cv_df) {
  list(
    R2   = summary(lm(observed ~ var1.pred, data = cv_df))$r.squared,
    MAE  = Metrics::mae(cv_df$observed,  cv_df$var1.pred),
    RMSE = Metrics::rmse(cv_df$observed, cv_df$var1.pred),
    MSE  = Metrics::mse(cv_df$observed,  cv_df$var1.pred),
    Bias = Metrics::bias(cv_df$observed, cv_df$var1.pred)
  )
}

m_sph <- calc_metrics(cv_sph)
m_exp <- calc_metrics(cv_exp)
m_gau <- calc_metrics(cv_gau)

df_cv <- base::as.data.frame(base::cbind(
  Model = c("Sph", "Exp", "Gau"),
  R2    = round(c(m_sph$R2,   m_exp$R2,   m_gau$R2),   2),
  MAE   = round(c(m_sph$MAE,  m_exp$MAE,  m_gau$MAE),  2),
  RMSE  = round(c(m_sph$RMSE, m_exp$RMSE, m_gau$RMSE), 2),
  MSE   = round(c(m_sph$MSE,  m_exp$MSE,  m_gau$MSE),  2),
  Bias  = round(c(m_sph$Bias, m_exp$Bias, m_gau$Bias), 2)
))
print(df_cv)
writexl::write_xlsx(df_cv, "../results/valida_cruzada.xlsx")

# ============================================================
# 9. MAPA FINAL COM MELHOR MODELO (Exponencial)
# ============================================================

grid_exp_total <- gstat::krige(boxADT ~ 1, locations = data_projir,
                                newdata = grid, model = vmf2, nmax = 8)
grid_exp_total$var1.pred <- forecast::InvBoxCox(grid_exp_total$var1.pred, lambda = lambda)
grid_exp_total$var1.var  <- forecast::InvBoxCox(grid_exp_total$var1.var,  lambda = lambda)
grid_exp_total <- raster::stack(grid_exp_total)
grid_exp_total <- raster::mask(grid_exp_total, limite)

raster::writeRaster(grid_exp_total, filename = "../raster/grid_exp_total.tif", overwrite = TRUE)

# Visualização interativa
mapview::mapview(
  grid_exp_total$var1.pred,
  layer.name = "ADT (mm)",
  legend = TRUE,
  na.color = rgb(0, 0, 255, max = 255, alpha = 0, names = "transparency")
) + mapview::mapview(ADT_sf, label = ADT_sf$ADT, cex = 2)

# Exportação do mapa final
tiff("../figures/mapa_ADT_final.tiff", units = "cm", width = 20, height = 20, res = 300)
b_breaks <- c(0, 50, 100, 150, 200, 250, 300, 350)
plot(grid_exp_total$var1.pred,
     breaks = b_breaks,
     col    = hcl.colors(length(b_breaks) - 1, "Spectral"),
     reset  = FALSE)
raster::contour(grid_exp_total$var1.pred, breaks = b_breaks, add = TRUE)
dev.off()

rm(list = ls())
