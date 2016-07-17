##Getting and Cleaning Data Project

This repository contains the course project for the Cousera course "Getting and Cleaning data".

The R script run_analysis.R does the following tasks:

	1. Download the UCI HAR Dataset (Human Activity Recognition Using Smartphones Dataset) from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
	2. Extracts only the measurements on the mean and standard deviation for each measurement.
	3. Load the activity and subject datasets and merge those datasets whith their training/test dataset
	4. Merge together the 2 datasets obtained in the point 3 for the selected measurements in point 2.
	5. Converts the activity and subject columns into factors
	6. Finally, the script creates a tidy dataset, named "averageBySubjectActivity.txt", that consists of the average (mean) value of each variable for each subject and activity pair. 
	
The CodeBook.md describe the features in the resulting dataset "averageBySubjectActivity.txt".
	
	