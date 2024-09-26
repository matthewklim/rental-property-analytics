SELECT
       id                                                                                  AS listing_id
,      name                                                                                AS listing_name
,      host_id                                                                             AS host_id
,      host_name                                                                           AS host_name
,      host_since                                                                          AS host_since
,      host_location                                                                       AS host_location
,      host_verifications::ARRAY                                                           AS host_verifications
,      neighborhood                                                                        AS neighborhood_name
,      property_type                                                                       AS property_type
,      room_type                                                                           AS room_type
,      accommodates                                                                        AS number_of_accommodates
,      bathrooms_text                                                                      AS bathrooms_text
,      bedrooms                                                                            AS number_of_bedrooms
,      beds                                                                                AS number_of_beds
,      amenities::ARRAY                                                                    AS amenities_list
,      price::NUMERIC                                                                      AS price_dollars
,      number_of_reviews                                                                   AS number_of_reviews
,      first_review                                                                        AS first_review
,      last_review                                                                         AS last_review
,      review_scores_rating::NUMERIC                                                       AS review_scores_rating
FROM
       {{ source('rental_app', 'listings') }}
