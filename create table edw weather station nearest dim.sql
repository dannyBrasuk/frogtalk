/*
Location of weather stations, used to provide the official weather data
*/  


DROP TABLE IF EXISTS edw.weather_station_nearest_dim RESTRICT;


CREATE TABLE edw.weather_station_nearest_dim
(   
    weather_station_nearest_pk  INT NOT NULL,
    station_identifier  VARCHAR(256) NOT NULL,
    station_name VARCHAR(256) NOT NULL,
    station_longitude_wgs84 NUMERIC(11,6) NOT NULL,
    station_latitude_wgs84 NUMERIC(11,6)  NOT NULL,

    PRIMARY KEY (weather_station_nearest_pk)  WITH (FILLFACTOR=90) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;
