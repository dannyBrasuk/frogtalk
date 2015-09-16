/*
    Astronomical events that might have some influence or impact 

    Not all inclusive

*/


DROP TABLE IF EXISTS edw.extraordinary_astronomical_event_dim RESTRICT;

CREATE TABLE edw.extraordinary_astronomical_event_dim  
(   
    extraordinary_astronomical_event_pk INT NOT NULL,
    extraordinary_astronomical_event_description VARCHAR(255) NULL,             

    PRIMARY KEY (extraordinary_astronomical_event_pk)  WITH (FILLFACTOR=90) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;



