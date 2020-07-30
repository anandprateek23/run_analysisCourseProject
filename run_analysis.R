library(dplyr)
#Download the dataset
    url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url,destfile = "./project.zip")
    
if (!file.exists("UCI HAR Dataset")) { 
    unzip("./project.zip") 
}

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","feat"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("m", "act"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$feat)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "m")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$feat)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Data <- cbind(Subject, y, x)

TData<-Data%>%select(subject,m,contains("mean"),contains("std"))

TData$m <- activities[TData$m, 2]

names(TData)[2] = "activity"
names(TData)<-gsub("Acc", "Accelerometer", names(TData))
names(TData)<-gsub("Gyro", "Gyroscope", names(TData))
names(TData)<-gsub("BodyBody", "Body", names(TData))
names(TData)<-gsub("Mag", "Magnitude", names(TData))
names(TData)<-gsub("^t", "Time", names(TData))
names(TData)<-gsub("^f", "Frequency", names(TData))
names(TData)<-gsub("tBody", "TimeBody", names(TData))
names(TData)<-gsub("-mean()", "Mean", names(TData), ignore.case = TRUE)
names(TData)<-gsub("-std()", "STD", names(TData), ignore.case = TRUE)
names(TData)<-gsub("-freq()", "Frequency", names(TData), ignore.case = TRUE)
names(TData)<-gsub("angle", "Angle", names(TData))
names(TData)<-gsub("gravity", "Gravity", names(TData))

NewData <- TData %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))
write.table(NewData, "NewData.txt", row.name=FALSE)
