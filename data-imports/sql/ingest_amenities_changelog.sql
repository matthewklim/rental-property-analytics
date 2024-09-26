CREATE OR REPLACE TRANSIENT TABLE &table_destination (
    LISTING_ID INTEGER NOT NULL COMMENT = 'ID linking to the listing associated with this amenities changelog',
    CHANGE_DATE DATE NOT NULL COMMENT = 'Date when the amenities were changed',
    AMENITIES_ADDED VARCHAR COMMENT = 'List of amenities added, stored as a JSON array',
    AMENITIES_REMOVED VARCHAR COMMENT = 'List of amenities removed, stored as a JSON array'
)
COMMENT = 'Changelog of amenities added or removed for listings, tracking updates over time'
CLUSTER BY (listing_id, change_date);

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