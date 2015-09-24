
/*

Standard date dimension table.  

Note that some elements are more germane to commercial and public sector operations than to environmental tracking. 
I left the values in anyway, One such element is the "open (for business) flag," which also happens to be specific to the business.  Adjsut as needed.

To execute:

--TRUNCATE TABLE edw.date_dim RESTRICT;

select * FROM edw.DateDim_insert ( '01/01/2000'::date, '01/01/2031'::date, FALSE::boolean) ;

select * from edw.date_dim;

*/

CREATE OR REPLACE FUNCTION edw.date_dim_insert
(
    in start_date date =  '01/1/1900'::date, 
    in end_date date = '01/01/2030'::date,                      --Non inclusive. Stops on the day before this.
    in debug_flag boolean =FALSE                              -- toogle on/off run-time information 
) 
RETURNS  int  
AS $body$
DECLARE 
        date_of_current_row date;                    --@Date
        week_day_of_month int;
        the_current_month int;       --@CurrentMonth
        the_current_date date;       --@CurrentDate
        rows_inserted int;
        rows_updated int;
error_message text;
error_hint text;
error_detail text;

BEGIN

        --**
         --Limit table to 20 year range (just to keep it under control.
        IF EXTRACT(years FROM AGE(end_date,start_date))::INT >= 20 THEN
                        RAISE NOTICE 'Limit date range to under 20 years please.';
                        RETURN 0;
                        EXIT;
        END IF;

        --**
        --Substitute a default if not supplied.
        IF start_date IS NULL THEN 
            start_date:= CAST( '01/1/1900' AS date) ;
        END IF;
            
        IF end_date IS NULL THEN 
           end_date:= CAST( '01/01/2031' AS date);
        END IF;

        --***
        --Initialize table with dates. 

        --Need a temp table for counting day of week (dow) occurance in a month;  used in the loop below ("dow" is short for day of week).
        --Important: The sequence is  0 is Sunday, 1 = Monday, 2= Tuesday, etc.  Postgres defaults to this.  If the default changes, then the
        --weekday driven conditions in the Insert/Select need to be altered.
        DROP TABLE IF EXISTS temp_day_of_week;

       CREATE  TEMP TABLE  temp_day_of_week
       AS
       WITH list (dow, counter) AS 
             (  VALUES (0,0), (1,0), (2,0), (3,0), (4,0), (5,0), (6,0) )
        SELECT dow,counter FROM list;

       date_of_current_row:= start_date;
       the_current_date := CURRENT_DATE;
       the_current_month :=EXTRACT(month from date_of_current_row);

        IF debug_flag THEN
                RAISE NOTICE 'Initial values for date_of_current_row: %,   the_current_date: %,  the_current_month: %' , date_of_current_row, the_current_date , the_current_month;
        END IF;

        --Loop to pipulate the table

                WHILE date_of_current_row < end_date LOOP

                       IF debug_flag THEN
                                 RAISE NOTICE 'Top of loop:  date_of_current_row: %,   the_current_date: %,  the_current_month: %' , date_of_current_row, the_current_date , the_current_month;
                       END IF;

                       IF EXTRACT(MONTH FROM date_of_current_row) <> the_current_month THEN
                           the_current_month := EXTRACT(MONTH FROM date_of_current_row);
                           UPDATE temp_day_of_week SET counter = 0;
                       END IF;

                       UPDATE temp_day_of_week
                               SET counter = counter + 1
                       WHERE dow = CAST(EXTRACT (DOW FROM date_of_current_row) AS INT);

                       SELECT counter INTO week_day_of_month
                       FROM temp_day_of_week
                       WHERE dow = EXTRACT (DOW FROM date_of_current_row);

                       --add row to table

                       INSERT INTO edw.date_dim    (     date_pk, full_date, day_of_month, day_suffix, day_of_week,day_of_week_number, day_of_week_in_month, day_of_year_number
                                                                                  , week_of_year_number, week_of_month_number, calendar_month_number, calendar_month_name
                                                                                  , calendar_quarter_number, calendar_quarter_name,  calendar_year_number,  standard_date
                                                                                  , relative_days, relative_weeks, relative_months, relative_quarters, relative_years
                                                                                  , week_day_flag, firstday_of_calendar_month_flag, lastday_of_calendar_month_flag, open_flag,  holiday_flag, holiday_text
                                                                             ) 
                               SELECT 

                                   --use a numeric date value to create a constant key, regardless of how how often the table is rebuilt.
                                    CAST( to_char(date_of_current_row, 'YYYYMMDD') AS INT) AS date_pk

                                    , date_of_current_row AS full_date
                                    , EXTRACT(DAY FROM date_of_current_row)::SMALLINT AS day_of_month 
                                    , CASE 
                                           WHEN CAST(EXTRACT(DAY FROM date_of_current_row) AS VARCHAR(4))  IN ('11','12','13') THEN CAST(EXTRACT(DAY FROM date_of_current_row) AS VARCHAR(4)) || 'th'
                                           WHEN CAST(EXTRACT(DAY FROM date_of_current_row) AS VARCHAR(4)) LIKE '1%' THEN CAST(EXTRACT(DAY FROM date_of_current_row) AS VARCHAR(4)) || 'st'
                                           WHEN CAST(EXTRACT(DAY FROM date_of_current_row) AS VARCHAR(4)) LIKE '2%' THEN CAST(EXTRACT(DAY FROM date_of_current_row) AS VARCHAR(4)) || 'nd'
                                           WHEN CAST(EXTRACT(DAY FROM date_of_current_row) AS VARCHAR(4)) LIKE '3%' THEN CAST(EXTRACT(DAY FROM date_of_current_row) AS VARCHAR(4)) || 'rd'
                                           ELSE CAST(EXTRACT(DAY FROM date_of_current_row) AS VARCHAR(4)) || 'th' 
                                       END AS day_suffix
                                    , CASE EXTRACT(DOW FROM date_of_current_row)::INT
                                           WHEN 0 THEN 'Sunday'
                                           WHEN 1 THEN 'Monday'
                                           WHEN 2 THEN 'Tuesday'
                                           WHEN 3 THEN 'Wednesday'
                                           WHEN 4 THEN 'Thursday'
                                           WHEN 5 THEN 'Friday'
                                           WHEN 6 THEN 'Saturday'
                                       END AS day_of_week
                                    , EXTRACT(DOW FROM date_of_current_row)::INT AS day_of_week_number
                                    , week_day_of_month AS day_of_week_in_month                                                                        --Occurance of this day in this month. If Third Monday then 3 and DOW would be Monday.   VERIFY
                                    , EXTRACT(DOY FROM date_of_current_row)::INT AS day_of_year_number                      --Day of the year. 0 -- 365/366

                                    , EXTRACT(WEEK FROM date_of_current_row) AS week_of_year_number                --0-52/53
                                    , CAST(to_char(date_of_current_row, 'W') AS INT) AS week_of_month_number
                                    , EXTRACT(MONTH FROM date_of_current_row) AS calendar_month_number      --To be converted with leading zero later. 
                                    , RTRIM(to_char(date_of_current_row, 'Month')) AS calendar_month_name

                                    , EXTRACT(QUARTER FROM date_of_current_row) AS calendar_quarter_number --Calendar quarter
                                    , CASE EXTRACT(QUARTER FROM date_of_current_row) 
                                            WHEN 1 THEN 'First'
                                            WHEN 2 THEN 'Second'
                                            WHEN 3 THEN 'Third'
                                            WHEN 4 THEN 'Fourth'
                                       END AS calendar_quarter_name
                                    , EXTRACT(YEAR FROM date_of_current_row) AS calendar_year_number
                                    , RTRIM(to_char(date_of_current_row, 'DD/MM/YYYY')) AS standard_date

                                    --relative days from date the date dim table was populated.  If table is rebuilt each time the EDW is refreshed, the the number of days is relative to the most recent entry into the EDW.
                                    ,  date_of_current_row - the_current_date AS relative_days    
                                    ,  ROUND( (date_of_current_row-the_current_date)  / 7,0)::int AS relative_weeks
                                    ,  EXTRACT(years FROM AGE(date_of_current_row, the_current_date ))*12::int   + EXTRACT(mons FROM AGE(date_of_current_row, the_current_date  )) AS relative_months 
                                    ,  TRUNC( (EXTRACT(years FROM AGE(date_of_current_row, the_current_date ))*12.0  + EXTRACT(mons FROM AGE(date_of_current_row, the_current_date  )) ) / 3.0)::INT  AS relative_quarters
                                    ,  EXTRACT(years FROM AGE(date_of_current_row, the_current_date )) AS  relative_years

                                    --0=Sunday, 1=Monday, 2=Tuesday, etc.
                                    , CASE EXTRACT(DOW FROM date_of_current_row)::INT
                                            WHEN 0 THEN FALSE
                                            WHEN 1 THEN TRUE
                                            WHEN 2 THEN TRUE
                                            WHEN 3 THEN TRUE
                                            WHEN 4 THEN TRUE
                                            WHEN 5 THEN TRUE
                                            WHEN 6 THEN FALSE
                                        END AS week_day_flag

                                    , CASE EXTRACT(DAY FROM date_of_current_row)::INT
                                           WHEN 1 THEN TRUE
                                           ELSE FALSE
                                       END AS firstday_of_calendar_month_flag
                                    , CASE 
                                           WHEN CAST(DATE_TRUNC('MONTH', date_of_current_row) +'1month'::INTERVAL-'1day'::INTERVAL AS DATE) = date_of_current_row THEN TRUE
                                           ELSE FALSE
                                       END AS lastday_of_calendar_month_flag

                                       --set according to the normal business hours of  the organization.
                                       --0=Sunday, 1=Monday, 2=Tuesday, etc.
                                       --In this case, the business hours are Sunday to Friday.
                                    , CASE EXTRACT(DOW FROM date_of_current_row)::INT
                                            WHEN 0 THEN FALSE      
                                            WHEN 1 THEN TRUE
                                            WHEN 2 THEN TRUE
                                            WHEN 3 THEN TRUE
                                            WHEN 4 THEN TRUE
                                            WHEN 5 THEN TRUE
                                            WHEN 6 THEN TRUE
                                        END AS open_flag

                                   --these columns are set in the "Holiday" function
                                    , FALSE AS holiday_flag
                                    , ''   AS holiday_text
                               ;

                       --increment loop
                       date_of_current_row := date_of_current_row + INTERVAL '1 day';      --DATEADD(dd,1,@Date)

                       IF debug_flag THEN
                                 RAISE NOTICE '  Bottom of loop:  date_of_current_row: %,   the_current_date: %,  the_current_month: %' , date_of_current_row, the_current_date , the_current_month;
                       END IF;

                END LOOP;
            
              GET DIAGNOSTICS rows_inserted = ROW_COUNT;

                       IF debug_flag  THEN
                                  RAISE NOTICE 'Table initialed with N records: %' , rows_inserted;
                      END IF;

        --**
        --Return status

        SELECT COUNT(*) INTO rows_inserted FROM  edw.date_dim; 

        RETURN rows_inserted;

        --**
        --Clean up
        DROP TABLE IF EXISTS temp_day_of_week;

END;
$body$ 
LANGUAGE plpgsql;


COMMENT ON FUNCTION edw.date_dim_insert (date, date, boolean) IS 'The date function is used to populate the Date Dim table in the ETL.';


