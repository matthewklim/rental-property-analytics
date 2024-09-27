
{% snapshot listings_snapshot %}

{{-
    config
(
      unique_key='listing_id',
      strategy='check',
      check_cols = 'all',
      target_schema = 'snapshots',
      invalidate_hard_deletes = True
    )
-}}

SELECT
  listing_id
, listing_name
, host_id
, host_name
, host_since
, host_location
, host_verifications
, neighborhood_name
, property_type
, room_type
, number_of_accommodates
, bathrooms_text
, bathroom_type
, number_of_bathrooms
, number_of_bedrooms
, number_of_beds
, amenities_list
, price_dollars
, number_of_reviews
, first_review
, last_review
, review_scores_rating
FROM
  {{ ref
('stg_listings') }}
{% endsnapshot %}
