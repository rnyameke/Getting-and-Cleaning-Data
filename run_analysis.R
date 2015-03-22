############################################################
# Rose Nyameke
# Course Project -- Getting and Cleaning Data
# March 22, 2015
############################################################

#assuming working directory is UCI HAR Dataset folder
#loading required libraries (assumed they're already installed)

library("dplyr")
library ("tidyr")

#read in data files
activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")

#read in files from the test folder
subject_test <- read.table("test/subject_test.txt")
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")

#read in files from the train folder
subject_train <- read.table("train/subject_train.txt")
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")

#isolate the labels from the features table
labels <- features[,2]

#convert the labels for from factor to vector
column_names <- as.vector(labels)

#add subject and activity as label names and validating the names
column_names <- make.names(c("subject", "activity", column_names), unique = T)

#combining data files
combined_data <- rbind(cbind(subject_test,y_test, x_test) , cbind(subject_train,y_train, x_train) )

#labeling columns and making sure row names are NULL
colnames(combined_data) <- column_names
row.names(combined_data) <- NULL

#isolating means and standard deviations -- columns with "mean" or "std", case sensitive
mean_stdev <- select(combined_data, c(subject, activity, contains("mean", ignore.case = F), contains("std", ignore.case = F)))

#naming the activities using the key in activity_labels.txt
mean_stdev$activity[mean_stdev$activity == "5"] <- "STANDING"
mean_stdev$activity[mean_stdev$activity == "6"] <- "LAYING"
mean_stdev$activity[mean_stdev$activity == "4"] <- "SITTING"
mean_stdev$activity[mean_stdev$activity == "3"] <- "WALKING_DOWNSTAIRS"
mean_stdev$activity[mean_stdev$activity == "2"] <- "WALKING_UPSTAIRS"
mean_stdev$activity[mean_stdev$activity == "1"] <- "WALKING"

#calculating means of each variable per activity and subject
mean_per_group <- ddply(mean_stdev, .(activity, subject), colwise(mean))

#write new data set to .txt, with row.names set to False
write.table(mean_per_group, file = "tidy_UCI_data.txt", row.names = F)