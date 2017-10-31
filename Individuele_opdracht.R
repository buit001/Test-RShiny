
#install.packages("RMongo")
#install.packages("dplyr")
#install.packages("sqldf")
#install.packages("plotly")
#install.packages("tidyr")
#install.packages("stringr")
#install.packages("stringi")

library(RMongo)
library(dplyr)
library(sqldf)
library(tidyr)
library(stringr)
library(stringi)

mockdata <- read.csv("C:/Users/Tan/Desktop/Big data/Data processing/MOCK_DATA2.csv")


mcon <- mongoDbConnect("Movies", port=27017)

mlMovies <- RMongo::dbGetQuery(mcon, "ml-movies","{}", skip=0, limit=999999)
mlRating <- RMongo::dbGetQuery(mcon, "ml-ratings","{}", skip=0, limit=999999)
mlTags <- RMongo::dbGetQuery(mcon, "ml-tags","{}", skip=0, limit=999999)


#Getting the year from the title with regex: \\([0-9]{4}\\)
year <- data.frame(year = sapply(mlMovies$title, function(x) str_extract(x, "\\([0-9]{4}\\)")))
#Removing the year from the title
mlMovies$title <- gsub("\\([0-9]{4}\\)", "", mlMovies$title)
#Adding year to movielens in separate column
mlMovies$year <- as.numeric(sapply(year, function(x) stri_sub(str = x, from = 2, to = 5)))

mlMoviesTags <- sqldf("SELECT movieID, title, tag, year FROM mlMovies JOIN mlTags USING(movieID)")
mlMoviesRatings <- sqldf("SELECT movieID, title, rating, year FROM mlMovies JOIN mlRating USING(movieID)")

ml <- mlMoviesRatings %>%
  group_by(year) %>%
  summarise(
    avg_rating = mean(rating),
    dataset = "ml"
  )

md <- mockdata %>%
  group_by(movie_date) %>%
  summarise(
    avg_rating = mean(movie_rating),
    dataset = "md"
  )
colnames(md) <- colnames(ml)

ml <- rbind(ml, md)

ml$avg_rating <- round(ml$avg_rating, 2)

