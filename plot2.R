###############################################################
# Exploratory Data Analysis
#   Week 4 - Project
#
#  plot2.R script producing plot2.png
# 
# rm(list=ls())
# 
###############################################################
# Question 2
# Have total emissions from PM2.5 decreased in the Baltimore 
# City, Maryland (fips == "24510") from 1999 to 2008? 
# 
# Use the base plotting system to make a plot answering this
# question.
###############################################################

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

NEI <- readRDS(fpath[2]) # 6497651 x 6

# if file already downloaded and unzipped
NEI <- readRDS("./data/summarySCC_PM25.rds") # 6497651 x 6


baltimore <- NEI[NEI$fips == "24510",]

balt1999 <-  NEI[NEI$fips=="24510" & NEI$year=="1999", "Emissions"]
balt2002 <-  NEI[NEI$fips=="24510" & NEI$year=="2002", "Emissions"]
balt2005 <-  NEI[NEI$fips=="24510" & NEI$year=="2005", "Emissions"]
balt2008 <-  NEI[NEI$fips=="24510" & NEI$year=="2008", "Emissions"]

dat <- list(balt1999, balt2002, balt2005, balt2008)

summarydat <- lapply(dat, summary)


# Total emissions of PM2.5 for Baltimore have generally decreased


###############################################################
# output plot
###############################################################

png(filename = "plot2.png",width = 480, height = 480)

boxplot( log10(balt1999), log10(balt2002), log10(balt2005), 
         log10(balt2008), ylab="Emissions (log10)",
         names=c("1999","2002","2005","2008")  )
title(main="Emissions in Baltimore City")

dev.off()


