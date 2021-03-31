install.packages("rdflib") 
install.packages("NCmisc") 
library(NCmisc)
library(rdflib)
library(tidyverse)

#rdf_parse(doc=file.path(".","2021-01.txt"),format = "ntriples") doesn't compile, 
#the file is too large. 
#Breaking 2021-01.txt into several files using NCmisc package (1 file=150K lines)

file.split("2021-01.txt", size = 150000, same.dir = FALSE, verbose = TRUE, suf = "part", win = FALSE)

#only first 5 files have anime titles, rest store episodes, characters etc.
#making rdf of first 5 files

for (i in c(1:5))
{
   if (i==1) 
   {
      anime_rdf <- rdf_parse(doc=file.path(".",paste0("2021-01_part",i,".txt")),format = "ntriples")
   }
   else
   {
      anime_rdf <- rdf_parse(doc=file.path(".",paste0("2021-01_part",i,".txt")),format = "ntriples",rdf =anime_rdf)
   }
}

#Required information can be queried from anime_rdf using below format:
# sparql <-
# 'PREFIX anime: <https://betweenourworlds.org/anime/>
#  SELECT  ?Title ?NumberOfEpisodes ?description ?contentRating  ?endDate ?image ?startDate ?character
#  WHERE {
#  ?s <http://dbpedia.org/ontology/title>  ?Title .
#  ?s <http://dbpedia.org/ontology/numberOfEpisodes>  ?NumberOfEpisodes .
#  ?s <http://purl.org/dc/terms/description>  ?description .
#  ?s <http://schema.org/contentRating>  ?contentRating .
#  ?s <http://schema.org/endDate>  ?endDate .
#  ?s <http://schema.org/image> ?image .
#  ?s <http://schema.org/startDate> ?startDate .
#  ?s <https://betweenourworlds.org/ontology/character> ?character
#  FILTER ( lang(?Title) = "" )
#  FILTER ( isUri(?s) && STRSTARTS(STR(?s), STR(anime:)))
#  FILTER ( strlen(?contentRating)<=2)
# }'

sparql <-
   'PREFIX anime: <https://betweenourworlds.org/anime/>
   SELECT  ?Title ?NumberOfEpisodes ?description ?contentRating ?startDate ?endDate 
    WHERE 
    {
    ?s <http://dbpedia.org/ontology/title>  ?Title .
    ?s <http://dbpedia.org/ontology/numberOfEpisodes>  ?NumberOfEpisodes .
    ?s <http://purl.org/dc/terms/description>  ?description .
    ?s <http://schema.org/contentRating>  ?contentRating .
    ?s <http://schema.org/startDate> ?startDate .
    ?s <http://schema.org/endDate>  ?endDate .
    FILTER ( lang(?Title) = "" )
    FILTER ( isUri(?s) && STRSTARTS(STR(?s), STR(anime:)))
    FILTER ( strlen(?contentRating)<=2)
   }'

anime <- rdf_query(anime_rdf, sparql)

#remove some deleted shows
anime <- anime[anime$Title!="Delete",]
#remove duplicates due to extra NA content ratings
anime <- anime[!(duplicated(anime$Title) & is.na(anime$contentRating)),]

write.csv(anime,file="anime",row.names=FALSE)

















