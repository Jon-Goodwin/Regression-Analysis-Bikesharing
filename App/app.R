library(shiny)
library(tidyverse)
library(here)
data <- read_csv(here("inputs\\day.csv"))
# Define UI ----
ui <- fluidPage(
  titlePanel("Exploration of BikeShare Data"),
  sidebarLayout(
    sidebarPanel(
      selectInput("plottype", label = "Plot-type:", choices = c("Distribution",
                                                                "Bar",
                                                                "Scatterplot",
                                                                "Line")),
      selectInput("xvar", label = "X-variable:", choices = names(data)),
      selectInput("yvar", label = "Y-variable:", choices = names(data))
    )
  ),
  tabsetPanel(
    mainPanel(
        plotOutput("plot")
    )
  )
)

# Define server logic ----
server <- function(input, output) {
  output$plot <- renderPlot({
    ggplot(data, aes(x = .data[[input$xvar]], y = .data[[input$yvar]])) +
                              geom_point()
  }, res = 96)
}

# Run the app ----
shinyApp(ui = ui, server = server)