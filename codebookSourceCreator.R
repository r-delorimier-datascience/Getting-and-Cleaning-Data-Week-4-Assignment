#' Script to create code books for accelerometer data and the aggregated accelerometer data
#' # REQUIRES INSTALLATION OF 
#' - codebook
#' - rio
#' - future
#' - labelled
#' - dplyr
#' - data.table
#' 
#' @description 
#' This class has x functions:
#' - create_accelerometer_codebook: A top level function, created 
#' - create_accelerometer_aggregated_codebook: A top level function, it pulls a set of data from a remote http(s) 
#' location and creates the tidy data set files in a new tidy_datasets folder.

#' This function creates the codebook data for the accelerometer tidy set 
#' grouped by student and activity and aggregated each measurement column by 
#' mean. It is used by the accelerometerGroupedCodebook.Rmd to create a codebook 
#' to describe the data.
#' 
#' @examples
#' > create_accelerometer_codebook()
#'
#' @export
create_accelerometer_codebook <- function() {
  #  install.packages("codebook")
  library(codebook)
  #  install.packages("rio")
  library(rio)
  #  install.packages("future")
  library(future)
  #  install.packages("labelled")
  library(labelled)
  #  install.packages("dplyr")
  library(dplyr)
  
  #  install.packages("data.table")
  library(data.table)
  
  # CREATE THE BASE CODE BOOK
  print("CREATE THE BASE CODE BOOK")
  #codebook::new_codebook_rmd()
  codebook_data <- rio::import("tidydata.txt")
  
  # ADD THE TOP LEVEL METADATA
  print("ADD THE TOP LEVEL METADATA")
  metadata(codebook_data)$name <- "Grouped Accelerometer Standard Deviation and Mean Data by Student and Activity"
  metadata(codebook_data)$description <- "This data set contains the standard deviation and mean of the original data. See the README.txt found in the original data, \"sample_data/getdata_projectfiles_UCI_HAR_Dataset/UCI HAR Dataset/README.txt\", for more information. Features value are normalized and bounded within -1.0 and 1.0."
  metadata(codebook_data)$creator <- "Robert de Lorimier"
  metadata(codebook_data)$citation <- "Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012"
  metadata(codebook_data)$url <- "https://github.com/rodelor97/GettingCleaningDataWeek4Project"
  metadata(codebook_data)$datePublished <- "2021-02-07"
  metadata(codebook_data)$spatialCoverage <- "Online"
  
  # ADD THE COLUMN LEVEL METADATA
  print("ADD THE COLUMN LEVEL METADATA")
  accel_data_df <- fread("tidydata.txt")
  col_labels <- names(accel_data_df)
  #print(paste("col_labels: ", toString(col_labels), sep=""))
  col_descr <- lapply(col_labels, create_explanation_from_column_name)
  #print(paste("col_descr: ", toString(col_descr), sep=""))
  #print(paste("col_descr class: ", class(col_descr)))
  label_list <- create_label_variable_description_list(col_labels, col_descr)
  #print(paste("label_list: ", toString(label_list), sep=""))
  #print(paste("label_list class: ", class(label_list)))

  var_label(codebook_data) <- label_list

  # CREATE THE CODEBOOK
  print("CREATE THE CODEBOOK DATA")
  if(!file.exists("codebook_source")) {
    dir.create("codebook_source")
  }
  rio::export(codebook_data, "codebook_source/tidyset.rds")
  
  print("DONE")
}

#' This creates a list using a vector of column labels as the list item name and 
#' descriptions as the list item value
#' 
#' @param col_labels A vector of strings values of labels
#' @param col_descr A vector of string values of descriptions
#' @return A list with two dataframes, the unaggregated data "result_set", and aggregated data tables "aggregated_set"
#' @examples
#' > label_list <- create_label_variable_description_list(col_labels, col_descr)
#'
#' @export
create_label_variable_description_list <- function(col_labels, col_descr) {
  lab_descr_list = list()
  i <- 0
  for (label in col_labels) {
    i <- i + 1
    lab_descr_list[label] = col_descr[i]
  }
  lab_descr_list
}

