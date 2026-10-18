# ============================================================
# Título:    ARIMA com Diferenciação — Equipamentos Elétricos (Zona do Euro)
# Autor:     Seu Nome
# Data:      2024
# Descrição: Ajuste de modelos ARIMA a uma série com tendência e sazonalidade.
#            Inclui decomposição STL, ajuste sazonal, identificação da ordem
#            via FAC/FACP, seleção por AICc e diagnóstico de resíduos.
# Pacotes:   fpp2, forecast
# ============================================================

rm(list = ls(all = TRUE))  # Limpar ambiente

library(fpp2)

# ============================================================
# 1. SIMULAÇÃO — ARIMA COM INTEGRAÇÃO (d=1)
# ============================================================

# Simulando séries ARIMA integradas para entender o comportamento
ts_arima110 <- arima.sim(list(order = c(1, 1, 0), ar = 0.7),  n = 200)
ts_arima011 <- arima.sim(list(order = c(0, 1, 1), ma = 0.4),  n = 200)
ts_arima111 <- arima.sim(list(order = c(1, 1, 1), ar = 0.7, ma = 0.4), n = 200)

par(mfrow = c(3, 3))
ts.plot(ts_arima110, ylab = "z(t)", main = "(a) ARIMA(1,1,0)")
ts.plot(ts_arima011, ylab = "z(t)", main = "(b) ARIMA(0,1,1)")
ts.plot(ts_arima111, ylab = "z(t)", main = "(c) ARIMA(1,1,1)")
acf(ts_arima110,  main = "FAC",  lag.max = 24)
acf(ts_arima011,  main = "FAC",  lag.max = 24)
acf(ts_arima111,  main = "FAC",  lag.max = 24)
pacf(ts_arima110, main = "FACP", lag.max = 24)
pacf(ts_arima011, main = "FACP", lag.max = 24)
pacf(ts_arima111, main = "FACP", lag.max = 24)

# Ajuste ao ARIMA(1,1,1) simulado — verificando recuperação dos parâmetros
arima(ts_arima111, order = c(1, 1, 1), include.mean = FALSE)

# ============================================================
# 2. APLICAÇÃO — ÍNDICE DE PEDIDOS DE EQUIPAMENTOS ELÉTRICOS
# ============================================================

autoplot(elecequip) +
  ggtitle("Índice de Pedidos de Equipamentos Elétricos — Zona do Euro") +
  xlab("Ano") +
  ylab("Índice de pedidos")

# ============================================================
# 3. DECOMPOSIÇÃO DA SÉRIE
# ============================================================

# Decomposição STL
plot(stl(elecequip, "per"),
     labels = rbind("Observada", "Sazonalidade", "Tendência", "Resíduo"))

# Componente sazonal isolada
plot(decompose(elecequip)$seasonal,
     xlab = "Ano", ylab = "",
     main = "Componente Sazonal — Equipamentos Elétricos")

# ============================================================
# 4. AJUSTE SAZONAL (STL + DESSAZONALIZAÇÃO)
# ============================================================

# Removendo o componente sazonal via STL
eeadj <- elecequip %>%
  stl(s.window = "periodic") %>%
  seasadj()

plot(elecequip, ylab = "Índice de novos pedidos", xlab = "Tempo",
     cex = 2, ylim = c(60, 140))
lines(eeadj, col = "red")
legend(1998, 140,
       legend = c("Série original", "Série com ajuste sazonal"),
       col = c("black", "red"), lty = 1, cex = 1)

# ============================================================
# 5. IDENTIFICAÇÃO DA ORDEM — FAC/FACP NA SÉRIE DIFERENCIADA
# ============================================================

eeadj %>% diff() %>% ggtsdisplay(main = "Série diferenciada com FAC e FACP")

# Série diferenciada para análise manual
d_eeadj    <- diff(eeadj)
d_eeadj_ts <- ts(d_eeadj)

layout(matrix(c(1, 1, 2, 3), 2, 2, byrow = TRUE))
plot(d_eeadj, type = "l", ylab = "", main = "Série diferenciada")
acf(d_eeadj_ts,  main = "FAC",  lag.max = 36, ylab = "FAC")
pacf(d_eeadj_ts, main = "FACP", lag.max = 36, ylab = "FACP")

# ============================================================
# 6. AJUSTE E COMPARAÇÃO DE MODELOS ARIMA
# ============================================================

# Candidatos com base na análise FAC/FACP
fit  <- forecast::Arima(eeadj, order = c(3, 1, 1))
fit1 <- forecast::Arima(eeadj, order = c(3, 1, 0))
fit2 <- forecast::Arima(eeadj, order = c(4, 1, 0))
fit3 <- forecast::Arima(eeadj, order = c(2, 1, 0))

# Comparação por AICc (menor = melhor)
cat("AICc ARIMA(3,1,1):", fit$aicc,  "\n")
cat("AICc ARIMA(3,1,0):", fit1$aicc, "\n")
cat("AICc ARIMA(4,1,0):", fit2$aicc, "\n")
cat("AICc ARIMA(2,1,0):", fit3$aicc, "\n")

# ============================================================
# 7. DIAGNÓSTICO DE RESÍDUOS — MELHOR MODELO
# ============================================================

checkresiduals(fit)
shapiro.test(fit$residuals)  # Teste de normalidade dos resíduos

# ============================================================
# 8. PREVISÃO
# ============================================================

autoplot(forecast::forecast(fit)) +
  ggtitle("Previsão — ARIMA(3,1,1)") +
  xlab("Ano") +
  ylab("Índice de pedidos")

plot(forecast::forecast(fit),
     main = "Previsão do ARIMA(3,1,1)",
     xlab = "Ano", ylab = "Índice de pedidos")
lines(fit$fitted, col = "red")
