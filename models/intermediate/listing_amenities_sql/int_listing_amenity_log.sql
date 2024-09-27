{%- set table_start_date = '2008-12-03' -%}
{#- earliest date available in the sample data is December 3, 2008 -#}
-- Flatten the JSON array to extract individual amenities per listing
SELECT
       stg_amenities_changelog.listing_id
,      stg_amenities_changelog.change_at
,      stg_amenities_changelog.amenities_list
,      amenities_flattened.value::VARCHAR                                                  AS listing_amenity
FROM
       {{ ref('stg_amenities_changelog') }},
LATERAL FLATTEN(input => amenities_list) AS amenities_flattened
WHERE
       stg_amenities_changelog.change_at >= '{{ table_start_date }}'