#' This function converts the column value to a more human readable description
#' 
#' @param col_name A string value of the column
#' @return A description of the column
#' @examples
#' > descr <- create_explanation_from_column_name("frequ_body_accel_jerk_mean_freq_z")
#' > descr
#' [1] "Fast fourier tranform frequecy signal, body acceleration jerk mean freq Z axis,"
#'
#' @export
create_explanation_from_column_name <- function(col_name) {
  library(stringr)

  base_column_name <- gsub("\\.", " ", col_name)
  column_name <- base_column_name
  description_string <- ""
  meaning_string <- "Labels, "
  prefix_column_name <- "Aggregated Mean Value Grouped By Subject and Activity For "
  if (regexpr("Subject", base_column_name) != -1) {
    prefix_column_name <- ""
    val_decription <- "Subject = The identifier of the subject who carried out the experiment, numbered from 1 to 30"
    if(nchar(description_string) > 0) {
      description_string <- paste(description_string, val_decription, sep=", ")
    } else {
      description_string <- val_decription
    }
  }
  if (regexpr("Activity", base_column_name) != -1) {
    prefix_column_name <- ""
    val_decription <- "Activity = One of six activities performed by subjects, WALKIN, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, and LAYING"
    if(nchar(description_string) > 0) {
      description_string <- paste(description_string, val_decription, sep=", ")
    } else {
      description_string <- val_decription
    }
  }
  if (regexpr("Time", base_column_name) != -1) {
    val_decription <- "Time = Time Domain Signal, captured at a constant rate of 50 Hz"
    if(nchar(description_string) > 0) {
      description_string <- paste(description_string, val_decription, sep=", ")
    } else {
      description_string <- val_decription
    }
  }
  if (regexpr("Frequency", base_column_name) != -1) {
    val_decription <- "Frequency = Fast Fourier Transform (FFT) was applied to frequency domain signals in hertz"
    description_string <- paste(description_string, val_decription, sep=", ")
  }
  if (regexpr("Angle", base_column_name) != -1) {
    val_decription <- "Angle = Angle between two vectors"
    if(nchar(description_string) > 0) {
      description_string <- paste(description_string, val_decription, sep=", ")
    } else {
      description_string <- val_decription
    }
  }

  # NEEDED?
#  if (regexpr("Body", base_column_name) != -1) {
#    val_decription <- "Body = The body acceleration signal obtained by subtracting the gravity from the total acceleration"
#    if(nchar(description_string) > 0) {
#      description_string <- paste(description_string, val_decription, sep=", ")
#    } else {
#      description_string <- val_decription
#    }
#  }

  if (regexpr("Gravity", base_column_name) != -1) {
    val_decription <- "Gravity = Sensor gravity in standard units 'g'"
    if(nchar(description_string) > 0) {
      description_string <- paste(description_string, val_decription, sep=", ")
    } else {
      description_string <- val_decription
    }
  }
  if (regexpr("Acceleration", base_column_name) != -1) {
    val_decription <- "Acceleration = Acceleration in standard gravity units 'g'"
    if(nchar(description_string) > 0) {
      description_string <- paste(description_string, val_decription, sep=", ")
    } else {
      description_string <- val_decription
    }
  }
  if (regexpr("Gyroscope", base_column_name) != -1) {
    val_decription <- "Gyroscope = The gyroscope sensor signals in radians/second"
    if(nchar(description_string) > 0) {
      description_string <- paste(description_string, val_decription, sep=", ")
    } else {
      description_string <- val_decription
    }
  }
  if (regexpr("Jerk", base_column_name) != -1) {
    val_decription <- "Jerk = Jerk signals in standard gravity units 'g'"
    if(nchar(description_string) > 0) {
      description_string <- paste(description_string, val_decription, sep=", ")
    } else {
      description_string <- val_decription
    }
  }
  if (regexpr("Magnitude", base_column_name) != -1) {
    val_decription <- "Magnitude = The magnitude measured in the Euclidean norm"
    if(nchar(description_string) > 0) {
      description_string <- paste(description_string, val_decription, sep=", ")
    } else {
      description_string <- val_decription
    }
  }
  if (regexpr("X", base_column_name) != -1) {
    val_decription <- "X = Triaxial signals in the X direction"
    if(nchar(description_string) > 0) {
      description_string <- paste(description_string, val_decription, sep=", ")
    } else {
      description_string <- val_decription
    }
  }
  if (regexpr("Y", base_column_name) != -1) {
    val_decription <- "Y = Triaxial signals in the Y direction"
    if(nchar(description_string) > 0) {
      description_string <- paste(description_string, val_decription, sep=", ")
    } else {
      description_string <- val_decription
    }
  }
  if (regexpr("Z", base_column_name) != -1) {
    val_decription <- "Z = Triaxialsignals in the Z direction"
    if(nchar(description_string) > 0) {
      description_string <- paste(description_string, val_decription, sep=", ")
    } else {
      description_string <- val_decription
    }
  }
  
  if (regexpr("Standard Deviation", base_column_name) != -1) {
    val_decription <- "Standard Deviation = Standard deviation of value."
    if(nchar(description_string) > 0) {
      description_string <- paste(description_string, val_decription, sep=", ")
    } else {
      description_string <- val_decription
    }
  }
  
  if (regexpr("Mean", base_column_name) != -1) {
    val_decription <- "Mean = Mean of value."
    if(nchar(description_string) > 0) {
      description_string <- paste(description_string, val_decription, sep=", ")
    } else {
      description_string <- val_decription
    }
  }
  
  final_description <- paste(paste(prefix_column_name, column_name, ": ", sep=""), meaning_string, description_string, sep=" ")
  return(final_description)
}

#' This creates a list using a vector of column labels as the list item name and 
#' descriptions as the list item value
#' 
#' @param col_labels A vector of strings values of labels
#' @param col_descr A vector of string values of descriptions
#' @return A list with two dataframes, the unaggregated data "result_set", and aggregated data tables "aggregated_set"
#' @examples
#' > label_list <- create_label_variable_description_list(col_labels, col_descr)
#'
#' @export
create_label_variable_description_list2 <- function(col_labels) {
  lab_descr_list = list()
  i <- 0
  for (label in col_labels) {
    i <- i + 1
    column_val_descr <- create_explanation_from_column_name(label)
    lab_descr_list[[label]] = column_val_descr
  }
  lab_descr_list
}

create_accelerometer_codebook()