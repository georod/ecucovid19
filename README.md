# Coronavirus 2019 (COVID-19) Ecuador

**NOTA**: Dado los cambios e inconsistencias en la generación de datos por parte del Gobierno del Ecuador (apartir del 24 de abril de 2020 principalmente), ya no se actualizará los mismos en este repositorio. Esto afecta los datos de Santiago Ron que he venido distribuyendo aquí. Los datos de John Hopinks CSEE se actualizarán una vez por semana (sábado).

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
* [Pablo Reyes](https://github.com/pablora19/COVID19_EC), @PabloRA19: Proporciona en GitHub varias tablas importantes. Sus fuentes son la SNGRE (@riesgos_ec) pero con algunas correcciones importantes. (Ver cuenta de Pablo en Twitter.) Estos datos también se encuentran aquí [Google Sheets](https://docs.google.com/spreadsheets/d/1ZTXvIqq23cnmN-A8Fikyo6C_6jI3xYPE1Mff9fZOgHc/edit#gid=0).

<br>

<b>Contáctos: </b><br>
* Santiago Ron: santiago.r.ron@gmail.com, @santiak
* Peter Rodríguez: p.rodriguez97@gmail.com, @psrod97
<br><br>


## Cómo usar este repositorio?

Los datos presentados aquí se pueden acceder por dos métodos. Primero, usuarios pueden conectarse directamente a la base de datos relacional ([PostgreSQL](https://www.postgresql.org/)) usando cualquier programa estadístico (R, Stata, Excel, etc.) Segundo, pueden descargar los datos en formato CSV dando un click en los archivos que se encuentran en la carperta <b>data</b> arriba.

Los parámetros para a la bd conectarse son (Si deaseas un login por favor contáctme):

  - IP: 
  - Puerto: 
  - Base de datos: georodco_covid19
  - Usuario: 
  - Clave: 
  
Hasta el momento existen estos datos en la bd,

|Nombre de tabla en bd|Descripción|Fuente|
|--------|-----------|-----------|
|ecu_covid19|Datos de Covid19 por día a nivel nacional|Santiago Ron|
|jh_ts_covid19_deaths_ecu|Muertes por Covid19 por día (solo Ecuador) a nivel nacional|John Hopkins CSSE|
|jh_ts_covid19_confirmed_ecu|Casos confirmados de Covid19 por día (solo Ecuador) a nivel nacional|John Hopkins CSSE|
|jh_ts_covid19_recovered_ecu|Casos recuperados de Covid19 por día (solo Ecuador) a nivel nacional|John Hopkins CSSE|

  - Los datos de la tabla ecu_covid19 son inicialmente recopilados por Santiago Ron en [Google Sheets](https://docs.google.com/spreadsheets/d/1Gq06oasFB5K9893qbDV0dcXR6SX5ZCAZva_J6uSkmcE/edit#gid=0). Una copia actualizada de estos datos es almacenada en una base de datos (bd) relacional. 
  - Los datos de las tablas de John Hopkins CSSE son distribuidos libremente al público. Los datos disponibles en la bd han sido transformados para mostrar la fecha en una sola columna (tabla larga no ancha como la original). 

Nota: los datos son actualizados cada dos días. En la carpeta data/archive encontrará versiones antiguas de los datos. Usualmente, los datos en la carpeta archive tienen una estructura diferente a los datos en carpeta data. Por ejemplo, la última versión de una table puede tener nuevas variables o nuevos nombres de variables.


Abajo mostramos como usar los datos usando R.

### Usar los datos con R
R es un programa estadístico y computacional de fuente abierta (open-source software).  Se lo puede bajar aquí ([R-project](https://www.r-project.org/))

* Instalar y cargar librerías de R


		#Solo se necesita instalar las librerias una vez
		install.packages("DBI")
		install.packages("RPostgreSQL") # opcional
		
		# Cargar librería
		library(DBI)
		library(RPostgreSQL) # opcional



* Connectarse a (y desconectarse de) la bd
    
		# crear conección a la bd (Si deaseas un login por favor contáctme)
        con <- DBI::dbConnect("PostgreSQL", user='', password='',host='', port=, dbname='')

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


* Una vez que se bajen los datos, se puede crear un gráfico con este código

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

### Diccionario de datos

* Tabla: ecu_covid19

|Variable|Descripción|Description|
|--------|-----------|-----------|
|serial_id|Llave primaria|Primary Key|
|fecha|Fecha en formato YYYY-MM-DD|Date in YYYY-MM-DD|
|hora|hora de ingreso del registro|Time record was entered|
|pos_acum|Positivos..acumulado.|Cummulative positive cases|
|neg_acum|Negativos..acumulado.|Cummulative negative cases|
|test_diag_acum|No..test.con.diagnóstico|Cummulative number of tests with diagnosis|
|casos_sosp|casos.con.sospecha|Suspect cases|
|fallecidos_acum|Fallecidos.con.test|Cummulativ deaths|
|fallecidos_prob_acum|Fallecidos.probables.acumulado|Cummulative probable deaths|
|fallecidos_tot|Total.fallecidos|Total deaths|
|fallecidos_pmill|Fallecidos.millón|Total deaths per million|
|n_mues_acum|No..muestras.tomadas..acumulado.|Cummulative number of tests taken|
|conf_sosp_desc|confirmados...sospecha...descartados|Sum of positive, suspect and negative cases|
|pos_tasa|Tasa.positivos|Positive cases rate|
|n_mues|No..de.muestras.tomadas|Number of tests taken|
|test_diag|Tests.con.diagnóstico|Number of tests taken with diagnosis|
|pos|Positivos|Positive cases|
|por_pos|Porcentaje.positivos.por.día|Percent of infected people in a day|
|cont|Cont|Infected|
|por_pob|Porcentaje de la población infectada|Percent of population infected|
|n_est|No..esimado.f|Estimated number of infected people|
|fallecidos|Fallecidos.diarios|Deaths per day|
|neg|Negativos|Negative cases|
|fallecidos_test|Fallecidos.con.test.1|Deaths with tests performed|
|fallecidos_prob|Fallecidos.probables|Probable number of deaths|
|test_diag_pmill|test.con.diagnóstico.por.millón|Number of tests taken with diagnosis per million|
|n_mues_pmill|No..muestras.tomadas.por.millón|Number of tests taken per million|
|n_mues_sres|No..de.muestras.tomadas.sin.resulado|Number of tests taken without diagnosis|
|fallecidos_reg_civil|Fallecimientos.registro.civil|Civil Registry deaths|


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


## Visualizaciones

### Mapas interactivos
* [Días con fallecidos por COVID-19](https://georod.carto.com/builder/0e64800d-4993-4083-b65a-2ca5f45cf30c/embed): Con datos de [Andres N. Robalino](https://github.com/andrab/ecuacovid) se creó un mapa espacio-temporal que muestra días con fallecidos por provincia. Los puntos representan provincias (sus capitales) donde hubo más de 3 fallecidos a causa del COVID-19 en un día.  Este mapa permite ver la distribución geográfica y temporal de las muertes por COVID-19 en el Ecuador.  Se usó la plataforma [Carto](https://carto.com/) para crear este mapa.
* [Tasa de casos positivos de COVID-19 por cantón y tasa de letalidad de COVId-19 por provincia ](https://georod.carto.com/builder/d4e7d780-741e-46b2-9cc8-7903a0aa4f24/embed): Con datos de [Andres N. Robalino](https://github.com/andrab/ecuacovid) creé un  webmap interactivo con dos capas. La primera capa muestra un mapa coroplético con la tasa de casos positivos por cantón. La segunda capa, presenta un mapa coroplético con la tasa de letalidad de COVID-19 por provincia. Se usó la plataforma [Carto](https://carto.com/) para crear estos mapas interactivos.


## Términos de Uso

Este repositorio de GitHub y sus contenidos son de libre acceso. Los contenidos presentados aquí son proporcionados al público con fines educacionales y académicos. Los datos son tomados son de varias fuentes públicas y estas no siempre coinciden. La información presentada aquí no debe usarse para tomar decisiones médicas. Para información oficial referirse directamente al Ministerio de Salud Pública del Ecuador u otras fuentes gubernamentales.

