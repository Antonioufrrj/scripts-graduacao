# ============================================================
# Título:    Séries Temporais — AR, MA, ARMA e ARIMA
# Autor:     Seu Nome
# Data:      2024
# Descrição: Fundamentos de séries temporais com simulação de processos
#            AR(p), MA(q) e ARMA(p,q). Aplicação com dados reais de
#            exportações do Egito (1960-2017) usando auto.arima e previsão.
# Pacotes:   tseries, fpp2, fpp3, TTR, forecast
# ============================================================

rm(list = ls(all = TRUE))  # Limpar ambiente

library(tseries)
library(fpp2)
require(TTR)
library(fpp3)

# ============================================================
# 1. VISUALIZAÇÃO DA SÉRIE — PRODUÇÃO DE CERVEJA
# ============================================================

beer_st <- ts(beer, start = 1991, frequency = 12)
plot(beer_st, xlab = "Tempo (Mês)", ylab = "Produção mensal de cerveja")
abline(v = c(1991.5, 1992.0, 1992.5), col = "blue")

# ============================================================
# 2. FAC E FACP — FUNÇÃO DE AUTOCORRELAÇÃO
# ============================================================

# FAC com ggAcf (visualização moderna)
ggAcf(beer)

# FAC manual — ajustando o eixo de lags para meses
fac <- acf(beer, lag.max = 48)
fac$lag <- fac$lag * 12  # convertendo para meses
plot(fac, lwd = 2, main = "", ylab = "FAC")
axis(1, at = seq(0, 48, by = 12), pos = 0)
axis(2)

# FACP
facp <- pacf(beer, lag.max = 48)
facp$lag <- facp$lag * 12
plot(facp, lwd = 2, main = "", ylab = "FACP")
axis(1, at = seq(0, 48, by = 12), pos = 0)
axis(2)

# ============================================================
# 3. CÁLCULO MANUAL DO COEFICIENTE DE AUTOCORRELAÇÃO r₁
# ============================================================

media <- mean(beer)
c_vec <- v_vec <- numeric(length(beer) - 1)

for (i in 1:(length(beer) - 1)) {
  c_vec[i] <- (beer[i] - media) * (beer[i + 1] - media)
  v_vec[i] <- (beer[i] - media)^2
}

c_0 <- (1 / length(beer)) * sum(v_vec)
c_1 <- (1 / length(beer)) * sum(c_vec)
r_1 <- c_1 / c_0
cat("r_1 =", round(r_1, 4), "\n")

# ============================================================
# 4. RUÍDO BRANCO (WHITE NOISE) — REFERÊNCIA
# ============================================================

set.seed(30)
y <- ts(rnorm(50))

par(mfrow = c(2, 1), cex.lab = 1.4)
plot(y, main = "Ruído branco")
acf(y, lag.max = 36, main = "FAC — Ruído branco")

# ============================================================
# 5. PROCESSOS AR (AUTOREGRESSIVOS)
# ============================================================

# AR(1) com coeficiente positivo — decaimento exponencial na FAC
z_ar1_pos <- arima.sim(n = 200, model = list(ar = c(0.8)))
par(mfrow = c(1, 3))
plot(z_ar1_pos, type = "l", main = "AR(1) — φ = 0.8")
acf(z_ar1_pos, main = "FAC")
pacf(z_ar1_pos, main = "FACP")

# AR(1) com coeficiente negativo — oscilação na FAC
z_ar1_neg <- arima.sim(n = 200, model = list(ar = c(-0.8)))
par(mfrow = c(1, 3))
plot(z_ar1_neg, type = "l", main = "AR(1) — φ = -0.8")
acf(z_ar1_neg, main = "FAC")
pacf(z_ar1_neg, main = "FACP")

# AR(4) — corte na FACP na lag 4
z_ar4 <- arima.sim(n = 200, model = list(ar = c(0.7, 0.2, -0.1, -0.3)))
par(mfrow = c(1, 3))
plot(z_ar4, type = "l", main = "AR(4)")
acf(z_ar4, main = "FAC")
pacf(z_ar4, main = "FACP")

