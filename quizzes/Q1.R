# R script for quiz 1 - Getting and Cleaning Data
# Download American Community Survey 2006 microdata survey 
# about housing for the state of Idaho

#set working directory
setwd("./Documents/Coursera/datascience_jh/getclean/getclean/quizzes")
# download csv file
# set url
furl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
fname <- "2006IdahoHousing.csv"
download.file(furl, fname, method = "curl" )
# check if file downloaded
fdir <- getwd()
if (file.exists(fname)) {
    stop("file exists")
} else {
    stop("file does not exist")
}