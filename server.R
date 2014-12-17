library(UsingR) 
library(ggplot2) 
data(mtcars) 
shinyServer( 
  function(input, output) { 
    value <- reactive({input$id1}) 
    select_data<-reactive({ 
      subset(mtcars,select=input$id2) 
    }) 
    down_data<-reactive({ 
      subset(mtcars,select=input$id3) 
    }) 
    
    output$plot <- renderPlot({ 
      
      title <- "Histogram of Motor Trend Car Road Tests DB variables" 
      xlab <- value() 
      w=mtcars[ , value()] 
      hist(w,main = title,xlab=xlab) 
    }) 
     
    
    output$plot_corr <- renderPlot({ ## plot correlation between variables 
      pairs(select_data()) 
    }) 
    
    output$table <- renderDataTable( ## save data using selected variables 
{down_data()}, options = list(bFilter = FALSE, iDisplayLength = 10)) 

output$downloadData <- downloadHandler( 
  filename = function() { 
    paste('data-', Sys.Date(), '.csv', sep='') 
  }, 
  content = function(file) { 
    write.csv(down_data(), file, row.names=FALSE) 
  } 
) 
## DEBUG 
output$text_output <- renderText({sprintf("%s %s",input$id1,input$id2) 
}) 
  } 
) 
