{{
  config(
    materialized='incremental',
    unique_key='"storeId"',
    incremental_strategy='delete+insert',
    tags=['staging']
  )
}}

WITH base AS (
    SELECT
        s."storeId",
        s."areaId",
        s."isNoStaffStore",
        s."disName" AS store_name,
        a."disName" AS area_name,
        s."updateDate"
    FROM {{ ref('ig_store') }} AS s
    INNER JOIN {{ ref('ig_area') }} AS a ON s."areaId" = a."areaId"
)

SELECT * FROM base
{% if is_incremental() %}
    WHERE "updateDate" > (SELECT MAX("updateDate") FROM {{ this }})
{% endif %}
