library(shiny)
shinyUI(pageWithSidebar(
  headerPanel("Calculating the distance to the marine target"),
  sidebarPanel(
    numericInput('platform','Platform height, m',10,min=0,max=300,step=0.01),
    numericInput('observer','Observer\'s eye height, m',1.65,min=0.5,max=2.5,step=0.01),
    sliderInput('tide', 'Tide height, m',value = 0, min = -1.5, max = 1.5, step = 0.1,),
    conditionalPanel(condition = "input.units == 'mils'",
                     sliderInput(inputId = "mils",
                                 label = "Target reticle",
                                 min = 0, max = 80, value = 5, step = 0.5)
    ),
    conditionalPanel(condition = "input.units == 'deg'",
                     sliderInput(inputId = "degs",
                                 label = "Target reticle",
                                 min = 0, max = 5, value = 1, step = 0.1)
    ),
    radioButtons("units", 'Reticle units',
                 choices = list("Mils" = 'mils', "Degrees" = 'deg'),selected = 'mils')
    
  ),
  mainPanel(
    wellPanel(
      h3("Instructions"),
      p("In order to estimate the distance to the marine target:"),
      htmlOutput('item1'),
      htmlOutput('item2'),
      htmlOutput('item3'),
      htmlOutput('item4'),
      htmlOutput('item5'),
      htmlOutput('item6'),
      p("Note: Currently specified values are shown in brackets.")
    ),
    wellPanel(
      plotOutput('newHist')
    )
  )
))