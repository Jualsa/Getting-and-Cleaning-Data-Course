Getting-and-Cleaning-Data-Course
================================

Description of how the sript run_analysis.r works
(these comments also included in the .r file)

First af all, we read all the data needed
-features.txt: List of all features.
-activity_labels.txt: Links the class labels with their activity name.
-train/X_train.txt: Training set.
-train/y_train.txt: Training labels.
-test/X_test.txt: Test set.
-test/y_test.txt: Test labels.
-train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

The levels and labels defined on activity labels are applied to y test and y train data sets

Combine subject, y and X data sets (train and test) in one data set

Add names "Subject" and "Activity" to two first columns of this new data set 

Look for the column names with the string "mean" and "std" to select columns with mean and std values

Subset the data set selecting these columns with the columns Subject and Activity

Split the data set based on the Subject and Activity variable

sapply is applied to the splitted data set to calculate means of the columns

Add the columns Subject and Activity to this new data set, apppling the levels from activity_labels

Write the tidy data set to a txt file
