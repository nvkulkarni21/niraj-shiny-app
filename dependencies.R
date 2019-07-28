suppressPackageStartupMessages({
  if (!require(udpipe)){install.packages("udpipe")}
  if (!require(textrank)){install.packages("textrank")}
  if (!require(lattice)){install.packages("lattice")}
  if (!require(igraph)){install.packages("igraph")}
  if (!require(ggraph)){install.packages("ggraph")}
  if (!require(wordcloud)){install.packages("wordcloud")}
  if (!require(ggplot2)){install.packages("ggplot2")}
  if (!require(tidytext)){install.packages("tidytext")}
  if (!require(dplyr)){install.packages("dplyr")}
  if (!require(shiny)){install.packages("shiny")}
  
  library(udpipe)
  library(textrank)
  library(lattice)
  library(igraph)
  library(ggraph)
  library(ggplot2)
  library(wordcloud)
  library(stringr)
  library(ggplot2)
  library(shiny)
  library(dplyr)
  library(tidytext)
  
})
