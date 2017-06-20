library("dplyr")
library("readr")
library("tidyr")
library(ggplot2) # install.packages("ggplot2")

x <- read.csv('AFT_datarip.csv')
head(x)

y <- x %>% mutate(netRifles = MANUFRifles - EXPORTRifles + IMPORTRifles) %>% mutate(netShotguns = MANUFShotguns - EXPORTShotguns + IMPORTShotguns) %>% mutate(netHandguns = MANUFHandguns - EXPORTHandguns + IMPORTHandguns)

head(y)

z <- y[1:28,]

totalnet <- z %>% mutate(totalnetRFH = netRifles + netShotguns + netHandguns, totalnetMILS = totalnetRFH/1000000)

max(totalnet[,15])
min(totalnet[,15])
totalnet[,15]

#plot(totalnet[,1],totalnet[,14], type = "b", col = "blue",
#  xaxs = "i",
#  main = "Net Handgun, Rifle, Shotguns into US (1986-2013)", lwd = 1,
#  sub = "(Source: AFT bureau)",
#  xlim = c(1986,2013),
#  xlab = "Year", ylab = "Net gun gain")

getOption("scipen")
opt <- options("scipen" = 20)
getOption("scipen")

totalnet2 <- totalnet %>% mutate(totalnetMM = tatalnet[,14]/1000000)

plot(totalnet[,1],totalnet[,15], type = "b", col = "blue",
     axes=FALSE,
     main = "Net Handgun, Rifle, Shotguns into the US (1986-2013)", lwd = 1,
     sub = "(Data: ATF bureau. Values represent manufactured + imports - exports)",
     xlim = c(1986,2013), 
     xlab = "Year", ylab = "Net guns gained (millions)")

axis(1,at=1986:2015)
axis(2,at=1:16,las=2)

qplot(totalnet[,1],totalnet[,14],data = totalnet, geom=c("line"))
