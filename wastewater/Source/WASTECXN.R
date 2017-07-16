# WASTECXN
# WASTE*CXN
# Angel Hsu

###########################################################
# Initialization, File names
library(YaleToolkit)

source("../UtilityFcts.R")

# Name of original source data file in csv - format

file1 <- "WASTE.csv"
file2 <- "CXN.csv"

# Name of masterfile that consists of three columns (code, iso and country) 
# in the format and order of our convention
masterfile <- "../MasterFile.csv"

# names of new data sets that have the right format
output <- "WASTECXN_2014.csv"

###########################################################
# Reading in files

m <- read.csv(masterfile, header = TRUE, as.is = TRUE)

waste <- read.csv(file1, header = TRUE, as.is = TRUE)
cxn <- read.csv(file2, header = TRUE, as.is = TRUE)

###########################################################
# Reading data in

wastenew <- cbind(m, waste$WASTE.2014, cxn$CXN.2014)
names(wastenew)[4:5] <- c("WASTE.2014", "CXN.2014")

for (i in 4:ncol(wastenew)) wastenew[wastenew[,i] < 0, i] <- NA
wastenew[is.na(wastenew)] <- 1
wastenew$comb <- (wastenew$WASTE.2014*wastenew$CXN.2014)/100
colnames(wastenew)[6] <- "WASTECXN.2012"

# need to replace -9999 for countries that had missing data
wastenew$WASTE.2014 <- waste$WASTE.2014
wastenew$CXN.2014 <- cxn$CXN.2014

# replace erroneous WASTECXN values, if either WASTE or CXN missing, then -9999
for(i in 1:nrow(wastenew)){
  if(wastenew$WASTE.2014[i] == -9999 | wastenew$CXN.2014[i] == -9999){
    wastenew$WASTECXN.2012[i] <- -9999
  }
}

# remove WASTE.2014 and CXN.2014
wastenew <- wastenew[,-c(4:5)]

####################################################
# Exporting data frames

write.csv(wastenew, output, row.names = FALSE)
