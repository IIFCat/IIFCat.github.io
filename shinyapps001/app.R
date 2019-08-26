library(shiny)
library(ggplot2)
library(dplyr)

# uncomment this if you need to reload the stops table
stops <- read.csv('https://github.com/cengel/R-data-viz/raw/master/data/MS_stops.csv')

## UI
# Use a fluid Bootstrap layout
ui <- fluidPage(    
  
  # Give the page a title
  titlePanel("Missisippi Violations by County"),
  
  # adopted from https://www.cultureofinsight.com/blog/2018/03/15/2018-03-15-responsive-iframes-for-shiny-apps/
  tags$head(
    tags$script(src="https://cdnjs.cloudflare.com/ajax/libs/iframe-resizer/3.5.16/iframeResizer.contentWindow.min.js",
                type="text/javascript")
  ),
  
  # Generate a row with a sidebar
  sidebarLayout(      
    
    # Define the sidebar with one input
    sidebarPanel(
      selectInput("county", "County:", 
                  choices=unique(stops$county_name)),
      hr(),
      helpText("Data from Stanford Openpolicing Project.")
    ),
    
    # Create a spot for the barplot
    mainPanel(
      plotOutput("violationsPlot")  
    )
    
  ),
  
  # also adopted
  HTML('<div data-iframe-height></div>')
)



## Server

# Define a server for the Shiny app
server <- function(input, output) {
  
  # Fill in the spot we created for a plot
  output$violationsPlot <- renderPlot({
    
    stops %>% 
      filter(county_name == input$county) %>% 
      ggplot(aes(violation)) + 
      geom_bar(aes(fill = driver_gender), position = "fill")
  })
}

shinyApp(ui, server)