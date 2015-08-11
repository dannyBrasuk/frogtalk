/*
   Anuran calling codes and their descriptions

*/

USE frogtalk;
GO

DROP TABLE IF EXISTS edw.anuran_calling_code RESTRICT;

GO

CREATE TABLE edw.anuran_calling_code  
(   
    anuran_calling_code INT NOT NULL,
    anuran_calling_code_description VARCHAR(255) NULL,             

    PRIMARY KEY (anuran_calling_code)  WITH (FILLFACTOR=90) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;

GO

INSERT INTO edw.anuran_calling_code (anuran_calling_code, anuran_calling_code_description)
    VALUES
            (1,'Individuals can be counted; there is space between calls.'),
            (2,'Calls of individuals can be distinguished, but there are some overlapping calls.'),
            (3,'Full chorus, calls are constant, continuous and overlapping.')
;
GO
SELECT * FROM edw.anuran_calling_code ;
