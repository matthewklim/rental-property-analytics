CREATE OR REPLACE TRANSIENT TABLE &table_destination (
    LISTING_ID INTEGER NOT NULL COMMENT = 'Unique ID for the listing to which this row applies.',
    CHANGE_AT DATETIME NOT NULL COMMENT = 'Date and time when the amenities list changed.'
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