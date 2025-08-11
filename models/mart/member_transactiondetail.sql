{{
  config(
    materialized='incremental',
    unique_key='surrogate_key',
    incremental_strategy='merge',
    tags=['mart']
  )
}}

WITH base AS (
    SELECT
    CAST(CAST(scot."clientOrderId" AS VARCHAR(45)) || '-' || CAST(scot."type" AS VARCHAR(45)) AS VARCHAR(91)) AS surrogate_key
    , CAST(scot."clientOrderId" AS VARCHAR(45)) AS "order"
    , CAST(ioa."clientUserId" AS VARCHAR(20)) AS member_id
    , CAST(ioa."partition" AS INTEGER) AS "partition"
    , CAST(scot."type" AS VARCHAR(10)) AS transaction_stage -- 付款時間點
    , CAST(scot."moneyType" AS VARCHAR(10)) AS transaction_type -- 付款方式
    , CAST(scot."updateDate" AS TIMESTAMP) AS updated_at -- 訂單更新時間
FROM {{ ref('stg_client_order_trans') }} AS scot
    LEFT JOIN {{ ref('int_order_attributes') }} AS ioa
        ON scot."clientOrderId" = ioa."clientOrderId"
WHERE
    ioa.is_auto_canceled = 0
    AND ioa.is_canceled = 0
    AND ioa.is_applied_cancel = 0
)

SELECT * FROM base
{% if is_incremental() %}
    WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}
