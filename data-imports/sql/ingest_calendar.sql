CREATE OR REPLACE TRANSIENT TABLE &table_destination (
    LISTING_ID INTEGER NOT NULL COMMENT = 'ID linking to the listing',
    CALENDAR_DATE DATE NOT NULL COMMENT = 'The date for which the availability is checked',
    AVAILABLE BOOLEAN NOT NULL COMMENT = 'Whether the listing is available on the given date',
    PRICE_DOLLARS VARCHAR NOT NULL COMMENT = 'Price of the listing in dollars on the given date'
)
COMMENT = 'Calendar of availability and pricing for listings'
CLUSTER BY (calendar_date, listing_id);

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
