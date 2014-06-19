# R script for quiz 3 - Getting and Cleaning Data
# Download American Community Survey 2006 microdata survey 
# about housing for the state of Idaho

#set working directory
setwd("./Documents/Coursera/datascience_jh/getclean/getclean/quizzes")

# download csv file for Ques 1
# set url
furl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
fname <- "2006IdahoHousing.csv"
download.file(furl, fname, method = "curl" )
# check if file downloaded
fdir <- getwd()
if (file.exists(fname)) {
    # load file
    htbl <- read.csv(fname, sep = ",",header = TRUE ) 
    # Create a logical vector that identifies households on greater 
    # than 10 acres who sold more  than $10,000 worth of agriculture products.
    # Assign vector agricultureLogical
    agricultureLogical <- subset(htbl, [(htbl$ACR == 3 & htbl$AGS == 6), ]
    
    
    # Refer to code book to find the column name and value to filter
    # Code 24 for column VAL is $1000000+