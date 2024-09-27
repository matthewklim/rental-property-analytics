{{-
       config(
              tags=['listing_amenities']
       )
-}}

-- LEAD to get the next set of amenities for comparison
SELECT
       listing_id
,      listing_amenity
,      change_at
,      LEAD(change_at) OVER (PARTITION BY listing_id ORDER BY change_at) AS next_change
,      LEAD(amenities_list) OVER (PARTITION BY listing_id ORDER BY change_at) AS next_amenities
FROM
       {{ ref('int_listing_amenity_log') }}
