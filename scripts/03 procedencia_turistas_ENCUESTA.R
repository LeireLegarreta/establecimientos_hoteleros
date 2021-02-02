
######################################################
# Librerias a cargar:
library(shiny)
library(tidyverse)
library(maps)
library(readxl)
library(ggplot2)
library(sf)
library(dplyr)
library(mapproj)
library(raster)
library(sp)
library(rgdal)
library(leaflet)
library(leaflet.extras)
library(shinydashboard)
leaflet()%>%addTiles()

#########################################################
# CARGAR DATOS

#########################################################

# cargar mapas espaciales mundo

download.file("http://thematicmapping.org/downloads/TM_WORLD_BORDERS_SIMPL-0.3.zip" , destfile="world_shape_file.zip")
unzip("world_shape_file.zip")
world_spdf = readOGR(dsn=getwd(), layer="TM_WORLD_BORDERS_SIMPL-0.3")


# Cargar datos encuesta
setwd(directorio_out)

data_entradas <- read_excel("datos_dia.xlsx", stringsAsFactors = F)

data_entradas <- as.numeric(data_entradas, replace=T)

entradas <- mutate_all(data_entradas, function(x) as.numeric(as.character(x)))

str(entradas)

# Hago una tabla en excel con los valores máximos de entrada_PAIS. Separo dates por año, mes y dia


entradas2018 <- subset(entradas, data_entradas$FECHA> "2018-01-01" & data_entradas$FECHA < "2019-01-01")

entradas2019 <- subset(entradas, data_entradas$FECHA> "2019-01-01" & data_entradas$FECHA < "2020-01-01")

entradas2020 <- subset(entradas, data_entradas$FECHA> "2020-01-01" & data_entradas$FECHA < "2021-01-01")

str(entradas2018)

summary(entradas2018)
summary(entradas2019)
summary(entradas2020)





names(data_entradas)

# Cargo hoja excel que he creado con los valores máximos de entradas por país

setwd(directorio_in_OTROS)
procedencia <- read_excel("data_procedencia_turistas.xlsx") 


# Uno este dataframe con el que tiene las coordenadas del mapa del mundo

world_spdf_procedencia <- merge(world_spdf, procedencia, by="NAME")


##########################################################
# VISUALIZACIÓN CON SHINY



ui <- dashboardPage(
  dashboardHeader(title = "Mapa"),
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        "Procedencia de turistas",
        tabName = "maps",
        icon = icon("globe"),
        menuSubItem("Procedencia 2018", tabName = "2018", icon = icon("map")),
        menuSubItem("Procedencia 2019", tabName = "2019", icon = icon("map")),
        menuSubItem("Procedencia 2020", tabName = "2020", icon=icon("map"))
      )
    )
  ),

  
  dashboardBody(
    tabItems(
      tabItem(  
        tabName = "2018",
        tags$style(type = 'text/css', '#world_chor {height: calc(100vh - 80px) !important;}'),
        leafletOutput('world_chor1')
        
      ),
      
      tabItem(  
        tabName = "2019",
        tags$style(type = 'text/css', '#world_chor {height: calc(100vh - 80px) !important;}'),
        leafletOutput('world_chor2')
      ),
      
      tabItem(  
        tabName = "2020",
        tags$style(type = 'text/css', '#world_chor {height: calc(100vh - 80px) !important;}'),
        leafletOutput('world_chor3')
      )
    )
  )
)
  
  
  
    
    


server <- function(input, output, session) {
  
  data(world_spdf_procedencia)
  output$world_chor1 <- renderLeaflet({
    
    bins=c(0,10,20,50,100,500,Inf)
    pal = colorBin(palette = "YlOrBr", domain=world_spdf_procedencia$VISITANTES2018, na.color = "transparent", bins=bins)
    
    customLabel = paste("Pais: ", world_spdf_procedencia$NAME, "<br/>", "N. visitantes: ", world_spdf_procedencia$VISITANTES2018, sep = "") %>% 
      lapply(htmltools::HTML)
    
    leaflet(world_spdf_procedencia) %>%
      
      addProviderTiles(providers$OpenStreetMap, options = tileOptions(minZoom=2, maxZoom=8)) %>%
      
      addPolygons(fillColor = ~pal(VISITANTES2018),
                  fillOpacity = 0.9,
                  stroke = TRUE,
                  color="white",
                  highlight=highlightOptions(
                    weight = 5,
                    fillOpacity = 0.3
                  ),
                  label = customLabel,
                  weight = 0.3,
                  smoothFactor = 0.2) %>%
      
      addLegend(
        pal=pal,
        values = ~VISITANTES2018,
        position = "bottomright",
        title ="% Visitantes"
      )
  })
  
  
  output$world_chor2 <- renderLeaflet({
    
    bins=c(0,10,20,50,100,500,Inf)
    pal = colorBin(palette = "YlOrBr", domain=world_spdf_procedencia$VISITANTES2019, na.color = "transparent", bins=bins)
    
    customLabel = paste("Pais: ", world_spdf_procedencia$NAME, "<br/>", "N. visitantes: ", world_spdf_procedencia$VISITANTES2019, sep = "") %>% 
      lapply(htmltools::HTML)
    
    leaflet(world_spdf_procedencia) %>%
      
      addProviderTiles(providers$OpenStreetMap, options = tileOptions(minZoom=2, maxZoom=8)) %>%
      
      addPolygons(fillColor = ~pal(VISITANTES2019),
                  fillOpacity = 0.9,
                  stroke = TRUE,
                  color="white",
                  highlight=highlightOptions(
                    weight = 5,
                    fillOpacity = 0.3
                  ),
                  label = customLabel,
                  weight = 0.3,
                  smoothFactor = 0.2) %>%
      
      addLegend(
        pal=pal,
        values = ~VISITANTES2019,
        position = "bottomright",
        title ="% Visitantes"
      )
  })
  
  
  output$world_chor3 <- renderLeaflet({
    
    bins=c(0,10,20,50,100,500,Inf)
    pal = colorBin(palette = "YlOrBr", domain=world_spdf_procedencia$VISITANTES2020, na.color = "transparent", bins=bins)
    
    customLabel = paste("Pais: ", world_spdf_procedencia$NAME, "<br/>", "N. visitantes: ", world_spdf_procedencia$VISITANTES2020, sep = "") %>% 
      lapply(htmltools::HTML)
    
    leaflet(world_spdf_procedencia) %>%
      
      addProviderTiles(providers$OpenStreetMap, options = tileOptions(minZoom=2, maxZoom=8)) %>%
      
      addPolygons(fillColor = ~pal(VISITANTES2020),
                  fillOpacity = 0.9,
                  stroke = TRUE,
                  color="white",
                  highlight=highlightOptions(
                    weight = 5,
                    fillOpacity = 0.3
                  ),
                  label = customLabel,
                  weight = 0.3,
                  smoothFactor = 0.2) %>%
      
      addLegend(
        pal=pal,
        values = ~VISITANTES2020,
        position = "bottomright",
        title ="N. Visitantes"
      )
  })
  
  
  
  
  
}

shinyApp(ui, server)


  
  
  
  


