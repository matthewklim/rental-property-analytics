SELECT
       stg_calendar.availability_date
,      stg_calendar.listing_id
,      stg_calendar.is_available
,      stg_calendar.reservation_id
,      stg_calendar.price_dollars
,      stg_calendar.minimum_nights
,      stg_calendar.maximum_nights
,      stg_calendar.listing_date_key
,      stg_listings.neighborhood_name
,      int_consecutive_stays.longest_stay_duration
,      int_listing_amenity_availability_overtime."air conditioning"                        AS has_air_conditioning
,      int_listing_amenity_availability_overtime."lockbox"                                 AS has_lockbox
,      int_listing_amenity_availability_overtime."first aid kit"                           AS has_first_aid_kit
,      DENSE_RANK() OVER (ORDER BY longest_stay_duration DESC NULLS LAST)                  AS longest_stay_duration_rank
FROM
       {{ ref('stg_calendar') }}
JOIN
       {{ ref('stg_listings') }}
ON
       stg_calendar.listing_id = stg_listings.listing_id
LEFT JOIN
       {{ ref('int_consecutive_stays') }}
ON
       stg_calendar.listing_id = int_consecutive_stays.listing_id
LEFT JOIN
       {{ ref('int_listing_amenity_availability_overtime') }}
ON
       stg_calendar.listing_id = int_listing_amenity_availability_overtime.listing_id
AND
       stg_calendar.availability_date BETWEEN int_listing_amenity_availability_overtime.valid_from_date AND COALESCE(int_listing_amenity_availability_overtime.valid_to_date, CURRENT_TIMESTAMP())
