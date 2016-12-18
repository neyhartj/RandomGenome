## User interface script
library(shiny)

# Define the UI for an application that generates random genome titles
fluidPage(
  
  headerPanel("Genome Paper Title Generator"),
  
  sidebarPanel(
    p("Apparently genomes are very insightful. To illustrate, this app will
      randomly mash together segments from ~120 genome papers to create a 
      new paper title!"),
    br(),
    actionButton("action", "Generate Title")
  ),
  
  mainPanel(
    h4(textOutput("titles"))
  )
)