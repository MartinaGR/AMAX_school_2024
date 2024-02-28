mydata = read.csv("CervicalCancer_Kampala.csv", stringsAsFactors = TRUE)

dim(mydata)
summary(mydata)

# The trend of cervical cancer in Kampala from 1993 to 2012
All_Age_Group = mydata[mydata$AGE_GROUP =="All",]
barplot(height=All_Age_Group$NUMBER_CASES, names=All_Age_Group$YEAR, 
        las=2, ylim=c(0,max(All_Age_Group$NUMBER_CASES)+50))


# What’s the most affected age group by cervical cancer in Kampala in 2012?
mydata_2012 = mydata[mydata$YEAR =="2012" & mydata$AGE_GROUP != "All",]

barplot(height=mydata_2012$NUMBER_CASES, names=mydata_2012$AGE_GROUP, 
        las=2, ylim=c(0,max(mydata_2012$NUMBER_CASES)+10), col="slateblue1")

pie(mydata_2012$NUMBER_CASES , labels = mydata_2012$AGE_GROUP)


# Evolution of Cervical cancer in Women in Kampala for each age group
# with ggplot2
library(ggplot2)
mydata_age_group = mydata[mydata$AGE_GROUP != "All",]

ggplot(data = mydata_age_group, aes(YEAR, NUMBER_CASES)) +
  geom_line(color = "steelblue", size = 1) +
  geom_point(color = "steelblue") + 
  labs(title = "Evolution of Cervical cancer in Women in Kampala for each age group",
       y = "Number of cervical cancer cases", x = "") + 
  facet_wrap(~ AGE_GROUP) 



ggplot(data = diamonds, aes(x = carat, y = price, color = cut)) + 
  geom_point() + 
  geom_smooth(method = "lm")

dat = data.frame(longley)

ggplot(data = longley, aes(x= Unemployed, y= GNP)) +
  geom_line(color = "steelblue", size = 1) +
  geom_point(color = "steelblue")


Dat <- data.frame(longley)
  


# Times series plot  ------------------------------------------------------


## Install packages -------------------------------------------------------

install.packages("plotly")  
library(plotly)
library(tidyverse)

## Load economics data set ------------------------------------------------

data("economics")

## Create an interactive time series plot ---------------------------------

plot <- plot_ly(data = economics, x = ~date) 

## Add lines for differents variables -------------------------------------

plot <- add_lines(plot, y = ~unemploy, name = "Unemployed")
plot <- add_lines(plot, y = ~psavert, name = "Personal Saving Rate")
plot <- add_lines(plot, y = ~pop, name = "Population")


plot_2 <- economics %>% 
  plot_ly(economics, x = "date") %>% 
  add_lines(plot, y = "unemploy", name = "Unemployed") %>% 
  add_lines(plot, y = "psavert", name = "Personal Saving Rate") %>% 
  add_lines(plot, y = "pop", name = "Population")






