

# Carga de datos -------------------------------------------------------------
##############################################################################

# Cargamos el directorio donde están los datos de entrada:
setwd(directorio_in_EUSTAT)

# Aumentamos el memory.limit para poder cargar el fichero de la encuesta
memory.limit(size=56000)
encuesta <- read.csv("WORK_QUERY_FOR_ETR_IMP_MAESTRO_0000.csv", header = TRUE, sep = ";")

# Creamos la variable FECHA:
encuesta$FECHA<-ymd(paste0(encuesta$ANIO,"-",encuesta$MES,"-",encuesta$DIA))

# Dividimos el fichero de la encuesta en tres partes:
# · Ctas hoteles: datos propios de los hoteles, como nombre, categoría, etc.
# => Un registro por hotel
# · Datos_dia: datos relativos al hotel & la fecha de referencia.
# => Un registro por hotel y fecha
# · Datos otros: datos relativos al % de reservas 

ctas_hoteles<-select(encuesta,c('DIR_USUARIO','DIR_TH','DIR_MUN','DIR_ESTR','DIR_TIPO_EST',
                                'DIR_CATEGORIA','DIR_HABTOT','DIR_PLAZHOT','DIR_NOMBRE','DIR_EMPLEO'))
datos_dia<-select(encuesta,c('FECHA','DIR_USUARIO','DIR_N_HABTOT','DIR_N_PLAZHOT','IMPUTAR',
                             'INDICADOR_ABIERTO','HAB_OCUP','PLAZAS_SUP','ENTRADAS_A10','ENTRADAS_A11','ENTRADAS_A20',
                             'ENTRADAS_A40','ENTRADAS_A60','ENTRADAS_ARG','ENTRADAS_AUS','ENTRADAS_AUT','ENTRADAS_BEL',
                             'ENTRADAS_BRA','ENTRADAS_CAN','ENTRADAS_CHE','ENTRADAS_CHN','ENTRADAS_COM01','ENTRADAS_COM02',
                             'ENTRADAS_COM03','ENTRADAS_COM04','ENTRADAS_COM05','ENTRADAS_COM06','ENTRADAS_COM07','ENTRADAS_COM08',
                             'ENTRADAS_COM09','ENTRADAS_COM10','ENTRADAS_COM11','ENTRADAS_COM12','ENTRADAS_COM13','ENTRADAS_COM14',
                             'ENTRADAS_COM15','ENTRADAS_COM16','ENTRADAS_COM17','ENTRADAS_COM18','ENTRADAS_DEU','ENTRADAS_DNK',
                             'ENTRADAS_FIN','ENTRADAS_FRA','ENTRADAS_GBR','ENTRADAS_GRC','ENTRADAS_IRL','ENTRADAS_ITA','ENTRADAS_JPN',
                             'ENTRADAS_LUX','ENTRADAS_MEX','ENTRADAS_NLD','ENTRADAS_NOR','ENTRADAS_PRT','ENTRADAS_RUS','ENTRADAS_SWE',
                             'ENTRADAS_USA','PERNOCTACIONES_A10','PERNOCTACIONES_A11','PERNOCTACIONES_A20','PERNOCTACIONES_A40',
                             'PERNOCTACIONES_A60','PERNOCTACIONES_ARG','PERNOCTACIONES_AUS','PERNOCTACIONES_AUT','PERNOCTACIONES_BEL',
                             'PERNOCTACIONES_BRA','PERNOCTACIONES_CAN','PERNOCTACIONES_CHE','PERNOCTACIONES_CHN','PERNOCTACIONES_COM01',
                             'PERNOCTACIONES_COM02','PERNOCTACIONES_COM03','PERNOCTACIONES_COM04','PERNOCTACIONES_COM05',
                             'PERNOCTACIONES_COM06','PERNOCTACIONES_COM07','PERNOCTACIONES_COM08','PERNOCTACIONES_COM09',
                             'PERNOCTACIONES_COM10','PERNOCTACIONES_COM11','PERNOCTACIONES_COM12','PERNOCTACIONES_COM13',
                             'PERNOCTACIONES_COM14','PERNOCTACIONES_COM15','PERNOCTACIONES_COM16','PERNOCTACIONES_COM17',
                             'PERNOCTACIONES_COM18','PERNOCTACIONES_DEU','PERNOCTACIONES_DNK','PERNOCTACIONES_FIN',
                             'PERNOCTACIONES_FRA','PERNOCTACIONES_GBR','PERNOCTACIONES_GRC','PERNOCTACIONES_IRL','PERNOCTACIONES_ITA',
                             'PERNOCTACIONES_JPN','PERNOCTACIONES_LUX','PERNOCTACIONES_MEX','PERNOCTACIONES_NLD','PERNOCTACIONES_NOR',
                             'PERNOCTACIONES_PRT','PERNOCTACIONES_RUS','PERNOCTACIONES_SWE','PERNOCTACIONES_USA','DONANTE',
                             'ENTRADAS_T1T','PERNOCTACIONES_T1T','SALIDAS_T1T'))
datos_resto<-select(encuesta,c('FECHA','DIR_USUARIO','GEN_REVPAR','GEN_PREADRTOT','GEN_PREHABTOT',
                               'GEN_PREADREMPRESA','GEN_PREHABEMPRESA','GEN_PREADRAVT','GEN_PREHABAVT','GEN_PREADRPARTICULAR',
                               'GEN_PREHABPARTICULAR','GEN_PREADRGRUPO','GEN_PREHABGRUPO','GEN_PREADRINET','GEN_PREHABINET',
                               'GEN_PREADRAVO','GEN_PREHABAVO','GEN_PREADRTOO','GEN_PREHABTOO','GEN_PREADROTRO','GEN_PREHABOTRO',
                               'GEN_PREADRTMM','GEN_PREHABTMM'))

# Eliminamos información duplicada:
datos_dia<-distinct(datos_dia)
ctas_hoteles<-distinct(ctas_hoteles)
datos_resto<-distinct(datos_resto)

# Renombramos las variables
names(ctas_hoteles)<-c('ID_HOTEL',
                       'TERRITORIO',
                       'MUNICIPIO',
                       'ESTRATO',
                       'TIPO',
                       'CATEGORIA',
                       'HABITACIONES_DIR',
                       'PLAZAS_DIR',
                       'NOMBRE',
                       'EMPLEADOS')

# Guardamos los ficheros en el directorio
save(ctas_hoteles,file=paste0(directorio_out,'/ctas_hoteles.Rdata'))
save(datos_dia,file=paste0(directorio_out,'/datos_dia.Rdata'))
save(datos_otros,file=paste0(directorio_out,'/datos_otros.Rdata'))

# Exportamos los ficheros a un csv
write.table(ctas_hoteles,file=paste0(directorio_out,'/ctas_hoteles.csv'), sep = ";",
            row.names=F,col.names=T)
write.table(datos_dia,file=paste0(directorio_out,'/datos_dia.csv'), sep = ";",
            row.names=F,col.names=T)

