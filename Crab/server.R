
library(shiny)
library(ggplot2)
library(tidyverse)
# reconsider about this data input
crab<-read.table("C:/Users/Xiaomeng Liu/OneDrive/桌面/2023 fall/ST558/repo/Finalproject/crab.txt",header = TRUE)

# Define server logic required to draw a histogram
function(input, output, session) {
  
  output$plot<-renderPlot({
   p1<-plot(crab$width,crab$satell)
   p1
  }
  )
  output$summary<-renderTable({
    t(sapply(crab[colnames(crab)],summary))
  }
  )

    

}
