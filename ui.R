#
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

# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#Reference : Prof Sudhir Voleti's class codes

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  #Title
  titlePanel("Group Assignment by Niraj, Parul, Rohith"),
  
  #Side panel for inputs
  sidebarPanel(
    
    fileInput("file", "Upload text file"),
    checkboxGroupInput("checkGroup", label = h3("Select type of upos"), 
                       choiceNames =list("ADJ", "NOUN", "PROPN", "ADV" , "VERB"),
                       choiceValues = list("ADJ", "NOUN", "PROPN", "ADV" , "VERB"),
                       selected = c("ADJ","NOUN", "PROPN")),textOutput("txt"),verbatimTextOutput(outputId = "res1")
    
  ),
  
  mainPanel(
    
    tabsetPanel(type = "tabs",
                
                tabPanel("About",h4(p("About the app")),
                         p("The app will help you explore the NLP workflow of a text document you want to see.
                           There tabs which can provide us the info about :
                           a) Display annotated documents using udpipe.
                           b) Word Cloud of all the nouns and verbs from the corpus you have uploaded.
                           c) Top 30 co-occurences at document level", align = "justify"),
                         br(),
                          h4(p("How to use the app?")),
                         p("Use the left panel to upload a text file of any sort you want to analyze. 
                            You can select a specific UPOS you want to analyze and see infomration in specific tabs.", align = "justify")),
                
                tabPanel("Annoted Doc", 
                         h4(p("Top 100 list of sentences for the UPOS selected on the side panel.")),
                         (p("Please wait it takes time to load ..")),
                         tableOutput("annote_doc")),
                
                tabPanel("Word Cloud",
                         h4(p("Word Cloud for the NOUN & VERB selected")),
                         (p("Please wait it takes time to load ..")),
                         plotOutput("plot1"),
                         plotOutput("plot2")),
                
                
                tabPanel("Co-Occurence",
                         h4(p("Top 30 Co-Occurences for the UPOS selected")),
                         (p("Please wait it takes time to load ..")),
                         tableOutput("data_text"))
                

    )  # tabSetPanel closes
    
  )  # mainPanel closes
  
)
)  # fluidPage() & ShinyUI() close
