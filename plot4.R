#---------------------------------------------------------------------------------------------------------------
## Exploratory Data Analysis: Course Project 1 (plot 4)

# The code in this .R file generates time-series plots in four panels showing:
#  1. Global Active Power
#  2. Voltage
#  3. Energy sub metering i, where i=1,2,3.
#  4. Global reactive power
#---------------------------------------------------------------------------------------------------------------

#========================================  1. READING IN THE DATA  ==================================================
# The data: we use a data set showing the individual household electric power consumption made available from
# the UC Irvine Machine Learning Repository. The following piece of code downloads the data available in .zip format
# and extracts the files.
wd <- dirname(sys.frame(1)$ofile)
setwd(dir = wd)

fileurl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists("./data.zip")){
  download.file(fileurl, destfile = "./data.zip", method = "curl")
}
unzip("./data.zip")

# Here, we ask the user to enter the name of the file containing the data and add the extension .txt if one is not
# provided.

filecsv <- readline("Enter the name of the file containing the data: ")
if(file_ext(filecsv) == ""){
  filecsv<-paste(filecsv, ".txt", sep="")
}

if(!file.exists(filecsv)){
  filecsv <- readline("File does not exist. Please enter the name of the file containing the data: ")
  if(file_ext(filecsv) == ""){
    filecsv<-paste(filecsv, ".txt", sep="")
  }
}

# Prior to analyzing the data, we read in a few lines to look at the data structure as well as
# column names and classes.
testdf<-read.csv(filecsv, header = TRUE, nrows = 10, sep=';', na.strings = "?")
colnams<-names(testdf)

# Estimated memory required based on 8 bytes/numeric.
MBsrequired<-9*2075259*8*1e-6 

# As we are interested in looking at observations recorded between 2007-2-1 and 2007-2-2, we use the read.csv.sql
# command from the {sqldf} library to select rows corresponding to the aforementioned dates.

library(sqldf)
df<-read.csv.sql(filecsv, header = TRUE,
             sep=';', sql='select * from file where Date="1/2/2007" or Date="2/2/2007"')
closeAllConnections()

# Date and time coversions from "factor"
df$Date<-as.Date(df$Date, format = "%d/%m/%Y")

df$datetime <- strptime(paste(df$Date, df$Time), "%Y-%m-%d %H:%M:%S") # to combine Date & Time in 1 column

#========================================  2. CREATING PLOT 4  ================================================

# The following creates time series plots for the variables mentioned above in a four-panel plot.
png(filename="plot4.png", width = 480, height = 480)
attach(df)
# Set parameter for four-panel plot:
par(mfrow=c(2,2))
# Panel 1
plot(datetime, Global_active_power, type="l", xlab="", ylab="Global Active Power")
#Panel 2
plot(datetime, Voltage, type="l", ylab="Voltage")
# Panel 3
plot(datetime, Sub_metering_1, type="l", xlab="" ,ylab="Energy sub metering")
lines(datetime, Sub_metering_2, type="l", col = "red")
lines(datetime, Sub_metering_3, type="l", col = "blue")
# The legend command is used to include a legend to our plot.
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black","red","blue"),
       lwd = 1, bty = "n")
#Panel 4
plot(datetime, Global_reactive_power, type="l")

dev.off()

