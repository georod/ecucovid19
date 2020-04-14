# Coronavirus 2019 (COVID-19) Ecuador

-   [Introducción](#introducción)
-	[Cómo usar este repositorio](#cómo-usar-este-repositorio)
	-   [Usar los datos con R](#usar-los-datos-con-R)
	-   [Diccionario de datos](#diccionario-de-datos)
-	[Visualizaciones](#visualizaciones)
-   [Términos de Uso](#términos-de-uso)

## Introducción
Este repositorio contiene datos sobre Coronavirus (Covid-19) del Ecuador de varias fuentes y código para realizar visualizaciones. Invitamos al público a contribuir libremente a este repositorio.

<br>

<b>Fuentes de datos de este repositorio:</b><br>
* Santiago Ron (PUCE), ha recopilado datos del [Ministerio de Salud Pública del Ecuador (MSPE)](https://www.salud.gob.ec/) y otras fuentes. Sus datos tambien contienen varias medidas derivadas.<br>
* [John Hopinks CSSE](https://github.com/CSSEGISandData/COVID-19)

<b>Otras iniciativas similares:</b><br>

* [Andres N. Robalino](https://github.com/andrab/ecuacovid), @andras_io: Proporciona en GitHub muertes y casos positivos de los informes del Servicio Nacional de Gestión de Riesgos y Emergencias del Ecuador (SNGRE). Andrés proporciona datos crudos y con código de INEC provincial/cantonal. Excelente trabjo Andrés.
* [Pablo Reyes](https://github.com/pablora19/COVID19_EC), @PabloRA19: Proporciona en GitHub varias tablas importantes. Sus fuentes son la SNGRE (@riesgos_ec) pero con algunas correcciones importantes. (Ver cuenta de Pablo en Twitter.) 

Por otro lado, Ugo Rivera (@ugo_r_b): compartió por Twitter un archivo [Google Sheets](https://docs.google.com/spreadsheets/d/1ZTXvIqq23cnmN-A8Fikyo6C_6jI3xYPE1Mff9fZOgHc/edit#gid=0) que parecer ser de la SNGRE. Este archivo tiene tablas similares a las de Pablo Reyes.

<br>

<b>Contáctos: </b><br>
* Santiago Ron: santiago.r.ron@gmail.com, @santiak
* Peter Rodríguez: p.rodriguez97@gmail.com, @psrod97
<br><br>


## Cómo usar este repositorio?

Los datos presentados aquí se pueden acceder por dos métodos. Primero, usuarios pueden conectarse directamente a la base de datos relacional ([PostgreSQL](https://www.postgresql.org/)) usando cualquier programa estadístico (R, Stata, Excel, etc.) Segundo, pueden descargar los datos en formato CSV dando un click en los archivos que se encuentran en la carperta <b>data</b> arriba.

Los parámetros para a la bd conectarse son:

  - IP: 66.198.240.224
  - Puerto: 5432
  - Base de datos: georodco_covid19
  - Usuario: georodco_pubu
  - Clave: Covid19Ecuador
  
Hasta el momento existen estos datos en la bd,

|Nombre de tabla en bd|Descripción|Fuente|
|--------|-----------|-----------|
|ecu_covid19|Datos de Covid19 por día a nivel nacional|Santiago Ron|
|jh_ts_covid19_deaths_ecu|Muertes por Covid19 por día (solo Ecuador) a nivel nacional|John Hopkins CSSE|
|jh_ts_covid19_confirmed_ecu|Casos confirmados de Covid19 por día (solo Ecuador) a nivel nacional|John Hopkins CSSE|
|jh_ts_covid19_recovered_ecu|Casos recuperados de Covid19 por día (solo Ecuador) a nivel nacional|John Hopkins CSSE|

  - Los datos de la tabla ecu_covid19 son inicialmente recopilados por Santiago Ron en [Google Sheets](https://docs.google.com/spreadsheets/d/1Gq06oasFB5K9893qbDV0dcXR6SX5ZCAZva_J6uSkmcE/edit#gid=0). Una copia actualizada de estos datos es almacenada en una base de datos (bd) relacional. 
  - Los datos de las tablas de John Hopkins CSSE son distribuidos libremente al público. Los datos disponibles en la bd han sido transformados para mostrar la fecha en una sola columna (tabla larga no ancha como la original). 


Abajo mostramos como usar los datos usando R.

### Usar los datos con R
R es un programa estadístico y computacional de fuente abierta (open-source software).  Se lo puede bajar aquí ([R-project](https://www.r-project.org/))

* Intalar librerías de R


		install.packages("RDBI")
		install.packages("RPostgreSQL")



* Connectarse a (y desconectarse de) la bd
    
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
		
		# borrar objeto res con consulta realizada a la bd
		dbClearResult(res)

		# desconectarse de la bd
		dbDisconnect(con)


* Una vez que se bajen los datos, se puede crear un gráfico con este código

		# El primer gráfico de Santiago Ron usando R 
		# instalar librería
		install.packages("ggplot2")
		# Cargar librería
		library(ggplot2)
		# Crear gráfico
		ggplot(data=cv19[!is.na(cv19$por_inf),], aes(x=fecha, y=por_inf)) + 
		  geom_bar(stat="identity") + xlab("Fecha") + ylab("Porcentaje de infectados") +  
		  ggtitle("Porcentaje de infectados por día") + 
		  geom_text(aes(x = fecha, y = por_inf + 2.5, label = round(por_inf , 0))) + guides(fill=FALSE) 

### Diccionario de datos

* Tabla: ecu_covid19

|Variable|Descripción|Description|
|--------|-----------|-----------|
|serial_id|Llave primaria|Primary Key|
|fecha|Fecha en formato YYYY-MM-DD|Date in YYYY-MM-DD|
|hora|hora de ingreso del registro|Time record was entered|
|pos_acum|Positivos..acumulado.|Cummulative positive cases|
|neg_acum|Negativos..acumulado.|Cummulative negative cases|
|test_dia_acum|No..test.con.diagnóstico|Number of tests with diagnosis|
|casos_sosp|casos.con.sospecha|Suspect cases|
|fallecidos|Fallecidos.con.test|Deaths|
|fallecidos_prop|Fallecidos.probables|Probable deaths|
|fallecidos_tot|Total.fallecidos|Total deaths|
|fallecidos_pmill|Fallecidos.millón|Total deaths per million|
|n_mues_acum|No..muestras.tomadas..acumulado.|Cummulative number of tests taken|
|conf_sosp_desc|confirmados...sospecha...descartados|Sum of positive, suspect and negative cases|
|pos_tasa|X|Positive cases rate|
|test_dia|Tests.con.diagnóstico|Number of tests with diagnosis|
|pos|Positivos|Positive cases|
|por_inf|Porcentaje.infectados.por.día|Percent of infected people in a day|
|cont|Cont|Infected|
|por_pob|X.|Percent of population infected|
|n_est|No..esimado.f|Estimated number of infected people|
|fallecidos_nue|Nuevos.fallecidos|New deaths|


* Tabla: jh_ts_covid19_confirmed_ecu, jh_ts_covid19_deaths_ecu, jh_ts_covid19_recovered_ecu 

|Variable|Descripción|Description|
|--------|-----------|-----------|
|serial_id|Llave primaria, identificador único de fila|Primary Key|
|province_state|Provincia o estado|Province or state|
|country_region|País o región|Country or region|
|lat|latitud|latitude|
|lon|longitud|longitude|
|fecha1|Fecha en formato YYYY-MM-DD|Date in YYYY-MM-DD|
|value1|Casos confirmados, fallecidos o recuperados dependiendo de la tabla|Confirmed cases, deaths or recovered depending on the table|

<br>
## Visualizaciones
<b>Mapas interactivos:</b><br>
* [Días con fallecidos por COVID-19](https://georod.carto.com/builder/0e64800d-4993-4083-b65a-2ca5f45cf30c/embed): Con datos de [Andres N. Robalino](https://github.com/andrab/ecuacovid) se creó un mapa espacio-temporal que muestra días con fallecidos por provincia. Los puntos representan provincias (sus capitales) donde hubo más de 3 fallecidos a causa del COVID-19 en un día.  Este mapa permite ver la distribución geográfica y temporal de las muertes por COVID-19 en el Ecuador.  Se usó la plataforma [Carto](https://carto.com/) para crear este mapa.


## Términos de Uso

Este repositorio de GitHub y sus contenidos son de libre acceso. Los contenidos presentados aquí son proporcionados al público con fines educacionales y académicos. Los datos son tomados son de varias fuentes públicas y estas no siempre coinciden. La información presentada aquí no debe usarse para tomar decisiones médicas. Para información oficial referirse directamente al Ministerio de Salud Pública del Ecuador u otras fuentes gubernamentales.

