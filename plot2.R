#read data, it's quite big so try to speed it up and save memory by
#predetermining column classes and reading the full data just in the requested
#timerange

#first, find out column names and classes
myData <- read.table("household_power_consumption.txt", nrows=5, header=TRUE, 
                     sep=';', na.strings='?')
cclasses <- vapply(myData, class, "character")
cnames <- colnames(myData)

#then, find out which rows are in the timeframe we want
just_date <- c("character", rep("NULL",length(cnames)-1))
myData <- read.table("household_power_consumption.txt", header=TRUE, sep=';', 
                     na.strings='?', colClasses = just_date)
myData$converted_date <- as.Date(myData$Date, format="%d/%m/%Y")
startdate <- as.Date("2007-02-01")
stopdate <- as.Date("2007-02-02")
selected <- myData[(myData$converted_date >= startdate) & (myData$converted_date <=stopdate),]

startrow<-as.numeric(rownames(head(selected, 1)))
stoprow <- as.numeric(rownames(tail(selected, 1)))

#read actual data
# we don't use header=TRUE this time so we can skip startrows unmodified.
#for nrows, we need to add one to reach the correct number
myData <- read.table("household_power_consumption.txt", nrows=(stoprow-startrow+1),
                     skip=startrow, sep=';', colClasses=cclasses, col.names=cnames)
myData$timestamp <- strptime(paste(myData$Date, myData$Time, sep=","), 
                             format="%d/%m/%Y,%H:%M:%S")

png("plot2.png")
#plot 2
with(myData, plot(Global_active_power ~ as.POSIXct(timestamp), type='l', ylab="Global Active Power (kilowatts)", xlab=""))
dev.off()