--   Dimension table of dates for the EDW
--for frogs, probably do not need all the standard columns, but keep anyway

USE frogtalk;
GO
    DROP TABLE IF EXISTS edw.date_dim RESTRICT;
    --DROP TABLE IF EXISTS edw.date_dim CASCADE;
GO
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
        relative_days INT NULL,
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
        holiday_flag BOOLEAN NULL,
        open_flag BOOLEAN NULL,
        firstday_of_calendar_month_flag BOOLEAN NULL,
        lastday_of_calendar_month_flag BOOLEAN NULL,
        holiday_text VARCHAR(50) NULL,

        PRIMARY KEY (date_pk) WITH (FILLFACTOR=100) USING INDEX TABLESPACE myIndexSpace
) 
WITH (FILLFACTOR=100)
TABLESPACE myDataSpace
;
GO
ALTER TABLE edw.anuran_fact
    ADD CONSTRAINT fk_anuran_date
	FOREIGN KEY(date_fk)
	REFERENCES edw.date_dim(date_pk)
	ON DELETE SET NULL 
	ON UPDATE CASCADE;