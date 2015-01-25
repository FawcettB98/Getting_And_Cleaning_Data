#Open plyr, dplyr and tidyr packages
library(plyr)
library(dplyr)
library(tidyr)

#Read the tables into R

test_set<-read.table(".\\CourseAssignment\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\X_test.txt")
test_labels<-read.table(".\\CourseAssignment\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\y_test.txt")
test_subject<-read.table(".\\CourseAssignment\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\test\\subject_test.txt")
train_set<-read.table(".\\CourseAssignment\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\X_train.txt")
train_labels<-read.table(".\\CourseAssignment\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\y_train.txt")
train_subject<-read.table(".\\CourseAssignment\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\train\\subject_train.txt")
activity_labels<-read.table(".\\CourseAssignment\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\activity_labels.txt")
features<-read.table(".\\CourseAssignment\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\features.txt")

#Add a column to test_set and train_set indicating whether test or train
test_set<-mutate(test_set,set="test")
train_set<-mutate(train_set,set="train")

### PROJECT STEP #1
#Combine data sets
total_set<-rbind(test_set,train_set)
total_labels<-rbind(test_labels,train_labels)
total_subject<-rbind(test_subject,train_subject)

### PROJECT STEP #2
#Extract only measurments on mean and standard deviation - using measurement descriptions found in "features"
total_set_extract<-total_set[,grep("mean()|std()",features$V2)]

### PROJECT STEP #3
#Rename columns of total_set_extract using measurement descriptions found in "features"
#Remove some aspects of the names to facilitate later transformations
colnames<-grep("mean()|std()",features$V2,value=TRUE)
names(total_set_extract)<-colnames
names(total_set_extract)<-gsub("-","_",names(total_set_extract))
names(total_set_extract)<-gsub("()","",names(total_set_extract),fixed=TRUE)

#Append "set", "Label" and "subject" to total_set_extract
total_set_extract<-mutate(total_set_extract,set=total_set$set,label=total_labels$V1,subject=total_subject$V1)

### PROJECT STEP #4
#Add describtive names to activities
total_set_merged<-merge(total_set_extract,activity_labels,by.x="label",by.y="V1")

#Re-order the columns
total_set_merged<-select(total_set_merged,subject,activity_label=V2,set,tBodyAcc_mean_X:fBodyBodyGyroJerkMag_meanFreq)

### total_set_merged is the data set after step 4.  It will be used as the starting point for step 5

tidy_data <- total_set_merged

tidy_data <- gather(tidy_data,feature,measurement,-(subject:set)) 
tidy_data <- separate(tidy_data,col=feature,into=c("feature","stat"),extra="merge") 
tidy_data <- separate(tidy_data,col=stat,into=c("stat","direction"),extra="merge")
tidy_data <- group_by(tidy_data,subject,activity_label,set,feature,stat,direction)
tidy_data <- summarize(tidy_data,average_measurement=mean(measurement))
