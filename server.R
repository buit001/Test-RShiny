function(input, output, session) {
  
  #Creating reactive object: result
  result <- reactive({
      filter(ml, dataset %in% input$dataset1)
  })
  
  #Rendering Line chart
  output$plot1 <- renderPlotly({

    p <-
      ggplot(data = result(),
             aes(x = year,
                 y = avg_rating,
                 color = dataset)) +
      geom_line(alpha = 0.5) +
      geom_point(aes(group = dataset)) +
      theme(axis.text.x = element_text(
        angle = 45,
        hjust = 1,
        vjust = 0.5
      ))

    p <- ggplotly(p)
  })
  
  #Rendering datatable: genre.movies
  output$datatable1 = DT::renderDataTable({
    datatable(
      ml,
      filter = 'top',
      options = list(pageLength = 10, autoWidth = TRUE)
    )
  })
}