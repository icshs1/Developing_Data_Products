library(UsingR)
data(mtcars)
variables <- sort(colnames(mtcars))
shinyUI(
  navbarPage("mtcars Database Explorer",
             tabPanel("Historam",
                      sidebarPanel(
                        radioButtons("id1", "Choose variables", variables ) 
                      ),
                      mainPanel(
                        plotOutput('plot') 
                      )
             ),
             tabPanel("Correlation",
                      sidebarPanel(
                        checkboxGroupInput("id2", "Select Varaiables", variables, selected=variables) 
                      ),
                      mainPanel(
                        plotOutput('plot_corr') 
                      )
             ),
             tabPanel("Download",
                      sidebarPanel(
                        checkboxGroupInput("id3", "Select Varaiables", variables, selected=variables) 
                      ),
                      mainPanel(
                        dataTableOutput(outputId="table"),
                        downloadButton('downloadData', 'Download') 
                      )
             ),
             tabPanel("About",
                      mainPanel(includeMarkdown("introduction.md"))
             )
  )
)
