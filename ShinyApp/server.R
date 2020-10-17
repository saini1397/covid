
#### -----------------------------Header---------------------####
# Program Name : server.r
# Program Purpose : Shiny Server Components.
# Created By : Deepak Saini
# Created Date : Oct-2020
#
#

#-----------------------------------------------------------------

server <- (function(input, output) {
  output$vbox1 <- renderValueBox({
    valueBox(
      "Confirmed",
      vbox$Confirmed,
      icon = icon("fas fa-user-md"),
      color = "blue"
    )
  })

  output$vbox2 <- renderValueBox({
    valueBox(
      "Active",
      vbox$Active,
      icon = icon("bed"),
      color = "green"
    )
  })

  output$vbox3 <- renderValueBox({
    valueBox(
      "Recovered",
      vbox$Recovered,
      icon = icon("walking"),
      color = "orange"
    )
  })

  output$vbox4 <- renderValueBox({
    valueBox(
      "Deceased",
      vbox$Deceased,
      icon = icon("fas fa-heart-broken"),
      color = "red"
    )
  })

  output$data_table <- renderDataTable({
    df_final %>% datatable(rownames = FALSE, extensions = c("FixedColumns"), options = list(
      #dom = c("f"),
      scrollX = TRUE,
      fixedColumns = list(leftColumns = 2)
      
    ))
  })

  output$plotmap_output <- renderLeaflet({
    pal <- colorFactor(c("blue", "green", "orange", "red"), domain = c("Confirmed", "Active", "Recovered", "Deceased"))

    map_object <- leaflet() %>%
      addTiles() %>%
      addProviderTiles(providers$Stamen.Toner)
    names(cv_data_for_plot.split) %>%
      purrr::walk(function(df) {
        map_object <<- map_object %>%
          addCircleMarkers(
            data = cv_data_for_plot.split[[df]],
            lng = ~Long, lat = ~Lat,
            #                 label=~as.character(cases),
            color = ~ pal(type),
            stroke = FALSE,
            fillOpacity = 0.8,
            radius = ~log_cases,
            popup = leafpop::popupTable(cv_data_for_plot.split[[df]],
              feature.id = FALSE,
              row.numbers = FALSE,
              zcol = c("State", "type", "cases")
            ),
            group = df,
            labelOptions = labelOptions(
              noHide = F,
              direction = "auto"
            )
          )
      })
    map_object %>%
      addLayersControl(
        overlayGroups = names(cv_data_for_plot.split),
        options = layersControlOptions(collapsed = FALSE)
      )
  })

  data_pred <- reactive({
    df1_daily %>% filter(State == input$state)
  })

  observeEvent(input$p1, {
    output$plotp1_output <- renderPlotly({
      pred1 <- data_pred()

      data_confirmed <- pred1 %>%
        filter(Status == "Cumulative_Confirmed") %>%
        select(Date, cases)

      ds <- data_confirmed$Date
      y <- data_confirmed$cases
      df <- data.frame(ds, y)

      m <- prophet::prophet(df)
      future <- prophet::make_future_dataframe(m, periods = 14)
      forecast <- predict(m, future)

      options(scipen = 5)

      ggplotly(plot(m, forecast)) %>%
        layout(
          title = "",
          yaxis = list(title = "Cumulative Confirmed Cases"),
          xaxis = list(title = "Date"),
          legend = list(x = 0.1, y = 0.9),
          showlegend = F
        )
    })
  })

  observeEvent(input$p2, {
    output$plotp2_output <- renderPlotly({
      pred2 <- data_pred()

      data_death <- pred2 %>%
        filter(Status == "Cumulative_Deceased") %>%
        select(Date, cases)

      ds <- data_death$Date
      y <- data_death$cases
      df <- data.frame(ds, y)

      m1 <- prophet::prophet(df)
      future1 <- prophet::make_future_dataframe(m1, periods = 14)
      forecast1 <- predict(m1, future1)

      options(scipen = 5)

      ggplotly(plot(m1, forecast1)) %>%
        layout(
          title = "",
          yaxis = list(title = "Cumulative Death Cases"),
          xaxis = list(title = "Date"),
          legend = list(x = 0.1, y = 0.9),
          showlegend = F
        )
    })
  })


  observeEvent(input$summary, {
    output$plotsummary_output <- renderPlotly({
      plot_ly(data = summary) %>%
        plotly::add_trace(
          x = ~Date,
          y = ~cases,
          type = "scatter",
          mode = "lines+markers",
          name = summary$Status,
          color = summary$Status
        ) %>%
        plotly::layout(
          title = "",
          yaxis = list(title = "Cumulative Number of Cases"),
          xaxis = list(title = "Date"),
          hovermode = "compare"
        )
    })
  })



  observeEvent(input$comparison, {
    output$plotcomparison_output <- renderPlotly({
      plotly::plot_ly(
        data = df_compare,
        x = ~State,
        y = ~Confirmed,
        type = "bar",
        name = "Confirmed",
        marker = list(color = "blue")
      ) %>%
        plotly::add_trace(
          y = ~Recovered,
          name = "Recovered",
          marker = list(color = "orange")
        ) %>%
        plotly::add_trace(
          y = ~Deceased,
          name = "Death",
          marker = list(color = "red")
        ) %>%
        plotly::layout(
          barmode = "stack",
          yaxis = list(title = "Total cases"),
          xaxis = list(title = ""),
          hovermode = "compare",
          margin = list(
            # l = 60,
            # r = 40,
            b = 10,
            t = 10,
            pad = 2
          )
        )
    })
  })


  observeEvent("", {
    hide("p1div")
    hide("p2div")
    show("home1")
    hide("summarydiv")
    hide("comparisondiv")
  })

  observeEvent(input$home, {
    hide("p1div")
    hide("p2div")
    show("home1")
    hide("summarydiv")
    hide("comparisondiv")
  })

  observeEvent(input$p1, {
    show("p1div")
    hide("p2div")
    hide("home1")
    hide("summarydiv")
    hide("comparisondiv")
  })

  observeEvent(input$p2, {
    hide("p1div")
    show("p2div")
    hide("home1")
    hide("summarydiv")
    hide("comparisondiv")
  })

  observeEvent(input$summary, {
    hide("p1div")
    hide("p2div")
    hide("home1")
    show("summarydiv")
    hide("comparisondiv")
  })

  observeEvent(input$comparison, {
    hide("p1div")
    hide("p2div")
    hide("home1")
    hide("summarydiv")
    show("comparisondiv")
  })
})
