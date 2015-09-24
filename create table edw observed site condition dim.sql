/*
Type 4 mini Dimension table of all possible combinations of "current conditions"
*/

DROP TABLE IF EXISTS edw.observed_site_condition_dim RESTRICT;


--Because Postgres does not support computed columns, compute the Point object in the ETL - if i decide I need it in EDW

CREATE TABLE edw.observed_site_condition_dim  
(   
    observed_site_condition_pk INT NOT NULL,
    current_condition_description VARCHAR(40) NOT NULL,
    wind_scale_description VARCHAR(40) NOT NULL,
    rain_last_48_hours_description VARCHAR(40) NOT NULL,
    water_level_description VARCHAR(40) NOT NULL,

    PRIMARY KEY (observed_site_condition_pk)  WITH (FILLFACTOR=100) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;