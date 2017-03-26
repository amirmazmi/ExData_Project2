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

yEmiss <- NEI[, c("year", "Emissions")]
total <- aggregate(Emissions ~ year, yEmiss, sum)

###############################################################
# output plot
###############################################################


png(filename = "plot1.png",width = 500, height = 480)

barplot((total$Emissions / 10^6),
        names.arg = total$year,
        ylim=c(0,8),
        ylab = "Total Emission (milions)", 
        xlab = 'Year', 
        main = "US Total PM2.5 Emission")

dev.off()

# Total emissions have generally decreased for the years

