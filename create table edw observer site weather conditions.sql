/*
All possible combinations of "current weather conditions"

Type 2 SCD.


*/

DROP TABLE IF EXISTS edw.observed_site_weather_conditions_dim RESTRICT;


--Because Postgres does not support computed columns, compute the Point object in the ETL - if i decide I need it in EDW

CREATE TABLE edw.observed_site_weather_conditions_dim  
(   
    observed_site_weather_conditions_pk INT NOT NULL,
    current_condition_description VARCHAR(40) NOT NULL,
    wind_scale_description VARCHAR(40) NOT NULL,
    rain_last_48_hours_description VARCHAR(40) NOT NULL,
    water_level_description VARCHAR(40) NOT NULL,

    PRIMARY KEY (observed_site_weather_conditions_pk)  WITH (FILLFACTOR=100) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;