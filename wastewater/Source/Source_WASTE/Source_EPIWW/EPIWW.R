# EPI 2014
# Indicator: EPIWW - EPI Team researched Wastewater Treatment 
# Producing EPIWW_2014.csv
# Angel Hsu
#
# Comments starting with "##" are specific to this indicator
#
# Countries dropped: 

###########################################################
# Initialization, File names

source("../UtilityFcts.R")

# Name of original source data file in csv - format
file <- "EPIWW_export_12Nov.csv"

# Name of masterfile that consists of three columns (code, iso and country) 
# in the format and order of our convention
masterfile <- "../MasterFile.csv"

# names of new data sets that have the right format
output <- "EPIWW_2014.csv"

###########################################################
# Reading in files

m <- read.csv(masterfile, header = TRUE, as.is = TRUE)

x <- read.csv(file, header = FALSE, as.is = TRUE)

# only need columns 3, 8, 10
x <- x[c(3,8,10)]

colnames(x) <- c("country", "Value", "Year")

###########################################################
# Cleaning and Exploring Data

# need to replace estimates with averages
x$Value[x$Value == "0-5?"] <- 2.5
x$Value[x$Value == "0-10?"] <- 5
x$Value[x$Value == "<10"] <- 5
x$Value[x$Value == "75-95?"] <- 85
x$Value[x$Value == "0-10"] <- 5

# need to replace -5555 with -99999
x$Value[x$Value == -5555] <- -99999

# need to make data numeric
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

yearseq <- seq(1990,2013)
numy <- length(yearseq)

###########################################################
# Corrections to the data

# remove India 2004,  datapoint 
x <- x[-34,]

# average Peru 2000
temp <- mean(x$Value[x$country == "Peru"])
x$Value[59] <- temp
# remove other Peru value
x <- x[-58,]

# Iraq, take average for 2010 data
temp <- mean(x$Value[x$country == "Iraq"])
x$Value[97] <- temp

# remove other Iraq value
x <- x[-98,]

# Kenya, take average for 2011
temp <- mean(x$Value[x$country == "Kenya"])
x$Value[35] <- temp

# remove other Kenya 2011 value
x <- x[-36,]

# China
temp <- (1/3)*(x$Value[71]) + (2/3)*(x$Value[73])
x$Value[71] <- temp

# remove other value for China
x <- x[-73,]

###########################################################
# Creating new data frames

new <- cbind(m, matrix(-9999, ncol = numy, nrow = nrow(m)))
colnames(new)   <- c("code", "iso", "country", paste("EPIWW.", yearseq, sep = ""))

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


###########################################################
# Extra corrections to the data



###########################################################
# Exporting data frames

write.csv(new, output, row.names=FALSE)

