## Code Book: Structure of tidy data
Tidy data set **TidyD01.txt** stores the **averaged values** of 79 targeted features across activity and subject. First and second column resprsent `ID` and `Activity`. The resting 79 columns store the averaged values of feature factors. Total 180 oversvations are summarized.

####ID
  Each ID has 3 numbers.
  
  Initial 1 refers to the subjects from **train set**.   
  Initial 2 refers to the subjects from **test set**.   
  The resting 2 numbers are from raw data set.
    
####Activity
 Original labels in *activity_labels.txt* are transformed as following:    
 
 WAL1 == WALKING   
 WAL2 == WALKING_UPSTAIRS   
 WAL3 == WALKING_DOWNSTAIRS   
 SIT4 == SITTING   
 STA5 == STANDING   
 LAY6 == LAYING   
    
#### 79 variable names of features
Retrieve the following variable names from *features.txt*. See step 2.

tBodyAcc-mean()-X,tBodyAcc-mean()-Y,tBodyAcc-mean()-Z,tGravityAcc-mean()-X,tGravityAcc-mean()-Y,tGravityAcc-mean()-Z,tBodyAccJerk-mean()-X,tBodyAccJerk-mean()-Y,tBodyAccJerk-mean()-Z,tBodyGyro-mean()-X,tBodyGyro-mean()-Y,tBodyGyro-mean()-Z,tBodyGyroJerk-mean()-X,tBodyGyroJerk-mean()-Y,tBodyGyroJerk-mean()-Z,tBodyAccMag-mean(),tGravityAccMag-mean(),tBodyAccJerkMag-mean(),tBodyGyroMag-mean(),tBodyGyroJerkMag-mean(),fBodyAcc-mean()-X,fBodyAcc-mean()-Y,fBodyAcc-mean()-Z,fBodyAcc-meanFreq()-X,fBodyAcc-meanFreq()-Y,fBodyAcc-meanFreq()-Z,fBodyAccJerk-mean()-X,fBodyAccJerk-mean()-Y,fBodyAccJerk-mean()-Z,fBodyAccJerk-meanFreq()-X,fBodyAccJerk-meanFreq()-Y,fBodyAccJerk-meanFreq()-Z,fBodyGyro-mean()-X,fBodyGyro-mean()-Y,fBodyGyro-mean()-Z,fBodyGyro-meanFreq()-X,fBodyGyro-meanFreq()-Y,fBodyGyro-meanFreq()-Z,fBodyAccMag-mean(),fBodyAccMag-meanFreq(),fBodyBodyAccJerkMag-mean(),fBodyBodyAccJerkMag-meanFreq(),fBodyBodyGyroMag-mean(),fBodyBodyGyroMag-meanFreq(),fBodyBodyGyroJerkMag-mean(),fBodyBodyGyroJerkMag-meanFreq(),tBodyAcc-std()-X,tBodyAcc-std()-Y,tBodyAcc-std()-Z,tGravityAcc-std()-X,tGravityAcc-std()-Y,tGravityAcc-std()-Z,tBodyAccJerk-std()-X,tBodyAccJerk-std()-Y,tBodyAccJerk-std()-Z,tBodyGyro-std()-X,tBodyGyro-std()-Y,tBodyGyro-std()-Z,tBodyGyroJerk-std()-X,tBodyGyroJerk-std()-Y,tBodyGyroJerk-std()-Z,tBodyAccMag-std(),tGravityAccMag-std(),tBodyAccJerkMag-std(),tBodyGyroMag-std(),tBodyGyroJerkMag-std(),fBodyAcc-std()-X,fBodyAcc-std()-Y,fBodyAcc-std()-Z,fBodyAccJerk-std()-X,fBodyAccJerk-std()-Y,fBodyAccJerk-std()-Z,fBodyGyro-std()-X,fBodyGyro-std()-Y,fBodyGyro-std()-Z,fBodyAccMag-std(),fBodyBodyAccJerkMag-std(),fBodyBodyGyroMag-std(),fBodyBodyGyroJerkMag-std()   
