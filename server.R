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
    # select predictor 
    predictor <-reactive({input$id4}) 
    
    # adjust value according to selected predictor 
    predict_value <-reactive({ 
      if(input$id4=="disp") 
        predict_value<-input$id5 
      else if(input$id4=="hp") 
        predict_value<-input$id6 
      if(input$id4=="wt") 
        predict_value<-input$id7 
      if(input$id4=="qsec") 
        predict_value<-input$id8 
      return(predict_value) 
    }) 
    
    # linear model training 
    # predictor am and selected variable (hp, dist, qsec, wt) 
    ## fit<- lm(mpg ~ x1 + am + x1 * am, mtcars) 
    fit<- reactive({ 
      fit<-lm(mpg ~ mtcars[ , predictor()] + am + mtcars[ , predictor()]* am, mtcars) 
      return(fit) 
    }) 
    # predict resutl with input predict value. 
    predict_result<- reactive({ 
      predict<-c(fit()$coef[1] + predict_value() * fit()$coef[2], 
                 fit()$coef[1] + fit()$coef[3] + predict_value() * (fit()$coef[2] + fit()$coef[4])) 
      return(predict) 
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

    output$plot_modeling <- renderPlot({ 
  
      title <- "Linear Model of mtcars" 
  
      ## plot mpg and selected predictor 
      x1<- mtcars[ , predictor()] 
      plot(x=x1,y=mtcars$mpg,col = (mtcars$am == 0)*2 + 2,main=title,xlab=predictor(),ylab="mpg") 
  
      # plot model coefs 
      abline(c(fit()$coef[1],fit()$coef[2]),col='blue') 
      abline(c(fit()$coef[1] + fit()$coef[3],fit()$coef[2] + fit()$coef[4]),col='red') 
  
      # plot results of prediction 
      input$goButton 
      isolate(points(x=predict_value(),y=predict_result()[1], col='blue', pch = 17)) 
      input$goButton 
      isolate(points(x=predict_value(),y=predict_result()[2], col='red', pch = 17)) 
    }) 

    ## print results of prediction 
    output$predictedValue <- renderText({input$goButton 
                             isolate(sprintf("For %s %g\n automatic is: %g mpg\n standard is %g mpg", 
                             input$id4, predict_value(), predict_result()[1], predict_result()[2])) 
    }) 
  } 
)
