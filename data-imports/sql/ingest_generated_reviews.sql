CREATE OR REPLACE TRANSIENT TABLE &table_destination (
    ID INTEGER NOT NULL COMMENT 'Auto-incrementing ID for the dummy reviews data'
    LISTING_ID INTEGER NOT NULL COMMENT 'Unique ID for the listing to which this row applies.',
    REVIEWER_SCORE INTEGER NOT NULL COMMENT 'Generated score of the review, ranging from 1 to 5.',
    REVIEW_DATE DATE NOT NULL COMMENT 'Generated date of the review.'
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
