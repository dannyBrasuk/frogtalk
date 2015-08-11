/*
Type 4 mini Dimension table of all possible combinations of "current conditions"
*/

USE frogtalk;
GO

DROP TABLE IF EXISTS edw.observed_site_condition_dim RESTRICT;

GO

--Because Postgres does not support computed columns, compute the Point object in the ETL - if i decide I need it in EDW

CREATE TABLE edw.observed_site_condition_dim  
(   
    observed_site_condition_pk INT NOT NULL,
    current_condition_description VARCHAR(40) NOT NULL,
    wind_scale_description VARCHAR(40) NOT NULL,
    rain_last_48_hours_description VARCHAR(40) NOT NULL,
    water_level_description VARCHAR(40) NOT NULL,

    PRIMARY KEY (observed_site_condition_pk)  WITH (FILLFACTOR=90) USING INDEX TABLESPACE myindexspace  
)
WITH (FILLFACTOR=90)
TABLESPACE myDataSpace
;
GO

INSERT INTO edw.observed_site_condition_dim (observed_site_condition_pk, current_condition_description, wind_scale_description, rain_last_48_hours_description, water_level_description)
    SELECT ROW_NUMBER() OVER(ORDER BY cc_code, ws_code, r_code, wl_code) as ID, current_condition_description, wind_scale_description, rain_last_48_hours_description, water_level_description
    FROM
    (VALUES
            (0,'Not recorded'),
            (1,'Sunny and clean'),
            (2,'Partly cloudy or variable sky'),
            (3,'Overcast'),
            (4,'Fog or smoke'),
            (5,'Drizzle / light rain')
    ) AS current_conditions (cc_code, current_condition_description)
    CROSS JOIN
    (VALUES
    (0,'Not recorded or observed'),
    (1,'Calm'),
    (2,'Light Breeze'),
    (3,'Gentle Breeze'),
    (4,'Moderate Breeze'),
    (5,'Fresh Breeze')
    ) AS wind_scale_conditions (ws_code, wind_scale_description)
    CROSS JOIN
    (VALUES
    (0,'None'),
    (1,'Light (less than 1/2 inch)'),
    (2,'Moderate (1/2 - 1 inch)'),
    (3,'Heavy (< 1 inch)')
    ) AS rain_conditions (r_code, rain_last_48_hours_description)
    CROSS JOIN
    (VALUES
    (0,'Not observed or unobservable'),
    (1,'Extremely dry - drought conditions'),
    (2,'Moist, but no standing water'),
    (3,'Shallow water (less than 1 foot)'),
    (4,'Deep water (more than 1 foot)'),
    (5,'Permanent Water')
    ) AS later_level_conditions (wl_code, water_level_description);

GO
 SELECT * FROM edw.observed_site_condition_dim  ORDER BY observed_site_condition_pk;