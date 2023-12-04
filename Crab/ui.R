

library(shiny)

# Define UI for application that draws a histogram
fluidPage(
  titlePanel("crab data analysis"),
  
  sidebarLayout(
    sidebarPanel(
      h3("This controls what to show in the Data Exploration"),
      selectInput("varname",label = "Choose the variable you need",choices = "color")
    ),
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
                 tableOutput("summary")
                 ),
        tabPanel("Modeling")
      )
    )

)
)
