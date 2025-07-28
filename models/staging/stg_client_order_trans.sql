{{
  config(
    materialized='incremental',
    unique_key=['"clientOrderId"', '"disName"'],
    incremental_strategy='delete+insert',
    tags=['staging']
  )
}}


WITH base AS (
    SELECT
        "rowId",
        "clientOrderId",
        "disName",
        "moneyType",
        "updateDate"
    FROM
        {{ ref('ig_client_order_trans') }}
    WHERE status = 'SUCCESS'
), final AS (
    SELECT
        base.*,
        ROW_NUMBER() OVER( PARTITION BY ("clientOrderId","disName") ORDER BY "rowId" DESC) AS rn
    FROM base
)


SELECT
    "clientOrderId",
    "disName",
    "moneyType",
    "updateDate"
FROM
    final
WHERE rn = 1
{% if is_incremental() %}
AND
    "updateDate" > (SELECT MAX("updateDate") FROM {{ this }} )
{% endif %}
