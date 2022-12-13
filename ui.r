ui = fluidPage(
    theme = shinytheme("sandstone"),
    titlePanel("Nah"),
    sidebarLayout(
        sidebarPanel(
            width = 4,
            tabsetPanel(
                tabPanel("DATASET",
                    selectInput("dataset",
                                "Dataset:",
                                ""
                    ),
                    fluidRow(
                        column(4,
                            checkboxGroupInput("cb_CleanOption",
                                "Clean data:",
                                choices = list("N/A" = 1,
                                                "Type" = 2
                                                )
                            )
                        ),
                        column(4,
                            radioButtons("rd_sort",
                                "Sort:",
                                c("None" = "none",
                                    "A-Z" = "a-z",
                                    "Z-A" = "z-a")
                            )
                        )
                    ),
                    sliderInput("sd_DataZise",
                        "Data Size:", 
                        min = 0, 
                        max = 100, 
                        value = c(0, 20)
                    ),
                    textInput("txt_search",
                        "Search"
                    ),
                    textOutput("txt_result")
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
                tabPanel("Table",
                    dataTableOutput('table')
                ),
                tabPanel("Plot",
                    plotOutput("plot")
                ),
                tabPanel("Summary")
            )
        )
    )
)