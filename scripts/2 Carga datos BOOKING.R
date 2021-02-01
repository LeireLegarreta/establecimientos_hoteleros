

# Carga de datos -------------------------------------------------------------
##############################################################################

# Cargamos el directorio donde están los datos de entrada:
setwd(directorio_in_EUSTAT)

booking <- read.csv("HONTZA_2018_2019_2020.csv", header = TRUE, sep = ";")

# Cargamos la información de eventos:
setwd(directorio_in_OTROS)

eventos <- read.csv("Eventos Donosti.csv", header = TRUE, sep = ";")
names(eventos)<-c("FECHA","TEMPORADA")
eventos$FECHA<-as.Date(eventos$FECHA,"%d/%m/%Y")

# Cargamos la ubicación de los hoteles:
ubicacion <- read.csv("Hoteles ubicación.csv", header = TRUE, sep = ";")
names(ubicacion)<-c("ID_HOTEL","LATITUD","LONGITUD")
ubicacion$LATITUD<-as.numeric(sub(",", ".", ubicacion$LATITUD, fixed = TRUE))
ubicacion$LONGITUD<-as.numeric(sub(",", ".", ubicacion$LONGITUD, fixed = TRUE))

# Cargamos la información básica de los hoteles que obtenemos por la info de la encuesta:
setwd(directorio_out)
load(paste0(directorio_out,"/ctas_hoteles.RData"))
 

# Selección y renombrado de vars ---------------------------------------------
##############################################################################

# Seleccionamos las variables de la muestra de booking
booking<-select(booking,-c("ID_FECHA","ID_ALOJAMIENTO","ID_PROCESO"))
# Renombramos las variables
names(booking)<-c('PRECIO',
                  'PRECIO_REBAJADO',
                  'DIAS_VISTA',
                  'CANCELACION_GRATIS',
                  'ANIO',
                  'MES',
                  'DIA',
                  'ID_HOTEL',
                  'N_NOCHES')

# Creación de vars------------------------------------------------------------
##############################################################################

# Generamos la variable "FECHA"
booking$FECHA<-ymd(paste0(booking$ANIO,"-",booking$MES,"-",booking$DIA))

# Calculamos el precio medio por noche para los datos de booking:
booking$PRECIO_NOCHE<-round(booking$PRECIO/booking$N_NOCHES,1)
booking$PRECIO_NOCHE_REBAJADO<-round(booking$PRECIO_REBAJADO/booking$N_NOCHES,1)

# Incorporamos en el fichero de booking la información de ctas del hotel
booking<-merge(booking,ctas_hoteles)
copia<-booking
# Incorporamos en el fichero la información de eventos
booking<-merge(booking,eventos)

# Analizamos los casos en los que las variables "PRECIO" y/o "PRECIO_REBAJADO" están informadas:
booking$info_precio<-1
booking$info_precio[is.na(booking$PRECIO)==T]<-0
booking$info_precio_reb<-1
booking$info_precio_reb[is.na(booking$PRECIO_REBAJADO)==T]<-0
table(booking$info_precio,booking$info_precio_reb)

# Decidimos eliminar aquellos casos en los que tanto una como la otra variable figuran a missing:
booking<-booking[booking$info_precio==1,]
booking<-select(booking,-c("info_precio","info_precio_reb"))

# Almacenamos las tablas output
save(booking,file=paste0(directorio_out,'/booking.Rdata'))






