# ST558-finalproject

Brief description of the app and its purpose.
```
The app is desired to show features of a data set about horseshoe crabs. It would
help us better understand the relationships between the number of male satellite 
crabs residing near the female and possible predictors of female crabs' information.
A more detailed description would be inside the "About" page.
A basic EDA would be provided in the "Data Exploration" page for each predictor.
Two types of supervised learning models, generalized linear model and radnom forest
model, are provided in the "Modeling" page. Both models would be used to fit the
data and to provide predictions. The performances of both models would be compared
and the results would be shown.
Overall, the app could help us to learn more about the data and make predictions. 
```

A list of packages needed to run the app.
```
library(shiny)
library(tidyverse)
library(caret)
```

A line of code that would install all the packages used (so we can easily grab that and run it prior to
running your app).
```
install.packages(c("shiny","tidyverse","caret"))
```

The shiny::runGitHub() code that we can copy and paste into RStudio to run your app.
```
shiny::runGitHub("ST558-finalproject","XiaomengLiu6",subdir="app")
```
