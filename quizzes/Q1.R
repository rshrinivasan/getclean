# R script for quiz 1 - Getting and Cleaning Data
# Download American Community Survey 2006 microdata survey 
# about housing for the state of Idaho

#set working directory
setwd("./Documents/Coursera/datascience_jh/getclean/getclean/quizzes")

# download csv file for Ques 1 and 2
# set url
furl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
fname <- "2006IdahoHousing.csv"
download.file(furl, fname, method = "curl" )
# check if file downloaded
fdir <- getwd()
if (file.exists(fname)) {
    # load file
    htbl <- read.csv(fname, sep = ",",header = TRUE ) 
    #Ques 1: How many housing units in this survey were worth more than $1,000,000?
    # Refer to code book to find the column name and value to filter
    # Code 24 for column VAL is $1000000+
    nrow(x <- subset(htbl, VAL == 24))
} else {
    stop("file does not exist")
}

# download Natural Gas Aquisition Program XLS file for Ques 1 and 2
furl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
fname <- "ng.xlsx"
download.file(furl, fname, method = "curl" )
# install and load package xlsx
install.packages("xlsx")
library(xlsx) # package rJava not installing

# download XML data on Baltimore restaurants for Ques 4
furl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
fname <- "baltrestaurants.xml"
download.file(furl, fname, method = "curl" )
# install XML package
install.packages("XML")
library(XML)
# parse XML file
xmldoc <- xmlTreeParse(fname, useInternal = TRUE)
# How many restaurants have zipcode 21231?
# get doc root
docroot <- xmlRoot(xmldoc)
names(docroot)
# filter for the element zipcode
x <- xpathSApply(docroot,"//zipcode",xmlValue)
# count number of elements with zipcode == 21231
# numbers == x creates a logical vector which is TRUE at every location that x occurs,
# and when suming, the logical vector is coerced to numeric which converts TRUE to 1 
# and FALSE to 0.
# src: http://stackoverflow.com/questions/1923273/counting-the-number-of-elements-with-the-values-of-x-in-a-vector
# x is a character vector
sum(x == "21231")
# check to see if the answer could be returned without using the vector

# download the 2006 microdata survey about housing for the state of Idaho for Ques 5
furl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
fname <- "2006IdahoQ5.csv"
download.file(furl, fname, method = "curl" )
# use fread() to load the data, needs data.table library
library(data.table)
DT <- fread(fname)
system.time(mean(DT$pwgtp15,by=DT$SEX)) # does not give mean by SEX
system.time(rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]) #errors out
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean)) # has the same time as option 5
system.time(mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)) # errors out on system.time
system.time(tapply(DT$pwgtp15,DT$SEX,mean)) # has the same time as option 3
system.time(DT[,mean(pwgtp15),by=SEX]) -- seems to be slowest

# As option 3 & 5 seem to have the run time for a single execution
# loop through a large enough number of iterations to check performance
# Use the following code to check performance
trial_size <- 1000
collected_results <- numeric(trial_size)
for (i in 1:trial_size){
    single_function_time <- system.time(DT[,mean(pwgtp15),by=SEX])
    collected_results[i] <- single_function_time[1] #user time
}
print(sum(collected_results))
# Option -3: 0.782
# Option - 4: 1.251
# Option - 5: 1.276