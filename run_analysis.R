# Reading trainings tables:
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('./UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./UCI HAR Dataset/activity_labels.txt')

# assigning column names:
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activity_Id"
colnames(subject_train) <- "subject_Id"
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activity_Id"
colnames(subject_test) <- "subject_Id"
colnames(activityLabels) <- c('activity_Id','activity_Type')

#merging data:
all_train <- cbind(y_train, subject_train, x_train)
all_test <- cbind(y_test, subject_test, x_test)
total <- rbind(all_train, all_test)

#extracting mean and std:
colNames <- colnames(total)
mean_and_std <- (grepl("activity_Id" , colNames) | grepl("subject_Id" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
sub_mean_and_std <- total[ ,mean_and_std == TRUE]
sub_activityNames <- merge(sub_mean_and_std, activityLabels, by="activity_Id", all.x = TRUE)

# creating an independent tidy data set with the average of each variable:
tidy <- aggregate(. ~subject_Id + activity_Id, sub_activityNames, mean)
tidy <- tidy[order(tidy$subject_Id, tidy$activity_Id), ]
write.table(tidy, "tidy.txt", row.name = FALSE)