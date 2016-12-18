## The server script
library(shiny)

# Load data
genome_insights <- readRDS("genome_insights.rds")

# Define the server logic
function(input, output) {
  
  # Wait for action button
  titles.to.print <- eventReactive(input$action, {
    
    paste(sample(genome_insights$genome, 1), "provides insights into", sample(genome_insights$insights, 1))
    
  })
  
  # Retun titles
  output$titles <- renderPrint({
    cat(titles.to.print())
  })
    
}
    
    
    
  