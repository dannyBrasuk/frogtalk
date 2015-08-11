/*
    Noise level metrics 

*/

USE frogtalk;
GO

DROP TABLE IF EXISTS edw.noise_level_dim RESTRICT;

GO

CREATE TABLE edw.noise_level_dim  
(   
    noise_level_pk INT NOT NULL,
    noise_level_description VARCHAR(255) NULL,             

    PRIMARY KEY (noise_level_pk)  WITH (FILLFACTOR=90) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;

GO

INSERT INTO edw.noise_level_dim (noise_level_pk, noise_level_description)
    VALUES 
            (0,'Not recorded or observed'),
            (1,'No effect (owl calling)'),
            (2,'Slight effect (distant traffic, dog barking)'),
            (3,'Moderate effect (nearby traffic, 2-5 cars passing)'),
            (4,'Serious effect (continuous traffic nearby, 6-10 cars passing)'),
            (5,'Profound effect (continuous traffic passing, construction noise)')
    ;
GO
SELECT * FROM edw.noise_level_dim ;