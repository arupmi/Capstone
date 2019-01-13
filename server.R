######## function to establish user interface for Shiny app
## Coursera Capstone Project
# created by: Arup Mitra
# 


source("predict-functions-v1.R")

shinyServer(function(input, output) {
        output$text_next <- renderText({
                        getWords(input$text)
        })
        

})