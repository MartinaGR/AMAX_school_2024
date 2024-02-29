# Survival analysis 28-02-2024

#Calling the packages

library(survival)
library(ggfortify)
library(ggplot2)
library(dplyr)
library(tidyverse)


#Load database

veteran <- data.frame(veteran)
data(cancer, package = "survival")
head(veteran)


# Kaplan-Meier ------------------------------------------------------------

# Built a standard survival curve
Y <- Surv(veteran$time, veteran$status)
head(Y,80)

# Produce the Kaplan-Meier stimates of the probability of survival
km_fit <- survfit(Y~1, data = veteran)

# Plot the Kaplan-Meier curve
autoplot(km_fit) + labs(x= "Time in months", y="Survival probability")

# To stimate the probablity of surviving to 1 year
summary(km_fit, times =12)

# To stimate the probablity of surviving to 10 year
summary(km_fit, times = c(1, 12*(1:10)))


# Long Rank Test ----------------------------------------------------------

# Null hyphotesis: S(t)a = S(t)b

km_trt_fit <- survfit(Y ~ trt, data = veteran)
autoplot(km_trt_fit) + labs( x = 'Time in months', 
                             y = 'Survival probability')

km_trt_fit
survfit(Y ~ trt, data=veteran)

# Task 1 ------------------------------------------------------------------

vet <- veteran %>% 
  mutate(
    AG = ifelse((age <60), 'LT60', 'OV60'),
    AG = factor(AG),
    trt = factor(trt, labels = c('Stards', 'Test')),
    prior = factor(prior, labels = c('No', 'Yes'))
    )

head(vet)

# Task 2 ------------------------------------------------------------------

# AG
km_age_fit <- survfit(Y ~ AG, data = vet)
autoplot(km_age_fit) + labs( x = 'Time in months', 
                             y = 'Survival probability')
km_age_fit
survdiff(Y ~ AG, data=vet)


# Prior
km_prior_fit <- survfit(Y ~ prior, data = vet)
autoplot(km_prior_fit) + labs( x = 'Time in months', 
                             y = 'Survival probability')
km_prior_fit
survdiff(Y ~ prior, data=vet)


# Treatment
km_trt_fit <- survfit(Y ~ trt, data = vet)
autoplot(km_trt_fit) + labs( x = 'Time in months', 
                             y = 'Survival probability')
km_trt_fit
survdiff(Y ~ trt, data=vet)


# Cox regression

cox <- coxph(Y ~ trt + celltype + karno + diagtime +
               age + prior, data = vet)

summary(cox)

  
# 

cox.zph(cox)















