# Load library and setwd() before running runApp() from console
# UI.R stands for User Interface. In fact, UI.R is the file where
#the different parts of the
# application's frontend (that is, what the end users see) is
#defined. server.R, on the
# contrary, is the backend or the engine of the application,
# that is, where the data is processed.

# runApp() function is part of shiny package.
# When we will run runApp() then it will search for server.R in
#present working directory.

library(shiny)

fluidPage(
  titlePanel("Subject Summary-ADaM"),
  sidebarLayout(
    sidebarPanel(
      selectInput("inSubj","Select a subject",choices=adae$USUBJID)
    ),
    mainPanel(
      tableOutput("subjData")
    )
  )
)