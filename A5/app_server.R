# A5 server.R
library(dplyr)
library(ggplot2)
library(leaflet)
source('./scripts/build_map1.R')

world_data <- ggplot2::map_data('world')
names(world_data)[5] <- "country"
#View(world_data)

# Read in data

co2_data <- read.csv('./co2-data/owid-co2-data.csv', stringsAsFactors = FALSE)

#data variables

#Annual total production-based emissions of carbon dioxide (CO₂), measured in million tonnes. 
highest_co2_emission_total <- co2_data %>%
  filter(co2 == max(co2, na.rm = TRUE)) %>% 
  pull(co2)
#print(highest_co2_emission_total)
#Primary energy consumption per capita, measured in kilowatt-hours per person per year.
highest_per_capita_energy_consumption <- co2_data %>% 
  filter(energy_per_capita == max(energy_per_capita, na.rm = TRUE)) %>% 
  pull(energy_per_capita)
#print(highest_per_capita_energy_consumption)
highest_per_capita_energy_consumption_country <- co2_data %>% 
  filter(energy_per_capita == max(energy_per_capita, na.rm = TRUE)) %>% 
  pull(country)
#print(highest_per_capita_energy_consumption_country)

#Total greenhouse gas emissions, measured in tonnes of carbon dioxide-equivalents per capita.
highest_per_capita_greenhouse_country <- co2_data %>% 
  filter(ghg_per_capita == max(ghg_per_capita, na.rm = TRUE)) %>% 
  pull(country)
#print(highest_per_capita_greenhouse_country)
highest_per_capita_greenhouse <- co2_data %>% 
  filter(ghg_per_capita == max(ghg_per_capita, na.rm = TRUE)) %>% 
  pull(ghg_per_capita)
#print(highest_per_capita_greenhouse)

filtered_data <- co2_data %>% 
  group_by(country) %>% 
  filter(year == max(year, na.rm = TRUE))
#View(filtered_data)

lat_long_df <- left_join(world_data, filtered_data, by = "country")
#View(lat_long_df)

# Define your shiny server in which you...
server <- function(input, output) {
  output$leafletMap <- renderLeaflet({
    leaflet(data = lat_long_df) %>% #input$mapvar
      addMarkers(lng = ~long, lat = ~lat) %>% 
      addTiles() %>%
      addProviderTiles(providers$Esri.WorldStreetMap)
  })
}


map <- leaflet() %>%
  addTiles() %>% 
  addMarkers()
#print(map)



#output$map <- renderPlotly({
#  return(build_map(filtered_data1, input$mapvar))
#})
