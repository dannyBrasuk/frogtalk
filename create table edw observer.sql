/*

Dimension table of observers for the EDW.

Contact information assumed to be not important in the EDW.  Main concern is reliability of observations.

*/

DROP TABLE IF EXISTS edw.observer_dim RESTRICT;

CREATE TABLE edw.observer_dim  
(   
    observer_pk                                  INT NOT NULL,
    observer_type_description                    VARCHAR(40) NOT NULL,      /* volunteer, professional */
    date_first_joined                            DATE NULL,
    affliation_description                       VARCHAR(40) NULL,         /* University of ...,  Riverkeeper of ..., 'water authority of ...*/
    source_observer_record_id                    VARCHAR(24) NOT NULL,       /*  MongoDB ID */
    PRIMARY KEY (observer_pk)  WITH (FILLFACTOR=90) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;

