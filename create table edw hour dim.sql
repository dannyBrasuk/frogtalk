USE frogtalk;
GO

DROP TABLE IF EXISTS edw.hour_dim RESTRICT;

GO


CREATE TABLE edw.hour_dim  
(   
    hour_pk INT NOT NULL,
    hour_label VARCHAR(8) NOT NULL,   
  
    PRIMARY KEY (hour_pk)  WITH (FILLFACTOR=90) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;
GO

DO $$
DECLARE     
    hour_pk int = 0;
    hour_label VARCHAR(256);

BEGIN
 
        LOOP   
                    hour_label := 
                                        CASE
                                                WHEN hour_pk < 10 THEN '0' || hour_pk::varchar(256) || ':00 AM'
                                                WHEN hour_pk < 12 THEN hour_pk::varchar(256) || ':00 AM'
                                                ELSE hour_pk::varchar(256) || ':00 PM'
                                        END:: VARCHAR(8);
                               -- RAISE NOTICE 'entry: %, %', hour_pk, hour_label;
                    INSERT INTO edw.hour_dim (hour_pk, hour_label)
                            VALUES (hour_pk, hour_label);

                    hour_pk := hour_pk + 1;
             
                    EXIT WHEN hour_pk = 24;
 
        END LOOP;

END ;
--$$  language SQL;
$$  language plpgsql;


GO

select * from edw.hour_dim
