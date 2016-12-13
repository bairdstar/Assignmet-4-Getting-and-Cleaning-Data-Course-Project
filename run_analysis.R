#Merges the training and the test sets to create one data set.
#read files 
message("reading X_train.txt")
train_x <- read.table("train/X_train.txt")
message("read y_train.txt")
train_y <- read.table("train/y_train.txt")
message("read subject_train.txt")
train_subject <- read.table("train/subject_train.txt")
message("read X_test.txt")
test_x <- read.table("test/X_test.txt")
message("read y_test.txt")
test_y <- read.table("test/y_test.txt")
message("read subject_test.txt")
test_subject <- read.table("test/subject_test.txt")

#merge into three distinct sets
merged_x <- rbind(train_x, test_x)
merged_y <- rbind(train_y, test_y)
merged_subjects <- rbind(train_subject, test_subject)

#Uses descriptive activity names to name the activities in the data set
#get activity names from file
activityLabels <- read.table("activity_labels.txt")[,2]
merged_activities<-activityLabels[unlist(merged_y)]

#store names of columns from features.txt file and prep for move into featureList
featureList <- read.table("features.txt")[, 2]
#update data.frame headers to values names from features.txt file 
names(merged_x)<-featureList
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Get only columns with featureList names matching value in the name with "mean()" or "std()":
matchingColums_x <- grep("(mean|std)\\(\\)", names(merged_x))
limitedFocus_x <- merged_x[, matchingColums_x]

#Appropriately labels the data set with descriptive variable names.
#change "t" at the beginning of any field name to > time
names(limitedFocus_x) <- gsub("^t", "Time", names(limitedFocus_x))
#change "f" at the beginning of any field name to > "Frequency"
names(limitedFocus_x) <- gsub("^f", "Frequency", names(limitedFocus_x))
#change "-mean()" anywhere found in the field name to > "Mean"
names(limitedFocus_x) <- gsub("-mean\\(\\)", "Mean", names(limitedFocus_x))
#change "-std()" anywhere found in the field name to > "StdDev" (Standard Deviation)
names(limitedFocus_x) <- gsub("-std\\(\\)", "StdDev", names(limitedFocus_x))
#change "-" anywhere found in the field name to > "" (empty - remove it)
names(limitedFocus_x) <- gsub("-", "", names(limitedFocus_x))
#change "BodyBody" duplicate found in the field name to > single "Body"
names(limitedFocus_x) <- gsub("BodyBody", "Body", names(limitedFocus_x))
#change "Acc" anywhere found in the field name to > "Accelerometer"
names(limitedFocus_x)<-gsub("Acc", "Accelerometer", names(limitedFocus_x))
#change "Gyro" anywhere found in the field name to > "Gyroscope"
names(limitedFocus_x)<-gsub("Gyro", "Gyroscope", names(limitedFocus_x))
#change "Mag" anywhere found in the field name to > "Magnitude"
names(limitedFocus_x)<-gsub("Mag", "Magnitude", names(limitedFocus_x))

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy <- cbind(Subject = merged_subjects, Activity = merged_activities, limitedFocus_x)
names(tidy)[1:2]<-c("Subject", "Activity")
copy_book<-names(tidy)

#Create a file with the new tidy data
write.table(tidy, "tidyData.txt", row.names = FALSE)
write.table(copy_book, "copy_book.txt", row.names = FALSE)
