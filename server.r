d = read.csv("dataset/heart_statlog.csv")

source("server.d/sidebar.dataset.r")
source("server.d/sidebar.working.r")

source("server.d/main.table.r")
source("server.d/main.plot.r")
source("server.d/main.summary.r")

server = function(input, output, session) {
    output$result = renderPrint({
        paste(url, sep = "/", input$dataset)
    })
    output$table = renderDataTable(
        data.frame(d),
        options = list(
            searching = FALSE,
            scrollX=TRUE
        )
    )
    output$plot = renderPlotly({
        # cor = cor(matrix(rnorm(100), ncol = 10))
        corr = round(cor(d), 1)
        ggplotly(ggcorrplot(corr, hc.order = TRUE, type = "lower", lab = TRUE))
    })

}