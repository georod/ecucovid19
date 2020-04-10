# Coronavirus 2019 (COVID-19) Ecuador

-   [Introducción](#introducción)
-   [Cómo usar este repositorio](#cómo-usar-este-repositorio)
	-   [Usar los datos con R](#usar-los-datos-con-R)
-   [Términos de Uso](#términos-de-uso)

## Introducción
Este repositorio contiene datos sobre Coronavirus (Covid-19) del Ecuador y código para realizar visualizaciones. Los datos son recopilados por Santigo Ron. Invitamos al público a contribuir libremente.


<br>

<b>Panel de datos (Dashboard) - por hacer:</b><br>
https://georod.rshinny.com/
<br><br>
<b>Mapa interactivo - por hacer:</b><br>
http://www.carto.com/
<br><br>

<b>Fuentes de datos - por confirmar:</b><br>
* Ministerio de Salud Pública del Ecuador, https://www.salud.gob.ec/ <br>
* World Health Organization (WHO): https://www.who.int/ <br>
* 1Point3Arces: https://coronavirus.1point3acres.com/en
* WorldoMeters: https://www.worldometers.info/coronavirus/
* Coronavirus App: https://coronavirus.app/

<br>

<b>Contáctanos: </b><br>
* Email: rons@gmail.com, p.rodriguez97@gmail.com
<br><br>


## Cómo usar este repositorio?

Los datos son inicialmente recopilados por Santiago Ron en [Google Sheets](https://docs.google.com/spreadsheets/d/1Gq06oasFB5K9893qbDV0dcXR6SX5ZCAZva_J6uSkmcE/edit#gid=0). Una copia actualizada de estos datos es almacenada en un base de datos relacional creada con PostgreSQL. Para acceder a los datos en la base de datos (bd) se puede usar cualquier programa estadístico (R, Stata, Excel, etc.)  También se puede descargar los datos en formato CSV dando un click en el archivo ecu_covid19.csv que se encuentra en la carperta <b>data</b> arriba.

Los parámetros para conectarse son:

  - IP: 99.225.128.160
  - Puerto: 5432
  - Base de datos: covid19
  - Usuario: pubu
  - Clave: covid19
  
Hasta el momento solo existe una tabla en la bd (ecu_covid19). Aquí mostramos como usar los datos usando R.

### Usar los datos con R
R es un programa estadistico y computacional de fuente abierta (open-source software).  Se lo puede bajar aqu

* Intalar librerías de R


		install.packages("RDBI")
		install.packages("RPostgreSQL")



* Connectarse a (y desconectarse de) la bd
    
		# crear conección a la bd
        con <- DBI::dbConnect(drv = RPostgres::Postgres(),user='pubu',password='Covid19',host='99.225.128.160',port=5432,dbname='covid19')

		# pedir a la bd la tabla con los datos
		res <- dbSendQuery(con, "SELECT * FROM ecu_covid19")
		cv19 <- dbFetch(res)
		
		# ver número de filas y columnas (25x15)
		dim(cv19)

		# ver primeras 6 observations de la tabla
		head(cv19)

		# borrar objeto res con consulta realizada a la bd
		dbClearResult(res)

		# desconectarse de la bd
		dbDisconnect(con)


* Una vez que se bajen los datos, se puede crear un gráfico con este código

		plot()

## Términos de Uso

Este repositorio de GitHub y sus contenidos son de libre acceso. Los contenidos presentados aquí son provistos al público con fines educacionales y académicos. Los datos son tomados son de varias fuentes públicas y estas no siempre coinciden. La información presentada aquí no debe usarse para tomar decisiones médicas. Para información oficial referirse directamente al Ministerio de Salud Pública del Ecuador u otras fuentes gubernamentales.

