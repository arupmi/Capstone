library(quanteda)
library(ggplot2)
library(data.table)

load("nfreq.f1.RData")
load("nfreq.f2.RData")
load("nfreq.f3.RData")

setkey(uni_words, word_1)
setkey(bi_words, word_1, word_2)
setkey(tri_words, word_1, word_2, word_3)


discount_value <- 0.75


# Finding number of bi-gram words
numOfBiGrams <- nrow(bi_words[by = .(word_1, word_2)])

# Dividing number of times word 2 occurs as second part of bigram, by total number of bigrams.  
# ( Finding probability for a word given the number of times it was second word of a bigram)
ckn <- bi_words[, .(Prob = ((.N) / numOfBiGrams)), by = word_2]
setkey(ckn, word_2)

# Assigning the probabilities as second word of bigram, to unigrams
uni_words[, Prob := ckn[word_1, Prob]]
uni_words <- uni_words[!is.na(uni_words$Prob)]

# Finding number of times word 1 occurred as word 1 of bi-grams
n1wi <- bi_words[, .(N = .N), by = word_1]
setkey(n1wi, word_1)

# Assigning total times word 1 occured to bigram cn1
bi_words[, Cn1 := uni_words[word_1, count]]

# Kneser Kney Algorithm
bi_words[, Prob := ((count - discount_value) / Cn1 + discount_value / Cn1 * n1wi[word_1, N] * uni_words[word_2, Prob])]

######## End of Finding Bi-Gram Probability ####################
# Finding count of word1-word2 combination in bigram 
tri_words[, Cn2 := bi_words[.(word_1, word_2), count]]

# Finding count of word1-word2 combination in trigram
n1w12 <- tri_words[, .N, by = .(word_1, word_2)]
setkey(n1w12, word_1, word_2)

# Kneser Kney Algorithm
tri_words[, Prob := (count - discount_value) / Cn2 + discount_value / Cn2 * n1w12[.(word_1, word_2), N] *
                  bi_words[.(word_1, word_2), Prob]]

# Finding the most frequently used 50 unigrmas
uni_words <- uni_words[order(-Prob)][1:50]



triWords <- function(w1, w2, n = 5) {
        pwords <- tri_words[.(w1, w2)][order(-Prob)]
        if (any(is.na(pwords)))
                return(biWords(w2, n))
        if (nrow(pwords) > n)
                return(pwords[1:n, word_3])
        count <- nrow(pwords)
        bwords <- biWords(w2, n)[1:(n - count)]
        return(c(pwords[, word_3], bwords))
}

# function to return highly probable previous word given a word
biWords <- function(w1, n = 5) {
        pwords <- bi_words[w1][order(-Prob)]
        if (any(is.na(pwords)))
                return(uniWords(n))
        if (nrow(pwords) > n)
                return(pwords[1:n, word_2])
        count <- nrow(pwords)
        unWords <- uniWords(n)[1:(n - count)]
        return(c(pwords[, word_2], unWords))
}


# function to return random words from unigrams
uniWords <- function(n = 5) { 
        return(sample(uni_words[, word_1], size = n))
}


# The prediction app
getWords <- function(str){
        require(quanteda)
        tokens <- tokens(x = char_tolower(str))

        if (str=="") { return("  ")}
        tokens <- char_wordstem(rev(rev(tokens[[1]])[1:2]), language = "english")

        words <- triWords(tokens[1], tokens[2], 5)
        chain_1 <- paste(tokens[1], tokens[2], words[1], sep = " ")
       

       print(words[1])

        
}
