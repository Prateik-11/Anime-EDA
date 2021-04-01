library(tidyverse) 
library(tidytext) # tidy implimentation of NLP methods
library(topicmodels) # for LDA topic modelling 
library(tm) # general text mining functions, making document term matrixes
library(SnowballC) # stemming

anime <- read.csv("~/R/Data/anime", comment.char="#")

# function to get & plot the most informative terms by a specificed number
# of topics, using LDA
top_terms_by_topic_LDA <- function(input_text, # columm from a dataframe
                                   plot = TRUE, # return a plot
                                   number_of_topics = 4) # number of topics
{    
  # create a corpus (type of object expected by tm) and document term matrix
  Corpus <- Corpus(VectorSource(input_text)) # make a corpus object
  DTM <- DocumentTermMatrix(Corpus) # get the count of words/document
  
  # remove any empty rows in our document term matrix (if there are any 
  # we'll get an error when we try to run our LDA)
  unique_indexes <- unique(DTM$i) # get the index of each unique value
  DTM <- DTM[unique_indexes,] # get a subset of only those indexes
  
  # preform LDA & get the words/topic in a tidy text format
  lda <- LDA(DTM, k = number_of_topics, control = list(seed = 1234))
  topics <- tidy(lda, matrix = "beta")
  
  # get the top ten terms for each topic
  top_terms <- topics  %>% # take the topics data frame and..
    group_by(topic) %>% # treat each topic as a different group
    top_n(10, beta) %>% # get the top 10 most informative words
    ungroup() %>% # ungroup
    arrange(topic, -beta) # arrange words in descending informativeness
  
  # if the user asks for a plot (TRUE by default)
  if(plot == T){
    # plot the top ten terms for each topic in order
    top_terms %>% # take the top terms
      mutate(term = reorder(term, beta)) %>% # sort terms by beta value 
      ggplot(aes(term, beta, fill = factor(topic))) + # plot beta by theme
      geom_col(show.legend = FALSE) + # as a bar plot
      facet_wrap(~ topic, scales = "free") + # which each topic in a seperate plot
      labs(x = NULL, y = "Beta") + # no x label, change y label 
      coord_flip() # turn bars sideways
  }else{ 
    # if the user does not request a plot
    # return a list of sorted terms instead
    return(top_terms)
  }
}
# create a document term matrix to clean
Corpus <- Corpus(VectorSource(anime$description)) 
DTM <- DocumentTermMatrix(Corpus)

# convert the document term matrix to a tidytext corpus
tidy_DTM <- tidy(DTM)

# adding extra stop words
custom_stop_words <- tibble(word = c("(source:","ann)","however,","episode","anime","mal",'anidb)'))

# remove stopwords from data
removed_tidy_DTM <- tidy_DTM %>% 
  anti_join(stop_words, by = c("term" = "word")) %>% # remove English stopwords
  anti_join(custom_stop_words, by = c("term" = "word")) # remove custom stopwords

# stem the words (e.g. convert each word to its stem, where applicable)
stemmed_removed_tidy_DTM <- removed_tidy_DTM %>%
 mutate(stem = wordStem(term))

# reconstruct document with only stemmed words with correct count
stemmed_removed_tidy_DTM <- stemmed_removed_tidy_DTM %>%
  group_by(document) %>%
  mutate(terms = toString(rep(stem, count))) %>%
  select(document, terms) %>%
  unique()

# Most informative words
top_terms_by_topic_LDA(stemmed_removed_tidy_DTM$terms,number_of_topics=4)
# Four Categories are probably:
# 1 Music, shorts(OVA's), Movies
# 2 Isekai, Magic, Fantasy, High-School, 
# 3 Shounen, Mecha, Fighting, Power, Saving Earth/Humanity
# 4 Moe, Shoujo, Romance, School, Slice of Life, Friendship



