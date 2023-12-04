
library(shiny)
library(tidyverse)
# reconsider about this data input
crab<-read.table("C:/Users/Xiaomeng Liu/OneDrive/桌面/2023 fall/ST558/repo/Finalproject/crab.txt",header = TRUE)
g<-ggplot(crab)

# Define server logic required to draw a histogram
function(input, output, session) {
  
  output$plot<-renderPlot({
   p1<-plot(crab$width,crab$satell)
   p1
  }
  )
  output$summary<-renderTable({
    variables<-colnames(crab)[1]
    
    cbind(data.frame(variables),t(sapply(crab[variables],summary)))
  }
  )
  output$newplot<-renderPlot({
    g+geom_point(aes(x=width,y=satell,color = color))
  })
  output$histplot<-renderPlot({
    g+ geom_histogram(aes(x=width))
  })
  output$glm<- renderPrint({
    fit.logit<-glm(y~width,family = binomial(link = "logit"),data = crab)
    summary(fit.logit)
  })
}
