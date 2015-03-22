# Getting-and-Cleaning-Data Course Project
Script: run_analysis.R

This script assumes that the working directory is set to the UCI HAR Dataset folder, and requires the installation of the dplyr and tidyr packages

The script begins by loading the required libraries and importing all the files with the desired data, except files in the Inertial Signals folder.

As the function used to extract the means later requires that the column names do not contain "( )" and other  invalid characters, this script validates the column names with the make.names function, with an argument to make sure the resulting column names are unique.

In isolating the means and standard deviations, I chose to keep all columns that contain the words "mean" or "std" (case-sensitive). This includes columns with "meanFreq", as the codebook with the dataset explained that they were also means. "mean" was case-sensitive because when I initially inspected the dataset, I noticed that variables which were not true means were labeled with "Mean..."

After extracting the columns with the means and standard deviations, while keeping the "subject" and "activity" columns, I named the activities according to the key-value pairs provided in activity_labels.txt. I then calculated the mean of every column, using the ddply function to group by activity and subject, so that the resulting data set was a table with one row per average per variable, for one subject performing one activity.

The last line of the script writes the final table to a file called tidy_UCI_data.txt, with the row names parameter set to false.
