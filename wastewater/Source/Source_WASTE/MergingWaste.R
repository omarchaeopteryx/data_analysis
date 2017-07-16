# Water Merging
# 
# Angel Hsu

# Merging together FAO, OECD, and EPI data

###########################################################
# Initialization, File names
library(YaleToolkit)

# source("../UtilityFcts.R")

# Name of original source data file in csv - format

file1 <- "CleanedUNSD.csv"
file2 <- "CleanedFAO.csv"
file3 <- "OECDWW.csv"
file4 <- "EPIWW.csv"
file5 <- "PINSETWW.csv"

# Name of masterfile that consists of three columns (code, iso and country) 
# in the format and order of our convention
masterfile <- "../MasterFile.csv"

# names of new data sets that have the right format
output <- "WASTE_2014.csv"

###########################################################
# Reading in files

m <- read.csv(masterfile, header = TRUE, as.is = TRUE)

###########################################################
# Reading data in
  
unsd <- read.csv(file1, header = TRUE, as.is = TRUE)
fao <- read.csv(file2, header = TRUE, as.is = TRUE)
oecd <- read.csv(file3, header = TRUE, as.is = TRUE)
epi <- read.csv(file4, header=TRUE, as.is=TRUE)
pin <- read.csv(file5, header=TRUE, as.is=TRUE)

# only need FAO_frac column in fao; unsd_con_treat from unsd
x <- fao[,c(3:4,10)]

# need to multiply last column by 100 if not -9999
i <- NULL
for (i in 1:nrow(x)){
  if(x$FAO_frac[i] != -9999){
    x$FAO_frac[i] <- (x$FAO_frac[i])*100
  }
}

# whatis(epi)
# need to replace NA in epi with -9999
epi[is.na(epi)] <- -9999

############################################################
# Creation of WASTE, merged data set

# need to format FAO and UNSD data according to others
# Number of "countries" in source data
numc <- length(unique(x[,1]))

# Years fao
# to find the year range, whatis(x)
yearseq <- 1962:2012
numy <- length(yearseq)

# Years unsd
whatis(unsd)
yearseq2 <- 1990:2009
numy2 <- length(yearseq2)

# only need UNSD_treat data
unsd <- unsd[,-4]

###########################################################
# Creating new data frames for FAO and UNSD

new <- cbind(m, matrix(-9999, ncol = numy, nrow = nrow(m)))
colnames(new) <- c("code", "iso", "country", paste("FAOWW.", yearseq, sep = ""))

i <- NULL
for (i in 1:nrow(x)){
  
  country <- x[i,1]
  year <- x[i,2]
  # Find position of country in masterfile,
  # Warning if not found is built in getcp function
  pos <- getcp(country)
  
  if (pos == -1){
    notindict <- c(notindict, country)
  } else {
    
    ## Extracting the right series of data for a specific country 
    newrow <- x[i,3]
    j <- which(yearseq == year)
    new[pos, j+3] <- newrow
  }
}

faonew <- new #fao data

# same for UNSD

new2 <- cbind(m, matrix(-9999, ncol = numy2, nrow = nrow(m)))
colnames(new2) <- c("code", "iso", "country", paste("UNSD.", yearseq2, sep = ""))

i <- NULL
for (i in 1:nrow(unsd)){
  
  country <- unsd[i,1]
  year <- unsd[i,2]
  # Find position of country in masterfile,
  # Warning if not found is built in getcp function
  pos <- getcp(country)
  
  if (pos == -1){
    notindict <- c(notindict, country)
  } else {
    
    ## Extracting the right series of data for a specific country 
    newrow <- unsd[i,3]
    j <- which(yearseq2 == year)
    new2[pos, j+3] <- newrow
  }
}

unsdnew <- new2 #unsd data

###########################################################
###                   DATA MERGE                        ### 

# First use EPI data, then use OECD, then UNSD, then Pinset, then FAO
# need to read back in the original data

faonew <- faonew[,c(1:3,32:54)]

merge <- epi
yearseq <- 1990:2013
colnames(merge) <- c("code", "iso", "country", paste("WASTE.", yearseq, sep = ""))


# first replace with OECD data 
for(i in 1:nrow(merge)){
  for(j in 4:ncol(oecd)){
    if (merge[i,j] == -9999){
      merge[i,j] <- oecd[i,j]
    }
  }
}

# then replace with UNSD
for(i in 1:nrow(merge)){
  for(j in 4:ncol(unsdnew)){
    if (merge[i,j] == -9999){
      merge[i,j] <- unsdnew[i,j]
    }
  }
}

# then replace with Pinset
i <- NULL
j <- NULL
for(i in 1:nrow(merge)){
  for(j in 4:ncol(pin)){
    if (merge[i,j] == -9999){
      merge[i,j] <- pin[i,j]
    }
  }
}


# then replace with FAO
i <- NULL
j <- NULL
for(i in 1:nrow(merge)){
  for(j in 4:ncol(faonew)){
    if (merge[i,j] == -9999){
      merge[i,j] <- faonew[i,j]
    }
  }
}

# create 10 year average of wastewater data 
for (i in 4:ncol(merge)) merge[merge[,i] < 0, i] <- NA

# creates 10-year averages of all available data for each dataset
merge$avg <- apply(merge[,grep("2000", names(merge)):27], 1, mean, na.rm = TRUE)
colnames(merge)[28] <- "WASTE.2014"

# need to replace NA with -9999
merge[is.na(merge)] <- -9999

# adds in 1990-2010 average data for countries that don't have 2000-2010 data
sel <- which(merge[,"WASTE.2014"] == -9999)
unique(merge[sel,"country"])

# need to replace -9999 with NA
for (i in 4:ncol(merge)) merge[merge[,i] < 0, i] <- NA

merge$WASTE.2014[sel] <- apply(merge[sel,(4:27)], 1, mean, na.rm = TRUE)

# replace NAs with -9999
merge[is.na(merge)] <- -9999

###########################################################
# Exporting data frames

write.csv(merge, output, row.names=FALSE)

