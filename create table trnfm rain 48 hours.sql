/*
   Rain in the last 48 hours level: codes and their descriptions.

   This data is part of the application itself, and therefore the data
   is maintained in MongoDB.  However, in the ETL its merged with Sites data.

*/
DROP TABLE IF EXISTS trnfm.rain_48hours RESTRICT;


CREATE TABLE trnfm.rain_48hours  
(   
    rain_48hours_pk INT NOT NULL,
    rain_48hours_description VARCHAR(40) NOT NULL,

    PRIMARY KEY (rain_48hours_pk)  WITH (FILLFACTOR=100) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;