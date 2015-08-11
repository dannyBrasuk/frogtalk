/*
        Initial attempt to characterize the observers on some proxy for reliability
*/

USE frogtalk;
GO

DROP MATERIALIZED VIEW IF EXISTS edw.observer_history;

GO
CREATE MATERIALIZED VIEW edw.observer_history
    WITH (FILLFACTOR = 90)
    TABLESPACE mydataspace
AS
SELECT

    f.observer_fk,
    MAX(o.observer_type_description) AS observer_type_description,
    MAX(f.date_fk ) AS date_of_most_recent_observation,
    COUNT(f.anuran_fact_pk) AS count_of_observations,
    SUM(    CASE 
                        WHEN d.relative_days BETWEEN 0 AND 365 THEN 1
                        ELSE 0
                END 
    ) AS Count_of_observations_past_12_months

FROM edw.anuran_fact f 
JOIN edw.date_dim d ON f.date_fk = d.date_pk
JOIN edw.observer_dim o ON f.observer_fk = o.observer_pk
WHERE f.observer_fk > 0
GROUP BY f.observer_fk;

GO

REFRESH MATERIALIZED VIEW edw.observer_history;