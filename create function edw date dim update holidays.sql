
/*

Associate dates with a holiday. (not that this has anything to do with frog tracking, but its a conventional 
attribute to include in a date dimension table.  (The exception could be July 4 and Jan 1 due to fireworks.)

If the holiday is "celebrated" by the business/organization, then set the holiday flag to true.
If the business/organization is closed on the holiday (and perhaps the day after or before) then set the open_flag to false.

Note that in this example, I'm ignoring the fact that holidays and/or open/close values can change over time.
Therefore would need to convert the holiday and open/close entires to dim table(s), and to treat as type 4 SCD

*/
CREATE OR  REPLACE FUNCTION edw.date_dim_update_holiday 
(
    in debug_flag boolean =FALSE                              -- toogle on/off run-time information 
) 
RETURNS  int  
AS $body$
DECLARE 
        records_updated int;
 BEGIN
        
       IF (SELECT COUNT(*) FROM edw.date_dim) = 0 THEN
            BEGIN
                    RAISE NOTICE 'edw.date_dim is Empty.  Operation canceled.';
                    RETURN 0;
            END;
       END IF;


      -- New Years Day
        UPDATE edw.date_dim SET
            holiday_text = 'New Year''s Day',
            holiday_flag = true,
            open_flag = false
        WHERE calendar_month_number = 1 AND day_of_month = 1;

              GET DIAGNOSTICS records_updated = ROW_COUNT;

                       IF debug_flag  THEN
                                  RAISE NOTICE '# Holiday, New Year''s Day: %' , records_updated;
                      END IF;

        --Set OpenFlag = 0 . Close on Monday if  New Year's Day is on Sunday 
        UPDATE edw.date_dim SET
            open_flag = false
        WHERE date_pk in 
                (SELECT
                     CASE 
                            WHEN day_of_week = 'Sunday'  THEN date_pk + 1
                    END
                FROM  edw.date_dim
                WHERE calendar_month_number = 1  AND day_of_month = 1
                );

              GET DIAGNOSTICS records_updated = ROW_COUNT;

                       IF debug_flag  THEN
                                  RAISE NOTICE '# Holiday, New Year''s Day. Close on Monday if holiday is on Sunday: %' , records_updated;
                      END IF;

            --Martin Luther King Day. Third Monday in January starting in 1983
            UPDATE edw.date_dim SET
                holiday_text = 'Martin Luther King Jr. Day',
                holiday_flag = TRUE,
                open_flag = FALSE
            WHERE calendar_month_number = 1                 --January
                    AND day_of_week = 'Monday' 
                    AND calendar_year_number >= 1983        --When holiday was official
                    AND day_of_week_in_month = 3;         --Third X day of current month

                    GET DIAGNOSTICS records_updated = ROW_COUNT;

                           IF debug_flag  THEN
                                      RAISE NOTICE '# Holiday, MLK Day: %' , records_updated;
                          END IF;

                --President's Day. Third Monday in February.
                UPDATE edw.date_dim SET
                    holiday_text = 'President''s Day',
                    holiday_flag = TRUE,
                    open_flag = FALSE
                WHERE calendar_month_number = 2                 --February
                        AND day_of_week = 'Monday'
                        AND day_of_week_in_month = 3;         --Third occurance of a monday in this month.

                GET DIAGNOSTICS records_updated = ROW_COUNT;

                       IF debug_flag  THEN
                                  RAISE NOTICE '# Holiday, President''s Day: %' , records_updated;
                      END IF;

                --Memorial Day. Last Monday in May
                WITH keys (date_fk)
                 AS   (
                            SELECT MAX(date_pk) as keys
                            FROM edw.date_dim
                            WHERE calendar_month_name = 'May'
                            AND day_of_week = 'Monday'
                            GROUP BY calendar_year_number, calendar_month_number
                        )
                UPDATE edw.date_dim SET
                    holiday_text = 'Memorial Day',
                    holiday_flag = TRUE,
                    open_flag = FALSE
                WHERE date_pk IN (SELECT date_fk FROM keys);
   
                GET DIAGNOSTICS records_updated = ROW_COUNT;

                       IF debug_flag  THEN
                                  RAISE NOTICE '# Holiday, Memorial Day: %' , records_updated;
                      END IF;

                --4th of July 
                UPDATE edw.date_dim SET
                    holiday_text = 'Independance Day',
                    holiday_flag = TRUE,
                    open_flag = FALSE
                WHERE calendar_month_number = 7 AND day_of_month = 4;

                GET DIAGNOSTICS records_updated = ROW_COUNT;

                       IF debug_flag  THEN
                                  RAISE NOTICE '# Holiday, Independance Day: %' , records_updated;
                      END IF;

            --Set open_flag = FALSE, to Close on Monday if holiday is on a Sunday
            UPDATE edw.date_dim SET
                open_flag = FALSE
            WHERE date_pk in 
            (       SELECT  
                            CASE 
                                WHEN day_of_week = 'Sunday' THEN date_pk + 1
                            END
                    FROM  edw.date_dim 
                    WHERE calendar_month_number = 7  AND day_of_month = 4
            );

                            GET DIAGNOSTICS records_updated = ROW_COUNT;

                                   IF debug_flag  THEN
                                              RAISE NOTICE '# Holiday, Independance Day.  Close on Monday if holiday is on a Sunday: %' , records_updated;
                                  END IF;

            --Labor Day. First Monday in September
            UPDATE edw.date_dim SET
                holiday_text = 'Labor Day',
                holiday_flag = TRUE,
                open_flag = FALSE
            WHERE date_pk IN 
                    (   SELECT MIN(date_pk)
                        FROM edw.date_dim
                        WHERE calendar_month_name = 'September'
                        AND day_of_week = 'Monday'
                        GROUP BY calendar_year_number, calendar_month_number
                    );

                                GET DIAGNOSTICS records_updated = ROW_COUNT;

                                       IF debug_flag  THEN
                                                  RAISE NOTICE '# Holiday, Labor Day: %' , records_updated;
                                      END IF;

            --Columbus Day. 2nd Monday in October
            UPDATE edw.date_dim 
            SET holiday_text = 'Columbus Day',
                holiday_flag = TRUE,
                open_flag = FALSE
            WHERE date_pk IN 
                    (   SELECT MIN(date_pk)
                        FROM edw.date_dim
                        WHERE calendar_month_name = 'October'
                                AND day_of_week = 'Monday'
                                AND day_of_week_in_month = 2
                        GROUP BY calendar_year_number, calendar_month_number
                    );

                            GET DIAGNOSTICS records_updated = ROW_COUNT;

                                   IF debug_flag  THEN
                                              RAISE NOTICE '# Holiday, Columbus Day: %' , records_updated;
                                  END IF;

            --Veteran's Day
            UPDATE edw.date_dim SET
                holiday_text = 'Veteran''s Day',
                holiday_flag = TRUE,
                open_flag = FALSE
            WHERE date_pk in 
                    (   SELECT CASE
                                WHEN day_of_week = 'Saturday' THEN date_pk - 1           --Celebrate and close on Friday is Veteran's Day is Saturday
                                WHEN day_of_week = 'Sunday'   THEN date_pk + 1          --Celebrate and close on Monday is Veteran's Day is Sunday
                                ELSE date_pk
                            END as veterans_date_pk
                        FROM  edw.date_dim 
                        WHERE calendar_month_number  = 11 AND day_of_month = 11
                    );

                            GET DIAGNOSTICS records_updated = ROW_COUNT;

                                   IF debug_flag  THEN
                                              RAISE NOTICE '# Holiday, Veteran''s Day: %' , records_updated;
                                  END IF;

            --THANKSGIVING. Fourth THURSDAY in November.
            UPDATE  edw.date_dim
            SET holiday_text = 'Thanksgiving Day',
                holiday_flag = TRUE,
                open_flag = FALSE
            WHERE calendar_month_number = 11 
                AND day_of_week = 'Thursday' 
                AND day_of_week_in_month = 4;

                            GET DIAGNOSTICS records_updated = ROW_COUNT;

                                   IF debug_flag  THEN
                                              RAISE NOTICE '# Holiday, Thanksgiving Day: %' , records_updated;
                                  END IF;

                --CHRISTMAS
                UPDATE edw.date_dim SET
                    holiday_text = 'Christmas Day',
                    holiday_flag = TRUE,
                    open_flag = FALSE
                WHERE calendar_month_number = 12 AND day_of_month = 25;

                            GET DIAGNOSTICS records_updated = ROW_COUNT;

                                   IF debug_flag  THEN
                                              RAISE NOTICE '# Holiday, Christmas Day: %' , records_updated;
                                  END IF;

               --Set open_flag = FALSE on Friday and Monday when Christmas is on a  Saturday or Sunday;
                UPDATE edw.date_dim 
                SET open_flag = FALSE
                WHERE date_pk in 
                        (   SELECT CASE 
                                WHEN day_of_week = 'Sunday' THEN date_pk + 1
                                WHEN day_of_week = 'Saturday' THEN date_pk - 1
                                END
                            FROM  edw.date_dim 
                            WHERE calendar_month_number = 12 and day_of_month = 25
                        );

                           GET DIAGNOSTICS records_updated = ROW_COUNT;

                                   IF debug_flag  THEN
                                              RAISE NOTICE '# Holiday, Closed Saturday or Sunday around Christmas Day: %' , records_updated;
                                  END IF;

                --Set open_flag = FALSE on the day after Christmas;
                UPDATE edw.date_dim 
                SET open_flag = FALSE
                WHERE date_pk in 
                        (   SELECT date_pk + 1
                            FROM  edw.date_dim 
                            WHERE calendar_month_number = 12 and day_of_month = 25
                        );

                            GET DIAGNOSTICS records_updated = ROW_COUNT;

                                   IF debug_flag  THEN
                                              RAISE NOTICE '# Holiday, Closed day after Christmas Day: %' , records_updated;
                                  END IF;


            -- Valentine's Day 
            UPDATE edw.date_dim SET 
                holiday_text = 'Valentine''s Day',
                holiday_flag = false
            WHERE calendar_month_number = 2 AND day_of_month = 14;

                           GET DIAGNOSTICS records_updated = ROW_COUNT;

                                   IF debug_flag  THEN
                                              RAISE NOTICE '# Holiday, Valentine''Day: %' , records_updated;
                                  END IF;

            -- Saint Patrick's Day
            UPDATE edw.date_dim SET
                holiday_text = 'Saint Patrick''s Day',
                holiday_flag = false
            WHERE calendar_month_number = 3 AND day_of_month = 17;

                           GET DIAGNOSTICS records_updated = ROW_COUNT;

                                   IF debug_flag  THEN
                                              RAISE NOTICE '# Holiday, Saint Patrick''s Day: %' , records_updated;
                                  END IF;

            --Mother's Day. Second Sunday of May
            UPDATE  edw.date_dim SET
                    holiday_text = 'Mother''s Day' , 
                    holiday_flag = false         
            WHERE calendar_month_number = 5             
                    AND day_of_week = 'Sunday'
                    AND day_of_week_in_month = 2;     --Second occurance of a monday in this month.

                           GET DIAGNOSTICS records_updated = ROW_COUNT;

                                   IF debug_flag  THEN
                                              RAISE NOTICE '# Holiday, Mother''s Day: %' , records_updated;
                                  END IF;

            --Father's Day. Third Sunday of June
            UPDATE  edw.date_dim SET
                holiday_text = 'Father''s Day' ,
                holiday_flag = false
            WHERE calendar_month_number = 6                    
                    AND day_of_week = 'Sunday'
                    AND day_of_week_in_month = 3;     --Third occurance of a monday in this month.

                           GET DIAGNOSTICS records_updated = ROW_COUNT;

                                   IF debug_flag  THEN
                                              RAISE NOTICE '# Holiday, Father''s Day: %' , records_updated;
                                  END IF;

            --Halloween 10/31 
            UPDATE edw.date_dim SET
                holiday_text = 'Halloween',
                holiday_flag = false      
            WHERE calendar_month_number = 10 AND day_of_month = 31;

                           GET DIAGNOSTICS records_updated = ROW_COUNT;

                                   IF debug_flag  THEN
                                              RAISE NOTICE '# Holiday, Halloween: %' , records_updated;
                                  END IF;
                          
        --**
        --Return status
        SELECT COUNT(*) INTO records_updated FROM  edw.date_dim WHERE holiday_text <> '';
        RETURN records_updated;


END;
$body$ 
LANGUAGE plpgsql;

COMMENT ON FUNCTION edw.date_dim_update_holiday (boolean) IS 'The holiday function is executed independently from the Date Dim Insert function.';
        