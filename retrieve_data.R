## This script retrieves and unzips the files needed for the Tidy Data Project
## for the first time. Additional details may be found in the README.txt file.

## Source file URL:
##      https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## Zip file is downloaded to:
##      ./data/raw/getdata_projectfiles_UCI HAR Dataset.zip
## Files are unziped into the ./data/raw directory

## define file URLs and file paths
dataFileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataDir <- "./data/raw"
dataFile <- paste(dataDir,"/getdata_projectfiles_UCI HAR Dataset.zip", sep = "")

## check data directory, create data directory if it doesn't exist
if (!file.exists("data/raw")) {
        dir.create("data/raw", recursive = TRUE)
}

## If the data hasn't been download, download and unzip it
if(!file.exists(dataFile)) {
        download.file(dataFileURL, dataFile)
        unzip(dataFile, exdir = dataDir)
}
