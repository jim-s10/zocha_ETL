{{
  config(
    materialized='incremental',
    unique_key='"rowId"',
    incremental_strategy='merge',
    tags=['ingest']
  )
}}

WITH base AS (
    SELECT
        cot."rowId"
        , cot.amt
        , cot.qty
        , cot.type
        , cot."disName"
        , cot.response
        , cot."updateDate"
        , cot.updator
        , cot."returnUrl"
        , cot."moneyType"
        , cot."payId"
        , cot."merchantOrderNo"
        , cot.status
        , cot."moneyAccount"
        , cot."moneyTypeExtend"
        , cot."icpRequestData"
        , CAST(cot."clientOrderId" AS VARCHAR(45)) AS "clientOrderId"
    FROM {{ ref('client_order_trans') }} AS cot
)

SELECT * FROM base
{% if is_incremental() %}
    WHERE "updateDate" > (SELECT MAX("updateDate") FROM {{ this }})
{% endif %}
