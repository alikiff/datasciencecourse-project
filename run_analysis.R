library(plyr)

github="https://github.com/alikiff/datasciencecourse-project/raw/master/datasets/"

trainpath=paste(github,"train/X_train.txt",sep="")
trainlabels=paste(github,"train/y_train.txt",sep="")
train.subject.path=paste(github,"train/subject_train.txt",sep="")

testlabels=paste(github,"test/y_test.txt",sep="")
testpath=paste(github,"test/X_test.txt",sep="")
test.subject.path=paste(github,"test/subject_test.txt",sep="")

activitylabels=paste(github,"activity_labels.txt",sep="")

featurespath=paste(github,"features.txt",sep="")

#--------------------------------------------------------------------------

train.data=read.table(trainpath)
train.label=read.table(trainlabels,col.names="activity")
train.subject=read.table(train.subject.path,col.names="subject")

test.data=read.table(testpath)
test.label=read.table(testlabels,col.names="activity")
test.subject=read.table(test.subject.path,col.names="subject")
activity.label=read.table(activitylabels,col.names=c("activity","activity.name"))

data=rbind(train.data,test.data)
labels=rbind(train.label,test.label)
subjects=rbind(train.subject,test.subject)

#---------------------------------------------------------


features=read.table(featurespath)
colnames(data)=features[,2]
mean.std.features=c(grep("mean",features[,2]),grep("std",features[,2]))
mean.std.features=sort(mean.std.features)
data.mean.std=data[,mean.std.features]

#-----------------------------------------------------------------

data.final=cbind(data.mean.std,labels,subjects)
data.final=merge(data.final,activity.label,by="activity",sort=FALSE)

#-----------------------------------------------------------------------

data.final.kum=ddply(data.final,.(subject,activity,activity.name),numcolwise(mean))


write.table(data.final.kum, "ProjectFinalTidy.txt", sep=",") 
