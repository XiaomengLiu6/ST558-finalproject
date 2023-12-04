

library(shiny)
crab<-read.table("C:/Users/Xiaomeng Liu/OneDrive/桌面/2023 fall/ST558/repo/Finalproject/crab.txt",header = TRUE)

# Define UI for application that draws a histogram
fluidPage(
  titlePanel("crab data analysis"),
  
  #sidebarLayout(
    #sidebarPanel(
    #  h3("This controls what to show"),
    #  selectInput("xx",label = "choose the x",choices = colnames(crab)),
    #  selectInput("yy",label = "Choose the y",choices = colnames(crab))
   # ),
    
    mainPanel(
      tabsetPanel(
        type="tabs",
        tabPanel("About",
                 tags$p("Describe the purpose of the app"),
                 tags$p("– Briefly discuss the data and its source - providing a link to more information about the data"),
                 tags$p("Tell the user the purpose of each tab (page) of the app"),
                 tags$p("Include a picture related to the data (for instance, if the data was about the world wildlife fund,
                        you might include a picture of their logo)"
                 )),
        tabPanel("Data Exploration",
                 plotOutput("plot"),
                 tableOutput("summary"),
                 plotOutput("newplot"),
                 plotOutput("histplot")
                 ),
        tabPanel("Modeling",tabsetPanel(
          type="tabs",
          tabPanel("Model Info",
                   tags$p("I explain what they are")
                   ),
          tabPanel("Model Fitting",
                   sliderInput("train",label = "train/test percentage", min = 0, max = 1,value = 0.5),
                   checkboxGroupInput("predictor",label = "Choose the predictor variables for the plot",
                                      choices = colnames(crab)),
                   verbatimTextOutput("glm")
                   ),
          tabPanel("Prediction")
        ))
      )
      
    )

#)
)
