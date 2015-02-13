### Content


### Data Source
The full data set is from [UCI machine learning repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). The initial codes as following donwnload the [raw data set](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and extracted the files to the directory *../UCI HAR Dataset/* out of the working directory.  
```
ProjectName <- "/GCData_Project"
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "../Dataset.zip")
if(!file.exists("../UCI HAR Dataset")) {
  unzip("../Dataset.zip", exdir = gsub(ProjectName,"",getwd()))  
}
File_ls <- dir("../UCI HAR Dataset/", all.files = TRUE, full.names = TRUE, recursive = TRUE, include.dirs = TRUE)

```


### Structure of raw data
Processed data include the subjects' activity records stored in Traing set *x_train.txt* and in Test set *x_test.txt*. Subject IDs of Train set and Test set are stroed in *subject_train.txt* and *subject_test.txt*. Activity type of each record are stored in *y_train.txt* and *y_test.txt*. At first these files are merged into the raw data set `RAW_DT` incuding the columns of subject ID, activity type, and 561 feature vectors. The variable names of features are stored in `features.txt`.   

### Study Design: Critial steps in *run_analysis.R*
**Step 1.** Create Train set `Train_DT` and Test set `Test_DT` and merge them into raw data table `RAW_DT`.Subject ID is transformed to the style described in `codebook.md`.
```
Train_ID <- read.table(File_ls[24], col.names = "ID")  #subject_train.txt
Train_ACT <- read.table(File_ls[26], col.names = "ACT_CODE") #y_train.txt
Train_Features <- read.table(File_ls[25])                    #x_train.txt
Train_DT <- data.table(Train_ID, Train_ACT, Train_Features)

Test_ID <- read.table(File_ls[11], col.names = "ID")   #subject_test.txt
Test_ACT <- read.table(File_ls[13], col.names = "ACT_CODE")  #y_test.txt
Test_Features <- read.table(File_ls[12])                     #x_test.txt
Test_DT <- data.table(Test_ID, Test_ACT, Test_Features)

RAW_DT <- rbind(Train_DT, Test_DT)
```
**Step 2.** Extract the feature names having 'mean()' and 'std()' from *features.txt*. There are 79 features have to be extracted. These data are stored in new data table `RAW_Extract`. This data table is going to be processed after this step.    
```
pattern1 <- "mean()"
pattern2 <- "std()"
Extract_Features <- Features$V2[c(grep(pattern1, Features$V2), grep(pattern2, Features$V2))]
ColP <- c((2+grep(pattern1, Features$V2)),(2+grep(pattern2, Features$V2)))
RAW_Extract <- RAW_DT[,c(1,2,ColP),with=FALSE]
```

**Step 3.** Create vector `RAW_Activity` to store the original activity lables mapping to `ACT_CODE` in `RAW_DT`.    
```
RAW_Activity = RAW_DT$ACT_CODE
for(i in 1:6) {RAW_Activity <- gsub(ACT_Label$V1[i], ACT_Label$V2[i], RAW_Activity)}
```

**Step 4.** Replace the original activity labels with the abbreviated names(see `codebook.md`).   
```
RAW_Activity1 = RAW_DT$ACT_CODE
RAW_Extract[,ACT_CODE:= paste0(substr(RAW_Activity,1,3),RAW_Activity1)]
```

**Step 5.** Calcuate average values of targeted features by activity and subject. The output tidy data is stored in the external file `TidyDT.txt`. My script firstly write the vaiable names (see `codebook.md`) then append the data under each column.    
```
Tidy_DT <- RAW_Extract[,lapply(.SD,mean),by=paste0(ACT_CODE,ID)]

ColNAMES <- c("ID","Activity",as.character(Extract_Features))
write(ColNAMES,file="TidyDT.txt",ncolumns = length(ColNAMES), sep = ",")
write.table(data.table(substr(Tidy_DT[,paste0],5,6),substr(Tidy_DT[,paste0],1,4),Tidy_DT[,!1,with=FALSE]), file = "TidyDT.txt", quote = FALSE, sep = ",",col.names = FALSE,row.names=FALSE, append=TRUE )
```