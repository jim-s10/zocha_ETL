{{
  config(
    materialized='incremental',
    unique_key='"rowId"',
    incremental_strategy='delete+insert',
    tags=['ingest']
  )
}}
WITH base AS (
    SELECT
        cod."rowId",
        cod."parentDocId",
        cod."prodId",
        cod.price,
        cod.qty,
        cod."catId",
        cod."plusInsurance",
        cod."carNo",
        cod."prodPriceRowId",
        cod."prodStockRowId",
        cod."insurancePrice",
        cod."accessoriesHelmet",
        cod."accessoriesRaincoat",
        cod."accessoriesHelmetFull",
        cod."fromVoltage",
        cod."toVoltage",
        cod."fromSoc",
        cod."toSoc"
    FROM {{ ref('client_order_detail') }} AS cod
)

SELECT * FROM base
{% if is_incremental() %}
    WHERE "rowId" > (SELECT MAX("rowId") FROM {{ this }})
{% endif %}
