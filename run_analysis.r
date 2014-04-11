
#First af all, we read all the data needed
#features.txt: List of all features.
#activity_labels.txt: Links the class labels with their activity name.
#train/X_train.txt: Training set.
#train/y_train.txt: Training labels.
#test/X_test.txt: Test set.
#test/y_test.txt: Test labels.
#train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

X.train <- read.table("UCI HAR Dataset/train/X_train.txt")
y.train <- read.table("UCI HAR Dataset/train/y_train.txt")
X.test <- read.table("UCI HAR Dataset/test/X_test.txt")
y.test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject.train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subject.test <- read.table("UCI HAR Dataset/test/subject_test.txt")
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

#The levels and labels defined on activity_labels are applied to y_test and y_train data sets
y.test[, 1] <- factor(y.test[, 1], levels=activity.labels[, 1], labels=activity.labels[, 2])
y.train[, 1] <- factor(y.train[, 1], levels=activity.labels[, 1], labels=activity.labels[, 2])

#Combine subject, y and X data sets (train and test) in one data set
X.y.subject.test <- cbind(subject.test, y.test, X.test)
X.y.subject.train <- cbind(subject.train, y.train, X.train)

features.names <- as.character(features$V2)
newnames <- c("Subject","Activity")
column.names <- c(newnames,features.names)

dataset <- rbind(X.y.subject.train, X.y.subject.test)

# add names "Subject" and "Activity" to two first columns of this new data set 
colnames(dataset) <- column.names

# look for the column names with the string "mean" and "std" to select columns with mean and std values
mean.features <- grep("mean", names(dataset))
std.features <- grep("std", names(dataset))

#Subset the data set selecting these columns with the columns Subject and Activity
dataset <- dataset[, c(1, 2, mean.features,std.features)]

library("plyr")
dataset <- arrange(dataset, dataset[, 1], dataset[, 2])

dataset <- arrange(dataset, dataset[, 1], dataset[, 2])

#Split the data set based on the Subject and Activity variable
dataset.split <- split(dataset, list(dataset$Activity, dataset$Subject))

#sapply is applied to the splitted data set to calculate means of the columns
new.dataset <- sapply(dataset.split, function(x) colMeans(x[, c(3:81)]))
new.dataset <- data.frame(t(new.dataset))

#Add the columns Subject and activity to this new data set, apppling the levels from activity_labels
Activity <- rep(seq(1:6), 3)
Activity <- factor(Activity, label=activity.labels[, 2])
Subject <- gl(30,6)

tidy.dataset <- cbind(Subject, Activity, new.dataset)
row.names(tidy.dataset) <- c(1:180)

#Write the tidy data set to a txt file
write.table(tidy.dataset, file="tidy_dataset.txt")

rm(X.y.subject.test,X.y.subject.train,X.test,X.train,activity.labels,dataset,features,new.dataset,subject.test,subject.train,y.test,y.train,Activity,Subject,column.names,dataset.split,features.names,mean.features,newnames,std.features)
