CREATE OR REPLACE TRANSIENT TABLE generated_reviews (
    LISTING_ID INTEGER NOT NULL COMMENT = 'ID linking to the listing being reviewed',
    REVIEW_ID INTEGER NOT NULL COMMENT = 'Unique ID for the review',
    DATE_REVIEWED DATE NOT NULL COMMENT = 'Date when the review was posted',
    REVIEWER_ID INTEGER NOT NULL COMMENT = 'ID of the reviewer',
    REVIEWER_NAME VARCHAR NOT NULL COMMENT = 'Name of the reviewer',
    COMMENTS TEXT COMMENT = 'Text content of the review left by the reviewer'
)
COMMENT = 'Reviews generated for listings, including reviewer details and comments'
CLUSTER BY (date_reviewed);

PUT &data_file_path &stage_destination
parallel = 4
auto_compress = TRUE
overwrite = TRUE;

COPY INTO &table_destination
FROM &stage_destination
file_format = (
    type = 'CSV'
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    field_delimiter = ','
    skip_header = 1
    ESCAPE = '\\'
    trim_space = TRUE
    empty_field_as_null = TRUE
);
