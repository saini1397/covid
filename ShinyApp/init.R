my_packages = c("shiny","tidyverse","sqldf","shinydashboard","leaflet","plotly","shinythemes","shinyBS","DT","shinycssloaders","shinyjs","corrplot","leafpop")

install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p, dependencies = TRUE)
  }
}

invisible(sapply(my_packages, install_if_missing))
