#===============================================================================
# Name   : COVID19 - Ecuador
# Author : Peter R.
# Date   : 2020-09-18
# Version: v1
# Aim    : Comandos básicos de R para explorar datos de Covid-19 (Basic R cmds)
# URL    : https://github.com/georod/ecucovid19
#===============================================================================
 
 
 # Solo se necesita instalar las librerias una vez
 # Install libraries
  install.packages("DBI")
  install.packages("RPostgres") 
  
  # Cargar librería
  # Load libraries
  library(DBI)
  library(RPostgres)
  
  # crear conección a la base de datos (bd)
  # crete conection to database (db)
  con <- DBI::dbConnect(drv = RPostgres::Postgres(),user='georodco_pubu',password='Covid19Ecuador',host='66.198.240.224',port=5432,dbname='georodco_covid19')

  # pedir a la bd la tabla ecu_covid19
  # request a table from the db
  res <- dbSendQuery(con, "SELECT * FROM ecu_covid19")
  cv19 <- dbFetch(res)
  
  # ver número de filas y columnas (25x15)
  # check dimension of object
  dim(cv19)

  # ver primeras 6 observations de la tabla
  # see first 6 records
  head(cv19)
  
  # ver últimas 6 observations de la tabla
  # see last 6 records
  tail(cv19)

  # pedir a la bd una de las tablas de John Hopkins
  # request one of the John Hopkins' tables
  res <- dbSendQuery(con, "SELECT * FROM jh_ts_covid19_deaths_ecu")
  jh_cv19 <- dbFetch(res)
  
  # ver últimas 6 observations de la tabla
  # see first 6 records
  head(jh_cv19)
  
  # borrar objeto res con consulta realizada a la bd
  # clear res object
  dbClearResult(res)

  # desconectarse de la bd
  # disconnect from db
  dbDisconnect(con)
  
  # El primer gráfico de Santiago Ron usando R
  # Santiago Ron's first plot using R 
  # instalar librería
  # install library
  install.packages("ggplot2")
  # Cargar librería
  # Load library
  library(ggplot2)
  # Crear gráfico de barras
  # Bar plot
  ggplot2::ggplot(data=cv19[!is.na(cv19$por_pos),], aes(x=fecha, y=por_pos)) + 
  	geom_bar(stat="identity") + xlab("Fecha") + ylab("Porcentaje de infectados") +  
  	ggtitle("Porcentaje de infectados de COVID-19 en el Ecuador por día") + 
  	geom_text(aes(x = fecha, y = por_pos + 2.5, label = round(por_pos , 0))) + 
  	labs(caption="Fuente: Santiago Ron, @santiak")
    
  # Crear gráfico de líneas usando datos de John Hopkins (número de fallecidos)
  # Create line plot using John Hopkins data
    ggplot2::ggplot(data=jh_cv19[jh_cv19$date1>"2020-03-28",], aes(x=date1, y=value1)) + 
  	geom_line( color="red", size=1, stat="identity") + labs(title = "Número de fallecidos por COVID-19 en el Ecuador por día", caption = "Fuente: John Hopkins CSSE", x = "Fecha", y = "Número de fallecidos")