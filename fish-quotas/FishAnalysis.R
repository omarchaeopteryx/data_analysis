# 10-26-2015 omar malik
# analyzing fish catch data (PNW)

library("YaleToolkit")
library("dplyr")
library("tidyr")
library(ggplot2)

getwd()
setwd('../WritingEditing/ForHakaidata')
read.csv("PacificFishNOAA-2015-10-31csv.csv", header = TRUE) -> x
head(x)
#is.na(x) -> xi
#xi
#x[,4]
#x <- (x[,1:6])
remain <- as.numeric(x[,6])
head(remain)
quota <- as.numeric((x[,3]))
head(quota)
tail(quota)

perUncaught <- remain/quota*100  # finding percent remaining, percent caught
head(perUncaught)
x <- mutate(x,perUncaught,perCaught = (100-perUncaught))

n <- x %>% group_by(Species) %>% spread(Year,perCaught)

m <- group_by(x,Year)

plot(x$Year,x$perCaught)  ## useful overview 

write.csv(x,"Test.csv")

# TO BE CONTINUED...
