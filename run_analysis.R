setwd("D:/Akhil/course_era/R/C3/w4/project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")
feat <- read.table("features.txt", col.names = c("no","func"))
act <- read.table("activity_labels.txt", col.names = c("code", "act"))

setwd("D:/Akhil/course_era/R/C3/w4/project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test")
s_t <- read.table("subject_test.txt", col.names = "sub")
x_t <- read.table("X_test.txt", col.names = feat$func)
y_t <- read.table("y_test.txt", col.names = "code")

setwd("D:/Akhil/course_era/R/C3/w4/project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train")
s_tr <- read.table("subject_train.txt", col.names = "sub")
x_tr <- read.table("X_train.txt", col.names = feat$func)
y_tr <- read.table("y_train.txt", col.names = "code")

X <- rbind(x_tr, x_t)
Y <- rbind(y_tr, y_t)
S <- rbind(s_tr, s_t)
merged <- cbind(S, Y, X)

tidy <- merged %>% select(subject, code, contains("mean"), contains("std"))

tidy$code <- act[tidy$code, 2]

names(tidy)[2] = "activity"
names(tidy)<-gsub("Acc", "Accelerometer", names(tidy))
names(tidy)<-gsub("Gyro", "Gyroscope", names(tidy))
names(tidy)<-gsub("BodyBody", "Body", names(tidy))
names(tidy)<-gsub("Mag", "Magnitude", names(tidy))
names(tidy)<-gsub("^t", "Time", names(tidy))
names(tidy)<-gsub("^f", "Frequency", names(tidy))
names(tidy)<-gsub("tBody", "TimeBody", names(tidy))
names(tidy)<-gsub("-mean()", "Mean", names(tidy), ignore.case = TRUE)
names(tidy)<-gsub("-std()", "STD", names(tidy), ignore.case = TRUE)
names(tidy)<-gsub("-freq()", "Frequency", names(tidy), ignore.case = TRUE)
names(tidy)<-gsub("angle", "Angle", names(tidy))
names(tidy)<-gsub("gravity", "Gravity", names(tidy))

Final <- tidy %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

write.table(Final, "Final.txt", row.name=FALSE)