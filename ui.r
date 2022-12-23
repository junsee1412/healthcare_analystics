
ui <- dashboardPage(
  dashboardHeader(title = "Heart dashboard"),
  
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("home")),
      menuItem("Charts", tabName = "charts", icon = icon("chart-simple")),
      menuItem("About", tabName = "about", icon = icon("circle-info"))
    )
  ),
  
  
  
  
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "dashboard",
              fluidPage(
                theme = shinytheme("yeti"),
                titlePanel("Healthcare Analystics"),
                sidebarLayout(
                  sidebarPanel(
                    width = 4,
                    tabsetPanel(
                      tabPanel("DATASET",
                               checkboxGroupInput("cb_clean",
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
                    verbatimTextOutput("result"),
                    verbatimTextOutput("Test"),
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
                      tabPanel("TestTable",
                               dataTableOutput('test_table')
                      ),
                    )
                  )
                )
              )
              
              
      ),
      
      # Second tab content
      tabItem(tabName = "charts",
              h2("Charts tab content"),
              plotOutput("plot1", height = 600),
              
              htmlOutput("table_hd")
              
      ),
      tabItem(tabName = "about",
              includeMarkdown("README.MD")
              
      )
    )
  )
)