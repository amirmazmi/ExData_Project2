###############################################################
# Exploratory Data Analysis
#   Week 4 - Project
#
#  plot5.R script producing plot5.png
# 
# rm(list=ls())
# 
###############################################################
# Question 5
# How have emissions from motor vehicle sources changed from 
# 1998-2008 in Baltimore City?
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
SCC <- readRDS(fpath[1]) # 11717 x 15

# if file already downloaded and unzipped
NEI <- readRDS("./data/summarySCC_PM25.rds") # 6497651 x 6
SCC <- readRDS("./data/Source_Classification_Code.rds") # 11717 x 15


#############################
# Data wrangling
#############################

# get SCC codes that have the words "coal" and "comb"
# ---avoiding to use merge here since it will create an even 
# larger data set

# write out to text file - easier to inspect
categories <- levels(SCC$Short.Name)
write.table(categories, "./SCC levels.txt", row.names=F)

# grep EITHER "vehicle" OR "motor" and look at intersect
grepSCC <- grepl("[Vv]ehicle", SCC$Short.Name) | 
    grepl("[Mm]otor", SCC$Short.Name)   
SCC$filter <- grepSCC
codes <- SCC[SCC$filter == TRUE, "SCC"]

# get data that have the SCC codes for Baltimore City
baltveh <- NEI[NEI$SCC %in% codes & NEI$fips == "24510",]

y1999 <- baltveh[ baltveh$year == 1999,]
y2002 <- baltveh[ baltveh$year == 2002,]
y2005 <- baltveh[ baltveh$year == 2005,]
y2008 <- baltveh[ baltveh$year == 2008,]


###############################################################
# output plot
###############################################################

png(filename = "plot5.png",width = 600, height = 480)

boxplot(log10(y1999$Emissions), log10(y2002$Emissions),
        log10(y2005$Emissions), log10(y2008$Emissions),
        ylab="Emissions (log10)",
        names=c("1999","2002","2005","2008")  )
title(main="Motor Vehicle Emissions in Baltimore City") 

dev.off()

