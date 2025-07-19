{{
  config(
    materialized='incremental',
    unique_key='"prodCatId"',
    incremental_strategy='delete+insert',
    tags=['ingest']
  )
}}

WITH base AS (
    SELECT
        "prodCatId",
        "disName",
        updator,
        "updateDate",
        descp,
        -- "pic",
        status,
        "rentDateType",
        "isEcoProd",
        "isPbgnProd"
    FROM {{ ref('prod_cat') }}
)

SELECT * FROM base
{% if is_incremental() %}
    WHERE "updateDate" > (SELECT MAX("updateDate") FROM {{ this }})
{% endif %}
