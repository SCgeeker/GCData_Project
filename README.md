---
title: "Geting and Cleaning Data Project"
author: "Sau-Chin Chen"
date: "Sunday, January 18, 2015"
output: html_document
---
    
## Code Book: structure of variables
This project processed the raw data stored in Traing set `x_train.txt` and Test set `x_test.txt`. The lables of subject ID and activity are stored in `y_train.txt`, `subject_train.txt`,`y_test.txt`, and `subject_test.txt`. These files will be complied in to a raw data set. This data set has 563 columns that incude subject ID, activity, and 561 measured features. The variable names of features are stored in `features.txt`.    
    
In the end of this process, the tidy data has the averaged values of 79 features across activity and subject. The ID and Activity are transformed for the demands of this process. Here are the variable names of the tidy data and the corresponding descriptions.    

**ID**   
 Initial 1 refers to the subjects in train set.   
 Initial 2 refers to the subjects in test set.   
    
**Activity**   
 WAL1 == WALKING   
 WAL2 == WALKING_UPSTAIRS   
 WAL3 == WALKING_DOWNSTAIRS   
 SIT4 == SITTING   
 STA5 == STANDING   
 LAY6 == LAYING   
    
**List of 79 Feature Names**    
tBodyAcc-mean()-X,tBodyAcc-mean()-Y,tBodyAcc-mean()-Z,tGravityAcc-mean()-X,tGravityAcc-mean()-Y,tGravityAcc-mean()-Z,tBodyAccJerk-mean()-X,tBodyAccJerk-mean()-Y,tBodyAccJerk-mean()-Z,tBodyGyro-mean()-X,tBodyGyro-mean()-Y,tBodyGyro-mean()-Z,tBodyGyroJerk-mean()-X,tBodyGyroJerk-mean()-Y,tBodyGyroJerk-mean()-Z,tBodyAccMag-mean(),tGravityAccMag-mean(),tBodyAccJerkMag-mean(),tBodyGyroMag-mean(),tBodyGyroJerkMag-mean(),fBodyAcc-mean()-X,fBodyAcc-mean()-Y,fBodyAcc-mean()-Z,fBodyAcc-meanFreq()-X,fBodyAcc-meanFreq()-Y,fBodyAcc-meanFreq()-Z,fBodyAccJerk-mean()-X,fBodyAccJerk-mean()-Y,fBodyAccJerk-mean()-Z,fBodyAccJerk-meanFreq()-X,fBodyAccJerk-meanFreq()-Y,fBodyAccJerk-meanFreq()-Z,fBodyGyro-mean()-X,fBodyGyro-mean()-Y,fBodyGyro-mean()-Z,fBodyGyro-meanFreq()-X,fBodyGyro-meanFreq()-Y,fBodyGyro-meanFreq()-Z,fBodyAccMag-mean(),fBodyAccMag-meanFreq(),fBodyBodyAccJerkMag-mean(),fBodyBodyAccJerkMag-meanFreq(),fBodyBodyGyroMag-mean(),fBodyBodyGyroMag-meanFreq(),fBodyBodyGyroJerkMag-mean(),fBodyBodyGyroJerkMag-meanFreq(),tBodyAcc-std()-X,tBodyAcc-std()-Y,tBodyAcc-std()-Z,tGravityAcc-std()-X,tGravityAcc-std()-Y,tGravityAcc-std()-Z,tBodyAccJerk-std()-X,tBodyAccJerk-std()-Y,tBodyAccJerk-std()-Z,tBodyGyro-std()-X,tBodyGyro-std()-Y,tBodyGyro-std()-Z,tBodyGyroJerk-std()-X,tBodyGyroJerk-std()-Y,tBodyGyroJerk-std()-Z,tBodyAccMag-std(),tGravityAccMag-std(),tBodyAccJerkMag-std(),tBodyGyroMag-std(),tBodyGyroJerkMag-std(),fBodyAcc-std()-X,fBodyAcc-std()-Y,fBodyAcc-std()-Z,fBodyAccJerk-std()-X,fBodyAccJerk-std()-Y,fBodyAccJerk-std()-Z,fBodyGyro-std()-X,fBodyGyro-std()-Y,fBodyGyro-std()-Z,fBodyAccMag-std(),fBodyBodyAccJerkMag-std(),fBodyBodyGyroMag-std(),fBodyBodyGyroJerkMag-std()   

## Study Design and description of the script
**Step 1.** Load the Train set and Test set to a data table `RAW_DT`.Subject ID had been transformed to the described style in the code book.    
```
require(data.table)
Train_ID <- 100 + read.table(File_ls[30], col.names = "ID")
Train_ACT <- read.table(File_ls[32], col.names = "ACT_CODE")
Train_Features <- read.table(File_ls[31])
Train_DT <- data.table(Train_ID, Train_ACT, Train_Features)

Test_ID <- 200 + read.table(File_ls[16], col.names = "ID")
Test_ACT <- read.table(File_ls[18], col.names = "ACT_CODE")
Test_Features <- read.table(File_ls[17])
Test_DT <- data.table(Test_ID, Test_ACT, Test_Features)

RAW_DT <- rbind(Train_DT, Test_DT)
```
**Step 2.** Extract the feature names having 'mean()' and 'std()' from `features.txt`. The respective columns in `RAW_DT` are stored in a new data table `RAW_Extract`. This data table will be processed in the following steps.    
```
pattern1 <- "mean()"
pattern2 <- "std()"
Extract_Features <- Features$V2[c(grep(pattern1, Features$V2), grep(pattern2, Features$V2))]
ColP <- c((2+grep(pattern1, Features$V2)),(2+grep(pattern2, Features$V2)))
RAW_Extract <- RAW_DT[,c(1,2,ColP),with=FALSE]
```

**Step 3.** Create the object `RAW_Activity` to store the vector of descriptive activity names transformed from `ACT_CODE`.    
```
RAW_Activity = RAW_DT$ACT_CODE
for(i in 1:6) {RAW_Activity <- gsub(ACT_Label$V1[i], ACT_Label$V2[i], RAW_Activity)}
```

**Step 4.** Replace the units of `ACT_CODE` with the labels described in the code book.   
```
RAW_Activity1 = RAW_DT$ACT_CODE
RAW_Extract[,ACT_CODE:= paste0(substr(RAW_Activity,1,3),RAW_Activity1)]
```

**Step 5.** Calcuate averages of features by activity and subject. The output is stored in the external file `TidyD01.txt`. My script firstly write the colnum names then append the tidy data.    
```
ColNAMES <- c("ID","Activity",as.character(Extract_Features))
write(ColNAMES,file="TidyD01.txt",ncolumns = length(ColNAMES), sep = ",")
write.table(data.table(substr(Tidy_DT[,paste0],1,3),substr(Tidy_DT[,paste0],4,7),Tidy_DT[,!1,with=FALSE]), file = "TidyD01.txt", quote = FALSE, sep = ",",col.names = FALSE,row.names=FALSE, append=TRUE )
```