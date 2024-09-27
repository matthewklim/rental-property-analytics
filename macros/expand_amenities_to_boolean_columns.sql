{% macro expand_amenities_to_boolean_columns(table, column) %}
    -- Query to extract unique amenities from the amenities column
    {% set amenities_query %}

       SELECT
              value::VARCHAR AS amenity
       FROM (
       SELECT
           ARRAY_DISTINCT(ARRAY_FLATTEN(ARRAY_AGG(amenities_list))) AS unique_amenities
       FROM
              {{ table }}
       )
       ,LATERAL FLATTEN (INPUT => unique_amenities)

    {% endset %}

    {% set results = run_query(amenities_query) %}

    -- Extract unique amenities list
    {% if execute %}
        {% set unique_amenities = results %}
    {% else %}
        {% set unique_amenities = [] %}
    {% endif %}

    -- Dynamically generate the SELECT statement with Boolean columns
    {% set boolean_columns %}
        {% for amenity in unique_amenities %}
            ,CASE
                     WHEN ARRAY_CONTAINS('{{ amenity[0] }}'::VARIANT, {{ column }}) THEN TRUE
                     ELSE FALSE
            END AS "{{ amenity[0] | lower }}"
    {# consider other ways to cleanup special characters upstream for examples like pack n play #}
        {% endfor %}
    {% endset %}

    -- Return the final result with all Boolean columns
    {{ return(boolean_columns) }}
{% endmacro %}
