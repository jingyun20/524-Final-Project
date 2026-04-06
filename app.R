library(shiny)
library(httr)
library(jsonlite)
library(dplyr)
library(ggplot2)

# =========================
# 🌍 World Bank API function
# =========================
get_wb_data <- function(country, indicator, start_year, end_year) {
  
  url <- paste0(
    "https://api.worldbank.org/v2/country/",
    country,
    "/indicator/",
    indicator,
    "?format=json&date=",
    start_year, ":", end_year
  )
  
  res <- GET(url)
  data <- fromJSON(content(res, "text"), flatten = TRUE)
  
  df <- data[[2]]
  
  df_clean <- df %>%
    select(date, value) %>%
    rename(year = date) %>%
    mutate(
      year = as.numeric(year),
      value = as.numeric(value)
    ) %>%
    filter(!is.na(value)) %>%
    arrange(year)
  
  return(df_clean)
}

# =========================
# 🤖 Simple Interpretation
# =========================
generate_interpretation <- function(df) {
  
  if (nrow(df) < 2) {
    return("Not enough data to generate interpretation.")
  }
  
  trend <- ifelse(last(df$value) > first(df$value), "increasing", "decreasing")
  
  paste0(
    "From ", min(df$year), " to ", max(df$year),
    ", the indicator shows an overall ", trend,
    " trend. The average value is ",
    round(mean(df$value, na.rm = TRUE), 2),
    ", with a minimum of ",
    round(min(df$value, na.rm = TRUE), 2),
    " and a maximum of ",
    round(max(df$value, na.rm = TRUE), 2),
    "."
  )
}

# =========================
# 🎛 UI
# =========================
ui <- fluidPage(
  
  titlePanel("🌍 Interactive Global Health Trend Explorer"),
  p("Explore global health trends across countries and time to support data-driven insights."),
  
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput("country", "Select Country:",
                  choices = c(
                    "United States" = "USA",
                    "China" = "CHN",
                    "India" = "IND",
                    "Brazil" = "BRA"
                  )),
      
      selectInput("indicator", "Select Indicator:",
                  choices = c(
                    "Life Expectancy" = "SP.DYN.LE00.IN",
                    "Infant Mortality" = "SP.DYN.IMRT.IN",
                    "Health Expenditure (% GDP)" = "SH.XPD.CHEX.GD.ZS"
                  )),
      
      sliderInput("years", "Select Year Range:",
                  min = 1960, max = 2022,
                  value = c(2000, 2020))
    ),
    
    mainPanel(
      plotOutput("trendPlot"),
      verbatimTextOutput("summaryStats"),
      h4("🧠 Interpretation"),
      textOutput("interpretation")
    )
  )
)

# =========================
# ⚙️ Server
# =========================
server <- function(input, output) {
  
  data_reactive <- reactive({
    get_wb_data(
      input$country,
      input$indicator,
      input$years[1],
      input$years[2]
    )
  })
  
  output$trendPlot <- renderPlot({
    
    df <- data_reactive()
    
    ggplot(df, aes(x = year, y = value)) +
      geom_line(size = 1) +
      geom_point() +
      labs(
        title = "Trend Over Time",
        x = "Year",
        y = "Value"
      ) +
      theme_minimal()
  })
  
  output$summaryStats <- renderPrint({
    
    df <- data_reactive()
    
    df %>%
      summarise(
        mean = round(mean(value), 2),
        min = round(min(value), 2),
        max = round(max(value), 2)
      )
    
  })
  
  output$interpretation <- renderText({
    df <- data_reactive()
    generate_interpretation(df)
  })
}

# =========================
# ▶️ Run App
# =========================
shinyApp(ui = ui, server = server)
