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
# NEI <- readRDS("./data/summarySCC_PM25.rds") # 6497651 x 6

baltimore <- NEI[NEI$fips == "24510",]

yEmiss <- baltimore[, c("year", "Emissions")]
total <- aggregate(Emissions ~ year, yEmiss, sum)


###############################################################
# output plot
###############################################################

png(filename = "plot2.png",width = 480, height = 480)

barplot(total$Emissions,names.arg = total$year, ylim=c(0,3500),
        ylab = "Total Emissions", 
        xlab = 'Year', 
        main = "Baltimore City Total PM2.5 Emission")

dev.off()


