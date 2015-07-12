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

# Loading data manipulation packages
library("dplyr")

# Defining directories and setting working directory
print("# Defining and setting working directory...")
dirWork <- "C:/Users/Nicholas/Documents/GitHub/Capstone/"
dirData <- "./Data/"
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

# Storing data in data tables
dataText <- lapply(corpText, as.character)
dataBlogs <- data.table(dataText$en_US.blogs.txt)
dataNews <- data.table(dataText$en_US.news.txt)
dataTwit <- data.table(dataText$en_US.twitter.txt)
names(dataBlogs) <- "textData"
names(dataNews) <- "textData"
names(dataTwit) <- "textData"
rm(dataText)

# Generating statistics of each element in each data table
dataBlogs <- dataBlogs %>%
                mutate(chrCount = nchar(textData),
                       wordCount = gregexpr("[[:alpha:]]+", textData))

# Data cleaning on the corpus
corpText <- tm_map(corpText, stripWhitespace)
corpText <- tm_map(corpText, content_transformer(gsub("[:punct:]", "")))
