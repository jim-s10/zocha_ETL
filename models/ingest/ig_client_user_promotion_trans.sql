{{
  config(
    materialized='incremental',
    unique_key='"rowId"',
    incremental_strategy='merge',
    tags=['ingest']
  )
}}

-- Ingesting layer for client_user_promotion_trans
-- Fixing typo: cleintOrderId -> clientOrderId and ensuring varchar(45)
WITH base AS (
    SELECT
        cupt."rowId"
        , cupt."clientUserId"
        , cupt."promotionRowId"
        , cupt.used
        , cupt."getDate"
        , cupt."usedDate"
        , cupt."updateDate"
        , cupt.updator
        , cupt."endDate"
        , cupt.phone
        , CAST(cupt."cleintOrderId" AS VARCHAR(45)) AS "clientOrderId"
    FROM {{ ref('client_user_promotion_trans') }} AS cupt
)

SELECT * FROM base
{% if is_incremental() %}
    WHERE "updateDate" > (SELECT MAX("updateDate") FROM {{ this }})
{% endif %}
