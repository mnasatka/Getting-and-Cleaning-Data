#This script gets and cleans data collected from the accelerometers from the Samsung Galaxy S smartphone.
#The data can be found here:
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

library("plyr", lib.loc="C:/Program Files/R/R-3.1.0/library")

#Read in train data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

#Read in test data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

#1.Merges the training and the test sets to create one data set.
merged_x <- rbind(x_train, x_test)    
merged_y <- rbind(y_train, y_test)    
merged_subject <- rbind(subject_train, subject_test)

#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
features = read.table("UCI HAR Dataset/features.txt")
means <- sapply(features[,2], function(x) grepl("mean()", x, fixed=T))    
stds <- sapply(features[,2], function(x) grepl("std()", x, fixed=T))
merged_data <- merged_x[,(means | stds)]

#3.Uses descriptive activity names to name the activities in the data set
colnames(merged_y) <- "activity"
merged_y$activity[merged_y$activity == 1] = "walking"    
merged_y$activity[merged_y$activity == 2] = "walking upstairs"    
merged_y$activity[merged_y$activity == 3] = "walking downstairs"    
merged_y$activity[merged_y$activity == 4] = "sitting"    
merged_y$activity[merged_y$activity == 5] = "standing"    
merged_y$activity[merged_y$activity == 6] = "laying"

#4.Appropriately labels the data set with descriptive variable names. 
colnames(merged_data) <- features[(means|stds),2]
colnames(merged_subject) <- c("subject")

#5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
combined <- cbind(merged_data, merged_y, merged_subject)
tidy <- ddply(combined, .(subject, activity), function(x) colMeans(x[,1:60]))
write.csv(tidy, file="TIDY_UCI_HAR.csv", row.names=FALSE)