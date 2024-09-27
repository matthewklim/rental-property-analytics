CREATE OR REPLACE TRANSIENT TABLE &table_destination (
    LISTING_ID INTEGER NOT NULL COMMENT 'Unique ID for the listing to which this row applies. Part of the primary key.',
    DATE DATE NOT NULL COMMENT 'ate of availability this row describes. Part of the primary key.',
    AVAILABLE BOOLEAN NOT NULL COMMENT 'Contains 't' if this property is available on this date. Contains 'f' if not.',
    RESERVATION_ID INTEGER NOT NULL COMMENT 'Unique ID for that date's reservation. Foreign key. If NULL, there was no reservation on that date.',
    PRICE VARCHAR NOT NULL COMMENT 'The USD price to rent this property on the specified date.',
    MINIMUM_NIGHTS INTEGER NOT NULL COMMENT 'The minimum number of nights that must be booked consecutively for this property.',
    MAXIMUM_NIGHTS INTEGER NOT NULL COMMENT 'The maximum number of nights that may be booked consecutively for this property.'
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
