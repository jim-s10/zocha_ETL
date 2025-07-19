{{
  config(
    materialized='incremental',
    unique_key = '"prodId"',
    incremental_strategy='delete+insert',
    tags=['staging']
  )
}}
WITH base AS (
    SELECT
        p."prodId",
        p."clientOrderId",
        p."prodCatId",
        pc."disName" AS prod_cat_name, --租用車款
        pc."isPbgnProd", -- 車種類型
        p."updateDate"
    FROM {{ ref('ig_prod') }} AS p
    INNER JOIN
        {{ ref('ig_prod_cat') }} AS pc
        ON p."prodCatId"::text = pc."prodCatId"::text
    WHERE p."clientOrderId" IS NOT NULL
)

SELECT * FROM base
{% if is_incremental() %}
    WHERE "updateDate" > (SELECT MAX("updateDate") FROM {{ this }})
{% endif %}
