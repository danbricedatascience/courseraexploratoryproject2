## Exploratory Data Analysis
## Course Project 2
## plot6.R

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

motorvehiclespm25 <- filter(NEI,SCC %in% motorvehiclesources$SCC & (fips == "24510" | fips == "06037" ))

totalemissions <- summarise(group_by(motorvehiclespm25,year,fips),emissions=sum(Emissions))

place <- data.frame(fips=c("24510","06037"),place=c("Baltimore City","Los Angeles County"),stringsAsFactors=FALSE)

totalemissions <- left_join(totalemissions,place,by="fips")

## Step 3 : Create a relative emission level column, with 100 as the base index for 1999
## This allows comparing these two places despites the huge emission level differences

## ASSUME 100 AS THE BASE INDEX IN 1999
## Initialize the index column to 100 for every years
totalemissions <- mutate(totalemissions,index=100)

# Calculate the variations from the 100 reference of 1999
# The lapply returns two separate dataframe
totalemissions <- lapply(split(totalemissions,totalemissions$place),
                         function(x) {ref100 <- x[x$year==1999,]$emissions
                                      x$index = ifelse(x$year==1999,
                                      100,
                                      100 + 100*(x$emissions - ref100)/ref100
                                      )
                                      x}
                         )

# merge the two splited data frame into a single one
totalemissions <- do.call("rbind",totalemissions)

## So the result is the following:
## year  fips  emissions              place     index
## 1 1999 24510  346.82000     Baltimore City 100.00000
## 2 2002 24510  134.30882     Baltimore City  38.72580
## 3 2005 24510  130.43038     Baltimore City  37.60751
## 4 2008 24510   88.27546     Baltimore City  25.45282
## 5 1999 06037 3931.12000 Los Angeles County 100.00000
## 6 2002 06037 4274.03020 Los Angeles County 108.72296
## 7 2005 06037 4601.41493 Los Angeles County 117.05099
## 8 2008 06037 4101.32100 Los Angeles County 104.32958

## Step 3 : Plot the data in a single colored chart
# Prepare aestetic
g <- ggplot(totalemissions,aes(x=factor(year),y=index,group=place,colour=factor(place))) 
# defines the geom
g <- g + geom_line(size=2) + geom_point(size=6)
# set the labels
g <- g + labs(list(x="Year",y="emissions base 100 index changes since 1999",colour="index",title=expression("Base 100 comparison of PM"[2.5]*" Emissions from Motor Vehicle between Baltimore City and LA County")))

# Print the chart
# Prepare the device
png(filename="plot6.png", width = 800, height = 480)
g
# shut down the current device (png file)
dev.off()
