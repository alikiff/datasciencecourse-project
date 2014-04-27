Coursera "Getting and Cleaning Data" - Project
========================================================
Script-Description
========================================================
```
library(plyr)
```
### Setting the Github paths for the relevant datasets
```
github="https://github.com/alikiff/datasciencecourse-project/raw/master/datasets/"

trainpath=paste(github,"train/X_train.txt",sep="")
trainlabels=paste(github,"train/y_train.txt",sep="")
train.subject.path=paste(github,"train/subject_train.txt",sep="")

testlabels=paste(github,"test/y_test.txt",sep="")
testpath=paste(github,"test/X_test.txt",sep="")
test.subject.path=paste(github,"test/subject_test.txt",sep="")

activitylabels=paste(github,"activity_labels.txt",sep="")

featurespath=paste(github,"features.txt",sep="")
```
* "X_train.txt" contains the training data without the labels
* "y-train.txt" contains the traing data labels (activities)
* "subject_train.txt" contains the subjects belonging to the train data entrys
* "X_test.txt" contains the test data without the labels
* "y_test.txt" contains the test data labels (activities)
* "activity_labels.txt" contains the written activity descriptions
* "subject_test.txt" contains the subjects belonging to the test data entrys
* "features.txt" contains the variable names for the (train/test) data

### Creating the relevant raw datasets

```
train.data=read.table(trainpath)
train.label=read.table(trainlabels,col.names="activity")
train.subject=read.table(train.subject.path,col.names="subject")

test.data=read.table(testpath)
test.label=read.table(testlabels,col.names="activity")
test.subject=read.table(test.subject.path,colnames="subject")
activity.label=read.table(activitylabels,col.names=c("activity","activity.name"))
```

* "train.data" is the training data set, where each row represents an activity
  of an subject, which are stored in the datasets
* "train.label" and
* "train.subject"
* "test.data" is the test data set, where also each row represents an activity of  
 an subject, which are stored in the datasets
* "test.label"
* "test.subject" 
* "activity.label" is the dataset, which contains the written descriptions
  of the persons activities. These are abbreviated with numbers in the
  training/test-data
  
### Combining the training/test - data/labels/subjects
```
data=rbind(train.data,test.data)
labels=rbind(train.label,test.label)
subjects=rbind(train.subject,test.subject)
```

### Adding and Filtering the variable names
```
features=read.table(featurespath)
colnames(data)=features[,2]
mean.std.features=c(grep("mean",features[,2]),grep("std",features[,2]))
mean.std.features=sort(mean.std.features)
data.mean.std=data[,mean.std.features]
```
* The table "features" contains the variable names. From them we are filtering   out the names containing "mean" and "std" , leaving only the variables, which are corresponding to the mean and standard deviation of the measurements. Finally we are subsetting the combined training/test-data with these variables.

### Creating the complete tidy data set
```
data.final=cbind(data.mean.std,labels,subjects)
data.final=merge(data.final,activity.label,by="activity",sort=FALSE)
```


First we combine the measurement variables, the activitys and the subjects into the dataset "data.final".

Finally we substitute the numerical activity codes with the activity labels found in the "activity-label" dataset. The so created variable is called "activity.name"

### Creating the averages over all subjects/activities

```
data.final.kum=ddply(data.final,.(subject,activity,activity.name),numcolwise(mean))
```
At the very end we are summarizing over all subject-activity combinations
and taking the averages over all the numeric measurement variables. Thats how we create the final, tidy dataset.
