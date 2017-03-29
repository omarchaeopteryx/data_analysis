setwd("~") # Check.
getwd()
netimp <- read.csv("Net_Imports.csv", header = TRUE) # Remember to assign right away.

# Installing useful packages:
install.packages("ggplot2")
library("ggplot2")

install.packages("YaleToolkit")
library("YaleToolkit")

# Exploring the information:
head(netimp, 3)
nrow(netimp)
ncol(netimp)
names(netimp)
netimpsimp <- netimp[,1:2]
head(netimpsimp, 2)
summary(netimpsimp[,2])
nrow(netimpsimp)

# Converting date info in format 'mm/dd/yyyy':

#install.packages("date")

#?as.Date
timeline2 <- netimpsimp[,1]
head(timeline2)

as.Date(timeline2, format = "%b %d, %Y") -> timeline2new
head(timeline2new)
# desired: timeline 08 Feburary 1991 - November 7, 2014


# timeline <- c(1:1241) --- alternative timeline if the as.Date function doesn't work;

cbind(timeline2new, netimpsimp[,2]) -> netimpsimpler
head(netimpsimpler)
summary(netimpsimpler)
head(netimpsimpler)
names(netimpsimpler)
nrow(netimpsimpler)
ncol(netimpsimpler)
colnames(netimpsimpler) <- c("Dates", "Thousands Barrels per Day") # Looks OK!

timeline2newlabel <- ("Thousands Barrels per Day")

timeline2new2 <- c(1991:2015)


plot(timeline2new,netimpsimpler[,2], type = "l", col = "chocolate4",
     xaxs = "i",
     main = "Net Oil Imports in the U.S. (1991-2014)", lwd=1, 
     
     sub = "(Source: EIA)",
     xlab = "Year", ylab = "Thousand Barrels per Day")

axis.Date(1, at=timeline2new, labels = FALSE)
grid(nx=5, col = "darkgray", lty = "dotted")

?xlim
?par
?axis.Date
?labels
?plot

# The final step for making the plot: 
plot(timeline2new, netimpsimpler[,2], type = "l", main = "Net Oil Imports in US (1991-2014)", xlab = "Year", ylab = "Thousand Barrels per Day")

