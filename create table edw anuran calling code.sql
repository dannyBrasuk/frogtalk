/*
   Anuran calling codes and their descriptions

*/


DROP TABLE IF EXISTS edw.anuran_calling_code RESTRICT;

CREATE TABLE edw.anuran_calling_code  
(   
    anuran_calling_code INT NOT NULL,
    anuran_calling_code_description VARCHAR(255) NULL,             

    PRIMARY KEY (anuran_calling_code)  WITH (FILLFACTOR=100) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;


