

library(shiny)
crab<-read.table("C:/Users/Xiaomeng Liu/OneDrive/桌面/2023 fall/ST558/repo/Finalproject/crab.txt",header = TRUE)

# Define UI for application that draws a histogram
fluidPage(
  titlePanel("crab data analysis"),

    
    mainPanel(
      tabsetPanel(
        type="tabs",
        tabPanel("About",
                 tags$p("The app is for studying the relationship between the 
                 number of male satellite crabs residing near the female and 
                        female crab information"),
                 
                 tags$p("The data come from a study originally described by Brockman 
                 (Ethology 102:1 - 21,[1996]) and since reproduced in Agresti's 
                        text Categorical Data Analysis. The data has n=173  
                        nesting female horseshoe crab.The primary response 
                        variable satell is a count of the number of male satellite crabs 
                        residing near the female. The response variable called y
                        is simply a binary indicator for whether the number of 
                        satellite crabs is greater than 0. There are several 
                        predictor variables that give characteristics of the 
                        female crab. 
                        https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1439-0310.1996.tb01099.x"),
                 
                 tags$p("In this app, three tabs are provided:
                        'About' provides basic information about the app.
                        'Data Exploration' provides numerical and graphical summaries about the crab data.
                        'Modeling' provides two types of supervised learning models for the data"),
                 tags$p("Include a picture related to the data (for instance, if the data was about the world wildlife fund,
                        you might include a picture of their logo)"
                 )),
        tabPanel("Data Exploration",
                 sidebarLayout(
                   sidebarPanel(
                     selectInput("selectplot","Select the plot to show",
                                 choices = c("scatter plot","histogram",
                                             "multivariate relatinoships plots")),
                     checkboxGroupInput("num_var",label = "Choose the variables for the summary",
                                        choices = colnames(crab))
                   ),
                   mainPanel(
                     plotOutput("plot"),
                     tableOutput("summary")
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
                       numericInput("pamax",label = "amount of parameter grid for random forest",min = 1,max = 5,value = 2),
                       actionButton("action","Click here to run the models")
                                ),
                   
                    mainPanel(
                   verbatimTextOutput("glm"),
                   verbatimTextOutput("rf")
                              )
                  )),
          tabPanel("Prediction",
                   conditionalPanel(condition = "input.predictor.includes('width')",
                                    numericInput("pre1","Inputt your desired value for width",min = 0, max =9999, value =1)
                   ),
                   conditionalPanel(condition = "input.predictor.includes('color')",
                                    numericInput("pre2","Inputt your desired value for color",min = 0, max =9999, value =1)
                   ),
                   conditionalPanel(condition = "input.predictor.includes('spine')",
                                    numericInput("pre3","Inputt your desired value for spine",min = 0, max =9999, value =1)
                   ),
                   conditionalPanel(condition = "input.predictor.includes('satell')",
                                    numericInput("pre4","Inputt your desired value for satell",min = 0, max =9999, value =1)
                   ),
                   conditionalPanel(condition = "input.predictor.includes('weight')",
                                    numericInput("pre5","Inputt your desired value for weight",min = 0, max =9999, value =1)
                   ),
                   
                   verbatimTextOutput("pred")
                   )
        ))
      )
      
    )

#)
)
