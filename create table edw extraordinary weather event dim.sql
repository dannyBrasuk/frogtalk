/*
    Big weather events that might have some influence or impact 

    Not all inclusive, and in fact I'm guessing the first two entries.

    Data is expected to come from official weather service.

*/


DROP TABLE IF EXISTS edw.extraordinary_weather_event_dim RESTRICT;

CREATE TABLE edw.extraordinary_weather_event_dim  
(   
    extraordinary_weather_event_pk INT NOT NULL,
    extraordinary_weather_event_description VARCHAR(255) NULL,             

    PRIMARY KEY (extraordinary_weather_event_pk)  WITH (FILLFACTOR=90) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;

