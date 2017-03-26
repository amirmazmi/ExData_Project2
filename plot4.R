###############################################################
# Exploratory Data Analysis
#   Week 4 - Project
#
#  plot4.R script producing plot4.png
# 
# rm(list=ls())
# 
###############################################################
# Question 4
# Across the United States, how have emissions from coal 
# combustion-related sources changed from 1999-2008?
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

# get SCC codes that have both the words "coal" AND "comb"
# ---avoiding to use merge here since it will create an even 
# larger data set
coalcomb <- grepl("[Cc]oal", SCC$Short.Name) & 
    grepl("[Cc]omb", SCC$Short.Name)   

SCC$coalcomb <- coalcomb
codes <- SCC[SCC$coalcomb == TRUE, "SCC"]

# get data that have the SCC codes
coal <- NEI[NEI$SCC %in% codes,]

coal1999 <- coal[coal$year == "1999", c("fips","Emissions")]
coal2008 <- coal[coal$year == "2008", c("fips","Emissions")]


mn1999 <- with(coal1999, tapply(Emissions, fips, mean))
df1999 <- data.frame(fips=names(mn1999), mean=mn1999)
    
mn2008 <- with(coal2008, tapply(Emissions, fips, mean))
df2008 <- data.frame(fips=names(mn2008), mean=mn2008)

# alternate method - aggregate, merge, relabel
# aggregate(coal1999$Emissions, list(coal1999$fips), mean)
# aggregate(coal2008$Emissions, list(coal2008$fips), mean)


merged <- merge(df1999, df2008, by="fips", suffixes=c(1999,2008))
merged$change <- merged$mean1999 - merged$mean2008
dim(merged)[1] #2338 areas in total

# Areas that got worse 
inc <- merged[merged$change < 0,]
dim(inc)[1] #401 areas
dim(inc)[1]/dim(merged)[1] #0.1715 -> 17.15% of total


###############################################################
# output plot
###############################################################

png(filename = "plot4.png",width = 600, height = 480)

plot(rep(1999, dim(merged)[1]), merged$mean1999, xlim=c(1998,2009),
     ylim=c(0,4000), xlab="", ylab="", main="US Mean Emissions per Area") 
par(new=T)
plot(rep(2008, dim(merged)[1]), merged$mean2008, xlim=c(1998,2009),
     ylim=c(0,4000), xlab="Year", ylab="Emissions PM2.5") 
segments(rep(1999, dim(merged)[1]), merged$mean1999, 
         rep(2008, dim(merged)[1]), merged$mean2008, col="darkblue" )
segments(rep(1999, dim(inc)[1]), inc$mean1999, 
         rep(2008,dim(inc)[1]), inc$mean2008, col="red" )
par(new=F)

dev.off()























