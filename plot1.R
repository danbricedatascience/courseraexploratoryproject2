## Exploratory Data Analysis
## Course Project 2
## plot1.R

library(dplyr)
library(RColorBrewer)


## Step 1 : Import data from RDS files
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

## Step 2 : Prepare the data in a vector that could be plotted with barplot()
totalemissions <- summarise(group_by(NEI,year),emissions=sum(Emissions))
totalemissionsvect <- totalemissions$emissions
names(totalemissionsvect) <- totalemissions$year
totalemissionsvect <- totalemissionsvect/1000000

## Step 3 : Plot the data
par(mar=c(5,4,4,2)+0.1)

cols <- brewer.pal(9,"YlOrRd")
pal <- colorRampPalette(cols)
col <- rev(pal(9))

with(totalemissions, barplot(totalemissionsvect,main=expression("Total PM"[2.5]*" Emissions per year in US"),
                             col=col,xlab="Year",ylab="Emissions (million of tons)"),space=0)



