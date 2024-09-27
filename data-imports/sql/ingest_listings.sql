CREATE OR REPLACE TRANSIENT TABLE &table_destination (
    ID INTEGER NOT NULL COMMENT 'Unique ID for this listing. Primary key',
    NAME VARCHAR COMMENT 'Display name of the listing',
    HOST_ID INTEGER NOT NULL COMMENT 'Unique ID for the host who owns this property',
    HOST_NAME VARCHAR COMMENT 'Display name of the host',
    HOST_SINCE DATE COMMENT 'Date when the host signed up on the platform',
    HOST_LOCATION VARCHAR COMMENT 'Location where the host is based',
    HOST_VERIFICATIONS VARCHAR COMMENT 'Array of verification methods the host can use (JSON)',
    NEIGHBORHOOD VARCHAR COMMENT 'Neighborhood where this listing is located',
    PROPERTY_TYPE VARCHAR COMMENT 'Description of the type of property',
    ROOM_TYPE VARCHAR COMMENT 'Description of the type of room available',
    ACCOMMODATES INTEGER COMMENT 'Number of guests this listing can accommodate',
    BATHROOMS_TEXT VARCHAR COMMENT 'Text description of the bathrooms available (number and types)',
    BEDROOMS VARCHAR COMMENT 'Number of bedrooms available for use',
    BEDS INTEGER COMMENT 'Number of beds available for use',
    AMENITIES VARCHAR COMMENT 'List of amenities available for guests (JSON array)',
    PRICE VARCHAR COMMENT 'Price of this listing as of the start of the date range in the calendar',
    NUMBER_OF_REVIEWS INTEGER COMMENT 'Total number of reviews this listing has ever received',
    FIRST_REVIEW DATE COMMENT 'Date when the first review was received for this listing',
    LAST_REVIEW DATE COMMENT 'Date when the most recent review was received',
    REVIEW_SCORES_RATING VARCHAR COMMENT 'Average review score of this listing'
)
COMMENT = 'Detailed information for each listing, including host data, amenities, and review scores'
CLUSTER BY (HOST_ID);


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
