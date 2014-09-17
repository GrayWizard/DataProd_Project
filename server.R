library(shiny)
library(UsingR)
data(galton)

distance2target <- function(height,theta) {
  earth_radius <- 6371000
  full_height <- earth_radius+height
  alpha <- atan(sqrt(2*height*earth_radius+height^2)/earth_radius)
  beta <- pi/2-alpha-theta
  d0  <- full_height*cos(beta)-sqrt(full_height^2*cos(beta)^2-(2*height*earth_radius+height^2))
  delta  <-  asin(sin(beta)*d0/earth_radius)
  distance <- delta*earth_radius
  distance
}

shinyServer(
  function(input, output) {
    output$newHist <- renderPlot({
      obsHeight <- input$platform+input$observer-input$tide
      if(input$units=='mils') {
        conv <- 0.000981748
        theta <- input$mils*conv
        f <- function(x) distance2target(obsHeight,x*conv)
        curve(f,from=0,to=80,n=1000,xlab="Reticle",ylab="Distance",main=paste("Distance profile for the observation height of ",obsHeight,"m"))
        lines(c(input$mils,input$mils),c(0,distance2target(obsHeight,0)),col="green",lwd=3)
        text(80,distance2target(obsHeight,0),paste("Distance to target: ",round(f(input$mils),2),'m'),adj = c(1,1))
      } else {
        conv <- 0.0174532925
        theta <- input$degs*conv
        f <- function(x) distance2target(obsHeight,x*conv)
        curve(f,from=0,to=5,n=1000,xlab="Reticle",ylab="Distance",main=paste("Distance profile for the observation height of ",obsHeight,"m"))
        lines(c(input$degs,input$degs),c(0,distance2target(obsHeight,0)),col="green",lwd=3)
        text(5,distance2target(obsHeight,0),paste("Distance to target: ",round(f(input$degs),2),'m'),adj = c(1,1))
      }
    })
    output$item1 <- renderText({paste("1. Speciy the height of the observation platform (",strong(input$platform),") and the eye-hight of the observer",strong(input$observer),")")})
    output$item2 <- renderText({paste("2. Select the unit of the reticle grid for your binoculars (",strong(input$units),")")})
    output$item3 <- renderText({paste("3. Specify the tide height at the observation time (",strong(input$tide),")")})
    output$item4 <- renderText({paste("4. Align the zero reticle mark on your binoculars with the horizon")})
    output$item5 <- renderText({
      if(input$units=='mils') {
        paste("5. Specify the reticle mark that overlays the target (",strong(input$mils),")")
      } else {
        paste("5. Specify the reticle mark that overlays the target (",strong(input$degs),")")
      }
      })
    output$item6 <- renderText({paste("6. The distance profile graph for the specified heights and the distance to target would be shown in the window below")})
    
  }
)