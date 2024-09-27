SELECT
       listing_id                                                                          AS listing_id
,      change_at                                                                           AS change_at
,      PARSE_JSON(amenities)                                                               AS amenities_list
,      HASH(listing_id, change_at)                                                         AS amenities_change_key
FROM
       {{ source('rental_app', 'amenities_changelog') }}
