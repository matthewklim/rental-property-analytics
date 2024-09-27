WITH available_periods AS (
SELECT
       listing_id
,      availability_date
,      is_available
,      minimum_nights
,      maximum_nights
,      LAG(availability_date) OVER (PARTITION BY listing_id ORDER BY availability_date)    AS previous_date
,      CASE
              WHEN
                            previous_date = DATEADD(day, -1, availability_date)
                     AND
                            is_available THEN 0
              ELSE
                     1
       END                                                                                 AS gap_identifier
FROM
       {{ ref('stg_calendar') }}
WHERE
       is_available
),
partitioned_periods AS (
SELECT
       listing_id
,      availability_date
,      maximum_nights
,      SUM(gap_identifier) OVER (
                            PARTITION BY
                                   listing_id
                            ORDER BY
                                   availability_date ROWS UNBOUNDED PRECEDING
                            )                                                              AS period_group
FROM
       available_periods
),
consecutive_stays AS (
SELECT
       listing_id
,      period_group
,      ANY_VALUE(maximum_nights)                                                           AS maximum_nights
,      MIN(availability_date)                                                              AS stay_start_date
,      MAX(availability_date)                                                              AS stay_end_date
,      COUNT(availability_date)                                                            AS stay_duration_bookable
,      ROW_NUMBER() OVER (
                     PARTITION BY
                            listing_id
                     ORDER BY
                            stay_duration_bookable DESC
                     )                                                                     AS bookable_duration_rank
FROM
       partitioned_periods
GROUP BY
       1,2
)
SELECT
       listing_id
,      COUNT(period_group)                                                                 AS available_period_count
,      MAX(stay_duration_bookable)                                                         AS stay_duration_bookable_max
,      ANY_VALUE(maximum_nights)                                                           AS maximum_nights
,      MIN(CASE WHEN bookable_duration_rank = 1 THEN stay_start_date END)                  AS long_stay_earliest_date
,      MAX(CASE WHEN bookable_duration_rank = 1 THEN stay_end_date END)                    AS long_stay_latest_date
,      LEAST(stay_duration_bookable_max, ANY_VALUE(maximum_nights))                        AS longest_stay_duration
FROM
       consecutive_stays
GROUP BY
       listing_id

