# A5 ui.R
library(shiny)
library(plotly)

source("app_server.R")
#land_use_change_co2, land_use_change_co2_per_capita
map_sidebar_content <- sidebarPanel(
  selectInput(
    "mapvar",
    label = "Variable to Map",
    choices = list("CO2 Emissions" = "co2", "Population" = "population", 
                   "CO2 per capita" = "co2_per_capita", "CO2 Growth" = "co2_growth_abs", 
                   "CO2 per kilowatt-hour Energy" = "co2_per_unit_energy",
                   "CO2 per GDP" = "co2_per_gdp",
                   "CO2 Produced by Coal" = "coal_co2",
                   "CO2 Produced by Land-Use Change" = "land_use_change_co2",
                   "CO2 Produced by Land-Use Change per capita" = "land_use_change_co2_per_capita"
                   )
  ),
  selectInput(
    "yearvar",
    label = "Select Year",
    choices = list("1850", "1855", "1860", "1865", "1870", "1875", "1880", "1885", "1890", "1895", "1900", "1905", "1910", "1915", "1920", "1925", 
                   "1930", "1935", "1940", "1945", "1950", "1955", "1960", "1965", "1970", "1975", "1980", "1985", "1990", "1995", "2000", "2005",
                   "2010", "2015", "2020", "2021")
  )
)

map_main_content <- mainPanel(
  leafletOutput("Map")
)

map_panel <- tabPanel(
  "Map",
  titlePanel("A5 Map Test"),
  sidebarLayout(
    map_sidebar_content,
    map_main_content
  )
)

main_panel <- tabPanel(
  "Intro",
  titlePanel("CO2 Data Analysis"),
  mainPanel(
    h1("CO2 - A Global Issue", style = "font-family: 'times'; font-si16pt", align = "center"),
    h2("INFO 201 - A5", style = "font-family: 'times'; font-si16pt", align = "center"),
    p(paste0("CO2 is everywhere yet when it is unregulated, many environmental and public health issues 
        can arise. This Shiny Website has the purpose of filtering through CO2 data to determine 
        potential trends and factors that could be influencing CO2 levels which would ultimatley help 
        in identifying the best possible solution and course of action. According to the most recent data 
        available, the highest world annual total for production-based emissions of carbon dioxide 
        (CO₂), measured in million tonnes, is ", highest_co2_emission_total, ". Along with that, the highest 
        primary energy consumption per capita, in kilowatt-hours per person per year, 
        is ", highest_per_capita_energy_consumption, " which is held by ", highest_per_capita_energy_consumption_country, 
             ". In terms of greenhouse gas emissions, the highest per capita value, in tonnes of carbon dioxide-equivalents per capita, is ", 
             highest_per_capita_greenhouse, " which is held by ", highest_per_capita_greenhouse_country), 
      style = "font-family: 'times'; font-si16pt"
    )
  )
)

ui <- navbarPage(
  "CO2 Data Analysis",
  main_panel,
  map_panel
)

