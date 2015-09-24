/*     Test functions edw date dim insert and edw date dim update holiday functions
*/
DO

$test_exec$

DECLARE rows_updated INT;

BEGIN


    RAISE INFO '>>> Populate the Date Dim table';

    RAISE INFO '...Empty the date table, if not empty';

    DELETE FROM edw.date_dim ;

    --**
    --Initialize the date table
    --**

    RAISE INFO '...Execute the function "edw.date_dim_insert" to populate it.';

    SELECT * INTO rows_updated FROM edw.date_dim_insert ( '01/01/2010'::date, '01/01/2020'::date, FALSE) ;

            --PERFORM edw.date_dim_insert ( '01/01/2010'::date, '01/01/2020'::date, FALSE) ;

       RAISE NOTICE '...Date rows added to Date Dim table: %' , rows_updated;

    --**
    --Set  Holidays.  Might need to alter the rules in this function.
    --Ignoring the fact that holidays and therefore open/close dates might change, and  therefore would need to convert the holiday 
    --and open/close table to open dim table (to treat as type SCD)
    --**

    IF rows_updated > 0 THEN

             SELECT * INTO rows_updated FROM edw.date_dim_update_holiday(FALSE) ;

            RAISE NOTICE 'Holidays set for N rows/dates: %' , rows_updated;
                  
    END IF;
              
    RAISE INFO '...Pull a random selection of records to review (including holidays)';



END;
$test_exec$ 
language plpgsql;
GO
;
    WITH selection
    AS
    (
        SELECT * FROM edw.date_dim  OFFSET floor(random()* (SELECT COUNT(*) FROM edw.date_dim ) ) LIMIT 100 
    )
    SELECT * FROM selection 
        UNION
    SELECT * FROM edw.date_dim  WHERE holiday_text <> ''
        UNION 
    SELECT * FROM edw.date_dim WHERE open_flag = FALSE  AND day_of_week <> 'Sunday'
    ORDER BY date_pk;