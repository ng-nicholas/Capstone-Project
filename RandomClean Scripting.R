## Scripting file for data cleaning

# To pull in the data, perform data cleaning, remove special characters and
# prepare the text for further analysis. Need to figure out why read_lines pulls
# in funny characters. Also need to figure out how to clean for profanities.


# Loading packages for parallel computing and setting options
library("cluster")
library("parallel")
library("doSNOW")
coreNumber <- max(detectCores(),1)
cluster <- makeCluster(coreNumber, type = "SOCK",outfile="")
registerDoSNOW(cluster)

# Loading data manipulation packages
library("readr")
# library("data.table")
library("RCurl")
library("tm")
library("RWeka")

# Defining directories and setting working directory
print("# Defining and setting working directory...")
dirWork <- "~/GitHub/Capstone-Project/Coursera-SwiftKey/final/en_US/"
setwd(dirWork)

# Extracting filenames of matching data files
dataFiles <- grep("en_US", dir(dirWork), value = T)

# Setting seed for random sampling
print("# Setting seed...")
set.seed(100)

# Extracting subsets of files to create samples to work with
print("# Creating sample...")
randSample <- c()
for (i in 1:length(dataFiles)) {

    dataLines <- read_lines(dataFiles[i])

    randSample <- c(randSample, gsub("[^0-9A-Za-z///' ]", "",
                                     sample(dataLines, 1000)))

}

print("# Creating corpus...")
dataCorp <- VCorpus(VectorSource(randSample))

# Downloading profanity dictionary
urlpro <- "http://www.bannedwordlist.com/lists/swearWords.csv"
dictPro <- c(t(read.csv(text = getURL(urlpro), header = F)))

# Data transformations
print(paste0("# Text cleaning processes..."))
dataCorp <- tm_map(dataCorp, content_transformer(tolower)) # lower case
dataCorp <- tm_map(dataCorp, removePunctuation) # rm punct
dataCorp <- tm_map(dataCorp, removeNumbers) # rm numbers
dataCorp <- tm_map(dataCorp, removeWords, dictPro) # rm profanities
dataCorp <- tm_map(dataCorp, stripWhitespace) # strip whitespace
dataCorp <- tm_map(dataCorp, stemDocument, "english") # stemming

# Term Document Matrix
print(paste0("# Building term-document matrix..."))
dataTDM <- TermDocumentMatrix(dataCorp)

# Building N-grams
print(paste0("# Building n-gram tables..."))
dataDF <- data.frame(text = unlist(sapply(dataCorp, '[', "content")),
                     stringsAsFactors = F)
tokenDelims <- " \\t\\r\\n.!?,;\"()"
tokenUni <- NGramTokenizer(dataDF, Weka_control(min = 1, max = 1))
tokenBi <- NGramTokenizer(dataDF, Weka_control(min = 2, max = 2,
                                                delimiters = tokenDelims))
tokenTri <- NGramTokenizer(dataDF, Weka_control(min = 3, max = 3,
                                                delimiters = tokenDelims))
tableUni <- data.frame(table(tokenUni))
tableBi <- data.frame(table(tokenBi))
tableTri <- data.frame(table(tokenTri))

tableUni <- tableUni[order(tableUni$Freq, decreasing = TRUE), ]
tableBi <- tableBi[order(tableBi$Freq, decreasing = TRUE), ]
tableTri <- tableTri[order(tableTri$Freq, decreasing = TRUE), ]

# Clearing up variables
print(paste0("# Cleaning up..."))
rm(cluster, coreNumber, dataFiles, dirWork, dataLines, i, urlpro, dictPro,
   tokenDelims)

print("# Script complete!")
