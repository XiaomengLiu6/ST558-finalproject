

library(shiny)
crab<-read.table("crab.txt",header = TRUE)

# Define UI for application that draws a histogram
fluidPage(
  titlePanel("crab data analysis"),
    withMathJax(),
    mainPanel(
      tabsetPanel(
        type="tabs",
        # include the introduction and links and photos
        tabPanel("About",
                 h4("Purpose of the app."),
                 tags$p("The app is for studying the relationship between the 
                 number of male satellite crabs residing near the female and 
                        female crab information"),
                 br(),
                 h4("Brief data introduction and its source"),
                 tags$p("The data come from a study originally described by 
                 Brockman (Ethology 102:1 - 21,[1996]) and since reproduced in 
                 Agresti's text Categorical Data Analysis. The data has n=173  
                 nesting female horseshoe crab.The primary response 
                 variable satell is a count of the number of male satellite 
                 crabs residing near the female. The response variable called y 
                 is simply a binary indicator for whether the number of 
                 satellite crabs is greater than 0. There are several predictor 
                 variables that give characteristics of the female crab."),
                 uiOutput("source"),
                 br(),
                 h4("The purpose of each tab of this app."),
                 tags$p("In this app, three tabs are provided:
                        'About' provides basic information about the app.
                        'Data Exploration' provides numerical and graphical 
                        summaries about the crab data.
                        'Modeling' provides two types of supervised learning 
                        models for the data"),
                 br(),
                 h4("This is the picture of a horseshoe crab."),
                 uiOutput("source1"),
                 imageOutput("crabpic")
                 ),
        # include selection of plot output and action button for numerical summary
        tabPanel("Data Exploration",
                 sidebarLayout(
                   sidebarPanel(
                     selectInput("selectplot","Select the plot to show",
                                 choices = c("scatter plot","histogram", "multivariate relatinoship plots")),
                     conditionalPanel(condition = "input.selectplot == 'scatter plot'",
                                      selectInput("xs1","x for scatter plot",choices = colnames(crab)[-c(4,6)]),
                                      selectInput("ys1","y for scatter plot",choices = colnames(crab)[c(4,6)])
                                      ),
                     conditionalPanel(condition = "input.selectplot == 'histogram'",
                                      selectInput("xs2","x for histogram",choices = colnames(crab)[-c(4,6)])
                     ),
                     conditionalPanel(condition = "input.selectplot == 'multivariate relatinoship plots'",
                                      selectInput("xs3","x for multivariate relationship plot",choices = colnames(crab)[-c(4,6)]),
                                      selectInput("ys3","y for multivariate relationship plot",choices = colnames(crab)[c(4,6)]),
                                      selectInput("zs3","third variable for multivariate relationship plot",choices = colnames(crab)[-c(4,6)])
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
                     h3("Numerical summary for the crab data"), 
                     h5("Please select the variable(s) and feature(s), then hit 
                        the button to show"),
                     tableOutput("summary")
                   )
                 )),
        # explain the two models using in this study
        tabPanel("Modeling",tabsetPanel(
          type="tabs",
          tabPanel("Model Info",
                   h3("Generalized Linear Regression Model"),
                   tags$p("The generalized linear regression model applied in 
                          this study is the logistic regression model. It is a 
                          model for response that is success/failure. It models 
                          the probability of an event taking place by having the
                          log-odds for the event being a linear combination of 
                          one or more independent variables. It is estimating 
                          the parameters of a logistic model as the coefficients
                          in the linear combination"),
                    helpText("This is the formula for logistic regression:
                              $$P(success/x)=\\frac{e^{\\beta_0+\\beta_1x}}{1+
                             e^{\\beta_0+\\beta_1x}}$$"),
                   br(),
                   h4("Advantage of GLM"),
                   tags$p("1. Could be used for prediction/classification purpose"),
                   tags$p("2. Logistic regression works well for fitting binary
                          predicted varible."),
                   tags$p("3. The function for success probability never goes 
                          below 0 and never above 1, which is great for many
                          application"),
                   br(),
                   h4("Disadvantage of GLM"),
                   tags$p("1. It cannnot fit a continuous ourcome."),
                   tags$p("2. Logistic regression assumes linearity between the 
                          predicted variable and predictor variables."),
                   tags$p("3. The predictors are hard to interpret."),
                   tags$p("4. The logistic regression model does not have a 
                          closed form solution"),
                   br(),
                   h3("Random Forests Model"),
                   tags$p("The random forests model is an ensemble learning 
                          method. It uses the same idea as bagging. 
                          It creates multiple trees from bootstrap samples and 
                          averages results. It uses a random subset of 
                          predictors for each bootstrap sample fit."),
                   helpText("For classification, usually use m randomly selected
                   predictors $$m=\\sqrt{p}$$ For regression, usually use m randomly 
                            selected predictors $$m=p/3$$ "),
                   h4("Advantage of Random Forest"),
                   tags$p("1. Decrease variance over an individual tree fit"),
                   tags$p("2. By randomly selecting a subset of predictors, a 
                          good predictor or two won't dominate the tree fits"),
                   h4("Disadvantage of Random Forest"),
                   tags$p("1. It requires much computational power since it is 
                          building many trees."),
                   tags$p("2. It loses interpretability for each variable.")
                   ),
          # fit both model with inputs and action button
          # random forest has more inputs for number of cv and tune grid
          tabPanel("Model Fitting",
                   sidebarLayout(
                     
                     sidebarPanel(
                       sliderInput("train",label = "train/test percentage", 
                                   min = 0, max = 1,value = 0.5),
                       checkboxGroupInput("predictor",label = "Choose the 
                                          predictor variables for the plot",
                                      choices = colnames(crab)[-6]),
                       h4("Predictor SATELL is the same as the response variable
                          Y, but it is a numeric count instead of a binary 
                          variable"),
                       numericInput("cv",label = "amount of cv for random forest",
                                    min = 0,max = 10,value = 5),
                       numericInput("pamin",label = "amount of min parameter grid 
                                    for random forest",min = 1,max = 5,value = 1),
                       numericInput("pamax",label = "amount of max parameter grid 
                                    for random forest",min = 1,max = 5,value = 2),
                       actionButton("action","Click here to run the models")
                                ),
                   
                    mainPanel(
                      h2("Selecting the 'satell' predictor would cause warnings
                         from R console. An inappropriate tungrid selection for
                         random forest would also cause warnings. The function 
                         is not affected and will provide results."),
                      h3("Results from glm with accuracy as fit stat."),
                      h4("Please make the selections then hit action button to show the results."),
                      verbatimTextOutput("glm"),
                      br(),
                      h3("Results from random forest with accuracy as fit stat."),
                      verbatimTextOutput("rf"),
                      br(),
                      h3("Comparison statsitcis on the test set with accuracy"),
                      verbatimTextOutput("compare")
                      )
                  )),
          # provide only input options for those included in the previous page
          # use a conditional panel to filter it
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
                   br(),
                   h2("This are the two prediction based on the previous selction of 
                      the previous variables and model selections."),
                   h4("Our response variable only has two level 0 and 1"),
                   verbatimTextOutput("pred")
                   )
        ))
      )
      
    )

#)
)
