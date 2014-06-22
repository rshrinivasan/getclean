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

# download csv file for Quest 3, 4, 5
# download GDP data first and then education data
furl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
fname <- "GDP.csv"
download.file(furl, fname, method = "curl" )
# load data
gdp <- read.table(fname, sep = ",",header = TRUE, encoding ="UTF-8" )

# download education file
edurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
edfname <- "educ.csv"
download.file(edurl, edfname, method = "curl")

# load education file
educ <- read.csv(edfname, sep =",", header = TRUE)

# Match the data based on the country shortcode.
# How many of the IDs match? Sort the data frame in descending order by GDP rank
# (so United States is last). What is the 13th country in the resulting data frame? 
# use sqldf
library(sqldf)
# filter out NAs in Ranking by using is not null clause
res <- sqldf("select gdp.Ranking, gdp.Economy from   gdp, educ 
            where gdp.Country = educ.CountryCode and gdp.Ranking is not null 
            order by gdp.Ranking desc")
# Ans: 189, St.Kitts and Nevis

# Q4 What is the average GDP ranking 
# for the "High income: OECD" and "High income: nonOECD" group?
#### Caution: sqldf does not link column names to have a period in them
# rename Income.Group column first
names(educ) <- sub("^Income.Group", "IncomeGroup", names(educ))
avgrank <- sqldf("select educ.IncomeGroup, avg(gdp.Ranking) from   gdp, educ 
                 where gdp.Country = educ.CountryCode and gdp.Ranking is not null
                 group by educ.IncomeGroup")
# Ans: 32.96667, 91.91304

# Q5 Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. 
# How many countries are Lower middle income but among the 38 nations with highest GDP?
res5 <- sqldf("select gdp.Ranking, gdp.Economy, educ.IncomeGroup from   gdp, educ 
            where gdp.Country = educ.CountryCode and gdp.Ranking is not null 
            order by gdp.Ranking")
# Use the cut2 function in the Hmisc package
install.packages("Hmisc")
library(Hmisc)
# use cut2 to group data into 5 quantile groups
res5$RankingGrp <- cut2(res5$Ranking, g = 5)
# use table to cross-tabulate the quantile against the Income Group
table(res5$RankingGroup, res5$IncomeGroup) # Ans: 5
