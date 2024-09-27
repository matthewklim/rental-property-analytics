{{-
       config(
              tags=['listing_amenities']
       )
-}}

SELECT
       listing_id
,      listing_amenity
,      change_at
,      CASE
              WHEN
                            next_change IS NULL
                     OR --ARRAYS_OVERLAP checks if the amenity still exists in the next set of amenities
                            ARRAYS_OVERLAP(ARRAY_CONSTRUCT(listing_amenity), next_amenities)
              THEN -- no new row needed
                     NULL
              ELSE
                     next_change
       END                                                                                 AS valid_to -- valid_to is NULL if the amenity is still valid in the next change
FROM
       {{ ref('int_listing_amenity_changes') }}
