# GettingAndCleaningData-Assn03
Getting and Cleaning Data, Assignment 3.

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
