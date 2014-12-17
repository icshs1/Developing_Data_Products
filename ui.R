library(UsingR) 
data(mtcars) 
variables <- sort(colnames(mtcars)) 

predictorRange <<- list(c(min(mtcars$disp),max(mtcars$disp)), 
                        c(min(mtcars$hp),max(mtcars$hp)), 
                        c(min(mtcars$wt),max(mtcars$wt)), 
                        c(min(mtcars$qsec),max(mtcars$qsec))) 
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
             tabPanel("Linear Model", 
                      sidebarPanel( 
                        radioButtons("id4", "Choose variables", c("disp","hp","wt","qsec")), 
                        numericInput("id5","disp Predictor value",(predictorRange[[1]][1] + predictorRange[[1]][2])/2.0, 
                                     min=predictorRange[[1]][1], 
                                     max=predictorRange[[1]][2], 
                                     step=0.0000001), 
                        numericInput("id6","hp Predictor value",(predictorRange[[2]][1] + predictorRange[[2]][2])/2.0, 
                                     min=predictorRange[[2]][1], 
                                     max=predictorRange[[2]][2], 
                                     step=0.0000001), 
                        numericInput("id7","wt Predictor value",(predictorRange[[3]][1] + predictorRange[[3]][2])/2.0, 
                                     min=predictorRange[[3]][1], 
                                     max=predictorRange[[3]][2], 
                                     step=0.0000001), 
                        numericInput("id8","qsec Predictor value",(predictorRange[[4]][1] + predictorRange[[4]][2])/2.0, 
                                     min=predictorRange[[4]][1], 
                                     max=predictorRange[[4]][2], 
                                     step=0.0000001), 
                        actionButton('goButton','Go!') 
                      ), 
                      mainPanel( 
                        plotOutput('plot_modeling'), 
                        h4('Predicted Milage values:'), 
                        verbatimTextOutput("predictedValue") 
                      ) 
             ), 
             tabPanel("About", 
                      mainPanel(includeMarkdown("introduction.md")) 
             ) 
  ) 
)