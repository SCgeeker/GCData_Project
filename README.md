### Data Source
The unziped files are stored in the directory *../UCI HAR Dataset/* that is out of the working directory. The data have to be summarized include the subjects' activity records stored in Traing set *x_train.txt* and in Test set *x_test.txt*. Subject IDs of Train set and Test set are stroed in *subject_train.txt* and *subject_test.txt*. Activity type of each record are stored in *y_train.txt* and *y_test.txt*. At first these files are merged into the raw data set `RAW_DT` incuding the columns of subject ID, activity type, and 561 feature vectors. The variable names of features are stored in `features.txt`.   

### Study Design: major steps in *run_analysis.R*
**Step 1.** Create Train set `Train_DT` and Test set `Test_DT` and merge them into raw data table `RAW_DT`.Subject ID is transformed to the style described in `codebook.md`.
```
Train_ID <- 100 + read.table(File_ls[24], col.names = "ID")  #subject_train.txt
Train_ACT <- read.table(File_ls[26], col.names = "ACT_CODE") #y_train.txt
Train_Features <- read.table(File_ls[25])                    #x_train.txt
Train_DT <- data.table(Train_ID, Train_ACT, Train_Features)

Test_ID <- 200 + read.table(File_ls[11], col.names = "ID")   #subject_test.txt
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

**Step 5.** Calcuate average values of targeted features by activity and subject. The output tidy data is stored in the external file `TidyD01.txt`. My script firstly write the vaiable names (see `codebook.md`) then append the data under each column.    
```
ColNAMES <- c("ID","Activity",as.character(Extract_Features))   # Listed in codebook.md
write(ColNAMES,file="TidyD01.txt",ncolumns = length(ColNAMES), sep = ",")
write.table(data.table(substr(Tidy_DT[,paste0],1,3),substr(Tidy_DT[,paste0],4,7),Tidy_DT[,!1,with=FALSE]), file = "TidyD01.txt", quote = FALSE, sep = ",",col.names = FALSE,row.names=FALSE, append=TRUE )
```