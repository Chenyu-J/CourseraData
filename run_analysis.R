# run_analysis


#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, "course_file.zip", method="curl")

unzip("course_file.zip") 

# Step1 : Read all relevant information 
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


#Merges the training and the test sets to create one data set.
Merged_Data <- cbind(rbind(subject_train, subject_test),  rbind(y_train, y_test), rbind(x_train, x_test))

#Uses descriptive activity names to name the activities in the data set
final_df <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))
head(final_df)

#Appropriately labels the data set with descriptive variable names.
names(final_df)[2] = "activity"
names(final_df)<-gsub("^t", "Time", names(final_df))
names(final_df)<-gsub("^f", "Frequency", names(final_df))
names(final_df)<-gsub("-std()", "STD", names(final_df), ignore.case = TRUE)
names(final_df)<-gsub("-freq()", "Frequency", names(final_df), ignore.case = TRUE)
names(final_df)<-gsub("Acc", "Accelerometer", names(final_df))
names(final_df)<-gsub("Gyro", "Gyroscope", names(final_df))
names(final_df)<-gsub("Mag", "Magnitude", names(final_df))


#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
output <- final_df %>%
  group_by(subject, activity) %>%
  summarise_all(mean)

write.table(output, "FinalData.txt")






