/* 1. Amenity Revenue */
SELECT
       DATE_TRUNC(month, availability_date)                                                AS reporting_month
,      has_air_conditioning
,      SUM(price_dollars)                                                                  AS revenue_by_air_conditioning
,      SUM(SUM(price_dollars)) OVER (PARTITION BY reporting_month)                         AS monthly_revenue
,      revenue_by_air_conditioning/monthly_revenue                                         AS percentage_of_monthly_revenue
FROM
       {{ ref('listings_daily_summary') }}
GROUP BY
       1,2
ORDER BY
       1,2

/* 2. Neighborhood Pricing */
WITH neighborhood_price_range AS (
SELECT
       neighborhood_name
,      listing_id
,      FIRST_VALUE(price_dollars) OVER (PARTITION BY listing_id ORDER BY availability_date)AS first_price_in_range
,      LAST_VALUE(price_dollars) OVER (PARTITION BY listing_id ORDER BY availability_date) AS last_price_in_range
FROM
       {{ ref('listings_daily_summary') }}
WHERE
       availability_date BETWEEN '2021-07-12' AND '2022-07-11'
QUALIFY
       ROW_NUMBER() OVER(PARTITION BY neighborhood_name, listing_id ORDER BY(SELECT NULL)) = 1
       )
SELECT
       neighborhood_name
       AVG(last_price_in_range - first_price_in_range)                                     AS average_price_change_for_neighborhood
GROUP BY
       1


/* 3a. Long Stay */
SELECT
       listing_id
, longest_stay_duration
FROM
       {{ ref
('listings_daily_summary') }}
WHERE
       longest_stay_duration_rank = 1
GROUP BY
       1,2
ORDER BY
       2 DESC

/* 3b. Long Stay with lockbox and first aid kits */
SELECT
       listing_id
, longest_stay_duration
FROM
       {{ ref
('listings_daily_summary') }}
WHERE
       has_lockbox
AND
       has_first_aid_kit
GROUP BY
       1,2
ORDER BY
       2 DESC
