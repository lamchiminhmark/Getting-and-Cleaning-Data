## run_analysis.R
## Rscript that downloads raw data and tidy it up to extract the mean and standard deviations of the 
## variables. Labels are also added to give meaning to the variable.  The 2 relevant datasets are result1 
## and result2. Note: Many variables are not renamed so as to maintain the technical precision. 
## A description of the variables are recorded in the code book.
##
## Minh Lam
## 02/26/2018

library(dplyr)

# Downloads and unzips the zip file. 
if (!file.exists("HARUS.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                "HARUS.zip")
}
unzip("HARUS.zip")

# Store activity labels into a data.frame.
activityLabel <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("Number", "Activity"))

# First, start with the test dataset.
# Store all txt files into variables subjectTest, xTest, yTest.
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
xTest <- read.table("UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("UCI HAR Dataset/test/y_test.txt")

# Convert yTest values to more meaningful activity labels
yTest[,1] <- factor(yTest[,1], levels = activityLabel$Number, labels = activityLabel$Activity)

# Store all features into a data.frame, and keep only the ones that compute mean() and std().
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("Number", "Variable"))
features <- filter(features, grepl("mean\\()|std\\()", Variable))
relevantNumbers <- features$Number
relevantVariables <- features$Variable

# From xTest, select only the varaibles that are relevant(the mean() and std()). Then rename columns to reflect 
# variables.
relevantXTest <- select(xTest, relevantNumbers)
colnames(relevantXTest) <- relevantVariables 

# Add to this table of variable values the case's subject and activity and rename the first 2 columns.
resultTest <- cbind(subjectTest, yTest, relevantXTest)
colnames(resultTest)[1:2] <- c("Subject", "Activity")


# Now, repeat the same process for the training dataset.
# Store all txt files into variables subjectTrain, xTrain, yTrain.
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt")

# Convert yTest values to more meaningful activity labels
yTrain[,1] <- factor(yTrain[,1], levels = activityLabel$Number, labels = activityLabel$Activity)

# Store all features into a data.frame, and keep only the ones that compute mean() and std().
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("Number", "Variable"))
features <- filter(features, grepl("mean\\()|std\\()", Variable))
relevantNumbers <- features$Number
relevantVariables <- features$Variable

# From xTrain, select only the varaibles that are relevant(the mean() and std()). Then rename columns to reflect 
# variables.
relevantXTrain <- select(xTrain, relevantNumbers)
colnames(relevantXTrain) <- relevantVariables 

# Add to this table of variable values the case's subject and activity and rename the first 2 columns.
resultTrain <- cbind(subjectTrain, yTrain, relevantXTrain)
colnames(resultTrain)[1:2] <- c("Subject", "Activity")


# Combine the 2 tables into a single result table
result1 <- rbind(resultTest, resultTrain)

# Finally, create a table with averages of each variable for each subject-activity combination.
result2 <- result1 %>% group_by(Subject, Activity) %>% summarize_all(funs(mean))
write.table(result2, file = "Tidy Data.txt", row.names = FALSE)
