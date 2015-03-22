## Exploratory Data Analysis
## Course Project 2
## plot5.R

library(dplyr)
library(RColorBrewer)
library(ggplot2)


## Step 1 : Import data from RDS files
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

## Step 2 : Prepare the data in a summary dataframe that could be plotted with ggplot2
## I filtered Mobile Sources from Level One and Vehicle from Sector
## It allows including Motorcycle, cars, truck ans buses while excluding
## some mobile sources that are not vehicles (like some dust engine)
## Maybe a better filtering is possible and require more accurate data study

motorvehiclesources <- filter(SCC,SCC.Level.One=="Mobile Sources" & grepl("Vehicles",EI.Sector))

motorvehiclespm25 <- filter(NEI,SCC %in% motorvehiclesources$SCC & fips == "24510")

totalemissions <- summarise(group_by(motorvehiclespm25,year),emissions=sum(Emissions))

## Step 3 : Plot the data in a single colored chart

# Prepare aestetic
g <- ggplot(totalemissions,aes(x=factor(year),y=emissions,fill=emissions)) 
# defines the geom
g <- g + geom_bar(stat="identity",position="dodge") 
# set the labels
g <- g + labs(list(x="Year",y="emissions (in tons)",fill="emissions",title=expression("PM"[2.5]*" Emissions from Motor Vehicles in Baltimore City (US)")))
# Set the colour scale
g <- g + scale_fill_gradientn(colours=c("#51B1F4","#183043"))

# Print the chart
# Prepare the device
png(filename="plot5.png", width = 480, height = 480)
g
# shut down the current device (png file)
dev.off()
