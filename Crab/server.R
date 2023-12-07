
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
    g+geom_col(aes(x=width))
    }
    if (sp()=="multivariate relatinoships plots"){
    g+geom_point(aes(x=width,y=y,color = color))
    }
  }
  )

  act1<-eventReactive(input$action1,{
    vv<-input$num_var
    ff<-input$feature
    list(vv=vv,ff=ff)
  })
  output$summary<-renderTable({
    variables<-act1()$vv
    c1<-cbind(data.frame(variables),t(sapply(crab[variables],summary)))
    c2<-cbind(c1,sapply(crab[variables],sd))
    colnames(c2)[8]<-"sd"
    
    # the test columns
    tcol<-act1()$ff
    tcol<-recode(tcol,"min"=2,"Q1"=3,"median"=4,"mean"=5,"Q2"=6,"max"=7,"std dev"=8)
    c3<-cbind(data.frame(c2[,1]),data.frame(c2[,tcol]))
    colnames(c3)[1]<-"variable"
    
    if(ncol(c3)==2){
      colnames(c3)[2]<-act1()$ff
    }
    c3
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
    fit.logit<-train(as.formula(act()$pp1),data = crab_train,
                                 method = "glm",
                                 preProcess=c("center","scale"))
    crab_test$y<-as.factor(crab_test$y)
    list(fit.logit,confusionMatrix(data=crab_test$y,predict(fit.logit,crab_test)))
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

    list(fit.rf,confusionMatrix(data=as.factor(crab_test$y),predict(fit.rf,crab_test)))
  })
  

  # prediction tab
  output$pred<-renderPrint({
    crab_train<-crab[act()$index,] 
    crab_test<-crab[-act()$index,]
    
    fit.logit<-train(as.formula(act()$pp1),data = crab_train,
                     method = "glm",
                     preProcess=c("center","scale"))
    fit.rf<-train(as.formula(act()$pp1), data = crab_train,
                  method="rf",
                  trControl = trainControl(method = "cv",number = act()$cc),
                  preProcess=c("center","scale"),
                  tuneGrid = data.frame(mtry=c(act()$pa1:act()$pa2)))
    pre<-c(input$pre1,input$pre2,input$pre3,input$pre4,input$pre5)
    ndata<-data.frame('width'=pre[1], 'color'=pre[2], 'spine'=pre[3], 'satell'=pre[4], 'weight'=pre[5])
    list(predict(fit.logit,ndata),predict(fit.rf,ndata))
  })
}
