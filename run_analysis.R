## Reference article
##      http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## data file: 
##      https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## This scripts assumes that the data have already been downloaded.  If not the
## script retrieve_data.R can be run to retrieve and unzip the files.

## This script will use the following files from the ./data/raw directory:
## - features.txt': List of all features.
## - activity_labels.txt': Links the class labels with their activity name.
## - train/X_train.txt': Training set.
## - train/y_train.txt': Training labels.
## - test/X_test.txt': Test set.
## - test/y_test.txt': Test labels.
## - train/subject_train.txt': Each row identifies the subject who performed 
##      the activity for each window sample. Its range is from 1 to 30.
## All other files are ignored.

## This script does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for 
##      each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set 
##      with the average of each variable for each activity and each subject.
   
## ---------------------------------------------------------------------------
## Set up needed libraries
library(readr)
library(dplyr)
library(tidyr)

## ---------------------------------------------------------------------------
## 0. Prep 
## a. define file paths
dataDir <- "./data/raw/UCI HAR Dataset"
processedDataDir <- "./data/processed/"

## verify that the output directory exists, if not, create it
if (!file.exists("data/processed")) {
        dir.create("data/processed", recursive = TRUE)
}

## ---------------------------------------------------------------------------
## 1. Merge the training and the test sets to create one data set.
## a. training data set
train <- read_table(paste(dataDir,"/train/X_train.txt", sep=""),
                col_names = FALSE) %>%
        mutate(read_table(paste(dataDir,"/train/subject_train.txt", sep=""),
                col_names = "subject")) %>%
        mutate(read_table(paste(dataDir,"/train/y_train.txt", sep=""),
                col_names = "activitynumber"))

## b. test data set
test <- read_table(paste(dataDir,"/test/X_test.txt", sep=""),  
                col_names = FALSE) %>%
        mutate(read_table(paste(dataDir,"/test/subject_test.txt", sep=""),
                col_names = "subject")) %>%
        mutate(read_table(paste(dataDir,"/test/y_test.txt", sep=""),
                col_names = "activitynumber"))

## c. merge test and train together
obsData <- rbind(test, train)

## ---------------------------------------------------------------------------
## 2. Extract only the measurements on the mean and standard deviation for 
##      each measurement.
## a. read in the feature names
feature <- read_table2(paste(dataDir,"/features.txt",sep=""),comment="",
                col_names = c("num","name"))

## b. define an index of column names for mean() and std() functions
index <- grep("-mean\\(\\)|-std\\(\\)",feature$name)

## c. filter for the values for mean and std function values
obsData <- select(obsData, names(obsData[index]), subject, activitynumber)

## ---------------------------------------------------------------------------
## 3. Use descriptive activity names to name the activities in the data set
## a. read in the activity labels
activityLabels <- read_table(paste(dataDir,"/activity_labels.txt", sep=""), 
                col_names = c("activitynumber","activity"))

## b. merge activity labels with obsData, then drop the activity number and
##      reorder the columns and drop the activity number
obsData <- left_join(obsData, activityLabels)  %>%
        select(subject, activity, everything(), -activitynumber)

## ---------------------------------------------------------------------------
## 4. Appropriately label the data set with descriptive variable names.
## a. apply the column names
names(obsData) <- c(names(obsData)[1:2], feature$name[index])
        
## ---------------------------------------------------------------------------
## 5. From the data set in step 4, create a second, independent tidy data set 
##      with the average of each variable for each activity and each subject.
## a. Pivot the measurement columns into rows, which will leave a tall 
##      dataset with columns subject, activity, measure and value.  
## b. Group this by subject and activity
## c. Summarize by the average for each measurement variable.
## d. Output the resultant dataset to ./data/processed/tidyData
tidyData <- obsData %>%
        pivot_longer(!(subject | activity), names_to = "measurement", 
                values_to = "value") %>%
        group_by(subject, activity, measurement)  %>%
        summarize(average = mean(value))

write.table(tidyData, paste(processedDataDir, "tidy data.txt", sep=""), 
        row.name = FALSE)
