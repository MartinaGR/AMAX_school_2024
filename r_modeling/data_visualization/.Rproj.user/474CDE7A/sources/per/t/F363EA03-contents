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

