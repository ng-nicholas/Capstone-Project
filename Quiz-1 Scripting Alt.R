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
print(paste0(">> The file is ", gsub("[:alpha:]", "", answer1),
             "b large."))
rm(dirDetails, answer1)

print("# Question 2: The en_US.twitter.txt has how many lines of text?")
answer2 <- strsplit(gsub("\\s{2,}", "", system("wc -l en_US.twitter.txt",
                                               intern = T)),
                    split = "\\s")[[1]][1]
print(paste0(">> There are ",
             format(as.numeric(answer2), big.mark = ",", trim = T),
             " lines of text in the file."))
rm(answer2)

print(paste0("# Question 3: What is the length of the longest line seen in ",
             "any of the three en_US data sets?"))
lineList <- strsplit(gsub("\\s{2,}", "", system("wc -L *.txt", intern = T)),
                     split = "\\s")
lineList <- lineList[-length(lineList)]
lineFrame <- data.frame(matrix(unlist(lineList), nrow=length(lineList),
                               byrow=T), stringsAsFactors = F)
lineFrame <- mutate(lineFrame, X1 = as.integer(X1))
longLine <- max(lineFrame[1])
print(paste0(">> The longest line(s) is ",
             format(longLine, big.mark = ",", trim = T),
             " characters long, and can be found in the ",
             lineFrame[[2]][match(longLine, lineFrame[[1]])], " file."))
rm(lineList, lineFrame, longLine)

print(paste0("# Question 4: In the en_US twitter data set, if you divide the ",
             "number of lines where the word 'love' (all lowercase) occurs by ",
             "the number of lines the word 'hate' (all lowercase) occurs, ",
             "about what do you get?"))
con <- file("en_US.twitter.txt", "r")
twitLines <- readLines(con, encoding = "en_US")
close(con)
love <- sum(grepl("love", twitLines))
hate <- sum(grepl("hate", twitLines))
rship <- love / hate
print(paste0(">> The love/hate relationship is ",
             format(rship, big.mark = ",", trim = T, digits = 0),
             "."))
rm(con, love, hate, rship)

print(paste0("# Question 5: The one tweet in the en_US twitter data set that ",
             "matches the word 'biostats' says what?"))
print(paste0(">> This is what it says: ",
             grep("biostats", twitLines, ignore.case = T, value = T)))

print(paste0("# Question 6: How many tweets have the exact characters 'A ",
             "computer once beat me at chess, but it was no match for me at ",
             "kickboxing'. (I.e. the line matches those characters exactly.)"))
exactLines <- sum(grepl(paste0("A computer once beat me at chess, but it was ",
                               "no match for me at kickboxing"), twitLines))
print(paste0(">> There are a total of ",
             format(exactLines, big.mark = ",", trim = T),
             " such lines in the twitter data."))
rm(list = ls())
