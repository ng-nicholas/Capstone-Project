## Scripting file for Task 1

# Loading packages for parallel computing and setting options
library("cluster")
library("parallel")
library("doSNOW")
coreNumber <- max(detectCores(),1)
cluster <- makeCluster(coreNumber, type = "SOCK",outfile="")
registerDoSNOW(cluster)

# Loading data cleaning package
library("dplyr")

# Defining directories and setting working directory
print("# Defining and setting working directory...")
dirWork <- "~/GitHub/Capstone-Project/Coursera-SwiftKey/final/en_US/"
setwd(dirWork)
rm(dirWork)

# The following lines of code will print out the answers to the questions
print("# Question 1: The en_US.blogs.txt file is how many megabytes?")
dirDetails <- strsplit(gsub("\\s{2,}", "", system("ls -alh", intern = T)),
                       split = "\\s")
for (i in 1:length(dirDetails)) {
    if ("en_US.blogs.txt" %in% dirDetails[[i]]) {
        answer1 <- dirDetails[[i]][4]
    }
}
print(paste0(">> The file is ", gsub("[:alpha:]", "", answer1), "Mb large."))
rm(dirDetails, answer1)

print("# Question 2: The en_US.twitter.txt has how many lines of text?")
answer2 <- strsplit(gsub("\\s{2,}", "", system("wc -l en_US.twitter.txt",
                                               intern = T)),
                    split = "\\s")[[1]][1]
print(paste0(">> There are ", answer2, " lines of text in the file."))

print("# Question 3: What is the length of the longest line seen in any of the
      three en_US data sets?")
lineList <- strsplit(gsub("\\s{2,}", "", system("wc -L *.txt", intern = T)),
                     split = "\\s")
lineList <- lineList[-length(lineList)]
lineFrame <- data.frame(matrix(unlist(lineList), nrow=length(lineList),
                               byrow=T), stringsAsFactors = F)
lineFrame <- mutate(lineFrame, X1 = as.integer(X1))
longLine <- max(lineFrame[1])
print(paste0(">> The longest line is ", longLine, " characters long, and can be
             found in the ", lineFrame[[2]][match(longLine, lineFrame[[1]])],
             " file."))

print("# Question 4: In the en_US twitter data set, if you divide the number of
      lines where the word 'love' (all lowercase) occurs by the number of lines
      the word 'hate' (all lowercase) occurs, about what do you get?")


print("# Question 5: The one tweet in the en_US twitter data set that matches
      the word 'biostats' says what?")

print("# Question 6: How many tweets have the exact characters 'A computer once
      beat me at chess, but it was no match for me at kickboxing'. (I.e. the
      line matches those characters exactly.)")

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
