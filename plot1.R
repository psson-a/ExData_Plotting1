#read data, it's quite big so try to speed it up by predetermining column classes

#first, find out column names and classes
myData <- read.table("household_power_consumption.txt", nrows=5, header=TRUE, sep=';', na.strings='?')
cclasses <- vapply(myData, class, "character")
cnames <- colnames(myData)

#then, find out which rows are in the timeframe we want
just_date <- c("character", rep("NULL",8))
myData <- read.table("household_power_consumption.txt", header=TRUE, sep=';', na.strings='?', colClasses = just_date)
myData$converted_date <- as.Date(myData$Date, format="%d/%m/%Y")
startdate <- as.Date("2007-02-01")
stopdate <- as.Date("2007-02-02")
selected <- myData[(myData$converted_date >= startdate) & (myData$converted_date <=stopdate),]

myData <- read.table("household_power_consumption.txt", nrows=2880, skip=66637, sep=';', colClasses=cclasses, col.names=cnames)
# 2007-02-01 and 2007-02-02. (february)