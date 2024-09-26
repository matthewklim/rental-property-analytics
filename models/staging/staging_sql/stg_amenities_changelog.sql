SELECT
       listing_id                                                                          AS listing_id
,      change_at                                                                           AS change_at
,      HASH(listing_id, change_at)                                                         AS amenities_change_key
FROM
       {{ source('rental_app', 'amenities_changelog') }}
