
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
    ) ),

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
          ),

          bsButton(
            "map",
            label = "Map",
            icon = icon("map"),
            style = "success"
          )
        )
      )
    )
  )

