library(shiny)
library(shinydashboard)

shinyServer(function(input,output){
  output$subjData <- renderTable({
    subjFilter <- subset(adae,adae$USUBJID==input$inSubj)
  }
  )
})
