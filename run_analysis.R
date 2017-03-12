## 1. Merge the training and test sets to create one data set
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

xdata <- rbind(x_train, x_test)

ydata <- rbind(y_train, y_test)

subjectdata <- rbind(subject_train, subject_test)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("features.txt")
mean_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
xdata <- xdata[, mean_std_features]

## 3. Use descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt")
ydata[, 1] <- activities[ydata[, 1], 2]
ydata <- rename(ydata, activity = V1)

## 4. Appropriately label the data set with descriptive variable names
subjectdata <- rename(subjectdata, subject = V1)
alldata <- cbind(xdata, ydata, subjectdata)

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
aggdata <- aggregate(. ~subject + activity, alldata, mean)
aggdata <- aggdata[order(aggdata$subject,aggdata$activity),]
write.table(aggdata, file = "tidydata.txt",row.name=FALSE)