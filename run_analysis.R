setwd("../Desktop/Aju/Coursera/UCI HAR Dataset")

run_analysis <- function(){
## read x files are read using the fixed-width-format
## widths parmater is generated using fixed width of 16 characters and repeating that 561 times as there are so many measurements per row
x_test <- read.fwf("./test/X_test.txt", header=FALSE, widths=c(rep(16,561)), buffersize=100)
x_train <- read.fwf("./train/X_train.txt", header=FALSE, widths=c(rep(16,561)), buffersize=100)

## read y files using read.csv
y_test <- read.csv("./test/y_test.txt", header=FALSE)
y_train <- read.csv("./train/y_train.txt", header=FALSE)

## read the subject information using read.csv
## use cbind to column_bind the subject, activity and x rows from test and train datasets

subject_test <- read.csv("./test/subject_test.txt", header=FALSE)
subject_train <- read.csv("./train/subject_train.txt", header=FALSE)


testdata <- cbind(subject_test, y_test, x_test)
traindata <- cbind(subject_train, y_train, x_train)

## change the columne names
names(testdata)[1] <- c("subject")
names(traindata)[1] <- c("subject")

## merge the test and train datasets using row bind as they are exactly the same columns
mergedata <- rbind(testdata, traindata)

## read the features file which can be used to set the column names for the 561 measurement columns in the merged data set
features <- read.csv("./features.txt", sep=" ", header=FALSE )
colnames(mergedata)[3:563] <- c(as.character(features[,2]))

## find all the columns which have "std" or "mean" in them and create a new dataframe which has all the rows with values only for those columns
test <- grep ("std|mean", colnames(mergedata), ignore.case=TRUE)
std_mean_data <- mergedata[,test]

## read the activity labels file
activity <- read.csv("./activity_labels.txt", sep=" ", header=FALSE)
## change the column name to activity_label
colnames(activity)[1:2] <- c("activity", "activity_label")
colnames(mergedata)[1:2] <- c("subject", "activity")

## merge the two tables - activity labels and mergedata - since merge adds the y related columns to the end, we pass activity as x and mergedata as y to merge() function
## also since we want all the rows to be present in mergedata (activity is more a lookup of the activity id's and labels), we pass all.y=TRUE
mergedata1 <- merge(activity, mergedata, by.x="activity", by.y="activity",all=FALSE, all.y=TRUE)


## aggregate() the data based on grouping of subject, activity_lable and activity. these grouping variables need to be fators in a list - - subject and activity are int and hence need to be converted to factor
## but activity_label is already is a factor and hence can be passed to the list as-is; pass the mean function as thats whats required
tidydataset <- aggregate(mergedata1, by=list(factor(mergedata1$subject), mergedata1[[2]], factor(mergedata1$activity)), FUN=mean, na.rm=TRUE)

## the dataframe created by aggregate now has three group columns one each for the grouping by subject, activity_label and activity. And it also tries to do the mean of those columns along with the other 561 measurement columns
## hence we remove the old 3 columns and rename the group columns
finaltidydataset <- tidydataset[,-(4:6)]
colnames(finaltidydataset)[1:3] <- c("subject", "activity_label", "activity")

## write the final tidy dataset to a file
write.table(finaltidydataset, file="./tidydata.txt", row.names=FALSE, sep=" ")

}
