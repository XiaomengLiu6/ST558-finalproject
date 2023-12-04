
library(shiny)
library(tidyverse)
library(caret)
# reconsider about this data input
crab<-read.table("C:/Users/Xiaomeng Liu/OneDrive/桌面/2023 fall/ST558/repo/Finalproject/crab.txt",header = TRUE)
g<-ggplot(crab)
# set the seed
set.seed(123)

# Define server logic required to draw a histogram
function(input, output, session) {

  graph<-reactive({
    gg<-input$graph
  })
  output$plot<-renderPlot({
    if (graph()=="TRUE"){
    p1<-plot(crab$width,crab$satell)
    p1
    }
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
  
  # split the training and testing
 index<-reactive({
    indextrain<-createDataPartition(y=crab$satell,p=input$train,list=FALSE)
  })   

 
# section for glm
 # input the predictors
 pred<-reactive({
   pp<-paste0("y~",paste(c(input$predictor),collapse = "+"))
 })
  
  output$glm<- renderPrint({    
    crab_train<-crab[index(),] 
    crab_test<-crab[-index(),]
    fit.logit<-glm(pred(),family = binomial(link = "logit"),data = crab_train)
    summary(fit.logit)
  })
  
  # section for random forest output
  pred1<-reactive({
    pp1<-paste0("as.factor(y)~",paste(c(input$predictor),collapse = "+"))
  })
  cv1<-reactive({
    cc<-input$cv
  })
  
  pa1<-reactive({
    pa1<-input$pamin
  })
  pa2<-reactive({
    pa2<-input$pamax
  })
  output$rf<-renderPrint({
    crab_train<-crab[index(),] 
    crab_test<-crab[-index(),]

    fit.rf<-train(as.formula(pred1()), data = crab_train,
                  method="rf",
                  trControl = trainControl(method = "cv",number = cv1()),
                  preProcess=c("center","scale"),
                  tuneGrid = data.frame(mtry=c(pa1():pa2())))

    fit.rf
  })
  
  output$pred<-renderPrint({
    
  })
}
