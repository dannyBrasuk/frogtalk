/*
    Big weather events that might have some influence or impact 

    Not all inclusive, and in fact I'm guessing the first two entries.

    Data is expected to come from official weather service.

*/

USE frogtalk;
GO

DROP TABLE IF EXISTS edw.extraordinary_weather_event_dim RESTRICT;

GO

CREATE TABLE edw.extraordinary_weather_event_dim  
(   
    extraordinary_weather_event_pk INT NOT NULL,
    extraordinary_weather_event_description VARCHAR(255) NULL,             

    PRIMARY KEY (extraordinary_weather_event_pk)  WITH (FILLFACTOR=90) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;

GO

INSERT INTO edw.extraordinary_weather_event_dim (extraordinary_weather_event_pk, extraordinary_weather_event_description)
    VALUES (0, 'None'), (1, 'Hurricane'), (2, 'Excessive Lighting');
GO
SELECT * FROM edw.extraordinary_weather_event_dim ;