# ============================================================
# 6. PROCESSOS MA (MÉDIAS MÓVEIS)
# ============================================================

MA1_sm  <- arima.sim(n = 100, model = list(ma = c(0.2)))
MA1_lg  <- arima.sim(n = 100, model = list(ma = c(0.9)))
MA1_neg <- arima.sim(n = 100, model = list(ma = c(-0.5)))

par(mfrow = c(3, 3))

plot.ts(MA1_sm,  ylab = expression(italic(x)[italic(t)]),
        main = expression(paste(theta, " = 0.2")))
plot.ts(MA1_lg,  ylab = expression(italic(x)[italic(t)]),
        main = expression(paste(theta, " = 0.9")))
plot.ts(MA1_neg, ylab = expression(italic(x)[italic(t)]),
        main = expression(paste(theta, " = -0.5")))

acf(MA1_sm,  main = "FAC",  lag.max = 48)
acf(MA1_lg,  main = "FAC")
acf(MA1_neg, main = "FAC")

pacf(MA1_sm,  main = "FACP")
pacf(MA1_lg,  main = "FACP")
pacf(MA1_neg, main = "FACP")

# ============================================================
# 7. PROCESSO ARMA(p,q)
# ============================================================

# ARMA(1,1)
z_arma_11 <- arima.sim(n = 100, model = list(ma = c(0.8), ar = c(0.7)))
par(mfrow = c(1, 3))
plot(z_arma_11, type = "l", main = "ARMA(1,1)")
acf(z_arma_11, main = "FAC")
pacf(z_arma_11, main = "FACP")

# ARMA(2,2) com média diferente de zero
set.seed(123)
ARMA22_model <- list(order = c(2, 0, 2), ar = c(-0.7, 0.2), ma = c(0.7, 0.2))
mu <- 5
z_ARMA_22 <- arima.sim(n = 1000, model = ARMA22_model) + mu

par(mfrow = c(1, 3))
plot(z_ARMA_22, type = "l", main = "ARMA(2,2)")
acf(z_ARMA_22, main = "FAC")
pacf(z_ARMA_22, main = "FACP")

# Estimativa dos parâmetros
arima(x = z_ARMA_22, order = c(2, 0, 2))

# ============================================================
# 8. APLICAÇÃO: EXPORTAÇÕES DO EGITO (1960-2017)
# ============================================================

dados <- global_economy %>% filter(Code == "EGY")
dados_ts <- ts(dados$Exports, start = 1960, frequency = 1)

plot(dados_ts, type = "l", lwd = 2,
     ylab = "Exportações (% do PIB)", xlab = "Ano",
     main = "Exportações do Egito — 1960 a 2017")

# Diagnóstico da série
par(mfrow = c(1, 3))
plot(dados_ts, type = "l", main = "Série temporal")
acf(dados_ts,  main = "FAC",  lag.max = 36)
pacf(dados_ts, main = "FACP", lag.max = 36)

# Seleção automática do modelo
fit_auto <- forecast::auto.arima(dados_ts)
print(fit_auto)
cat("AICc:", fit_auto$aicc, "\n")

# Previsão 10 anos à frente
forecast_auto <- forecast::forecast(fit_auto, h = 10)
plot(forecast_auto, xlab = "Ano", ylab = "Exportações (%)", main = "Previsão ARIMA")
lines(fit_auto$fitted, col = "red")

# Modelo alternativo: ARIMA(4,0,0) = AR(4)
fit_ar4 <- forecast::Arima(dados_ts, order = c(4, 0, 0))
print(fit_ar4)
cat("AICc ARIMA(4,0,0):", fit_ar4$aicc, "\n")

forecast_ar4 <- forecast::forecast(fit_ar4, h = 10)
plot(forecast_ar4, xlab = "Ano", ylab = "Exportações (%)", main = "Previsão ARIMA(4,0,0)")
lines(fit_ar4$fitted, col = "red")
