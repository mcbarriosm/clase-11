## Clase 11: Regresiones
## Eduard Martinez
## 02-11-2022

## configuracion inicial 
rm(list = ls()) # limpia el entorno de R

## llamar y/o instalar las librerias de la clase 
require(pacman)
p_load(tidyverse, arrow, rio , 
       broom, # tidy-coefficients
       mfx, # marginal effects
       margins,  # marginal effects
       estimatr, # robust standard errors
       lmtest, # HAC (Newey-West) standard errors
       fixest, # hdfe regressions (feols)
       modelsummary, # Coefplot with modelplot
       stargazer # export tables to latex 
)  

## importar datos
browseURL("https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page") # source
browseURL("https://www1.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_green.pdf") # data dictionaries 
df <- import("https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-01.parquet")
df <- janitor::clean_names(df) %>% .[,-1:-3]

# trip_distance: The elapsed trip distance in miles reported by the taximeter
# total_amount: The total amount charged to passengers. Does not include cash tips.
# payment_type: 1= Credit card 2= Cash 3= No charge 4= Dispute 5= Unknown 6= Voided trip
# passenger_count: The number of passengers in the vehicle.
# trip_type: 1= Street-hail 2= Dispatch

#=====================#
# 1. Basic Regression #
#=====================#

# lm function
?lm
lm(formula = total_amount ~ 1 , data = df)
lm(formula = total_amount ~ . , data = df) # Regresion que tiene todas las variables
lm(formula = total_amount ~ trip_distance + payment_type, data = df)
lm(formula = total_amount ~ -1 + trip_distance + payment_type, data = df)

# Linear regression
ols <- lm(formula = total_amount ~ trip_distance + as.factor(payment_type), data = df)

# What is ols object?
ols$coefficients
ols$residuals
summary(ols)

# get predict values
hist(ols$residuals)

#=================#
# 2. Subset datos #
#=================#

# remover outlayers
ols_credit <- lm(total_amount ~ trip_distance, data = df, subset = payment_type == 1)

# subset data


# new estimations


# get "tidy" regression coefficients (broom library)
tidy(ols)

#===========================#
# 3. Robust standard errors #
#===========================#

# Eicker-Huber-White robust standard errors (commonly referred to as “HC2”)


# replicar resultados de Stata
ols_stata <- lm_robust(total_amount ~ trip_distance + as.factor(payment_type), 
                       data = df, se_type = "stata")

summary(ols_stata)

# Print the HAC VCOV


# cluster standar errors


#==========================================#
# 4. Dummy variables and interaction terms #
#==========================================#

# categoricla variables
df_2 <- df %>% mutate(payment_type = factor(payment_type), 
                       trip_type = factor(trip_type),
                       store_and_fwd_flag = factor (store_and_fwd_flag)) 

#df_3 <- model.matrix(~,+I(trip_distance^2), data = df_2) %>% as_tibble()

# include interaction terms
cat("x1:x2 = x1 × x2")
cat("x1/x2 = x1 + x1:x2")
cat("x1*x2 = x1 + x2 + x1:x2")

ols_3 <- lm_robust(total_amount ~ trip_distance:as.factor(payment_type), data = df)
summary(ols_3)

#=====================#
# 5. Marginal effects #
#=====================#

# make output var
df = df %>% mutate(pay_credit =ifelse(payment_type == 1,1,0))

plm <- lm(pay_credit ~ trip_distance, data = df)

# logit

logit <- glm(pay_credit ~ trip_distance, data = df, family = binomial(link="logit"))
logit
summary(logit)

# probit
probit = glm(pay_credit ~ trip_distance, data = df , family = binomial(link = "probit")) 
probit
summary(probit)

# ols
plm <- lm(pay_credit ~ trip_distance, data = df)


# marginal effects
margins(logit)
m_probit <- margins(probit)
summary(m_probit)
m_probit

#=================#
# 6. Presentation #
#=================#

# joint models (modelsummary)
msummary(models = list(ols,ols_3,ols_credit,ols_stata))
df_models <- msummary(models = list(ols,ols_3,ols_credit,ols_stata))

# export table
stargazer(ols,probit,
          type = 'text',
          dep.var.labels = c('Monto pagado', 'Probabilidad de TC'),
          df = FALSE,
          digits = 3,
          out = paste0('output/ols.doc'))


# coefplot
coefplot(ols_stata)
modelplot(list(ols,ols_3,ols_credit,ols_stata))

# coefplot with ggplot
tidy(ols_stata,conf.int = T)

# Prediction and model validation




