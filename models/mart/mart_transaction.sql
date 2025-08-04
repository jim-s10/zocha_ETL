{{
  config(
    materialized='view',
    unique_key='surrogate_key',
    tags=['mart']
  )
}}

SELECT
    CAST(CAST(scot."clientOrderId" AS VARCHAR(45)) || '-' || CAST(scot."type" AS VARCHAR(45)) AS VARCHAR(91)) AS surrogate_key,
    CAST(scot."clientOrderId" AS VARCHAR(45)) AS clientOrderId,
    CAST(ioa."clientUserId" AS VARCHAR(20)) AS clientUserId,
    CAST(scot."type" AS VARCHAR(10)) AS displayName, -- 付款時間點
    CAST(scot."moneyType" AS VARCHAR(10)) AS moneyType -- 付款方式
FROM {{ ref('stg_client_order_trans') }} AS scot
    LEFT JOIN {{ ref('int_order_attributes') }} AS ioa
        ON scot."clientOrderId" = ioa."clientOrderId"
WHERE
    ioa.is_auto_canceled = 0
    AND ioa.is_canceled = 0
    AND ioa.is_applied_cancel = 0
