
# Cargamos las librerias:

paquetes <- c("lubridate","dplyr","xlsx")

# Identificamos librer�as no instaladas
no_instalados <- paquetes[!(paquetes %in% installed.packages()[,"Package"])] 
if(length(no_instalados)) install.packages(no_instalados)

# Cargamos todas las librer�as que vamos a utilizarinstaladas
lapply(paquetes, require, character.only=TRUE)
