# R script for quiz 2 - Getting and Cleaning Data
#set working directory
setwd("./Documents/Coursera/datascience_jh/getclean/getclean/quizzes")

# Question 1 
# Register an application with the Github API here 
# https://github.com/settings/applications. Access the API to get information
# on your instructors repositories 
# (hint: this is the url you want "https://api.github.com/users/jtleek/repos"). 
# Use this data to find the time that the datasharing repo was created. 
# What time was it created?

# Don't run from RStudiohave to run from R command line
install.packages("httr ")
install.packages("httpuv")
install.packages("jsonlite")

# From Hadley Wickham's tutorial on Github oauth found at:
# https://github.com/hadley/httr/blob/master/demo/oauth2-github.r
# *** Begin Code
# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. Register an application at https://github.com/settings/applications
#    Insert your values below - if secret is omitted, it will look it up in
#    the GITHUB_CONSUMER_SECRET environmental variable.
#
#    Use http://localhost:1410 as the callback url
myapp <- oauth_app("github", "56b637a5baffac62cad9", "secret")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
req <- GET("https://api.github.com/rate_limit", config(token = github_token))
stop_for_status(req)
# use jsonlite package to parse content returned
json1 = content(req)

json2 = jsonlite::fromJSON(toJSON(json1))
# get names of columns
names(json2)
#filter to get created date
json2$created_at[json2$name == "datasharing"]

# Questions 2 and 3
# Download American Community Survey data

# set url
furl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
fname <- "acs.csv"
download.file(furl, fname, method = "curl" )
# load file
acs <- read.csv(fname, sep = ",",header = TRUE ) 
install.packages("sqldf")
library(sqldf)
# Which of the following commands will select 
# only the data for the probability weights pwgtp1 with ages less than 50?
# sqldf("select * from acs")
# sqldf("select pwgtp1 from acs where AGEP < 50") *** Correct Answer
# sqldf("select * from acs where AGEP < 50 and pwgtp1")
# sqldf("select * from acs where AGEP < 50")

# what is the equivalent function to unique(acs$AGEP)
# sqldf("select distinct AGEP from acs") *** Correct Answer
# sqldf("select unique AGEP from acs")
# sqldf("select AGEP where unique from acs")
# sqldf("select distinct pwgtp1 from acs")

# Question 4
# Download HTML file
library(XML)
# set connection object
conn = url("http://biostat.jhsph.edu/~jleek/contact.html")

# How many characters are in the 10th, 20th, 30th and 100th lines of HTML
# use readLines to read the maximal number of lines
# this will return a character vector
x <- readLines(conn, 100)
# get the character counts for the line numbers needed
nchar(x[10]) # = 45
nchar(x[20]) # = 31
nchar(x[30]) # =  2
nchar(x[100]) # = 25

# Question 5
# Download fixed width file
# set url
furl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
fname <- "noaa.for"
download.file(furl, fname, method = "curl" )
# for reading fixed width files use function read.fwf
# specify field widths as a integer vector
# first 4 lines of the file do not have data
x <- read.fwf(fname, skip = 4, widths = c(12, 7, 4, 9, 4, 9, 4, 9, 4))
# report the sum of the numbers in the fourth column
sum(x$V4)
