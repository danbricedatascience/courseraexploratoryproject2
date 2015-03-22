## Exploratory Data Analysis
## Course Project 2
## plot4.R

library(dplyr)
library(RColorBrewer)
library(ggplot2)


## Step 1 : Import data from RDS files
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

## Step 2 : Prepare the data in a summary dataframe that could be plotted with ggplot2
## Confirmed by this document : www.state.nj.us/dep/aqm/es/scc.pdf , the column
## to consider in order to identify the emission source is the level Three
## They say : "The third level of description requires the first six digits 
## to be specified, and it identifies a specific industry or emission source category"
## So it could be a specific industry (case of Industrial process for instance)
## or a source category (like Coal)
## When looking at data more precisely, the combustion process appears to be part of 
## The level one
## So I filtered Combustion from LevelOne and Coal from Level Three
## Maybe a better filtering is possible and require more accurate data study
## 
## Note about the grepl : it's useless to use complex grep. After checking the data
## all the words starts by uppercase, so Coal always has "C" uppercase

coalsources <- filter(SCC,grepl("Coal",SCC.Level.Three) & grepl("Combustion",SCC.Level.One))

coalpm25 <- filter(NEI,SCC %in% coalsources$SCC)

totalemissions <- summarise(group_by(coalpm25,year),emissions=sum(Emissions))

## Step 3 : Plot the data in a single colored chart

# Prepare aestetic - convert the emissions in thousand of tons to make it more readable in the chart
g <- ggplot(totalemissions,aes(x=factor(year),y=emissions/1000,fill=emissions/1000)) 
# defines the geom
g <- g + geom_bar(stat="identity",position="dodge") 
# set the labels
g <- g + labs(list(x="Year",y="emissions (in thousands of tons)",fill="emissions",title=expression("PM"[2.5]*" Emissions from Coal Combustion Related Sources in US")))
# Set the colour scale
g <- g + scale_fill_gradientn(colours=c("#51B1F4","#183043"))

# Print the chart
# Prepare the device
png(filename="plot4.png", width = 480, height = 480)
g
# shut down the current device (png file)
dev.off()
