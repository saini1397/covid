
#### -----------------------------Header---------------------####
# Program Name : ui.r
# Program Purpose : To make shiny User Interface 
# Created By : Deepak Saini
# Created Date : Oct-2020
#
#

#-----------------------------------------------------------------

library(shiny)
library(tidyverse)
library(sqldf)
library(shinydashboard)
library(leaflet)
library(plotly)
library(shinythemes)
library(shinyBS)
library(DT)
library(shinycssloaders)
library(shinyjs)
library(corrplot)
library(leafpop)

ui <- dashboardPage(
  skin = "black",
  title = "covid19",

  dashboardHeader(
    title = span("Covid19"),
    titleWidth = 300,
    tags$li(
      a(
        strong("GitHub Codes !!"),
        height = 40,
        href = "https://github.com/saini1397/covid/tree/master/ShinyApp",
        title = "",
        target = "_blank"
      ),
      class = "dropdown"
    )
  ),

  dashboardSidebar(
    width = 300,
    div(class = "inlay", style = "height:15px;width:100%;background-color:#ecf0f5"),
    sidebarMenu(
      div(
        id = "sidebar_button",
        bsButton(
          inputId = "home",
          label = "Home",
          icon = icon("home"),
          style = "danger"
        )
      ),
      div(class = "inlay", style = "height:15px;width:100%;background-color:#ecf0f5"),
      menuItem(
        "Predictive Modelling",
        tabName = "Predictive Modelling",
        icon = icon("paint-roller"), br(),
        div(
          div(
            selectInput(
              inputId = "state", label = "Select State",
              choices = state_choices
            )
          ),
          bsButton(
            "p1",
            label = "Predict Confirmed",
            icon = icon("hand-point-right"),
            style = "success"
          ), br(),
          div(
            bsButton(
              "p2",
              label = "Predict Death",
              icon = icon("hand-point-right"),
              style = "success"
            ), br()
          )
        )
      )
    )
  ),

  dashboardBody(
    tags$head(
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "covid.css"
      )
    ),

    fluidRow(
      column(
        width = 12,
        bsButton(
          "summary",
          label = "Summary",
          icon = icon("chart-line"),
          style = "success"
        ),

        bsButton(
          "comparison",
          label = "Comparison",
          icon = icon("braille"),
          style = "success"
        )
      )
    ), br(),


    div(id = "home1", fluidRow(
      div(
        column(
          width = 12,
          tabBox(
            width = NULL,
            height = 400,
            tabPanel(
              useShinyjs(),
              title = "Dashboard (India)",

              div(column(
                width = 12, div(valueBoxOutput("vbox1")),
                div(valueBoxOutput("vbox2"))
              )),
              div(column(
                width = 12, div(valueBoxOutput("vbox3")),
                div(valueBoxOutput("vbox4"))
              ))
            ),

            tabPanel(
              useShinyjs(),
              title = "DataTable",
              withSpinner(
                dataTableOutput("data_table"),
                type = 4,
                color = "#d33724",
                size = 0.7
              )
            ),
            tabPanel(
              useShinyjs(),
              title = "Map",
              withSpinner(
                leafletOutput("plotmap_output", height = 600),
                type = 4,
                color = "#d33724",
                size = 0.7
              )
            )
          )
        )
      )
    )),

    hidden(div(id = "p1div", fluidRow(
      div(
        column(
          width = 12,
          tabBox(
            width = NULL,
            height = 400,
            tabPanel(
              useShinyjs(),
              title = "Forecasting Confirmed Cases (14 Days)",
              withSpinner(
                plotlyOutput("plotp1_output", height = "100%", width = "100%"),
                type = 4,
                color = "#d33724",
                size = 0.7
              )
            )
          )
        )
      )
    ))),

    hidden(div(id = "p2div", fluidRow(
      div(
        column(
          width = 12,
          tabBox(
            width = NULL,
            height = 400,
            tabPanel(
              useShinyjs(),
              title = "Forecasting Death Cases (14 Days)",
              withSpinner(
                plotlyOutput("plotp2_output", height = "100%", width = "100%"),
                type = 4,
                color = "#d33724",
                size = 0.7
              )
            )
          )
        )
      )
    ))) , 
    
    hidden(div(id = "summarydiv", fluidRow(
      div(
        column(
          width = 12,
          tabBox(
            width = NULL,
            height = 400,
            tabPanel(
              useShinyjs(),
              title = "Daily Cumulative Cases",
              withSpinner(
                plotlyOutput("plotsummary_output", height = "100%", width = "100%"),
                type = 4,
                color = "#d33724",
                size = 0.7
              )
            )
          )
        )
      )
    ))) ,
    
    hidden(div(id = "comparisondiv", fluidRow(
      div(
        column(
          width = 12,
          tabBox(
            width = NULL,
            height = 400,
            tabPanel(
              useShinyjs(),
              title = "Compare Top Ten States by Cases",
              withSpinner(
                plotlyOutput("plotcomparison_output", height = "100%", width = "100%"),
                type = 4,
                color = "#d33724",
                size = 0.7
              )
            )
          )
        )
      )
    )))
    
  )
)
