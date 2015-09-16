--   Dimension table of dates for the EDW
--   For frogs, probably do not need all the standard columns, such as holidays, but keep anyway


DROP TABLE IF EXISTS edw.date_dim RESTRICT;
    --DROP TABLE IF EXISTS edw.date_dim CASCADE;

CREATE TABLE edw.date_dim
(
        date_pk INT NOT NULL,            --YYYYMMDD
        full_date DATE NULL,
        day_of_month SMALLINT NULL,
        day_suffix VARCHAR(4) NULL,
        day_of_week VARCHAR(9) NULL,
        day_of_week_number INT NULL,
        day_of_week_in_month SMALLINT NULL,
        day_of_year_number INT NULL,
        relative_days INT NULL,                                                     --from date table was populated.  If rebuilt each time the EDW is refreshed, the the number of days is relative to the most recent entry into the EDW.
        week_of_year_number SMALLINT NULL,
        week_of_month_number SMALLINT NULL,
        relative_weeks INT NULL,
        calendar_month_number SMALLINT NULL,
        calendar_month_name VARCHAR(9) NULL,
        relative_months INT NULL,
        calendar_quarter_number INT NULL,
        calendar_quarter_name VARCHAR(6) NULL,
        relative_quarters INT NULL,
        calendar_year_number INT NULL,
        relative_years INT NULL,
        standard_date VARCHAR(10) NULL,
        week_day_flag BOOLEAN NULL, 

        firstday_of_calendar_month_flag BOOLEAN NULL,
        lastday_of_calendar_month_flag BOOLEAN NULL,
        open_flag BOOLEAN NULL,
        holiday_flag BOOLEAN NULL,
        holiday_text VARCHAR(50) NULL,

        PRIMARY KEY (date_pk) WITH (FILLFACTOR=100) USING INDEX TABLESPACE myIndexSpace
) 
WITH (FILLFACTOR=100)
TABLESPACE myDataSpace
;

COMMENT ON TABLE edw.date_dim IS 'For frogs, standard "date dim" columns such as and open/close and holidays dont really apply, but are kept anyway for completeness.';

COMMENT ON COLUMN edw.date_dim.relative_days IS '"Relative_days" is from the date the table was populated. If rebuilt each time the EDW is refreshed, then the number of days is relative to the most recent entry into the EDW.';