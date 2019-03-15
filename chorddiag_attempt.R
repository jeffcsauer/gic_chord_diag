#set and install packages
install.packages("gdata")
install.packages("igraph")
install.packages("tidygraph")
install.packages("dplyr")

library(gdata)
library(foreign)

#point to perl
perl <- "C:/Strawberry/perl/bin/perl5.28.1.exe"

#load the dataset
df = read.xls(xls = "C:/Users/js/Desktop/coding/PhD Origin-destination Tim E.xls", perl = perl)

#look at top of data
head(df)

#load dplyr library to manipulate dataset
library(dplyr)

#drop excess rows
df <- select(df,-starts_with("X"))

#clean up a variable name
df$Origin <- df$Oirigin

#drop bad variable
df <- select(df,-starts_with("Oirigin"))

#select only two columns of interest
df2 <- select(df, c("Origin", "Destination"))

df3 <- data.table::as.data.table(df2)
  
  #clean up some rough names
  df3[df3$Origin == "GERM"] <- "GER"
  df3[df3$Destination == "GERM"] <- "GER"

  df3[df3$Origin == "FR"] <- "FRA"
  
  df3[df3$Origin == "US"] <- "USA"
  df3[df3$Destination == "US"] <- "USA"
  
df3 <- df3[, .N, by = c('Origin','Destination')]
df3 <- df3[complete.cases(df3), ]
df3 <- df3[!(df3$Origin=="" | df3$Destinatio==""),]

  df4 <- df3 %>% group_by(Origin, Destination) %>% summarize(n())

  library(igraph)
  library(tidygraph)

#try the chord diagram
df4.filter <- as.matrix(as_adjacency_matrix(as_tbl_graph(df4),attr = "n()"))

devtools::install_github("mattflor/chorddiag")
library(chorddiag)

library(circlize)

#working chord diagram, but in wrong options? 
chord2<-chorddiag(df4.filter, 
                  groupColors = Palette) 
chord2

#what i would expect to use to modify colors, but no results? 
chord3<-chorddiag(df4.filter, 
                  groupColors = rainbow(38))

chord3










