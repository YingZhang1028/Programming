library(tm)
library(wordcloud)
library(memoise)

books <<- list("Review" = "review_clean","Hotel NYC"="wordcloud_hotel_clean")

getTermMatrix <- memoise(function(book) {
  if (!(book %in% books))
    stop("Unknown book")
  
  #text <- readLines(sprintf("./review_clean.txt", book),
                    #encoding="UTF-8")
  
  text <- readLines(sprintf("./%s.txt", book),
                    encoding="UTF-8")
  
  myCorpus = Corpus(VectorSource(text))
  myCorpus = tm_map(myCorpus, content_transformer(tolower))
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, removeWords,
                    c(stopwords("SMART"), "thy", "thou", "thee", "the", "and", "but","hotel"))
  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 1))
  m = as.matrix(myDTM)
  sort(rowSums(m), decreasing = TRUE)
})

