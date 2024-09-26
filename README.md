# Rental Property Analytics

This project showcases a dbt-based data transformation pipeline for a rental property management analytics use case. It includes the development of staging and mart models to facilitate insights into revenue, occupancy, and amenity impacts on rental listings. The project applies dbt guidelines and emphasizing clarity and consistency.

## dbt Project: Scalable and Flexible Data Models for Business Impact

This project designs and implements a flexible and scalable data infrastructure capable of answering current and future business questions efficiently. Key business problems to address include maximizing booking occupancy and revenue optimization. The architecture follows a structured transformation flow, incorporating best practices around flexibility, performance, and reporting needs.

### Business Problems Addressed

Key business problems this dbt project is designed to answer include: Revenue Optimization, Occupancy Rate, Listing Performance, and Amenity Impacts. These questions shape the structure of the project to enable answers for critical business questions while maintaining adaptability for future needs.

#### Revenue Optimization

How can we track and maximize revenue over time? What factors have the most impact on revenue such as property characteristics, seasonality, amenities?

#### Occupancy Rate Analysis

What patterns can we observe from occupancy rates across properties, regions, and times? How do changes in property features impact occupancy?

#### Listing Performance

Which property characteristics correlate with higher bookings? Can we forecast performance based on prior booking data and historical trends?

#### Property Amenity Impact

How do specific amenities drive revenue and bookings?

## Modeling Approach

The model design follows dbt’s layered approach to adhere to the principles of modularity and flexibility.

1. Staging
2. Intermediate
3. Mart

### Staging Layer

The staging models clean the raw source data to standardize for downstream models. These are be materialized as simple lightweight views without aggregations, column renaming, and data type casting. Database optimizations remain for downstream models, including partitions defined by cluster keys if using Snowflake.

### Intermediate Layer

Joins to combine data from staging to setup and modularize for downstream aggregations.

#### Flexible Metric Calculation

Metrics like occupancy rate or revenue per property can be calculated in the Intermediate or Mart Layer, but avoiding over-aggregation allows flexibility in downstream analysis tools like Looker. Metrics can be aggregated or sliced by different dimensions in the reporting layer.

### Mart Layer

The final layer serves optimized datasets aligned to reporting and business objectives for end users.

## Assumptions

### Business Assumptions

* Listings in across neighborhoods may follow different booking trends.

### Data Assumptions

* Source data is ingested into the database once a day. Data Freshness of 24 hours.

## Appendix

### Directory Design Tree

```bash
dbt_project/
├── staging/
│   ├── staging_metadata/
│   │   ├── src_listings.yml
│   │   ├── src_calendar.yml
│   │   └── ...
│   ├── staging_sql/
│   │   ├── stg_listings.sql
│   │   ├── stg_calendar.sql
│   │   └── ...
```

```bash
models/
│
├── marts/
│   ├── _.sql
│   ├── _.sql
│   └── marts.yml
│
├── staging/
│   ├── _.sql
│   ├── _.sql
│   └── staging.yml
│
├── intermediate/
│   ├── intermediate.sql
│   └── intermediate.yml
│
└── sources/
    ├── src_listings.yml
    ├── src_calendar.yml
    ├── src_reviews.yml
    └── src_amenities.yml
```
