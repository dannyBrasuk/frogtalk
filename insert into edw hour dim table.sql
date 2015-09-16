/*
    Initialize the hour dimension table
*/


DO $$

DECLARE     
    hour_pk int = 0;
    hour_label VARCHAR(256);

BEGIN

    RAISE INFO '>>> Initialize the hour dimension table';

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
$$  language plpgsql;



select * from edw.hour_dim
