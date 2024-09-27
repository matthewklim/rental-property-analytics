SELECT
       listing_id                                                                          AS listing_id
,      date                                                                                AS availability_date
,      available = 't'                                                                     AS is_available
,      reservation_id
,      price                                                                               AS price_dollars
,      minimum_nights
,      maximum_nights
,      HASH(listing_id, date)                                                              AS listing_date_key
FROM
       {{ source('rental_app', 'calendar') }}
