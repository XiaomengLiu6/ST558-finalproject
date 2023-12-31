
library(shiny)
library(tidyverse)
library(caret)
# data input
crab<-read.table("crab.txt",header = TRUE)
# basic plot
g<-ggplot(crab)
# set the seed
set.seed(123)


function(input, output, session) {
#input html links
  output$source<-renderUI({
    tagList("More info about data:",
            a("Orginal Paper",href='https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1439-0310.1996.tb01099.x'))
  })
  output$source1<-renderUI({
    tagList("The picture is from this link:",
            a("picture source",href='https://tbrnewsmedia.com/long-island-scientists-seek-horseshoe-crab-answers/'))
  })
  # input the image from the same folder
  output$crabpic<-renderImage({
    list(src='horseshoe_crab.jpg',
    contentType="image/jpeg",
    width = 700,
    height = 500
    )
    },deleteFile = FALSE
  )
  # name selection plot as sp
  sp<-reactive({
    gg<-input$selectplot
  })
  
  # do reactive for each selection choice
  s1<-reactive({
    xs1<-input$xs1
    ys1<-input$ys1
    list(xs1=xs1,ys1=ys1)
  })
  s2<-reactive({
    xs2<-input$xs2
  })
  s3<-reactive({
    xs3<-input$xs3
    ys3<-input$ys3
    zs3<-input$zs3
    list(xs3=xs3,ys3=ys3,zs3=zs3)
  })
  # draw the plot with selection by if function
  output$plot<-renderPlot({
    if (sp()=="scatter plot"){
    plot(crab[,s1()$xs1],crab[,s1()$ys1],
         xlab = s1()$xs1,ylab=s1()$ys1, 
         main = paste0("This is the scatter plot for ",s1()$xs1," vs. ",
                       s1()$ys1))
    }
    if (sp()=="histogram"){
      hist(crab[,s2()],xlab = s2(),main = paste0("This is the histogram for ",
                                                 s2()))
    }
    if (sp()=="multivariate relatinoship plots"){
    g+geom_point(aes_string(x=s3()$xs3,y=s3()$ys3,color = s3()$zs3))
      # an update need here
    }
  }
  )
  # The third variable for multivariate plot should not be the same as the 
  # first one. (it would not be meaningful)
  observe({
    if(input$xs3=="color"){
    updateSelectInput(session,"zs3",choices = c("spine","width","weight"))
    }
    else if (input$xs3 == "spine"){
      updateSelectInput(session,"zs3",choices = c("color","width","weight"))
    }
    else if (input$xs3 == "width"){
      updateSelectInput(session,"zs3",choices = c("spine","color","weight"))
    }
    else if (input$xs3 == "weight"){
      updateSelectInput(session,"zs3",choices = c("spine","width","color"))
    }
  })
  # set up action button for numerical summaries
  act1<-eventReactive(input$action1,{
    vv<-input$num_var
    ff<-input$feature
    list(vv=vv,ff=ff)
  })
  # use the action button to come up with different values
  output$summary<-renderTable({
    variables<-act1()$vv
    c1<-cbind(data.frame(variables),t(sapply(crab[variables],summary)))
    c2<-cbind(c1,sapply(crab[variables],sd))
    colnames(c2)[8]<-"sd"
    
    # decide the test columns
    tcol<-act1()$ff
    tcol<-recode(tcol,"min"=2,"Q1"=3,"median"=4,"mean"=5,"Q2"=6,"max"=7,"std dev"=8)
    c3<-cbind(data.frame(c2[,1]),data.frame(c2[,tcol]))
    colnames(c3)[1]<-"variable"
    
    if(ncol(c3)==2){
      colnames(c3)[2]<-act1()$ff
    }
    c3
    # output
    }
  )
  

  
# set the action button for modeling with all the options
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
    # split the training and testing
    crab_train<-crab[act()$index,] 
    crab_test<-crab[-act()$index,]
    # train the model and output it and summary
    withProgress(message = "Calculation in progress",{
    fit.logit<-train(as.formula(act()$pp1),data = crab_train,
                                 method = "glm",
                                 preProcess=c("center","scale"))
    crab_test$y<-as.factor(crab_test$y)
    })
    list(fit.logit,summary(fit.logit))
  })
  
  # section for random forest output
  output$rf<-renderPrint({
    # split the training and testing
    crab_train<-crab[act()$index,] 
    crab_test<-crab[-act()$index,]
    # train the model and output it and summary
    withProgress(message = "Calculation in progress",{
    fit.rf<-train(as.formula(act()$pp1), data = crab_train,
                  method="rf",
                  trControl = trainControl(method = "cv",number = act()$cc),
                  preProcess=c("center","scale"),
                  tuneGrid = data.frame(mtry=c(act()$pa1:act()$pa2)))
    })
    list(fit.rf,summary(fit.rf$finalModel))
  })
  
  # output the confusion matrix for comparison
  output$compare<-renderPrint({
    crab_train<-crab[act()$index,] 
    crab_test<-crab[-act()$index,]
    withProgress(message = "Calculation in progress",{
    fit.logit<-train(as.formula(act()$pp1),data = crab_train,
                     method = "glm",
                     preProcess=c("center","scale"))
    fit.rf<-train(as.formula(act()$pp1), data = crab_train,
                  method="rf",
                  trControl = trainControl(method = "cv",number = act()$cc),
                  preProcess=c("center","scale"),
                  tuneGrid = data.frame(mtry=c(act()$pa1:act()$pa2)))})
    # convert response to factor before confusion matrix
    list(confusionMatrix(data=as.factor(crab_test$y),predict(fit.logit,crab_test)),
         confusionMatrix(data=as.factor(crab_test$y),predict(fit.rf,crab_test)))
  })
  

  # prediction tab
  output$pred<-renderPrint({
    # do the same as above so that the same action button would work
    crab_train<-crab[act()$index,] 
    crab_test<-crab[-act()$index,]
    withProgress(message = "Calculation in progress",{
    fit.logit<-train(as.formula(act()$pp1),data = crab_train,
                     method = "glm",
                     preProcess=c("center","scale"))
    fit.rf<-train(as.formula(act()$pp1), data = crab_train,
                  method="rf",
                  trControl = trainControl(method = "cv",number = act()$cc),
                  preProcess=c("center","scale"),
                  tuneGrid = data.frame(mtry=c(act()$pa1:act()$pa2)))
    # define the input values' locations
    pre<-c(input$pre1,input$pre2,input$pre3,input$pre4,input$pre5)
    # create the new data frame with extra columns which will not affect the function
    ndata<-data.frame('width'=pre[1], 'color'=pre[2], 'spine'=pre[3], 'satell'=pre[4], 'weight'=pre[5])
    # make the predictions
    randomforest_prediction<-predict(fit.rf,ndata)
    glm_prediction<-predict(fit.logit,ndata)})
    list(glm_prediction=glm_prediction,randomforest_prediction=randomforest_prediction)
  })
}
