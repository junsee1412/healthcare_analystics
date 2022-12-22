ui = fluidPage(
    theme = shinytheme("sandstone"),
    titlePanel("Healthcare Analystics"),
    sidebarLayout(
        sidebarPanel(
            width = 4,
            tabsetPanel(
                tabPanel("DATASET",
                    # selectInput("dataset",
                    #             "Dataset:",
                    #             ""
                    # ),
                    checkboxGroupInput("cb_CleanOption",
                        "Clean data:",
                        choices = list("N/A" = 1,
                                        "Type" = 2
                                        )
                    ),
                    checkboxGroupInput("field",
                                       "Column data:",
                                       choices = list("age" = 1,
                                                      "sex" = 2
                                       )
                    ),
                    
                    # ,
                    # sliderInput("sd_DataZise",
                    #     "Data Size:", 
                    #     min = 0, 
                    #     max = 100, 
                    #     value = c(0, 20)
                    # ),
                    # textInput("txt_search",
                    #     "Search"
                    # )
                ),
                tabPanel("WORKING",
                    radioButtons("dist",
                                "Distribution type:",
                                c("Normal" = "norm",
                                    "Uniform" = "unif",
                                    "Log-normal" = "l-norm",
                                    "Exponential" = "exp")
                    ),
                    sliderInput(inputId = "bins", 
                        label = "Number of bins:",
                        min = 1,
                        max = 100,
                        value = sample(1:100, 1)
                    ),
                )
            ),
            verbatimTextOutput("result")
        ),
        mainPanel(
            width = 8,
            tabsetPanel(
                id = 'dataset',
                tabPanel("Table",
                    dataTableOutput('table')
                ),
                tabPanel("Plot",
                    plotlyOutput("plot")
                ),
                tabPanel("Summary", verbatimTextOutput("summary")),
            )
        )
    )
)