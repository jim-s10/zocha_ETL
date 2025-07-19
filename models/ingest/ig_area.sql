{{
  config(
    materialized='table',
    unique_key='"areaId"',
    incremental_strategy='delete+insert',
    tags=['ingest']
  )
}}

WITH base AS (
    SELECT
        a."areaId",
        a."disName"
    FROM {{ ref('area') }} AS a
)

SELECT * FROM base
