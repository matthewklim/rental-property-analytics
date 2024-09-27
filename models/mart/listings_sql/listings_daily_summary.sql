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
,      int_listing_amenity_availability_overtime."air conditioning"                        AS has_air_conditioning
,      int_listing_amenity_availability_overtime."lockbox"                                 AS has_lockbox
,      int_listing_amenity_availability_overtime."first aid kit"                           AS has_first_aid_kit
FROM
       {{ ref('stg_calendar') }}
JOIN
       {{ ref('stg_listings') }}
ON
       stg_calendar.listing_id = stg_listings.listing_id
LEFT JOIN
       {{ ref('int_listing_amenity_availability_overtime') }}
ON
       stg_calendar.listing_id = int_listing_amenity_availability_overtime.listing_id
AND
       stg_calendar.availability_date = int_listing_amenity_availability_overtime.change_date
