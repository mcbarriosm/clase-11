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


# Linear regression


# What is ols object?


# get predict values


#=================#
# 2. Subset datos #
#=================#

# remover outlayers


# subset data


# new estimations


# get "tidy" regression coefficients (broom library)


#===========================#
# 3. Robust standard errors #
#===========================#

# Eicker-Huber-White robust standard errors (commonly referred to as “HC2”)


# replicar resultados de Stata


# Print the HAC VCOV


# cluster standar errors


#==========================================#
# 4. Dummy variables and interaction terms #
#==========================================#

# categoricla variables


# include interaction terms
cat("x1:x2 = x1 × x2")
cat("x1/x2 = x1 + x1:x2")
cat("x1*x2 = x1 + x2 + x1:x2")


#=====================#
# 5. Marginal effects #
#=====================#

# make output var


# logit


# probit


# ols


# marginal effects


#=================#
# 6. Presentation #
#=================#

# joint models (modelsummary)


# export table


# coefplot



# coefplot with ggplot


# Prediction and model validation




