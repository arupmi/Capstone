library(quanteda)
library(ggplot2)
library(data.table)

setwd("C:/Users/arupm/OneDrive/Coursera/Capstone")
url<-"https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
destfile <- "Coursera-SwiftKey.zip"
if(!file.exists(destfile)){
        download.file(url,destfile)
        unzip("Coursera-SwiftKey.zip")
}


blogfile<-file("./final/en_US/en_US.blogs.txt","rb")
blogline<-readLines(blogfile)
close(blogfile)

twitterfile<- file("./final/en_US/en_US.twitter.txt","rb")
twitterline <-readLines(twitterfile)
close(twitterfile)

newsfile<- file("./final/en_US/en_US.news.txt","rb")
newsline <-readLines(newsfile)
close(newsfile)

sampleHolderBlog <- sample(length(blogline), length(blogline) * 0.1)
blogsample <- blogline[sampleHolderBlog]
sampleHolderTwitter <- sample(length(twitterline), length(twitterline) * 0.1)
twittersample <- blogline[sampleHolderTwitter]
sampleHolderNews <- sample(length(newsline), length(newsline) * 0.1)
newssample <- blogline[sampleHolderNews]

print("completed read file")
combined_vector <- c(blogsample, twittersample, newssample)

corp <- corpus(combined_vector)

uni_DFM <- dfm(tolower(corp), remove_punct = TRUE,
                remove_twitter = TRUE,
              remove_numbers = TRUE,
               remove_hyphens = TRUE,
              remove_symbols = TRUE,
                remove_url = TRUE, stem=TRUE,ngrams=1)

bi_DFM <- dfm(tolower(corp), remove_punct = TRUE,
               remove_twitter = TRUE,
               remove_numbers = TRUE,
               remove_hyphens = TRUE,
               remove_symbols = TRUE,
               remove_url = TRUE, stem=TRUE,ngrams=2)

tri_DFM <- dfm(tolower(corp), remove_punct = TRUE,
              remove_twitter = TRUE,
              remove_numbers = TRUE,
              remove_hyphens = TRUE,
              remove_symbols = TRUE,
              remove_url = TRUE, stem=TRUE,ngrams=3)


uni_DFM <- dfm_trim(uni_DFM, 3)
bi_DFM <- dfm_trim(bi_DFM, 3)
tri_DFM <- dfm_trim(tri_DFM, 3)



 sums_U <- colSums(uni_DFM)
 sums_B <- colSums(bi_DFM)
 sums_T <- colSums(tri_DFM)
 uni_words <- data.table(word_1 = names(sums_U), count = sums_U)
 bi_words <- data.table(
         word_1 = sapply(strsplit(names(sums_B), "_", fixed = TRUE), '[[', 1),
         word_2 = sapply(strsplit(names(sums_B), "_", fixed = TRUE), '[[', 2),
         count = sums_B)
 
 tri_words <- data.table(
         word_1 = sapply(strsplit(names(sums_T), "_", fixed = TRUE), '[[', 1),
         word_2 = sapply(strsplit(names(sums_T), "_", fixed = TRUE), '[[', 2),
         word_3 = sapply(strsplit(names(sums_T), "_", fixed = TRUE), '[[', 3),
         count = sums_T)
 save(uni_words,file="nfreq.f1.RData")
 save(bi_words,file="nfreq.f2.RData")
 save(tri_words,file="nfreq.f3.RData")
 
 