/*
   Current conditions at site: codes and their descriptions.

   This data is part of the application itself, and therefore the data
   is maintained in MongoDB.  However, in the ETL its merged with Sites data.

*/
DROP TABLE IF EXISTS trnfm.current_condition RESTRICT;



CREATE TABLE trnfm.current_condition 
(   
    current_condition_pk INT NOT NULL,
    current_condition_description VARCHAR(40) NOT NULL,

    PRIMARY KEY (current_condition_pk)  WITH (FILLFACTOR=100) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;