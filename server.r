d = read.csv("dataset/heart_statlog.data.csv")


server = function(input, output, session) {
    
    data_temp = data.frame(d)
    
    updateCheckboxGroupInput(session, inputId = "field", choices = names(data_temp),selected = names(data_temp))
    output$result = renderPrint({
        paste(url, sep = "/", input$dataset)
    })
    
    output$table = renderDataTable(
        data_temp[, input$field , drop = FALSE],
        options = list(
            searching = TRUE,
            scrollX=TRUE
        )
    )
    output$plot = renderPlotly({
        # cor = cor(matrix(rnorm(100), ncol = 10))
        corr = round(cor(d), 1)
        ggplotly(ggcorrplot(corr, hc.order = TRUE, type = "lower", lab = TRUE))
    })
    output$summary = renderPrint(summary(data_temp))

}