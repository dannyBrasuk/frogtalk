/*
        The EDW uses a composite table of all possible combinations of current conditions, wind scale, rain last 48 hours, and water level.
*/


DROP VIEW IF EXISTS trnfm.observed_site_condition;

CREATE  VIEW trnfm.observed_site_condition
AS

SELECT ROW_NUMBER() OVER(ORDER BY cc_code, ws_code, r_code, wl_code) as observed_site_condition_pk, current_condition_description, wind_scale_description, rain_last_48_hours_description, water_level_description
   FROM
        (
        SELECT
        Code AS cc_code, Description AS current_condition_description
        FROM trnfm.current_condition

        CROSS JOIN

        SELECT
        Code AS ws_code, Description AS wind_scale_description
        FROM trnfm.wind_scale

        CROSS JOIN

        SELECT
        Code AS r_code, Description AS rain_last_48_hours_description
        FROM trnfm.rain_48hours

        CROSS JOIN

        SELECT
        Code AS wl_code, Description AS water_level_description
        FROM trnfm.water_level
        )


COMMENT ON  VIEW trnfm.observed_site_condition IS 'Cross join of current condition, wind scale, rain last 48 hours, water level';