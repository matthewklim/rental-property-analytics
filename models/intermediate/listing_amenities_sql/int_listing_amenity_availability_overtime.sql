SELECT
       listing_id
,      change_at::DATE                                                                     AS valid_from_date
,      LEAD(valid_from_date) OVER (PARTITION BY listing_id ORDER BY change_at)             AS valid_to_date
    {{ expand_amenities_to_boolean_columns('stg_amenities_changelog', 'amenities_list') }}
FROM
    {{ ref('stg_amenities_changelog') }}
