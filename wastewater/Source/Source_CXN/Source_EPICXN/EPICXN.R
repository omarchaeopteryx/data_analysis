# EPI 2014
# Indicator: EPICXN - EPI team research Wastewater Connection Rate
# Producing EPICXN_2014.csv
# Angel Hsu
#
# Comments starting with "##" are specific to this indicator
#
# Countries dropped: 

###########################################################
# Initialization, File names

source("../UtilityFcts.R")

# Name of original source data file in csv - format
file <- "EPICXN_export_12Nov.csv"

# Name of masterfile that consists of three columns (code, iso and country) 
# in the format and order of our convention
masterfile <- "../MasterFile.csv"

# names of new data sets that have the right format
output <- "EPICXN_2014.csv"

###########################################################
# Reading in files

m <- read.csv(masterfile, header = TRUE, as.is = TRUE)

x <- read.csv(file, header = FALSE, as.is = TRUE)

# only need columns 3, 8, 10
x <- x[,c(3,8,10)]

colnames(x) <- c("country", "Value", "Year")

###########################################################
# Cleaning and Exploring Data

# need to replace ? estimates with averages
x$Value[x$Value == "<5"] <- "2.5"
x$Value <- as.numeric(x$Value)

#countries from new data file found in master file (for exploration purposes)
cf <- unique(x[,1])[unique(x[,1]) %in% m[,3]]
length(cf)

#countries from new data file not found in master file(for exploration purposes)
cnf <- unique(x[,1])[!(unique(x[,1]) %in% m[,3])]
cnf

# Number of "countries" in source data
numc <- length(unique(x[,1]))

# Years

yearseq <- seq(1995,2013)
numy <- length(yearseq)

###########################################################
# make corrections to data

# China
x <- x[-c(72:73),]

# Get rid of Taiwan's data
x <- x[-75,]

# Honduras
temp <- mean(x$Value[x$country == "Honduras"])
x$Value[28] <- temp

# remove other Honduras
x <- x[-29,]

# Malawi for year 2009
temp <- mean(x$Value[x$country == "Malawi"])
x$Value[38] <- temp

# remove other Malawi
x <- x[-c(39:40),]

# Benin
x <- x[-8,]

# Malaysia, 2010
x <- x[-76,]

# Sri Lanka
x <- x[-68,]

###########################################################
# Creating new data frames

new <- cbind(m, matrix(-9999, ncol = numy, nrow = nrow(m)))
colnames(new)   <- c("code", "iso", "country", paste("EPICXN.", yearseq, sep = ""))

# Countries not found in dictionary
notindict <- c()

i <- NULL
for (i in 1:nrow(x)){
  
  country <- x[i,1]
  year <- x[i,3]
  # Find position of country in masterfile,
  # Warning if not found is built in getcp function
  pos <- getcp(country)
  
  if (pos == -1){
    notindict <- c(notindict, country)
  } else {
  
    ## Extracting the right series of data for a specific country 
    newrow <- x[i,2]
    j <- which(yearseq == year)
    new[pos, j+3] <- newrow
  }
}

# paste("Country", notindict, "not found in dictionary")

# ignore Swaziland's number because it's not a percentage
new[new$country == "Swaziland",]
new$EPICXN.2012[199] <- -9999

# add in Taiwan's data
twn <- read.csv("Taiwan.csv", header=TRUE, as.is=TRUE)
twn <- twn[11, c(37:53)]

new[203, c(4:20)] <- twn

###########################################################
# Exporting data frames

write.csv(new, output, row.names=FALSE)

