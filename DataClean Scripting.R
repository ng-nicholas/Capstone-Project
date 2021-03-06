## Scripting file for data cleaning

# Loading packages for parallel computing and setting options
library("cluster")
library("parallel")
library("doSNOW")
coreNumber <- max(detectCores(),1)
cluster <- makeCluster(coreNumber, type = "SOCK",outfile="")
registerDoSNOW(cluster)


# Loading data manipulation packages
library("dplyr")

# Defining directories and setting working directory
print("# Defining and setting working directory...")
dirWork <- "~/GitHub/Capstone-Project/Coursera-SwiftKey/final/en_US/"
setwd(dirWork)

# Setting seed for random sampling
print("# Setting seed...")
set.seed(100)

# Extracting subsets of files to create samples to work with
print("# Creating samples...")
for (i in 1:length(dir(dirWork))) {
    con <- file(dir(dirWork[i]), "r")
    readLines(con)
    close(con)


}

# Generating statistics of each element in each data table
dataBlogs <- dataBlogs %>%
                mutate(chrCount = nchar(textData),
                       wordCount = gregexpr("[[:alpha:]]+", textData))


