Tidy-Data
Tidy Data programming example from Getting and Cleaning Data course


This analysis summarizes data originating from an experiment described in full 
at the following link: 
https://archive.ics.uci.edu/ml/datasets/human+activity+recognition+using+smartphones#. Full details of the oringal experiment can be found at the link cited above.

The orignal experiment involved motion measurements taken while various
activities were performed by 30 subjects. In this analysis, based on a subset of
the original data, we create a tidy data set and calculate the mean measurement 
value for each subject, activity and selected measurement.

This analysis is based on the principles of a tidy data set, as described by 
Hadley Wickham at the following link: 
https://vita.had.co.nz/papers/tidy-data.pdf.


Process description
The following process was used to conduct this analysis.

Preparation
1. The script retrieve_data.R is exectued to download and unzip the source dataset 
file:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
Unzipping stores the files in the data directory ./data/raw/UCI HAR Dataset. The analysis uses the following files:

        features.txt: List of all features (measuement names)
        activity_labels.txt: Links the class labels with their activity name.
        train/X_train.txt: Training set.
        train/y_train.txt: Training labels. (activity numbers)
        test/X_test.txt: Test set. (measurement names)
        test/y_test.txt: Test labels. (activity numbers)
        train/subject_train.txt: Each row identifies the subject who performed 
                the activity for each window sample. Its range is from 1 to 30.
All other files are ignored.


Analysis

The run_analysis script performs the following steps.
1. Merges the training and the test sets to create one data set. The source
subjects were assigned to a either a test or training group. As a first step, 
we create a single data set with both test and training data using the 
measurement, subject and activity files  (X_train, subject_train, y_train and
X_test, subject_test, y_test)

2. Extracts only the measurements on the mean and standard deviation for each 
measurement. The source file has a total of 561 measurements. For this analysis 
we are only concerned with the source measurements that represent mean and 
standard deviation, as identified with the strings "-mean()" and 
"-std()" in the measurement name. We subset our data using the feature names in 
the feature.txt file, selecting only those data columns for mean() and std() 
values. 

3. Uses descriptive activity names to name the activities in the data set. The 
name of each activity can be found by locating the activity number from our 
sample data in the activity_labels.txt file and retreiving the activity name
column. 

4. Appropriately labels the data set with descriptive variable names, using the
feature (measurement) names from the features.txt file.  This dataset has a
column for each subject and activity, followed by a column for each measurement.


5. From the data set in step 4, creates a second, independent tidy data set 
with the average of each variable for each activity and each subject.  Using the 
dataset created above, we merge the separate measurements into one colum 
containing the measurement values and add a column to indicate the measurement 
name and hen summarize using the mean for each measurement, subject and activity.
The final data set is stored in ./data/processed/tidyData.txt and can be read in 
using: 
read.table(file, header=TRUE). he resultant dataset is described in CodeBook.md.


Citations:
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. 
Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass 
Hardware-Friendly Support Vector Machine. International Workshop of Ambient 
Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

