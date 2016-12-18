## Mine the Wikipedia articles for sequenced genomes

library(tidyverse)
library(rvest)
library(stringr)

# Create a function to deliver a table of genomes and insights given a url
extract_insights <- function(url, genome_keywords = "Genome|genome|sequence",  
                             insight_keywords = "insight|reveal|elucidate|unveil") {

  # Open the html session
  session <- html_session(url)
  
  # Read the page
  page <- read_html(session)
  
  # Scrape the reference list
  references <- html_node(page, ".references-column-count-2 , .references-column-width , .journal") %>%
    html_text() %>%
    str_split("\n") %>%
    unlist()
  
  # Extract titles
  search <- references %>%
    gregexpr(pattern = "\"", text = .)
  
  # Iterate over both
  titles <- mapply(references, search, FUN = function(text, ind) {
    # Skip if no match found
    if (ind[1] == -1) return(NULL)
    
    # Otherwise extract
    str_sub(string = text, start = ind[1] + 1, end = ind[2] - 1) })
  
  # Remove nulls
  titles1 <- titles[!sapply(titles, is.null)]
  
  # Filter for titles with the word "genome" or "sequence" and the word "insight"
  # or "reveal"
  titles2 <- titles1 %>% 
    str_subset(genome_keywords) %>% 
    str_subset(insight_keywords)
    
  # Extract the "insights"
  insights <- titles2 %>% 
    str_split(insight_keywords) %>%
    # Grab the last result
    sapply(function(x) last(x)) %>%
    # Trim articles and things like "s," "ing," and "into %>%
    str_replace_all("^s|^ing|^into|^ed", "") %>%
    str_trim() %>%
    str_replace_all("^into", "") %>%
    str_trim()
  
  # Extract the genomes
  genomes <- titles2 %>% 
    str_split(insight_keywords) %>%
    # Grab the first result
    sapply(function(x) first(x)) %>%
    # Trim action words
    str_split("yield|provide") %>%
    sapply(function(x) first(x)) %>%
    # Trim punctuation
    str_replace_all("[:punct:]", "") %>%
    str_trim()
  
  # Create data.frame
  data.frame(
    genome = genomes,
    insights = insights
  )
  
} # Close function

  
# List the url to mine
urls <- list(
  "https://en.wikipedia.org/wiki/List_of_sequenced_animal_genomes",
  "https://en.wikipedia.org/wiki/List_of_sequenced_eukaryotic_genomes",
  "https://en.wikipedia.org/wiki/List_of_sequenced_plant_genomes",
  "https://en.wikipedia.org/wiki/List_of_sequenced_bacterial_genomes",
  "https://en.wikipedia.org/wiki/List_of_sequenced_archaeal_genomes",
  "https://en.wikipedia.org/wiki/List_of_sequenced_fungi_genomes",
  "https://en.wikipedia.org/wiki/List_of_sequenced_plastomes",
  "https://en.wikipedia.org/wiki/List_of_sequenced_protist_genomes"
)

# Extract insights
genome_insights <- lapply(urls, FUN = extract_insights) %>%
  bind_rows()

# Save the data
saveRDS(genome_insights, "genome_insights.rds")

titles <- replicate(n.titles, expr = {
  str_c(sample(genome_insights$genome, 1), " provides insights into ", sample(genome_insights$insights, 1))
})
  

# Function for randomly sampling genomes and insights
generate_title <- function(genome_insights, n.titles = 1) {
  
  replicate(n.titles, {str_c(sample(genome_insights$genome, 1), " provides insights into ", sample(genome_insights$insights, 1))})
  
}


  
generate_title(genome_insights, n.titles = 1)
