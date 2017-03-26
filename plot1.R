###############################################################
# Exploratory Data Analysis
#   Week 4 - Project
#
#  plot1.R script producing plot1.png
# 
# rm(list=ls())
# 

setwd("F:/Coursera/04 Exploratory Data Analysis/Project/Week 4/")

#############################
# get the data
#############################

downloadDate <- gsub(":",".",date())

targ_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
destfile <- paste0("./data/EPA data ",downloadDate,".zip" )
download.file(targ_url, destfile=destfile)


#  Get file names incl. path
fname <- unzip(destfile, list=TRUE)$Name
#unzip the files
unzip(destfile, files=fname, exdir="./data", overwrite=TRUE)
# path to extracted files
fpath <- file.path("./data", fname)
# read file in 
NEI <- readRDS(fpath[2]) # 6497651 x 6

# if file already downloaded and unzipped
NEI <- readRDS("./data/summarySCC_PM25.rds") # 6497651 x 6




###############################################################
# Question 1
# Have total emissions from PM2.5 decreased in the United 
# States from 1999 to 2008? 
# 
# Using the base plotting system,make a plot showing the 
# total PM2.5 emission from all sources for each of the
# years 1999, 2002, 2005, and 2008.
###############################################################

y1999 <- NEI[NEI$year == 1999, "Emissions" ] # 1108469 x 6
y2002 <- NEI[NEI$year == 2002, "Emissions" ] # 1698677 x 6
y2005 <- NEI[NEI$year == 2005, "Emissions" ] # 1713850 x 6
y2008 <- NEI[NEI$year == 2008, "Emissions" ] # 1976655 x 6

dat <- list(y1999, y2002, y2005, y2008)

# inspect data - observe that mean drops while median only
# drops between 1999 and 2002

# medians <- lapply(dat, median)
# means <- lapply(dat, mean)
summarydat <- lapply(dat, summary)
# [[1]]
# Min.  1st Qu.   Median     Mean  3rd Qu.      Max. 
# 0.00     0.01     0.04     6.62     0.26  66700.00 
# 
# [[2]]
# Min.  1st Qu.   Median     Mean  3rd Qu.      Max. 
# 0.0      0.0      0.0      3.3      0.1  647000.0 
# 
# [[3]]
# Min.  1st Qu.   Median     Mean  3rd Qu.      Max. 
# 0.00     0.00     0.01     3.18     0.07  58900.00 
# 
# [[4]]
# Min.   1st Qu.  Median     Mean   3rd Qu.     Max. 
# 0.000   0.000     0.005    1.753     0.062 20800.000 

###############################################################
# output plot
###############################################################


png(filename = "plot1.png",width = 480, height = 480)

# plot the logs since difference between 3rd quartile and 
# max is large
boxplot( log10(y1999), log10(y2002), log10(y2005), 
         log10(y2008), ylab="Emissions (log10)",
         names=c("1999","2002","2005","2008") )
title(main="Comparison of US Nationwide Emissions")

dev.off()


# Total emissions have generally decreased for the years




















