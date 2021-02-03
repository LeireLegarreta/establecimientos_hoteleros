
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
library(mapSpain)
library(utf8)
leaflet()%>%addTiles()

#########################################################
# CARGAR DATOS

#########################################################

# cargar mapas espaciales de las provincias de Espa?a (he descargado el archivo zip de shapefile espa?a en local)


#download.file("http://thematicmapping.org/downloads/TM_WORLD_BORDERS_SIMPL-0.3.zip" , destfile="world_shape_file.zip")
#unzip("provincias.zip")
mapa = readOGR(dsn="C:/Users/Irene/Desktop/Proyectos/EUSTAT/Scripts/ESP_adm", layer="ESP_adm1", encoding="utf-8")
mapa@data$NAME_1 <- as_utf8(mapa@data$NAME_1) # Creo que no cambia nada
mapa@data$NAME_1
plot(mapa)




# Cargar datos encuesta
setwd(directorio_out)

entradas <- read.csv("datos_dia.csv", header = TRUE, sep = ";")


str(entradas)

# Cambiar nombres de las columnas que contienen entradas de las comunidades aut?nomas

names(entradas)

names(entradas)[22:39] <- c("ENTRADAS_AND","ENTRADAS_ARA","ENTRADAS_AST","ENTRADAS_BAL",
                            "ENTRADAS_CANA","ENTRADAS_CANTA","ENTRADAS_CLM","ENTRADAS_CL",
                            "ENTRADAS_CAT","ENTRADAS_VAL","ENTRADAS_EXT","ENTRADAS_GAL",
                            "ENTRADAS_MAD","ENTRADAS_MUR","ENTRADAS_NAV","ENTRADAS_EUS",
                            "ENTRADAS_RIO","ENTRADAS_CEME")



names(entradas)
str(entradas)


# Hago una tabla en excel con los valores m?ximos de entrada_CCAA. Separo dates por a?o, mes y dia



nacionales2018 <- subset(entradas, entradas$FECHA> "2018-01-01" & entradas$FECHA < "2019-01-01")

nacionales2019 <- subset(entradas, entradas$FECHA> "2019-01-01" & entradas$FECHA < "2020-01-01")

nacionales2020 <- subset(entradas, entradas$FECHA> "2020-01-01" & entradas$FECHA < "2021-01-01")

str(entradas2018)



colSums(nacionales2018[,22:39], na.rm = T)
colSums(nacionales2019[,22:39], na.rm = T)
colSums(nacionales2020[,22:39], na.rm = T)





# Cargo hoja excel que he creado con los valores m?ximos de entradas por pa?s

setwd(directorio_in_OTROS)
procedencia_nacionales <- read_excel("procedencia_turistas_nacionales.xlsx") 


# Uno este dataframe con el que tiene las coordenadas del mapa del mundo

procedencia_turismo_nacional <- merge(mapa, procedencia_nacionales, by="ID_1")


##########################################################
# VISUALIZACI?N CON SHINY



ui <- dashboardPage(
  dashboardHeader(title = "Mapa"),
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        "Procedencia turistas nacionales",
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
        leafletOutput('spain_chor1')
        
      ),
      
      tabItem(  
        tabName = "2019",
        tags$style(type = 'text/css', '#world_chor {height: calc(100vh - 80px) !important;}'),
        leafletOutput('spain_chor2')
      ),
      
      tabItem(  
        tabName = "2020",
        tags$style(type = 'text/css', '#world_chor {height: calc(100vh - 80px) !important;}'),
        leafletOutput('spain_chor3')
      )
    )
  )
)
  
  
  
    
    


server <- function(input, output, session) {
  
  data(procedencia_turismo_nacional)
  output$spain_chor1 <- renderLeaflet({
    
    bins=c(0,1000,5000,10000,25000,50000,Inf)
    pal = colorBin(palette = "YlOrBr", domain=procedencia_turismo_nacional$VISITANTES2018, na.color = "transparent", bins=bins)
    
    customLabel = paste("CCAA: ", procedencia_turismo_nacional$CCAA, "<br/>", "N. visitantes: ", procedencia_turismo_nacional$VISITANTES2018, sep = "") %>% 
      lapply(htmltools::HTML)
    
    leaflet(procedencia_turismo_nacional) %>%
      
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
        title ="N. Visitantes"
      )
  })
  
  
  output$spain_chor2 <- renderLeaflet({
    
    bins=c(0,1000,5000,10000,25000,50000,Inf)
    pal = colorBin(palette = "YlOrBr", domain=procedencia_turismo_nacional$VISITANTES2019, na.color = "transparent", bins=bins)
    
    customLabel = paste("CCAA: ", procedencia_turismo_nacional$CCAA, "<br/>", "N. visitantes: ", procedencia_turismo_nacional$VISITANTES2019, sep = "") %>% 
      lapply(htmltools::HTML)
    
    leaflet(procedencia_turismo_nacional) %>%
      
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
        title ="N. Visitantes"
      )
  })
  
  
  output$spain_chor3 <- renderLeaflet({
    
    bins=c(0,1000,5000,10000,25000,50000,Inf)
    pal = colorBin(palette = "YlOrBr", domain=procedencia_turismo_nacional$VISITANTES2020, na.color = "transparent", bins=bins)
    
    customLabel = paste("CCAA: ", procedencia_turismo_nacional$CCAA, "<br/>", "N. visitantes: ", procedencia_turismo_nacional$VISITANTES2020, sep = "") %>% 
      lapply(htmltools::HTML)
    
    leaflet(procedencia_turismo_nacional) %>%
      
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


  
  
  
  


