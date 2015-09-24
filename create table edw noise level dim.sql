/*
   Noise level codes and their descriptions.

   This data is part of the application itself, and therefore the data
   is maintained in MongoDB.  However, in the ETL its merged with Sites data.

*/

DROP TABLE IF EXISTS edw.noise_level_dim RESTRICT;

CREATE TABLE edw.noise_level_dim  
(   
    noise_level_pk INT NOT NULL,
    noise_level_description VARCHAR(255) NULL,             

    PRIMARY KEY (noise_level_pk)  WITH (FILLFACTOR=90) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=100)
TABLESPACE myDataSpace;
