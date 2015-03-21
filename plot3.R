## Exploratory Data Analysis
## Course Project 2
## plot3.R

library(dplyr)
library(RColorBrewer)
library(ggplot2)


## Step 1 : Import data from RDS files
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

## Step 2 : Prepare the data in a summary dataframe that could be plotted with ggplot2
baltimorepm25 <- filter(NEI,fips=="24510") 
totalemissions <- summarise(group_by(baltimorepm25,year,type),emissions=sum(Emissions))

## Step 3 : Plot the data in a single colored chart

# Prepare aestetic
g <- ggplot(totalemissions,aes(x=factor(type),y=emissions,fill=factor(year))) 
# defines the geom
g <- g + geom_bar(stat="identity",position="dodge") 
# set the labels
g <- g + labs(list(x="Type",y="emissions (in tons)",fill="Year",title=expression("PM"[2.5]*" Emissions in Baltimore City (US)")))
# Print the chart
g

