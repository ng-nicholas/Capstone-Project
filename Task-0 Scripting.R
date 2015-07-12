## Scripting file for Task 1

# Loading packages for parallel computing and setting options
library("cluster")
library("parallel")
library("doSNOW")
coreNumber <- max(detectCores(),1)
cluster <- makeCluster(coreNumber, type = "SOCK",outfile="")
registerDoSNOW(cluster)

# Loading package for NLP
library("tm")

# Defining directories and setting working directory
print("# Defining and setting working directory...")
dirWork <- "C:/Users/Nicholas/Documents/GitHub/Capstone-Project/"
dirData <- "./Coursera-SwiftKey/final/en_US/"
dirCorp <- "./Corpus/"
if (dir.exists(dirCorp) == F) {
    dir.create(dirCorp)
}
setwd(dirWork)

# Creating a permanent corpus for working on files
print("# Creating a permanent corpus to save memory...")
corpText <- PCorpus(DirSource(dirData),
                    readerControl = list(reader = readPlain,
                                         language = "en_US"),
                    dbControl = list(dbName = paste0(dirCorp, "ProjectTexts.db"),
                                     dbType = "DB1"))

# Finding the longest line in the en_US data sets
print("# Loading the blogs and news data and finding length of longest line...")
dataBlogsNews <- lapply(corpText[1:2], as.character)
maxBlogs <- max(nchar(dataBlogsNews$en_US.blogs.txt))
maxNews <- max(nchar(dataBlogsNews$en_US.news.txt))
rm(dataBlogsNews)
print(paste("The longest line in en_US.blogs.txt is", maxBlogs,
            "and the same for en_US.news.txt is", maxNews, "."))

# Finding the ratio of lines with love/hate
print("# Loading the twitter data and finding length of longest line...")
dataTwit <- lapply(corpText[3], as.character)
loveCount <- sum(grepl("love", dataTwit))
hateCount <- sum(grepl("hate", dataTwit))
loveHateRatio <- loveCount / hateCount
rm(dataTwit)
