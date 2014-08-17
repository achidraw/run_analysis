run_analysis
============

Getting and Cleaning Data Course Project

This file does the following using the Samsung dataset:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The final output is a tidydata.txt file which has the result of the last item

Data is read either using read.fwf() or read.csv() depending on the text file's structure
cbind() are used to combine the various files and create the test and train data set
rbind() is used to combine the test and train data sets


