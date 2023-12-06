
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

  # name selection plot as sp
  sp<-reactive({
    gg<-input$selectplot
  })
  output$plot<-renderPlot({
    if (sp()=="scatter plot"){
    plot(crab$width,crab$satell)
    }
    if (sp()=="histogram"){
    g+ geom_histogram(aes(x=width))
    }
    if (sp()=="multivariate relatinoships plots"){
    g+geom_point(aes(x=width,y=satell,color = color))
    }
  }
  )

  va<-reactive({
    vv<-input$num_var
  })

  output$summary<-renderTable({
    variables<-va()
    cbind(data.frame(variables),t(sapply(crab[variables],summary)))
    }
  )
  

  
  # split the training and testing
  act<-eventReactive(input$action,{
    index<-createDataPartition(y=crab$satell,p=input$train,list=FALSE)
    cc<-input$cv
    pa1<-input$pamin
    pa2<-input$pamax
    pp<-paste0("y~",paste(c(input$predictor),collapse = "+"))
    pp1<-paste0("as.factor(y)~",paste(c(input$predictor),collapse = "+"))
    prediction<-c(input$predictor)
    list(pp=pp,pp1=pp1,index=index,cc=cc,pa1=pa1,pa2=pa2,prediction = prediction)
  })
 

 
# section for glm
  output$glm<- renderPrint({    
    crab_train<-crab[act()$index,] 
    crab_test<-crab[-act()$index,]
    fit.logit<-glm(act()$pp,family = binomial(link = "logit"),data = crab_train)
    summary(fit.logit)
  })
  
  # section for random forest output
  output$rf<-renderPrint({
    crab_train<-crab[act()$index,] 
    crab_test<-crab[-act()$index,]

    fit.rf<-train(as.formula(act()$pp1), data = crab_train,
                  method="rf",
                  trControl = trainControl(method = "cv",number = act()$cc),
                  preProcess=c("center","scale"),
                  tuneGrid = data.frame(mtry=c(act()$pa1:act()$pa2)))

    fit.rf
  })
  

  # prediction tab
  output$pred<-renderPrint({
    crab_train<-crab[act()$index,] 
    crab_test<-crab[-act()$index,]
    
    fit.logit<-glm(act()$pp,family = binomial(link = "logit"),data = crab_train)
    ndata<-data.frame()
    if ('width' %in% act()$prediction){
      ndata<-cbind(ndata,data.frame(width = input$pre1))
      if ('color' %in% act()$prediction){
        ndata<-cbind(ndata,data.frame(color = input$pre2))
        if ('spine' %in% act()$prediction){
          ndata<-cbind(ndata,data.frame(spine = input$pre3))
          if ('satell' %in% act()$prediction){
            ndata<-cbind(ndata,data.frame(satell = input$pre4))
            if ('weight' %in% act()$prediction){
              ndata<-cbind(ndata,data.frame(weight = input$pre5))
            }
          }
        }
      }
    }
    predict(fit.logit,ndata)
  })
}
