# A5 server.R
library(dplyr)
library(ggplot2)
library(leaflet)

world_data <- ggplot2::map_data('world')
names(world_data)[5] <- "country"
#View(world_data)

# Read in data

world_coordinates <- country_coordinates <- read.csv("./data/average-latitude-longitude-countries.csv")

codes <- read.csv("./data/countries_codes.csv")

co2_data <- read.csv('./data/owid-co2-data.csv', stringsAsFactors = FALSE)

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

filtered_data_all_years <- co2_data %>% 
  group_by(country) %>% 
  select(year, country, iso_code, co2, population, co2_per_capita, co2_growth_abs, co2_per_unit_energy)
#View(filtered_data_all_years)
#-----------------------------------------------------------

world_coordinates <- world_coordinates %>% 
  select(code = ISO.3166.Country.Code, lat = Latitude, long = Longitude)

codes <- codes %>% 
  select(code = alpha.2, iso_code = alpha.3)

world_coordinates <- world_coordinates %>% 
  left_join(codes, by = "code") %>% 
  select(iso_code, lat, long)

co2_all_years_coordinates <- filtered_data_all_years %>% 
  left_join(world_coordinates, by = "iso_code")

# Define your shiny server in which you...
server <- function(input, output) {
  output$Map <- renderLeaflet({
    
    # Construct a color palette (scale) based on chosen analysis variable
    palette_fn <- colorFactor(
      palette = "Dark2",
      domain = co2_all_years_coordinates[[input$mapvar]]
    )
    # Create and return the map 
    leaflet(data = co2_all_years_coordinates) %>%
      addProviderTiles("Stamen.TonerLite") %>% 
      addCircleMarkers( 
        lat = ~lat,
        lng = ~long,
        label = ~paste0(country, ", ", co2_all_years_coordinates[[input$mapvar]]),
        color = ~palette_fn(co2_all_years_coordinates[[input$mapvar]]),
        fillOpacity = .7,
        radius = 5,
        stroke = FALSE
      ) %>% 
      addLegend( 
        "bottomright",
        title = "Legend",
        pal = palette_fn, 
        values = co2_all_years_coordinates[[input$mapvar]],
        opacity = 1  
      )
  })
}
