fluidPage(
  
  sidebarLayout( 
    sidebarPanel(
      tabsetPanel(
        tabPanel("Cloud", 
                 titlePanel(h3("Word Cloud")),
                 selectInput("selection", "Choose a txt:",
                             choices = books),
                 actionButton("update", "Change"),#########
                 hr(),
                 sliderInput("freq","Minimum Frequency:",min = 1,  max = 50, value = 15),
                 sliderInput("max","Maximum Number of Words:",min = 1,  max = 100,  value = 30)
        ),
        
        tabPanel("Dataplot",
                 fileInput("file", label = h3("File input"),accept=c('text/csv', 'text/comma-separated-values,text/plain')),
                 br(),
                 selectInput('xcol', 'X Variable',""),
                 selectInput('ycol', 'Y Variable',""),
                 br(),
                 
                 checkboxGroupInput("checkGroup", label = h3("Checkbox group"), 
                                    choices = list("Linear Model" = 1, "Quadratic Model" = 2),
                                    selected = 0),
                 br(),
                 sliderInput("thickness", label = "Line Thickness", min = 1, max = 5, value = 1, step = 0.5) ,  #####
                 
                 numericInput('clusters', 'Cluster count', 3,min = 1, max = 9)
                 
                 
                 
                 ) , ######
        ############
        tabPanel("Cluster", 
                 fileInput("file1", label = h3("File input"),accept=c('text/csv', 'text/comma-separated-values,text/plain')),
                 br(),
                 selectInput('xcol1', 'X Variable',""),
                 selectInput('ycol1', 'Y Variable',""),                 
                 numericInput('clusters', 'Cluster count', 3,min = 1, max = 9)
        )
        
        
       ###### 
       )
      ),   
 
    mainPanel(
      tabsetPanel(
        tabPanel("Cloud",plotOutput("plot")),
        tabPanel("Dataplot", plotOutput("dataplot")),
        tabPanel("Cluster", plotOutput("plot1"))  
      )
      
    )
  )
)