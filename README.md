# AnimeEDA

The website above provides the data in an HDT file. This can be viewed through the application from rdfhdt.org, but is not particularly useful for analysis

![HDT](https://user-images.githubusercontent.com/81702110/113242425-94111d80-92ce-11eb-9240-871c0e527b10.gif)

We can, however, use this application to export it as an rdf file, then convert it to CSV through the rdflib package in R.
After extracting useful information with a SparQL query and cleaning the data a bit, there are some obvious things we can see:

![Anime2](https://user-images.githubusercontent.com/81702110/113245228-1f40e200-92d4-11eb-9c38-202e241e00fc.png)

The anime industry started in earnest in the 60's, and while the length of shows varied drastically at first, it has stabilised in the last two decades. This can be seen more clearly in the below graphs. This observation is in line with the general trend of newer shows airing in a seasonal format, whereas older shows often aired weekly for much longer periods of time. We can also see the most popular lengths for shows are approximately 12,24 and 48 now, which makes sense as a season is approximately 12 weeks and thus episode numbers are in multiples of 12. Shows with 1 episode have been removed so as not to count movies, and shows with 2 episodes are mostly Specials, OVAs, extra content released with DVD and BluRay etc.

![Animeplot3](https://user-images.githubusercontent.com/81702110/113246897-8b711500-92d7-11eb-9839-ec60326e852b.png)
![AnimePlot4](https://user-images.githubusercontent.com/81702110/113246899-8ca24200-92d7-11eb-9f25-d5e248b35c23.png)

We can also see that overall production has constantly been increasing every decade, and that shows are increasingly targeting a more mature audience.

<img src="https://user-images.githubusercontent.com/81702110/113264771-f7ac4280-92f0-11eb-92df-05cb997ab4db.png" width=600>
<img src="https://user-images.githubusercontent.com/81702110/113264766-f67b1580-92f0-11eb-834d-ce70bc7b58d3.png" width=600>

Although there are many more inferences we could make here, let us try a more complex task: finding the most common themes in Anime using the descriptions given for each show. After removing uninformative words like articles and prepositions, we can use LDA, an NLP algorithm used for unsupervised topic modelling to get the most significant themes. here they are listed below, with the most important words in each theme given under it:

![Anime7](https://user-images.githubusercontent.com/81702110/113290917-e58dcc80-930f-11eb-8707-59e328c63d16.png)

This gives us a good idea, something along the lines of:  
1 Music, shorts(OVA's), Movies  
2 Isekai, Magic, Fantasy, High-School,  
3 Shounen, Mecha, Fighting, Power, Saving Earth/Humanity  
4 Moe, Shoujo, Romance, School, Slice of Life, Friendship

Lets try to find more accurate themes by exapnding the number of topics:

![plot_zoom_png](https://user-images.githubusercontent.com/81702110/113291124-2f76b280-9310-11eb-8aee-858477b56ba6.jpg)

Although there is some overlap, we get a better idea with ten themes. For example, topic 9 is about space and robots: it most probably encompasses the mecha genre of anime, including shows such as Gurren Lagann, Neon Genesis Evangelion, Gundam etc. My guess for the themes based on the most important words are:  
1. films and short stories  
2. shoujo (adventures with female protagonist, such as Sailor Moon)  
3. fantasy/isekai (teleported to another world) 
4. & 7. highschool drama/romcom/slice of life/romance  
5. music videos  
6. shounen(action/adventure with male protagonist) / isekai [both have similar words since they're both typically power fantasies]  
8. bonus episodes, OVAs, specials etc. included in DVD/Blu-ray releases   
9. mecha  
10. mystery  
