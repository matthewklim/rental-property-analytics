SELECT
       id                                                                                  AS review_id
,      listing_id                                                                          AS listing_id
,      review_score                                                                        AS review_score
,      review_date                                                                         AS review_date
FROM
       {{ source('rental_app', 'generated_reviews') }}
WHERE
       NOT review_id IS NULL
