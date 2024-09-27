/* 1. Amenity Revenue */
SELECT
       DATE_TRUNC(month, availability_date)                                                AS reporting_month
,      has_air_conditioning
,      SUM(price_dollars0)
FROM
       {{ ref('listings_daily_summary') }}
GROUP BY
       1,2
ORDER BY
       1,2
