#   Name:       project01.R
#   Author:     Charles Carter
#   Date:       July 17, 2014

#You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject

library(matrixStats)

# PART ONE
# 1. Merges the training and the test sets to create one data set.
#Assume that the data files are in two subdirectories names 'train' and 'test'
#get the data, the list of subjects, and the list of activities
cat("PART ONE: getting /train' and 'test'  and creating one data set named 'data'\n")
train <- read.delim("train/X_train.txt", sep = "", header = F)
train_sub <- read.delim("train/subject_train.txt", sep = "", header = F)
train_act <- read.delim("train/y_train.txt", sep = "", header = F)
test <- read.delim("test/X_test.txt", sep = "", header = F)
test_sub <- read.delim("test/subject_test.txt", sep = "", header = F)
test_act <- read.delim("test/y_test.txt", sep = "", header = F)
cat("  Dimensions of train are [", dim(train), "] and for test are [", dim(test), "].\n")
cat("  Dimensions of train_sub are [", dim(train_sub), "] and for test_sub are [", dim(test_sub), "].\n")
cat("  Dimensions of test_act are [", dim(train_act), "] and for test_act are [", dim(test_act), "].\n")

data <- rbind(train, test)
rm(train)
rm(test)
subjects <- rbind(train_sub, test_sub)
rm(train_sub)
rm(test_sub)
activities <- rbind(train_act, test_act)
rm(train_act)
rm(test_act)
cat("  Dimensions of data are [", dim(data), "].\n")

# PART TWO
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
cat("PART TWO: Calculating means and standard deviations\n")
means <- colMeans(data, na.rm = T, dims = 1)
sds <-colSds(as.matrix(data))
cat("  column means are: ", means, ".\n")
cat("  column sigmas are: ", sds, ".\n")

# PART THREE
# 3. Uses descriptive activity names to name the activities in the data set
#convert the activities into activity labels
cat("PART THREE: convert the activities into activity labels\n")
act_labels <- c('WALKING','WALKING_UPSTAIRS','WALKING_DOWNSTAIRS','SITTING','STANDING','LAYING')
act_list <- list(activities$V1)
act_list <- as.integer(act_list[[1]])
act_fac <- factor(act_list, labels = act_labels)
act_fac <- as.data.frame(act_fac)
rm(act_list)
data <- cbind(act_fac, data)
cat("  added the activity labels to the first column of the data\n")
data <- cbind(subjects, data)
cat("  added the subjects to the first column of the data\n")
cat("  Dimensions of data are now [", dim(data), "] after adding subjects and activities.\n")
#cat("  Activity labels: ", act_labels, "\n")
rm(act_labels)

# PART FOUR
# 4. Appropriately labels the data set with descriptive variable names. 
cat('PART FOUR: label columns of data set with variable names\n')
col_labels <- read.delim("features.txt", sep = "", header = F, stringsAsFactors = F)
col_labels <- col_labels$V2
col_labels <- c('subjects', 'activities', col_labels)
#cat("labels data frame:\n")
#print(col_labels)
#cat("\n------------------------------\n")
names(data) <- col_labels

# PART FIVE
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject
cat("PART FIVE: Creates a second, independent tidy data set with the average of each variable for each activity and each subject\n")
data$subjects <- factor(data$subjects)
#tt <- aggregate(data, by = list(Subjects = data$subjects, Activities = data$activities), mean, simplify = T)
tt <- aggregate(data[c(-1,-2)], by = list(Subjects = data$subjects, Activities = data$activities), mean, simplify = T)
write.csv(tt, 'tidy_data_set.csv')
rm(list = ls())
cat("\nDone\n")
