###Merges the training and the test sets to create one data set.###
###Uses descriptive activity names to name the activities in the data set###
###Extracts only the measurements on the mean and standard deviation for each measurement.###
###Appropriately labels the data set with descriptive variable names.###
###From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.###

#Load activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

#Load data column names
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

#Extract only mean and std for each measurement
extract_features <- grepl("mean|std", features)

#Load and process X_test & y_test data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#Rename column names for X_test
names(X_test) = features

#Extract only mean and std for each measurement (X_test)
X_test <- X_test[,extract_features]

#Load activity labels for y_test
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "Subject"

#Bind data for test data
test_data <- cbind(subject_test, y_test, X_test)

# Load and process X_train & y_train data
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#Rename column names for X_train
names(X_train) = features

#Extract only mean and std for each measurement (X_train)
X_train <- X_train[,extract_features]

#Load activity labels for y_train
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "Subject"

#Bind data for train data
train_data <- cbind(subject_train, y_train, X_train)

#Merge test and train data
data <- rbind(train_data, test_data)

library(reshape2)
id_labels <- c("Subject", "Activity_ID", "Activity_Label")
data_labels <- setdiff(colnames(data), id_labels)
melt_data <- melt(data, id = id_labels, measure.vars = data_labels)

#Apply mean function to dataset using dcast
tidy_data <- dcast(melt_data, Subject + Activity_Label ~ variable, mean)

#Write tidy data as txt file
write.table(tidy_data, file = "./tidy_data.txt", row.name=FALSE)


