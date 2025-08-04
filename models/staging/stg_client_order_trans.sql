{{
  config(
    materialized='incremental',
    unique_key=['"clientOrderId"', '"type"'],
    incremental_strategy='merge',
    tags=['staging']
  )
}}


WITH base AS (
    SELECT
        "clientOrderId",
        "type",
        "moneyType",
        "updateDate"
    FROM
        {{ ref('ig_client_order_trans') }}
    WHERE status = 'SUCCESS'
), final AS ( -- 這邊的用意是因為他們會記錄failed log以防萬一抓這張單這個type最新更新時間當作最新狀況
    SELECT
        base.*,
        ROW_NUMBER() OVER(PARTITION BY ("clientOrderId", "type") ORDER BY "updateDate" DESC) AS rn
    FROM base
)


SELECT
    "clientOrderId",
    "type",
    "moneyType"
FROM
    final
WHERE rn = 1
{% if is_incremental() %}
AND
    "updateDate" > (SELECT MAX("updateDate") FROM {{ this }} )
{% endif %}
