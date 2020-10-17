
server <- (function(input, output) {
  
  output$vbox1 <- renderValueBox({
    
    valueBox(
      "Confirmed",
      vbox$Confirmed,
      icon = icon("fas fa-user-md"),
      color="blue"
    )
    
  })
  
  output$vbox2 <- renderValueBox({
    
    valueBox(
      "Active",
      vbox$Active,
      icon = icon("bed"),
      color="green"
    )
    
  })
  
  output$vbox3 <- renderValueBox({
    
    valueBox(
      "Recovered",
      vbox$Recovered,
      icon = icon("walking"),
      color="orange"
    )
    
  })
  
  output$vbox4 <- renderValueBox({
    
    valueBox(
      "Deceased",
      vbox$Deceased,
      icon = icon("fas fa-heart-broken"),
      color="red"
    )
    
  })
  
  output$data_table <- renderDataTable({
    df_final %>% datatable(extensions = c('FixedColumns'),filter='top',options = list(
      dom = c('t'),
      scrollX = TRUE,
      fixedColumns = list(leftColumns = 3),initComplete = JS(
        "function(settings, json) {",
        "$(this.api().table().header()).css({'background-color': '#000','color': '#fff'});",
        "}"
      )
      
    ))
  }
  )
  
  output$plotmap_output <- renderLeaflet({
    pal <- colorFactor( c("blue","green","orange","red") , domain = c("Confirmed","Active","Recovered","Deceased"))
    
    map_object <- leaflet()  %>%
      addTiles() %>%
      addProviderTiles(providers$Stamen.Toner)
    names(cv_data_for_plot.split) %>%
      purrr::walk( function(df) {
        map_object <<- map_object %>%
          addCircleMarkers(data=cv_data_for_plot.split[[df]],
                           lng=~Long, lat=~Lat,
                           #                 label=~as.character(cases),
                           color = ~pal(type),
                           stroke = FALSE,
                           fillOpacity = 0.8,
                           radius = ~log_cases,
                           popup =  leafpop::popupTable(cv_data_for_plot.split[[df]],
                                                        feature.id = FALSE,
                                                        row.numbers = FALSE,
                                                        zcol=c("type","cases","State")),
                           group = df,
                           labelOptions = labelOptions(noHide = F,
                                                       direction = 'auto'))
      })
    map_object %>%
      addLayersControl(
        overlayGroups = names(cv_data_for_plot.split),
        options = layersControlOptions(collapsed = FALSE)
      )
    
    
    
  })   
   

})