SELECT
       listing_id
,      change_at::DATE                                                                     AS change_date
    {{ expand_amenities_to_boolean_columns('stg_amenities_changelog', 'amenities_list') }}
FROM
    {{ ref('stg_amenities_changelog') }}
