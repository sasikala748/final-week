# Download the zip file and unzip it
# Create the working directory for the path of the file
# Read the file into the workspace
data <- file.path("C:/Users/GuruJithin/Desktop/Coursera/UCI HAR Dataset")
files <- list.files(data,recursive=TRUE)
files

#Load the dplyr package into R studio
library(dplyr)

# Initialize and read all the dataframes from the files into R studio and give the column names for each of the dataset 
activities <- read.table("C:/Users/GuruJithin/Desktop/Coursera/UCI HAR Dataset/activity_labels.txt",
                         col.names=c("code","activity"))
features <- read.table("C:/Users/GuruJithin/Desktop/Coursera/UCI HAR Dataset/features.txt",
                       col.names=c("number","functions"))

#Read all the files from the test dataset
x_test <-read.table("C:/Users/GuruJithin/Desktop/Coursera/UCI HAR Dataset/test/X_test.txt",
                    col.names=features$functions)
y_test <-read.table("C:/Users/GuruJithin/Desktop/Coursera/UCI HAR Dataset/test/y_test.txt",
                    col.names="code")
subject_test <-read.table("C:/Users/GuruJithin/Desktop/Coursera/UCI HAR Dataset/test/subject_test.txt",
                    col.names="subject")

# Read all the files from the train data set
x_train <-read.table("C:/Users/GuruJithin/Desktop/Coursera/UCI HAR Dataset/train/X_train.txt",
                    col.names=features$functions)
y_train <-read.table("C:/Users/GuruJithin/Desktop/Coursera/UCI HAR Dataset/train/y_train.txt",
                     col.names="code")
subject_train <-read.table("C:/Users/GuruJithin/Desktop/Coursera/UCI HAR Dataset/train/subject_train.txt",
                          col.names="subject")
# Now from the assignment we are asked to merge the test and train data sets together to create a single data set
X <- rbind(x_train,x_test)
Y <- rbind(y_train,y_test)
Subject <- rbind(subject_train,subject_test)
data_merged <- cbind(Subject,Y,X)
# The datas are merged with the above code

# The next step is to make the data set tidy with select function and pipeline operator
data_tidy <- data_merged%>%
        select(subject,code,contains("mean"),contains("std"))
# The data looks tidy with the above set of code

# The next step is to use the describing activity names to name the data set activities
data_tidy$code <- activities[data_tidy$code,2]

#The next step is give the appropriate names for the variables with descriptive names for clear understanding
names(data_tidy)[2] <- "activity"
names(data_tidy) <- gsub("Acc","Accelerometer",names(data_tidy))
names(data_tidy) <- gsub("Gyro","Gyroscope",names(data_tidy))
names(data_tidy) <- gsub("BodyBody", "Body",names(data_tidy))
names(data_tidy) <- gsub("Mag", "Magnitude",names(data_tidy))
# The "^t" and "^f" indicates the letter starts with t as Time and f as Frequency
names(data_tidy) <- gsub("^t", "Time",names(data_tidy))  
names(data_tidy) <- gsub("^f", "Frequency",names(data_tidy))
names(data_tidy) <- gsub("tBody", "TimeBody",names(data_tidy))
names(data_tidy) <- gsub("-mean()","Mean",names(data_tidy))
names(data_tidy) <- gsub("-std()", "STD",names(data_tidy))
names(data_tidy) <- gsub("-freq()", "Frequency",names(data_tidy))
names(data_tidy) <- gsub("angle", "Angle",names(data_tidy))
names(data_tidy) <- gsub("gravity", "Gravity",names(data_tidy))
# The appropriate descriptive names are given with the above code
# The end reaching step is to create an independent data set with an average of each subject and the activituy
Result_data <- data_tidy %>%
        group_by(subject, activity) %>%
        summarise_all(list(mean))
# The final step is to write the Result_data in a text format using write.table function
write.table(Result_data,"Result_data.txt",row.names=FALSE)
                    



