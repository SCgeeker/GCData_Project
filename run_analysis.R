# Load the raw data from the zip File
ProjectName <- "/GCData_Project"
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "../Dataset.zip")
if(!file.exists("../UCI HAR Dataset")) {
  unzip("../Dataset.zip", exdir = gsub(ProjectName,"",getwd()))  
}
File_ls <- dir("../UCI HAR Dataset/", all.files = TRUE, full.names = TRUE, recursive = TRUE, include.dirs = TRUE)

# Get the labels of activity
ACT_Label <- read.table(File_ls[27])
# Get the variable names of features
Features <- read.table(File_ls[28])

# 1.Load data.table of Train and Test
# Subject ID from Train append the initial '1'
# Subject ID from Test append the initial '2'
require(data.table)
Train_ID <- read.table(File_ls[24], col.names = "ID")
Train_ACT <- read.table(File_ls[26], col.names = "ACT_CODE")
Train_Features <- read.table(File_ls[25])
Train_DT <- data.table(Train_ID, Train_ACT, Train_Features)

Test_ID <- read.table(File_ls[11], col.names = "ID")
Test_ACT <- read.table(File_ls[13], col.names = "ACT_CODE")
Test_Features <- read.table(File_ls[12])
Test_DT <- data.table(Test_ID, Test_ACT, Test_Features)

RAW_DT <- rbind(Train_DT, Test_DT)
rm(Train_ID,Train_ACT,Train_Features,Train_DT,Test_ID,Test_DT,Test_ACT,Test_Features)

## 2.Extract the features of mean() and std()
# define the target patterns in the variable names
pattern1 <- "mean+"
pattern2 <- "std+"
# Store the labels of features
Extract_Features <- Features$V2[c(grep(pattern1, Features$V2), grep(pattern2, Features$V2))]

# Locate the column to be extracted
ColP <- c((2+grep(pattern1, Features$V2)),(2+grep(pattern2, Features$V2)))

RAW_Extract <- RAW_DT[,c(1,2,ColP),with=FALSE]


## 3.Update the labels of activity
RAW_Activity = RAW_DT$ACT_CODE
for(i in 1:6) {RAW_Activity <- gsub(ACT_Label$V1[i], ACT_Label$V2[i], RAW_Activity)}

# Merge the extracted data
# 4.Change the labels of Activity for final step
# All labels have a length =  4 (Initial 3 letters + number of original code)
RAW_Activity1 = RAW_DT$ACT_CODE
RAW_Extract[,ACT_CODE:= paste0(substr(RAW_Activity,1,3),RAW_Activity1)]

# Averages of features by activity and subject
Tidy_DT <- RAW_Extract[,lapply(.SD,mean),by=paste0(ACT_CODE,ID)]

# 5. Save the Tidy data
ColNAMES <- c("ID","Activity",as.character(Extract_Features))
write(ColNAMES,file="TidyDT.txt",ncolumns = length(ColNAMES), sep = ",")
write.table(data.table(substr(Tidy_DT[,paste0],5,6),substr(Tidy_DT[,paste0],1,4),Tidy_DT[,!1,with=FALSE]), file = "TidyDT.txt", quote = FALSE, sep = ",",col.names = FALSE,row.names=FALSE, append=TRUE )
