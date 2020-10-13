# Lodaing Packages

packages <- c("shiny",
          "tidyverse",
          "sqldf",
          "shinydashboard",
          "leaflet",
          "plotly",
          "shinythemes",
          "shinyBS",
          "DT",
          "shinycssloaders",
          "shinyjs",
          "corrplot"
)

lapply(packages, require, character.only = TRUE)