#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(here)
bikeshare_data <- read_csv(here("inputs\\day.csv"))
# Define the user interface (UI)
ui <- fluidPage(
  titlePanel("BikeShare Data Exploratory Data Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      # Dropdown menus for variable selection
      selectInput("x_var", "Select X variable:", choices = colnames(bikeshare_data)),
      selectInput("y_var", "Select Y variable:", choices = colnames(bikeshare_data)),
      
      # Date range input
      dateRangeInput("date_range", "Select date range:", start = min(bikeshare_data$date), end = max(bikeshare_data$date))
    ),
    
    mainPanel(
      # Plot output
      plotOutput("scatterplot"),
      
      # Summary statistics table
      tableOutput("summary_stats")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  # Reactive scatterplot
  output$scatterplot <- renderPlot({
    filtered_data <- bikeshare_data %>%
      filter(date >= input$date_range[1] & date <= input$date_range[2])
    
    ggplot(filtered_data, aes_string(x = input$x_var, y = input$y_var)) +
      geom_point() +
      theme_minimal() +
      labs(x = input$x_var, y = input$y_var, title = "BikeShare Data Scatterplot")
  })
  
  # Reactive summary statistics
  output$summary_stats <- renderTable({
    filtered_data <- bikeshare_data %>%
      filter(date >= input$date_range[1] & date <= input$date_range[2])
    
    summary_stats <- filtered_data %>%
      summarize(min_cnt = min(cnt), max_cnt = max(cnt), mean_cnt = mean(cnt), median_cnt = median(cnt), sd_cnt = sd(cnt))
    
    summary_stats
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)

