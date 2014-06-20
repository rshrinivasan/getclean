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
    agricultureLogical <- htbl$ACR == 3 & htbl$AGS == 6
# Q1 Apply the which() function like this to identify the rows 
# of the data frame where the logical vector is TRUE. which(agricultureLogical) 
# What are the first 3 values that result?
    which(agricultureLogical) # Ans. 125, 238, 262

# download jpeg file for Ques 2

# set url
furl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
fname <- "instructor.jpeg"
download.file(furl, fname, method = "curl"  )
# install and load package jpeg
install.packages("jpeg")
library(jpeg)
# read jpg file into a raster array
arr <- readJPEG(fname, native = TRUE)
# What are the 30th and 80th quantiles of the resulting data?
quantile(arr, probs = c(0.3, 0.8)) # Ans -15259150 -10575416
