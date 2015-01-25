# Getting_And_Cleaning_Data
Course Assignment for Getting and Cleaning Data - Coursera

## Description of R Script
Comments in the script describe the general structure

The R script uses the packages plyr, dplyr and tidyr.  These libraries are loaded at the beginning of the script

The tables are then read into R.  There are 8 tables that are read in:
  test_set - contains the measurements for the "test" set
  test_labels - contains the activity labels for the "test" set - each row corresponds to the same row in test_set
  test_subject - contains the subject information for the "test" set - each row corresponds to the same row in test_set
  train_set - contains the measurements for the "train" set
  train_labels - contains the activity labels for the "train" set - each row corresponds to the same row in train_set
  train_subject - contains the subject information for the "train" set - each row corresponds to the same row in train_set
  activity_labels - contains the meaningful lables for the values in "test_labels" and "train_lables".  
  features - contains descriptions of the columns in "test_set" and "train_set"
  
A column was added to both test_set and train_set to indicate which dataset they came from

### Project Step #1
The test and train sets were combined using "rbind" to create "total" versions of _set, _labels and _subject

### Project Step #2
The columns of "total_set" that corresponded to rows in "features" that contained the words "mean()" and "std()" were extracted to a separate dataset called "total_set_extract". 
  NOTE:  Some variables had the word "Mean" with a capital "M".  These rows were not included.

### Project Step #3
The column names of "total_set_extract" were changed to the corresponding row values of "features"

Certain aspects of the names were removed to facilitate later code.  Specifically, dashes ("-") were converted to underscores ("_") and the parenthesis ("()") were removed

Columsn for "set", "label" and "subject" were appended to total_set_extract.

### Project Step #4
The meaningful names for the activites were added to "total_set_extract" by merging the dataset with the activity_labels dataset.  The resulting data was saved as "total_set_merged"

The columns were re-ordered to make more sense (descriptors first, then data).  In this process the column containing the meaningful activity descriptions was renamed to "activity_label".

### Project Step #5

A copy of total_set_merged was created called "tidy_data"

The 79 feature columsn were gathered together into a single "feature" column with a corresponding "measurement" column

The feature column was separated at the first underscore to create a new "feature" column and a "stat" column

The stat column was separated at the underscore to create a new "stat" column and a "direction" column.  
  NOTE - not all rows have a "direction".  These rows will have an NA in the direction column
  
The dataset was grouped by subject, activity_label, set, feature, stat and direction.  This facilitated the subsequent "summarize".

The dataset was summarized to give the mean measurement for each subject/activity_label/set/feature/stat/direction combination.  The resulting dataset has 14220 (30 subjects * 6 activities * 79 feature/stat/direction) observations and 7 variables.

## Tidy Data
The data is now considered "tidy" because:
  
  Each column contains only one variable 
    The "feature" column was split into "feature", "stat" and "direction"
  
  Each observation is in a different row
    The various "feature" columns were combined so that each measurement was on a separate row
  
  There is only one type of observation in the table
    Measurement

## Data Set
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
