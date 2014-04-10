
X.train <- read.table("UCI HAR Dataset/train/X_train.txt")
y.train <- read.table("UCI HAR Dataset/train/y_train.txt")
X.test <- read.table("UCI HAR Dataset/test/X_test.txt")
y.test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject.train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subject.test <- read.table("UCI HAR Dataset/test/subject_test.txt")
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

y.test[, 1] <- factor(y.test[, 1], levels=activity.labels[, 1], labels=activity.labels[, 2])
y.train[, 1] <- factor(y.train[, 1], levels=activity.labels[, 1], labels=activity.labels[, 2])

X.y.subject.test <- cbind(subject.test, y.test, X.test)
X.y.subject.train <- cbind(subject.train, y.train, X.train)

features.names <- as.character(features$V2)
newnames <- c("Subject","Activity")
column.names <- c(newnames,features.names)

dataset <- rbind(X.y.subject.train, X.y.subject.test)

colnames(dataset) <- column.names

mean.features <- grep("mean", names(dataset))
std.features <- grep("std", names(dataset))

dataset <- dataset[, c(1, 2, mean.features,std.features)]

library("plyr")
dataset <- arrange(dataset, dataset[, 1], dataset[, 2])

dataset <- arrange(dataset, dataset[, 1], dataset[, 2])

dataset.split <- split(dataset, list(dataset$Activity, dataset$Subject))

new.dataset <- sapply(dataset.split, function(x) colMeans(x[, c(3:81)]))
new.dataset <- data.frame(t(new.dataset))

Activity <- rep(seq(1:6), 3)
Activity <- factor(Activity, label=activity.labels[, 2])
Subject <- gl(30,6)

tidy.dataset <- cbind(Subject, Activity, new.dataset)
row.names(tidy.dataset) <- c(1:180)

write.table(tidy.dataset, file="tidy_dataset.txt")

rm(X.y.subject.test,X.y.subject.train,X.test,X.train,activity.labels,dataset,features,new.dataset,subject.test,subject.train,y.test,y.train,Activity,Subject,column.names,dataset.split,features.names,mean.features,newnames,std.features)
