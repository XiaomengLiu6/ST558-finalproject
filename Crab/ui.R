

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
                     conditionalPanel(condition = "input.selectplot == 'scatter plot'",
                                      selectInput("xs","x for scatter plot",choices = colnames(crab)[-c(4,6)])
                                      ),
                     conditionalPanel(condition = "input.selectplot == 'histogram'",
                                      selectInput("xs","x for histogram",choices = colnames(crab)[-c(4,6)])
                     ),
                     conditionalPanel(condition = "input.selectplot == 'multivariate relatinoships plots'",
                                      selectInput("xs","x for mutlivariate relationship plot",choices = colnames(crab)[-c(4,6)])
                     ),
                     checkboxGroupInput("num_var",label = "Choose the variables for the summary",
                                        choices = colnames(crab)),
                     checkboxGroupInput("feature",label = "Choose the variables features",
                                        choices = c("min","Q1","median","mean","Q2","max","std dev")),
                     actionButton("action1","Click here to run the numerical summaries")
                   ),
                   mainPanel(
                     plotOutput("plot"),
                     br(),
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
                                    h3("Input your desired value for width"),
                                    numericInput("pre1","Width has a suggested 
                                                 range between ",
                                                 min = 0, max =9999, value =26.1)
                   ),
                   conditionalPanel(condition = "input.predictor.includes('color')",
                                    h3("Input your desired value for color"),
                                    numericInput("pre2","Color has a suggested 
                                                 range between",
                                                 min = 0, max =9999, value =3)
                   ),
                   conditionalPanel(condition = "input.predictor.includes('spine')",
                                    h3("Input your desired value for spine"),
                                    numericInput("pre3","Spine has a suggested 
                                                 range between ",
                                                 min = 0, max =9999, value =3)
                   ),
                   conditionalPanel(condition = "input.predictor.includes('satell')",
                                    h3("Input your desired value for satell"),
                                    numericInput("pre4","Satell has a suggested 
                                                 range between 0 and 5",
                                                 min = 0, max =9999, value = 2)
                   ),
                   conditionalPanel(condition = "input.predictor.includes('weight')",
                                    h3("Input your desired value for weight"),
                                    numericInput("pre5","Weight has a suggested
                                                 range between ",
                                                 min = 0, max =9999, value =2350.0)
                   ),
                   
                   verbatimTextOutput("pred")
                   )
        ))
      )
      
    )

#)
)
