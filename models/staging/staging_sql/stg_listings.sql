SELECT
       id                                                                                  AS listing_id
,      name                                                                                AS listing_name
,      host_id
,      host_name
,      host_since
,      host_location
,      PARSE_JSON(host_verifications)                                                      AS host_verifications
,      neighborhood                                                                        AS neighborhood_name
,      property_type
,      room_type
,      accommodates                                                                        AS number_of_accommodates
,      bathrooms_text                                                                      AS bathrooms_text
,      REGEXP_SUBSTR(bathrooms_text, '^\\d\\s([a-zA-Z\\s]+)$', 1,1,'ie')                   AS bathroom_type
,      REGEXP_SUBSTR(bathrooms_text, '^(\\d+)', 1,1,'e')                                   AS number_of_bathrooms
,      bedrooms                                                                            AS number_of_bedrooms
,      beds                                                                                AS number_of_beds
,      PARSE_JSON(amenities)                                                               AS amenities_list
,      TRY_TO_DOUBLE(REGEXP_REPLACE(price, '^\\$','',1,0,'e'))                             AS price_dollars
,      number_of_reviews                                                                   AS number_of_reviews
,      first_review                                                                        AS first_review
,      last_review                                                                         AS last_review
,      review_scores_rating::NUMERIC                                                       AS review_scores_rating
FROM
       {{ source('rental_app', 'listings') }}
