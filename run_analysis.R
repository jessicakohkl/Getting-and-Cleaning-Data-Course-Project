## 1. Merge the training and test sets to create one data set
xtrain <- read.table("train/X_train.txt")
ytrain <- read.table("train/y_train.txt")
subjecttrain <- read.table("train/subject_train.txt")

xtest <- read.table("test/X_test.txt")
ytest <- read.table("test/y_test.txt")
subjecttest <- read.table("test/subject_test.txt")

xdata <- rbind(xtrain, xtest)

ydata <- rbind(ytrain, ytest)

subjectdata <- rbind(subjecttrain, subjecttest)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("features.txt")
mean_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
xdata <- xdata[, mean_std_features]
names(xdata) <- features[mean_std_features, 2]

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