 #Solo se necesita instalar las librerias una vez
  install.packages("DBI")
  install.packages("RPostgreSQL") # opcional
  
  # Cargar librería
  library(DBI)
  library(RPostgreSQL) # opcional
  
  # crear conección a la bd
  con <- DBI::dbConnect(drv = RPostgres::Postgres(),user='georodco_pubu',password='Covid19Ecuador',host='66.198.240.224',port=5432,dbname='georodco_covid19')

  # pedir a la bd la tabla ecu_covid19
  res <- dbSendQuery(con, "SELECT * FROM ecu_covid19")
  cv19 <- dbFetch(res)
  
  # ver número de filas y columnas (25x15)
  dim(cv19)

  # ver primeras 6 observations de la tabla
  head(cv19)
  
  # ver últimas 6 observations de la tabla
  head(cv19)

  # pedir a la bd una de las tablas de John Hopkins
  res <- dbSendQuery(con, "SELECT * FROM jh_ts_covid19_deaths_ecu")
  jh_cv19 <- dbFetch(res)
  
  # ver últimas 6 observations de la tabla
  head(jh_cv19)
  
  # borrar objeto res con consulta realizada a la bd
  dbClearResult(res)

  # desconectarse de la bd
  dbDisconnect(con)
  
  # El primer gráfico de Santiago Ron usando R 
  # instalar librería
  install.packages("ggplot2")
  # Cargar librería
  library(ggplot2)
  # Crear gráfico de barras
  ggplot2::ggplot(data=cv19[!is.na(cv19$por_inf),], aes(x=fecha, y=por_inf)) + 
  	geom_bar(stat="identity") + xlab("Fecha") + ylab("Porcentaje de infectados") +  
  	ggtitle("Porcentaje de infectados de COVID-19 en el Ecuador por día") + 
  	geom_text(aes(x = fecha, y = por_inf + 2.5, label = round(por_inf , 0))) + 
  	labs(caption="Fuente: Santiago Ron, @santiak")
    
  #Crear gráfico de líneas usando datos de John hopkins (número de fallecidos)
  # gráfico con datos de John Hopkins
  ggplot2::ggplot(data=jh_cv19[jh_cv19$date1>"2020-03-28",], aes(x=date1, y=value1)) + 
  	geom_line( color="red", size=1, stat="identity") + labs(title = "Número de fallecidos por COVID-19 en el Ecuador por día", caption = "Fuente: John Hopkins CSSE", x = "Fecha", y = "Número de fallecidos")