## Exploratory Data Analysis
## Course Project 2
## plot2.R

library(dplyr)
library(RColorBrewer)


## Step 1 : Import data from RDS files
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

## Step 2 : Prepare the data in a vector that could be plotted with barplot()
baltimorepm25 <- filter(NEI,fips=="24510") 
totalemissions <- summarise(group_by(baltimorepm25,year),emissions=sum(Emissions))
totalemissionsvect <- totalemissions$emissions
names(totalemissionsvect) <- totalemissions$year
totalemissionsvect <- totalemissionsvect/1000

## Step 3 : Plot the data
par(mar=c(5,4,4,2)+0.1)

cols <- brewer.pal(9,"YlOrRd")
pal <- colorRampPalette(cols)
col <- rev(pal(9))

# Prepare the device
png(filename="plot2.png", width = 480, height = 480)

with(totalemissions, barplot(totalemissionsvect,main=expression("Total PM"[2.5]*" Emissions per year in Baltimore City(US)"),
                             col=col,xlab="Year",ylab="Emissions (thousand of tons)"),space=0)

# shut down the current device (png file)
dev.off()

