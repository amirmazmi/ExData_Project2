###############################################################
# Exploratory Data Analysis
#   Week 4 - Project
#
#  plot3.R script producing plot3.png
# 
# rm(list=ls())
# 
###############################################################
# Question 3
# Of the four types of sources indicated by the type 
# (point, nonpoint, onroad, nonroad) variable, which of these
# four sources have seen decreases in emissions from 
# 1999-2008 for Baltimore City? 
# 
# Which have seen increases in emissions from 1999-2008? 
# 
# Use the ggplot2 plotting system to make a plot answer 
# this question.
###############################################################

library(ggplot2)

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
SCC <- readRDS(fpath[1]) # 11717 x 15

# if file already downloaded and unzipped
NEI <- readRDS("./data/summarySCC_PM25.rds") # 6497651 x 6


baltimore <- NEI[NEI$fips == "24510",]

# check for negative values
negative <- baltimore$Emissions < 0
sum(negative, na.rm=TRUE) # no negative values


# All sources have seen a decrease
# No increase in the period


###############################################################
# output plot
###############################################################

png(filename = "plot3.png",width = 700, height = 480)

ggplot(baltimore, aes(year,log10(Emissions)) ) +
    geom_point() +
    geom_smooth(method="lm",color="red") +
    facet_grid(.~type) +
    ylab("Emissions (log10)") +
    labs(title="Baltimore Emission based on type")

dev.off()

