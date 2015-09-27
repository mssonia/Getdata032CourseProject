# 1.  Merges the training and the test sets to create one data set.
# 2.  Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.  Uses descriptive activity names to name the activities in the data set
# 4.  Appropriately labels the data set with descriptive variable names. 
# 5.  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(dplyr)
library(reshape2)
library(data.table)
library(stringr)

# Get features
setwd("~/Documents/JohnsHopkinsCoursera/getdata-007/CourseProject/UCI HAR Dataset")
features <- read.table("features.txt", header = FALSE, sep = "", blank.lines.skip = TRUE) 

# Get training data 
setwd("~/Documents/JohnsHopkinsCoursera/getdata-007/CourseProject/UCI HAR Dataset/train")
trainingSubjects <- read.table("subject_train.txt", sep = "", blank.lines.skip = TRUE)
trainingLabel <- read.table("y_train.txt", sep = "", blank.lines.skip = TRUE)
trainingSet <- read.table("X_train.txt", sep = "", blank.lines.skip = TRUE)
training <- cbind(trainingSubjects, trainingLabel, trainingSet)

# Get test data  
setwd("~/Documents/JohnsHopkinsCoursera/getdata-007/CourseProject/UCI HAR Dataset/test")
testSubjects <- read.table("subject_test.txt", sep = "", blank.lines.skip = TRUE)
testLabel <- read.table("y_test.txt", sep = "", blank.lines.skip = TRUE)
testSet <- read.table("X_test.txt", sep = "", blank.lines.skip = TRUE)
test <- cbind(testSubjects, testLabel, testSet)

# Combine training and test data
setwd("~/Documents/JohnsHopkinsCoursera/getdata-007/CourseProject")
mergedData <- rbind(training, test)
 
#Rename columns with appropriate labels
names(mergedData)[1] <- "Subject"
names(mergedData)[2] <- "Activity"
names(mergedData)[3:ncol(mergedData)] <- make.names(as.character(features$V2), unique=TRUE)
names(mergedData) <- str_replace_all(names(mergedData), "[.][.]", "")

# Extracts only the measurements on the mean and standard deviation for each measurement
mergedData <- select(mergedData, Subject, Activity, contains(".mean."), contains(".std."))

# Replace activity codes with descriptive activity names
mergedData$Activity <- as.character(mergedData$Activity)
mergedData$Activity[mergedData$Activity == 1] <- "WALKING"
mergedData$Activity[mergedData$Activity == 2] <- "WALKING_UPSTAIRS"
mergedData$Activity[mergedData$Activity == 3] <- "WALKING_DOWNSTAIRS"
mergedData$Activity[mergedData$Activity == 4] <- "SITTING"
mergedData$Activity[mergedData$Activity == 5] <- "STANDING"
mergedData$Activity[mergedData$Activity == 6] <- "LAYING"

# Creates tidy data set with the average of each variable for each activity and each subject.
tidyDataSet <- mergedData %>% group_by(Subject,Activity) %>% summarise_each(funs(mean))

# write the tidy data set to a file for project submission
write.table(tidyDataSet, "tidyDataSet.txt", row.names=FALSE)


