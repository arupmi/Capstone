library(shiny)

shinyUI(fluidPage(titlePanel("Next Word Prediction Application: Data Science Capstone Project")))
                  
######## function to establish user interface for Shiny app
## Coursera Capstone Project
# created by: Arup Mitra
# 
# the goal of this code is to create the right layout for my shiny app
library(shiny)

shinyUI(pageWithSidebar(
        
        headerPanel("Next Word Text Prediction"),
        
        sidebarPanel(textInput("text", label = h3("Enter text here:"), value="") 
                     ),
        
        
        mainPanel(
                h4("Next word prediction:"),
                verbatimTextOutput("text_next", placeholder = TRUE),

                h6("This program generates a prediction for the next word based on an 
                   inputted text. The prediction algoritihm relies on word frequencies in 
                   the English twitter, blogs, and news datasets at:"),
                
                
                h6("Created Jan 2019 as the captsone project on my Data Science Specialization
                   from Johns Hopkins and Coursera.") 
                
                )
        
        
                ))