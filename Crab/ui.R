

library(shiny)
crab<-read.table("C:/Users/Xiaomeng Liu/OneDrive/桌面/2023 fall/ST558/repo/Finalproject/crab.txt",header = TRUE)

# Define UI for application that draws a histogram
fluidPage(
  titlePanel("crab data analysis"),

    
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
                 sidebarLayout(
                   sidebarPanel(
                     checkboxInput("graph","keep it?")
                   ),
                   mainPanel(
                     plotOutput("plot"),
                     tableOutput("summary"),
                     plotOutput("newplot"),
                     plotOutput("histplot")
                   )
                 )),
        tabPanel("Modeling",tabsetPanel(
          type="tabs",
          tabPanel("Model Info",
                   tags$p("I explain what they are")
                   ),
          
          tabPanel("Model Fitting",
                   sidebarLayout(
                     
                     sidebarPanel(
                       sliderInput("train",label = "train/test percentage", min = 0, max = 1,value = 0.5),
                       checkboxGroupInput("predictor",label = "Choose the predictor variables for the plot",
                                      choices = colnames(crab)[-6]),
                       numericInput("cv",label = "amount of cv for random forest",min = 0,max = 10,value = 5),
                       numericInput("pamin",label = "amount of parameter grid for random forest",min = 1,max = 5,value = 1),
                       numericInput("pamax",label = "amount of parameter grid for random forest",min = 1,max = 5,value = 2)
                                ),
                   
                    mainPanel(
                   verbatimTextOutput("glm"),
                   verbatimTextOutput("rf")
                              )
                  )),
          tabPanel("Prediction",
                   numericInput("response","Input your desired response for y (0 or 1)",min = 0, max =1, value =1),
                   verbatimTextOutput("pred")
                   )
        ))
      )
      
    )

#)
)
