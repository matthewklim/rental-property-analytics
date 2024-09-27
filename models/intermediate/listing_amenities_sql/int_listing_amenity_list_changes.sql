{{-
       config(
              tags=['listing_amenities']
       )
-}}

/*
* Amenity Array Comparisons for changes
* Amenities_change_number return only positive additions in the sample data
*/
SELECT
       stg_amenities_changelog.listing_id
,      stg_amenities_changelog.change_at
,      stg_amenities_changelog.amenities_list
,      LAG(amenities_list) OVER (PARTITION BY listing_id ORDER BY change_at) 		AS amenities_list_prior
,      ARRAY_SIZE(stg_amenities_changelog.amenities_list)
              - ARRAY_SIZE(amenities_list_prior)                                           AS amenities_change_number
,      COALESCE(
              ARRAY_EXCEPT(amenities_list, amenities_list_prior)
       ,      stg_amenities_changelog.amenities_list
       )                                                                                   AS amenities_added
,      ARRAY_EXCEPT(amenities_list_prior, amenities_list)                                  AS amenities_removed
FROM
       {{ ref('stg_amenities_changelog') }}
