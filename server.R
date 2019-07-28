#Group Members :
# Niraj Kulkarni
# PGID - 11915030
# Email- Niraj_Kulkarni_cba2020s@isb.edu
#
# Rohith Varier
# 11915064
# Rohith_Varier_cba2020s@isb.edu
# 
# Parul Gaba
# 11915008
# Parul_Gaba_cba2020s@isb.edu

# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
#server logic
shinyServer(function(input, output,session) {
  
  #file input
  data_file <- reactive({
    
    if (is.null(input$file)) {return(NULL)}
    else {
      
      data_file = readLines(input$file$datapath)
      return(data_file)}
    
  })
  
  #get checkbox value (renderText)output$txt
   checkboxval<- renderText({
    icons = paste(input$checkGroup) #, collapse = ", ")
    paste("You chose", icons)
    return(icons)
  })
   
  # output$res1 <- renderText({
  #   
  #   res1 = paste(input$checkGroup , collapse = ", ")
  #   paste("You chose", res1)
  #   
  # })
  
   
  # load the file into tibble first
  data_text <- reactive({
    x<-data_file()
    Encoding(x) <- "latin1"
    xx <- iconv(x, "latin1", "UTF-8",sub='')
    
    data_text = tibble(text = (xx)) %>%
      unnest_tokens(sentence, text, token = "sentences", to_lower=FALSE) %>%    # sentence-tokenizing the article   
      mutate(sentence_id = row_number()) %>%    # insert setence_id
      select(sentence_id, sentence)  # drop frivolous stuff
    
    return(data_text)
  })
  
  
  #tab2 - annoted sentences
  output$annote_doc <- renderTable({
    #data = readLines('https://raw.githubusercontent.com/sudhir-voleti/sample-data-sets/master/text%20analysis%20data/amazon%20nokia%20lumia%20reviews.txt')
    data  =  str_replace_all(data_text(), "<.*?>", "") #get rid of html junk 
    str(data)
    str(checkboxval())
    val <- checkboxval()
    val <- strsplit(val, split='[,]')
    str(val)
    #str(val[1])
    #str(val[2])
    
    #load english model for annotation from working dir, should be already downloaed if not done
    setwd("/Users/nirajkulkarni/Desktop/Niraj/ISB-CBA/Term-1/Text-Analytics/Session 4 Materials/")
    english_model = udpipe_load_model("./english-ewt-ud-2.4-190531.udpipe")  # file_model only needed
    
    x <- udpipe_annotate(english_model, x = data) 
    x <- as.data.frame(x)
    #head(x[-4]$upos == 'VERB')
    
    #head(x[x[8] == 'VERB',-4],10)
  
    if (length(val) == 1){
      head(x[x[8] == val ,-4],100)
    }else if  (length(val) == 2){
      head(x[x[8] == val[1] & x[8] == val[2] ,-4],100)
    }else if  (length(val) == 3)
      head(x[x[8] == val[1] & x[8] == val[2] & x[8] == val[3] ,-4],100)
    else if  (length(val) == 4)
      head(x[x[8] == val[1] & x[8] == val[2] & x[8] == val[3] & x[8] == val[4] ,-4],100)
    else if  (length(val) == 5)
      head(x[x[8] == val[1] & x[8] == val[2] & x[8] == val[3] & x[8] == val[4] & x[8] == val[5],-4],100)

  })
  
  
  #tab3 - word cloud 1
  output$plot1 <- renderPlot({  
    
    
    #### WORD CLOUD NO.1 
  
    data  =  str_replace_all(data_text(), "<.*?>", "") #get rid of html junk 
    str(data)
    str(checkboxval())
    val <- checkboxval()
    val <- strsplit(val, split='[,]')
    str(val)
    #str(val[1])
    #str(val[2])
    
    #load english model for annotation from working dir, should be already downloaed if not done
    setwd("/Users/nirajkulkarni/Desktop/Niraj/ISB-CBA/Term-1/Text-Analytics/Session 4 Materials/")
    english_model = udpipe_load_model("./english-ewt-ud-2.4-190531.udpipe")  # file_model only needed
    
    x <- udpipe_annotate(english_model, x = data) 
    x <- as.data.frame(x)
    
    #co-ocurrence for noun and verb
    data_cooc_verb <- cooccurrence(   	
      x = subset(x, upos %in% c("VERB")), 
      term = "lemma", 
      group = c("doc_id", "paragraph_id", "sentence_id"))  
    # str(data_cooc_verb)
    head(data_cooc_verb)
    
    library(ggplot2)
    
    wordnetwork_verb <- head(data_cooc_verb, 50)
    wordnetwork_verb <- igraph::graph_from_data_frame(wordnetwork_verb) # needs edgelist in first 2 colms.
    
    ggraph(wordnetwork_verb, layout = "fr") +  
      
      geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
      geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
      
      theme_graph(base_family = "Arial Narrow") +  
      theme(legend.position = "none") +
      
      labs(title = "Cooccurrences word cloud", subtitle = "Verbs")
    
  })
  
  
  #tab3 : word - cloud2
  output$plot2 <- renderPlot({  
    #### WORD CLOUD NO.2 
    
    data  =  str_replace_all(data_text(), "<.*?>", "") #get rid of html junk 
    str(data)
    str(checkboxval())
    val <- checkboxval()
    val <- strsplit(val, split='[,]')
    str(val)
    #str(val[1])
    #str(val[2])
    
    #load english model for annotation from working dir, should be already downloaed if not done
    setwd("/Users/nirajkulkarni/Desktop/Niraj/ISB-CBA/Term-1/Text-Analytics/Session 4 Materials/")
    english_model = udpipe_load_model("./english-ewt-ud-2.4-190531.udpipe")  # file_model only needed
    
    x <- udpipe_annotate(english_model, x = data) 
    x <- as.data.frame(x)
    
    #co-ocurrence for noun and verb
    data_cooc_noun <- cooccurrence(   	
      x = subset(x, upos %in% c("NOUN")), 
      term = "lemma", 
      group = c("doc_id", "paragraph_id", "sentence_id"))  
    # str(data_cooc_noun)
    head(data_cooc_noun)
    
    library(ggplot2)
    
    wordnetwork <- head(data_cooc_noun, 50)
    wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
    
    ggraph(wordnetwork, layout = "fr") +  
      
      geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
      geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
      
      theme_graph(base_family = "Arial Narrow") +  
      theme(legend.position = "none") +
      
      labs(title = "Cooccurrences word cloud", subtitle = "Nouns")
    
    
  })
  
  ## Co-occurence logic write here
  output$data_text <- renderTable({
    
    #mylist<- setNames(as.list(seq(1,length(varnames))),varnames)
    str(checkboxval())
    val <- checkboxval()
    val <- strsplit(val, split='[,]')
    upos_list <- c(val)
    str(upos_list)
    #co-ocurrence for noun and verb
    data_cooc_random <- cooccurrence(   	
      x = subset(x, upos %in% c(val)), 
      term = "lemma", 
      group = c("doc_id", "paragraph_id", "sentence_id"))  
     str(data_cooc_random)
    #head(data_cooc_random)
    
   
    head(data_cooc_random,30)
    # if (length(val) == 1){
    #   head(data_cooc_random[data_cooc_random[8] == val ,-4],30)
    # }else if  (length(val) == 2){
    #   head(data_cooc_random[data_cooc_random[8] == val[1] & data_cooc_random[8] == val[2] ,-4],30)
    # }else if  (length(val) == 3)
    #   head(data_cooc_random[data_cooc_random[8] == val[1] & data_cooc_random[8] == val[2] & data_cooc_random[8] == val[3] ,-4],30)
    # else if  (length(val) == 4)
    #   head(data_cooc_random[data_cooc_random[8] == val[1] & data_cooc_random[8] == val[2] & data_cooc_random[8] == val[3] & data_cooc_random[8] == val[4] ,-4],30)
    # else if  (length(val) == 5)
    #   head(data_cooc_random[data_cooc_random[8] == val[1] & data_cooc_random[8] == val[2] & data_cooc_random[8] == val[3] & data_cooc_random[8] == val[4] & data_cooc_random[8] == val[5],-4],30)
    # 
    
    
    
    })
  

}) # shinyServer func ends
