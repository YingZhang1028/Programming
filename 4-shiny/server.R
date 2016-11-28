library(shiny)
library(ggplot2)

function(input, output, session) {
  
  terms <- reactive({
    input$update
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        getTermMatrix(input$selection)
      })
    })
  })

  wordcloud_rep <- repeatable(wordcloud)
  output$plot <- renderPlot({
    v <- terms()
    wordcloud_rep(names(v), v, scale=c(4,0.5),
                  min.freq = input$freq, max.words=input$max,
                  colors=brewer.pal(8, "Dark2"))
  })
  
  data <- reactive({ 
    
    inFile <- input$file 
    if (is.null(inFile)){return(NULL)}
    mydata <- read.csv(inFile$datapath)
    
    updateSelectInput(session, inputId = 'xcol', label = 'X Variable',
                      choices = names(mydata), selected = names(mydata)[[4]])
    updateSelectInput(session, inputId = 'ycol', label = 'Y Variable',
                      choices = names(mydata),selected = names(mydata)[[5]])
    
    return(mydata)
  })
  
  selectedData <- reactive({
    inFile <- input$file 
    if (is.null(inFile)){return(iris)}
    else{
      data()[, c(input$xcol, input$ycol)]
    }
  }) 
  
  output$dataplot <- renderPlot({
    
    mydata <- selectedData()
    naData <- mydata[!is.na(mydata$review),]     ##########
    
    g <- ggplot(NULL)+
      geom_point(data=mydata, aes(x=mydata[1],y=mydata[2], color="value", size=5))+
      #geom_boxplot(data=mydata, aes(x=mydata[1],y=mydata[2]))+
      xlab("Independent Variable")+
      ylab("Dependent Variable")+
      scale_color_manual(name="",values=c("value"="lightblue"))    
    
    if(is.null(input$checkGroup)){
      return(print(g))
    }
    
    else{
      
      if(input$checkGroup == 1 & length(input$checkGroup)==1) {
        g1 <- g + 
          geom_smooth(data=mydata,aes(x=mydata[1],y=mydata[2]), 
                      method='lm',color = "darkblue",lwd = input$thickness)
        return(print(g1))
      }
      
      else if(input$checkGroup == 2 & length(input$checkGroup)==1) {
        g2 <- g + 
          geom_smooth(data=mydata,aes(x=mydata[1],y=mydata[2]), 
                      method='lm',formula = y ~ x + I(x^2), color = "orange",
                      lwd = input$thickness)
        return(print(g2))
      }
      
      else {
        g3 <- g + 
          geom_smooth(data=mydata,aes(x=mydata[1],y=mydata[2]), 
                      method='lm',color = "darkblue",lwd = input$thickness)+
          geom_smooth(data=mydata,aes(x=mydata[1],y=mydata[2]), 
                      method='lm',formula = y ~ x + I(x^2), color = "orange",
                      lwd = input$thickness)
        return(print(g3))  
      }
    } 
 
  })
  
  
  
  ###############
  data1 <- reactive({ 
    
    inFile <- input$file1 
    if (is.null(inFile)){return(NULL)}
    mydata <- read.csv(inFile$datapath)
    
    updateSelectInput(session, inputId = 'xcol1', label = 'X Variable',
                      choices = names(mydata), selected = names(mydata)[[4]])
    updateSelectInput(session, inputId = 'ycol1', label = 'Y Variable',
                      choices = names(mydata),selected = names(mydata)[[5]])
    
    return(mydata)
  })
  
  selectedData1 <- reactive({
    inFile <- input$file1 
    if (is.null(inFile)){return(iris)}
    else{
      data1()[, c(input$xcol1, input$ycol1)]
      
    }
  }) 
  
  clusters <- reactive({
    kmeans(selectedData1(), input$clusters)
  })
  
  output$plot1 <- renderPlot({
    palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
              "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
    
    par(mar = c(5.1, 4.1, 0, 1))
    plot(selectedData1(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
  
  
  
}