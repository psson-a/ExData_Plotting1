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

#png("plot4.png")

#plot 4: 4 different panels.
par(mfrow=c(2,2))
#plot1:
with(myData, plot(Global_active_power ~ as.POSIXct(timestamp), type='l', ylab="Global Active Power (kilowatts)", xlab=""))

#plot2:
with(myData, plot (Voltage ~ as.POSIXct(timestamp), type='l', xlab="datetime"))


#plot3:
with(myData, plot(Sub_metering_1 ~ as.POSIXct(timestamp), type='l', col="black", ylab="Energy sub metering", xlab=""))
with(myData, lines(Sub_metering_2 ~ as.POSIXct(timestamp), type='l', col="red", ylab="Energy sub metering", xlab=""))
with(myData, lines(Sub_metering_3 ~ as.POSIXct(timestamp), type='l', col="blue", ylab="Energy sub metering", xlab=""))
legend("topright", bty="n", lwd=1, col=c("black","red","blue"),legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#plot4
with(myData, plot (Global_reactive_power ~ as.POSIXct(timestamp), type='l', xlab="datetime"))


#dev.off()