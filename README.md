---
title: "Course Project For Coursera Class, Getting and Cleaning Data  "
author: "Robert de Lorimier"
date: "02/07/2021"
---

# Overview

The data has been unified for a "tidy" data set, and contains the standard deviation and means values for the accelerometer feature measurements, aggregated by subject and activity. The original data was collect for "Human Activity Recognition Using Smartphones Dataset", collected by www.srmartlab.ws. A copy of the data used is found in folder sample_data. See "Original Description" below for more details, extracted from "sample_data/getdata_projectfiles_UCI_HAR_Dataset/UCI HAR Dataset/README.txt"

## References

- Source Data Set: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
- Explanation of Data: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphone

# Data Creation and Replication

Below is a description of how to run the script that will create the data set, and also a description of the logical steps used to 

## Data Creation Steps

### Tidy Data Creation Prerequisites

In order to run the script that create the tidy data set, these libraries need to be installed in R:

- RCurl
- data.table
- dplyr

### Running the Script

This project includes an R script called run_analysis.R that is a script used to create the tidy datasets. From the project folder in the R command prompt, run:

```source("run_analysis.R")```

This will create the file tidydata.txt.
  
## Data Creation Explanation

The creation of the data set goes through several transformation operations to create the final set. These set of steps illustrate what operations are performed:

1. Download and extract data from remote site.
2. Combine subject column data, subject_train.txt and subject_test.txt, via rbind.
3. Combine activity column id data, y_train.txt and y_test.txt, via rbind.
4. Create activity name column from activity_labels.txt via lookup and activity column id data.
5. Combine subject and activity columns using cbind.
6. Create columns names datatable with indexes and filter by standard deviation and means columns.
7. Format column names to be more readable.
8. Combine feature result data, X_train.txt and X_test.txt, via rbind.
9. Filter only standard deviation and mean columns from feature result data.
10. Add column names to feature result data.
11. Add activity name column and subject column to feature result data.
12. Aggregate feature result data by subject and activity, and order.
13. Write out tidy dataset, tidydata.txt

## Background

An extract from the authors of the original data set, found in "sample_data/getdata_projectfiles_UCI_HAR_Dataset/UCI HAR Dataset/README.txt":

> The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

> The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

> - Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
> - Triaxial Angular velocity from the gyroscope. 
> - A 561-feature vector with time and frequency domain variables. 
> - Its activity label. 
> - An identifier of the subject who carried out the experiment.
...
> - Features are normalized and bounded within [-1,1].

An extract from the authors about the features, found in "sample_data/getdata_projectfiles_UCI_HAR_Dataset/UCI HAR Dataset/features_info.txt":

> The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

> Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

> Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

> These signals were used to estimate variables of the feature vector for each pattern:  
> '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

## License:

This original data set was used in this publication:

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
