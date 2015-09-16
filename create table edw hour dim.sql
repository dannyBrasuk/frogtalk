/*
    Dimnension table for hour
*/

DROP TABLE IF EXISTS edw.hour_dim RESTRICT;


CREATE TABLE edw.hour_dim  
(   
    hour_pk INT NOT NULL,
    hour_label VARCHAR(8) NOT NULL,   
  
    PRIMARY KEY (hour_pk)  WITH (FILLFACTOR=100) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;

