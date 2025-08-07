{{
  config(
    materialized='table',
    unique_key='"areaId"',
    incremental_strategy='merge',
    tags=['ingest']
  )
}}

WITH base AS (
    SELECT
        a."areaId"
        , a."disName"
    FROM {{ ref('area') }} AS a
)

SELECT * FROM base
