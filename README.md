# AnimeEDA

The website above provides the data in an HDT file. This can be viewed through the application from rdfhdt.org, but is not particularly useful for analysis

![HDT](https://user-images.githubusercontent.com/81702110/113242425-94111d80-92ce-11eb-9240-871c0e527b10.gif)

We can, however, use this application to export it as an rdf file, then convert it to CSV through the rdflib package in R.
After extracting useful information with a SparQL query and cleaning the data a bit, there are some obvious things we can see:

![Anime2](https://user-images.githubusercontent.com/81702110/113245228-1f40e200-92d4-11eb-9c38-202e241e00fc.png)

The anime industry started in earnest in the 60's, and while the length of shows varied drastically at first, it has stabilised in the last two decades. This can be seen more clearly in the below graphs. This observation is in line with the general trend of newer shows airing in a seasonal format, whereas older shows often aired weekly for much longer periods of time. We can also see the most popular lengths for shows are approximately 12,24 and 48 now, which makes sense as a season is approximately 12 weeks and thus episode numbers are in multiples of 12. Shows with 1 episode have been removed so as not to count movies, and shows with 2 episodes are mostly Specials, OVAs, extra content released with DVD and BluRay etc.

![Animeplot3](https://user-images.githubusercontent.com/81702110/113246897-8b711500-92d7-11eb-9839-ec60326e852b.png)
![AnimePlot4](https://user-images.githubusercontent.com/81702110/113246899-8ca24200-92d7-11eb-9f25-d5e248b35c23.png)

Although there are many more inferences we could make from this data, lets first try to group
