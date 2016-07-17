library(data.table)
library(dplyr)

setwd("C:\\Users\\Gemma\\Documents\\GettingAndCleaningData")

#download zip file

dirPath<-"./data"

if(!file.exists(dirPath)){
        dir.create(dirPath)
}

file<-"HARUS.zip"
pathFile<-file.path(dirPath,file)


fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl, destfile= pathFile, mode="wb")

unzip(pathFile,list = FALSE, overwrite = TRUE)

#the unzip function put files into a folder named "UCI HAR Dataset". Define the path to the files
pathFiles<-file.path(dirPath,"UCI HAR Dataset")
list.files(pathFiles, recursive=TRUE)

#Function to read a file and load it to a data.table type
fileToDataTable <- function(f){
        
        df<-read.table(file.path(pathFiles, f), stringsAsFactors = F)
        data.table(df)
        
}

#read the training data files
dtXTrain <- fileToDataTable("train/X_train.txt")
dtYTrain <- fileToDataTable("train/y_train.txt")
dtSubjectTrain <- fileToDataTable("train/subject_train.txt")

#read the test data files
dtXTest <- fileToDataTable("test/X_test.txt")
dtYTest <- fileToDataTable("test/y_test.txt")
dtSubjectTest <- fileToDataTable("test/subject_test.txt" )

#read the features
dtFeatures <- fileToDataTable("features.txt")
names(dtFeatures)<- c("FeatureNum", "FeatureName")

#read the activity labels
dtActivityLab<- fileToDataTable("activity_labels.txt")
names(dtActivityLab)<- c("ActivityNum", "ActivityName")

#Extracts only the measurements on the mean and standard deviation for each measurement.
meanStdFeatures<-grep("mean|std\\(\\)",dtFeatures$FeatureName)

dtXTrain<-dtXTrain %>%
               select(meanStdFeatures)

dtXTest<-dtXTest %>%
              select(meanStdFeatures)

#merge the training and test data sets
dtTRAIN <- cbind(dtSubjectTrain,dtYTrain, dtXTrain)
dtTEST <- cbind(dtSubjectTest,dtYTest, dtXTest)

dt<- rbind(dtTEST,dtTRAIN)

#Appropriately labels the data set with descriptive variable names for the measurements selected before
names(dt)<-c("Subject", "Activity", dtFeatures$FeatureName[meanStdFeatures])


#remove unnecessary data.tables
rm(dtTRAIN)
rm(dtXTrain)
rm(dtYTrain)
rm(dtSubjectTrain)

rm(dtTEST)
rm(dtXTest)
rm(dtYTest)
rm(dtSubjectTest)


#Uses descriptive activity names to name the activities in the data set
dt <-mutate(dt, Activity=factor(Activity, levels = dtActivityLab$ActivityNum, labels = dtActivityLab$ActivityName))
View(dt)


#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
dtMelted <- melt(dt, id = c("Subject", "Activity"))
dtMean <- dcast(dtMelted, Subject + Activity ~ variable, mean)
write.table(dtMean, file.path(dirPath,"averageBySubjectActivity.txt"), row.name=FALSE)
