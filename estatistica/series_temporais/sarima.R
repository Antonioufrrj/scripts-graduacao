# ============================================================
# Título:    SARIMA — Índice de Varejo Europeu
# Autor:     Seu Nome
# Data:      2024
# Descrição: Ajuste de modelo SARIMA a série com sazonalidade explícita.
#            Inclui diferenciação sazonal e não-sazonal, seleção do modelo,
#            diagnóstico de resíduos e previsão 12 períodos à frente.
# Dados:     euretail — índice trimestral de varejo europeu (pacote fpp2)
# Pacotes:   fpp2, forecast
# ============================================================

rm(list = ls(all = TRUE))  # Limpar ambiente

library(fpp2)

# ============================================================
# 1. VISUALIZAÇÃO DA SÉRIE
# ============================================================

autoplot(euretail) +
  ylab("Índice de varejo") +
  xlab("Ano") +
  ggtitle("Índice de Varejo Europeu — Trimestral")

plot(euretail, type = "l",
     ylab = "Índice de varejo", xlab = "Ano",
     main = "Índice de Varejo Europeu")

# ============================================================
# 2. DIFERENCIAÇÃO — IDENTIFICANDO A ORDEM
# ============================================================

# Apenas diferenciação não-sazonal (d=1)
euretail %>%
  diff(lag = 1) %>%
  ggtsdisplay(main = "Diferenciação não-sazonal (d=1)")

# Diferenciação não-sazonal + sazonal (d=1, D=1, s=4 trimestres)
euretail %>%
  diff(lag = 1) %>%
  diff(lag = 4) %>%
  ggtsdisplay(main = "Diferenciação não-sazonal + sazonal (d=1, D=1)")

# Observações sobre FAC/FACP:
# - Pico na lag 1 na FAC → componente MA(1) não-sazonal
# - Pico na lag 4 na FAC → componente MA(1) sazonal
# → Sugestão inicial: SARIMA(0,1,1)(0,1,1)[4]

# ============================================================
# 3. DIAGNÓSTICO DO MODELO INICIAL
# ============================================================

euretail %>%
  forecast::Arima(order = c(0, 1, 1), seasonal = c(0, 1, 1)) %>%
  residuals() %>%
  ggtsdisplay(main = "Resíduos — SARIMA(0,1,1)(0,1,1)")

# ============================================================
# 4. AJUSTE DO MODELO FINAL
# ============================================================

# Modelo com termos MA adicionais para corrigir autocorrelação residual
fit3 <- forecast::Arima(euretail, order = c(0, 1, 3), seasonal = c(0, 1, 1))
print(fit3)
cat("AICc:", fit3$aicc, "\n")

# Diagnóstico completo dos resíduos
checkresiduals(fit3)

# ============================================================
# 5. PREVISÃO 12 TRIMESTRES À FRENTE (3 anos)
# ============================================================

fit3 %>%
  forecast::forecast(h = 12) %>%
  autoplot() +
  ggtitle("Previsão SARIMA(0,1,3)(0,1,1) — 3 anos") +
  xlab("Ano") +
  ylab("Índice de varejo")

# ============================================================
# 6. SELEÇÃO AUTOMÁTICA COM auto.arima
# ============================================================

fit_auto <- forecast::auto.arima(euretail)
print(fit_auto)
cat("AICc auto.arima:", fit_auto$aicc, "\n")

# Comparando os dois modelos
cat("\n--- Comparação de modelos ---\n")
cat("SARIMA(0,1,3)(0,1,1) — AICc:", fit3$aicc, "\n")
cat("auto.arima             — AICc:", fit_auto$aicc, "\n")
