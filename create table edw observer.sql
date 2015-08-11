/*

Dimension table of observers for the EDW.

Contact information assumed to be not important in the EDW.  Main concern is reliability of observations.

*/

USE frogtalk;
GO

DROP TABLE IF EXISTS edw.observer_dim RESTRICT;

GO


CREATE TABLE edw.observer_dim  
(   
    observer_pk                                          INT NOT NULL,
    observer_type_description                    VARCHAR(40) NOT NULL,      /* volunteer, professional */
    date_first_joined                                   DATE NULL,
    affliation_description                            VARCHAR(40) NULL,      /* University of ....,  Riverkeeper of .... , 'water authority of ...*/
    PRIMARY KEY (observer_pk)  WITH (FILLFACTOR=90) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;
GO

--these are just examples of possible entries

INSERT INTO edw.observer_dim (observer_pk, observer_type_description, date_first_joined,affliation_description ) 
VALUES
(0, 'Unregistered', NULL, NULL),
(1, 'Volunteer', '04/01/2013', NULL),
(2, 'Volunteer', '05/01/2014', NULL),
(3, 'Professional', '06/15/2010', 'Cobb County Water Authority')
;
GO
SELECT *  FROM edw.observer_dim;