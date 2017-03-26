###############################################################
# Exploratory Data Analysis
#   Week 4 - Project
#
#  plot6.R script producing plot6.png
# 
# rm(list=ls())
# 
###############################################################
# Question 6
# Compare emissions from motor vehicle sources in Baltimore 
# City with emissions from motor vehicle sources in Los Angeles 
# County, California (fips == "06037"). Which city has seen 
# greater changes over time in motor vehicle emissions?
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
vehi <- NEI[NEI$SCC %in% codes & (NEI$fips=="24510"| NEI$fips=="06037"),]


###############################################################
# output plot
###############################################################

label <- c("06037"="Los Angeles County", "24510"="Baltimore City")

png(filename = "plot6.png",width = 600, height = 480)

ggplot(vehi, aes(year,log10(Emissions)) ) +
    geom_point() +
    geom_smooth(method="lm",color="red") +
    facet_grid(.~fips, labeller=labeller(fips=label)) +
    ylab("Emissions (log10)") +
    labs(title="Baltimore City vs LA county - Motor Vehicle Emission")

dev.off()

