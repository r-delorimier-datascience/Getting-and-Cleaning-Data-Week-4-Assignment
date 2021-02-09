## Author: Robert de Lorimier
## Intro
# Script to combine accelerometer data from train and test folders. This includes:
## Run with source("run_analysis.R", echo=TRUE)
## Tranformation Steps
# 1. Download and extract data
# 2. Combine subject column data, subject_train.txt and subject_test.txt, via rbind
# 3. Combine activity column id data, y_train.txt and y_test.txt, via rbind
# 4. Create activity name column from activity_labels.txt via lookup and activity column id data
# 5. Combine subject and activity columns using cbind
# 6. Create columns names datatable with indexes and filter by standard deviation and means columns
# 7. Format column names to be more readable
# 8. Combine feature result data, X_train.txt and X_test.txt, via rbind
# 9. Filter only standard deviation and mean columns from feature result data
# 10. Add column names to feature result data
# 11. Add activity name column and subject column to feature result data
# 12. Aggregate feature result data by subject and activity, and order
# 13. Write out tidy dataset.

# STEP 0, LOAD LIBRARIES AND VARIABLES

## LIBRARIES
library(RCurl)
library(data.table)
library(dplyr)

# GET THE DATA

## STEP 1A, CREATE LOCATION AND DOWNLOAD THE FILE

if(!file.exists("./data")) {
  dir.create("./data")
}
download.file( "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="./data/dataset.zip", method="curl")

## STEP 1B, UNZIP THE FILE

unzip(zipfile="./data/dataset.zip", exdir="./data")

# CONSTUCT THE DATA SETS

## STEP 2, CONSTRUCT SUBJECT COLUMN DATATABLES AND COMBINE

train_subject_table <- fread("./data/UCI HAR Dataset/train/subject_train.txt")
test_subject_table <- fread("./data/UCI HAR Dataset/test/subject_test.txt")
subject_table <- rbind(train_subject_table, test_subject_table)
names(subject_table) <- c("Subject")

## STEP 3, CONSTRUCT COMBINED ACTIVITY ID COLUMN DATATABLES AND COMBINE

train_activity_table <- fread("./data/UCI HAR Dataset/train/y_train.txt")
test_activity_table <- fread("./data/UCI HAR Dataset/test/y_test.txt")
activity_id_column_table <- rbind(train_activity_table, test_activity_table)
names(activity_id_column_table) <- c("activity_id")

## STEP 4, CREATE COMBINED ACTIVITY NAME COLUMN FROM ACTIVITY ID COLUMN WITH LOOKUP

activity_table <- activity_id_column_table
activity_labels_set <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
activity_table$Activity <- activity_labels_set[activity_table$activity_id]
activity_table$activity_id = NULL

## STEP 5, COMBINE ACTIVITY NAME AND SUBJECT COLUMNS

subject_activity_col_set_table <- cbind(subject_table, activity_table)

## STEP 6, CONTRUCT COLUMN NAMES DATA TABLE FOR FEATURE RESULT SET DATATABLE AND FILTER STANDARD DEVIATON AND MEAN

result_columns_table <- fread("./data/UCI HAR Dataset/features.txt")
names(result_columns_table) <- c("column_id", "column_name")
filtered_result_columns_table <- result_columns_table[grep("ean|std", result_columns_table$column_name)]

## STEP 7, FORMAT FILTERED COLUMN NAMES

feature_column_names <- filtered_result_columns_table$column_name
feature_column_names <-gsub("^t", "Time ", feature_column_names)
feature_column_names <-gsub("^f", "Frequency ", feature_column_names)
feature_column_names <-gsub("Acc", " Acceleration", feature_column_names)
feature_column_names <-gsub("Gyro", " Gyroscope", feature_column_names)
feature_column_names <-gsub("Mag", " Magnitude", feature_column_names)
feature_column_names <-gsub("BodyBody", " Body", feature_column_names)
feature_column_names <-gsub("std", " Standard Deviation", feature_column_names)
feature_column_names <-gsub("[mM]ean", " Mean", feature_column_names)
feature_column_names <-gsub("Jerk", " Jerk", feature_column_names)
feature_column_names <-gsub("gravity", " Gravity ", feature_column_names)
feature_column_names <-gsub("angle", " Angle", feature_column_names)
feature_column_names <-gsub("tBody", " Time Body", feature_column_names)
feature_column_names <-gsub("Freq\\(\\)", " Frequency", feature_column_names)
feature_column_names <-gsub(" ", " ", feature_column_names)
feature_column_names <-gsub("\\(\\)", "", feature_column_names)
feature_column_names <-gsub("\\(", " ", feature_column_names)
feature_column_names <-gsub("\\)", " ", feature_column_names)
feature_column_names <-gsub("-", " ", feature_column_names)

feature_column_names <-gsub("Body", " ", feature_column_names)

feature_column_names <-gsub("[ ]+", " ", feature_column_names)
feature_column_names <-gsub("[ ]+$", "", feature_column_names)
feature_column_names <-gsub("^[ ]+", "", feature_column_names)
feature_column_names <-gsub(",", "", feature_column_names)
feature_column_names <-gsub("[ ]+", "_", feature_column_names)
feature_column_names <- make.names(feature_column_names, unique = TRUE, allow_ = FALSE)

## STEP 8, CONTRUCT COMBINED FEATURE RESULT SET DATATABLE

train_result_table <- fread("./data/UCI HAR Dataset/train/X_train.txt")
test_result_table <- fread("./data/UCI HAR Dataset/test/X_test.txt")
feature_table <- rbind(train_result_table, test_result_table)

## STEP 9, FILTER FEATURE RESULT SET BY ONLY NEEDED COLUMNS

index_cols <- unlist(filtered_result_columns_table$column_id)
feature_table <- feature_table %>% select(all_of(index_cols))

## STEP 10, ADD COLUMN NAMES TO FEATURE SET

data_set_table <- feature_table
names(data_set_table) <- feature_column_names

## STEP 11, ADD SUBJECT AND ACTIVITIES TO FEATURE SET

data_set_table <- cbind(subject_activity_col_set_table, data_set_table)
data_set_table <- data_set_table[order(Subject, Activity)]

## UNAGGREGATED DATA TEST

write.table(data_set_table, file = "unaggredated_tidydata.txt", row.name=FALSE, sep="\t")

## STEP 12, AGGREGATE THE FEATURE SET BY SUBJECT AND ACTIVITY

tidy_set_table <- aggregate(.~Subject+Activity, data_set_table, mean)
tidy_set_table <- tidy_set_table[order(tidy_set_table$Subject,tidy_set_table$Activity),]

## STEP 13, WRITE THE TIDY DATA SET

write.table(tidy_set_table, file = "tidydata.txt", row.names=FALSE, sep="\t")
