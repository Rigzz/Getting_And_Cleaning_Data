# Author Rigzz
#
# This program is processing the data UCI HAR Dataset, available at the following address - 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#
# Below are the following steps to implement in the course of the analysis and cleaning of data:
#  1. Merges the training and the test sets to create one data set.
#  2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#  3. Uses descriptive activity names to name the activities in the data set.
#  4. Appropriately labels the data set with descriptive variable names. 
#  5. From the data set in step 4, creates a second, independent tidy data set with the average of
#     each variable for each activity and each subject.
#
# Libraries: plyr, data.table


# --------------------------- Getting Data
# Download data
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              destfile = "./uci_har.zip")

# Unzip archive
unzip("./uci_har.zip")

# Reading and writing files in the appropriate objects
yTrain   = read.table("./UCI HAR Dataset/train/y_train.txt")
xTrain   = read.table("./UCI HAR Dataset/train/x_train.txt")
subTrain = read.table("./UCI HAR Dataset/train/subject_train.txt")
yTest    = read.table("./UCI HAR Dataset/test/y_test.txt")
xTest    = read.table("./UCI HAR Dataset/test/x_test.txt")
subTest  = read.table("./UCI HAR Dataset/test/subject_test.txt")
features = read.table("./UCI HAR Dataset/features.txt")
activities = read.table("./UCI HAR Dataset/activity_labels.txt")


# --------------------------- Step 1
# Merges the training and the test sets to create one data set.
allY = rbind(yTrain, yTest)
allX = rbind(xTrain, xTest)
allSubject = rbind(subTrain, subTest)


# --------------------------- Step 2 
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Mean and Standard deviation
meanDev = grep(".*mean.*|.*std.*", features[, 2])

# Subset of deviation
allX = allX[, meanDev]

# Set the correct column names
names(allX) = features[meanDev, 2]


# --------------------------- Step 3 
# Uses descriptive activity names to name the activities in the data set.
# Data updating
allY[, 1] = activities[allY[, 1], 2]

# Set the correct column names
names(allY) = "activity"


# --------------------------- Step 4
# Appropriately labels the data set with descriptive variable names.
# Set the correct column names
names(allSubject) = "subject"

# Final data set
data = data.frame(allX, allY, allSubject)


# --------------------------- Step 5
# From the data set in step 4, creates a second, independent tidy data set with the average of
# each variable for each activity and each subject.

# Subsets summary statistics for each
tidy = aggregate(. ~subject + activity, data, mean)

# Ordering permutation
finalTidy = tidy[order(tidy$subject, tidy$activity), ]

# Write result in the file
write.table(finalTidy, file = "tidy_data.txt", row.name = FALSE )
