/*
    Astronomical events that might have some influence or impact 

    Not all inclusive

*/

USE frogtalk;
GO

DROP TABLE IF EXISTS edw.extraordinary_astronomical_event_dim RESTRICT;

GO

CREATE TABLE edw.extraordinary_astronomical_event_dim  
(   
    extraordinary_astronomical_event_pk INT NOT NULL,
    extraordinary_astronomical_event_description VARCHAR(255) NULL,             

    PRIMARY KEY (extraordinary_astronomical_event_pk)  WITH (FILLFACTOR=90) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;

GO

INSERT INTO edw.extraordinary_astronomical_event_dim (extraordinary_astronomical_event_pk, extraordinary_astronomical_event_description)
    VALUES (0, 'None'), (1, 'Solar eclispe'), (2, 'Lunar eclispe');
GO
SELECT * FROM edw.extraordinary_astronomical_event_dim ;

