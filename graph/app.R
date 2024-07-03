library(shiny)
library(bslib)
library(tidyverse)
library(glue)

df <- read_csv("dataset/cleaned_breaches.csv")
colnames(df) <- c("organisation", "records_lost", "year", "month", "story", "sector", "method", "data sensitivity", "source_link")
df <- df %>%
  mutate(
    year = as.numeric(year),
    records_lost = as.numeric(gsub("[^0-9]", "", records_lost))
  )

# x - record_lost , y - year
plot_two <- function(data, x, y) {
  ggplot(data = data, aes(x = .data[["records_lost"]], y = .data[["year"]])) +
  geom_point() +
    theme_minimal() +
    labs(x = "Records Lost", y = "Year")
  }
  

# myPlot <- function(data, x, y, ptsize, axsize) {
#   
#   p <- ggplot(data = data, aes(x = .data[[x]], y = .data[[y]])) +
#     geom_point(size = ptsize) +
#     theme(axis.title = element_text(size = axsize))
#   
#   return(p)
# }

myText <- function(data, x, y, ptsize, axsize) {
  
  myString <- glue("ggplot(data = data, aes(x = {x}, y = {y})) +
    geom_point(size = {ptsize}) +
    theme(axis.title = element_text(size = {axsize}))")
  
  
  return(myString)
}



ui = fluidPage(
  titlePanel("Explore the Iris Data"),
  
  sidebarLayout(
    sidebarPanel(
      # selectInput("species", label = "Choose Species",
      #             choices = c(unique(as.character(iris$Species)), "All_species")),
      # selectInput("trait1", label = "Choose Trait1",
      #             choices = colnames(iris)[1:4]),
      # selectInput("trait2", label = "Choose Trait2",
      #             choices = colnames(iris)[1:4]),
      # selectInput("theme_Choice", label = "Theme",
      #             choices = c("Default", "Classic", "Black/White")),
      sliderInput("year",
                  label = "Year", 
                  min = 2004, max = 2024,
                  value = 2004),
      sliderInput("records_lost",
                  label = "Record_Lost",
                  min = 0, max = 1000000000,
                  value = 0)
    ),
    
    mainPanel(
      # plotOutput("Species_plot"),
      plotOutput("new_plot"),
      
      verbatimTextOutput("code1"),
      verbatimTextOutput("code2")
    )
  )
  
)

server <- function(input,output) {
  
  # data <- reactive(iris)
  
  filtered_data <- reactive({
    df %>%
      # filter(year >= input$year[1], year <= input$year[2],
      #        records_lost >= input$records_lost[1], records_lost <= input$records_lost[2])
    filter(year==input$year , records_lost <= input$records_lost)
  })
  
  
  output$new_plot <- renderPlot({
    # Most basic bubble plot
    plot_two(filtered_data(), input$records_lost,  input$year)
  })
  
  # To print out the code using glue library
  output$code1 <- renderPrint({
    filtered_data()
  })
  

}

shinyApp(ui, server)