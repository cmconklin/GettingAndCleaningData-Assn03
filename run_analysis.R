#=========================================================================
# Name: run_analysis.R  -  Getting and Cleaning Data, Assignment 3
# Date: 22-Nov-15
# Auth: Clifford M. Conklin
#	*** Note ***
#	The submissions calls for the data to be in the same directory as
#	as the location of this source.  I've opted to take a hit on purposely
#	not following that direction.  I instead have a "../data" directory,
#	relative to all assignments for this course.  That is I have one location
#	that houses all data for this course, so there isn't duplicate datasets.
#
#	The final results of the R script will be placed in the current working
#	directory.

# Purp: Read several datasets and merge into a single dataset
#
# 		features				: Column names of X_test.txt and X_train.txt
#		X_test.txt			: dataset
#		subject_test		: Subjects associated with rows in X_test.txt
#		y_train.txt			: dataset
#		subject_train.txt	: Subjects associated with rows in Y_train.txt
#
# Process:
#	Read in the features to get column names of the datasets.
#	For each of the datasets
#		Read in a dataset, then add the column names
#		Read in the subjects associated with the dataset and name the column
#		Merge the Subjects with their dataset.
#		Add another column for type of test, i.e. test or train
#	Extract only the columns which are means (mean) or standard deviation (std)
#		also include the Subjects.
#	Create a tidy dataset of averages for activities by subject
#	Save this tidy dataset to disk.
#=========================================================================

library(dplyr)

# fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download.file(fileUrl, destfile = "../data/HarDataset.zip", method = "curl")
#
# unzip HarDataset.zip
# ./data/UCI HAR Dataset

#-------------------------------------------------------------------------
# Setup Filenames
#-------------------------------------------------------------------------

baseDir <- "../../data/UCI HAR Dataset"
yTestFilename <- file.path(baseDir, "test", "y_test.txt")
xTestFilename <- file.path(baseDir, "test", "X_test.txt")
subjectTestFilename <- file.path(baseDir, "test", "subject_test.txt")
yTrainFilename <- file.path(baseDir, "train", "y_train.txt")
xTrainFilename <- file.path(baseDir, "train", "X_train.txt")
subjectTrainFilename <- file.path(baseDir, "train", "subject_train.txt")
featuresFilename <- file.path(baseDir, "features.txt")

							# Display Filenames

print(paste("Y Test File  : ", yTestFilename))
print(paste("X Test File  : ", xTestFilename))
print(paste("S Test File  : ", subjectTestFilename))
print(paste("Y Train File : ", yTrainFilename))
print(paste("X Train File : ", xTrainFilename))
print(paste("S Test File  : ", subjectTrainFilename))
print(paste("Features     : ", featuresFilename))

#-------------------------------------------------------------------------
# Read Files and assign column names
#-------------------------------------------------------------------------

print("Reading Files ...")

							# Read data: features (column names)

print(paste("  ", featuresFilename))
df_features <- read.table(featuresFilename)

							# Get Column names

columnNames <- df_features[[2]]
#columnNames[1:5] %>% print()

							# Read data: y test (Not used)

print(paste("  ", yTestFilename))
df_yTest <- read.table(yTestFilename)
#dim(df_yTest) %>% print()

							# Read data: x test

print(paste("  ", xTestFilename))
df_xTest <- read.table(xTestFilename)
#dim(df_xTest) %>% print()
colnames(df_xTest) <- columnNames

							# Read data: subjects test

print(paste("  ", subjectTestFilename))
df_subjectTest <- read.table(subjectTestFilename)
colnames(df_subjectTest) <- c("subject")
#dim(df_subjectTest) %>% print()

							# Merge Subjects and Test data

print("  ***  Merge Test and Subjects")
df_xTest <- cbind(df_subjectTest, df_xTest)
#dim(df_xTest) %>% print()

							# Read data: y train (Not Used)

print(paste("  ", yTrainFilename))
df_yTrain <- read.table(yTrainFilename)

							# Read data: x train

print(paste("  ", xTrainFilename))
df_xTrain <- read.table(xTrainFilename)
colnames(df_xTrain) <- columnNames

							# Read data: subjects train

print(paste("  ", subjectTrainFilename))
df_subjectTrain <- read.table(subjectTrainFilename)
colnames(df_subjectTrain) <- c("subject")

							# Merger Subjects and Training data

print("  ***  Merge Train and Subjects")
df_xTrain <- cbind(df_subjectTrain, df_xTrain)
#dim(df_xTrain) %>% print()

#-------------------------------------------------------------------------
# Add type of subject column, i.e. test or train
#-------------------------------------------------------------------------

							# Add Subject Type "test" to test dataset

# print("xTest")
# dim(df_xTest) %>% print()
df_xTest$testTrain <- "test"
# dim(df_xTest) %>% print()

							# Add Subject Type "train" to train dataset

# print("xTrain")
# dim(df_xTrain) %>% print()
df_xTrain$testTrain <- "train"
# dim(df_xTrain) %>% print()

#-------------------------------------------------------------------------
# Add type of subject column, i.e. test or train
#-------------------------------------------------------------------------

# print("xDataset")
df_dataset <- rbind(df_xTest, df_xTrain)
# dim(df_dataset) %>% print()
# dim(df_dataset) %>% print()
df_dataset <- df_dataset[, !duplicated(colnames(df_dataset))]
# dim(df_dataset) %>% print()

#-------------------------------------------------------------------------
# Read the data frame in to a Data Frame Table
#-------------------------------------------------------------------------

dataset <- tbl_df(df_dataset)

#-------------------------------------------------------------------------
# Create datasets of only mean, std, or both
#-------------------------------------------------------------------------

									# Only columns with "mean" (Not used)

# dataset_mean <- select(dataset, contains("mean"))
# print(paste("dataset_mean : ", dim(dataset_mean)))

									# Only columns with "std" (Not used)

# dataset_std <- select(dataset, contains("std"))
# print(paste("dataset_std  : ", dim(dataset_std)))

									# Only columns with "mean" or "std"
									# include "subject"

dataset_mean_std <- select(dataset, matches("subject|mean|std"))
# print(paste("dataset_mean_std : ", dim(dataset_mean_std)))

#-------------------------------------------------------------------------
# Average each variable for each activity and each subject
#-------------------------------------------------------------------------

subjects_mean_std <- group_by(dataset_mean_std, subject) %>%
	summarise_each(funs(mean))

#-------------------------------------------------------------------------
# Write the tidy table to disk
#-------------------------------------------------------------------------

write.table(subjects_mean_std,
#				file = "../data/subjects_mean_std.txt",
				file = "subjects_mean_std.txt",
				row.name = FALSE)

