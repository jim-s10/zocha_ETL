{{
  config(
    materialized='view',
    tags=['mart']
  )
}}



SELECT
    CAST(scot."clientOrderId" AS VARCHAR(45)) AS clientOrderId,
    CAST(ioa."clientUserId" AS VARCHAR(20)) AS clientUserId,
    CAST(scot."disName" AS VARCHAR(45)) AS displayName,
    CAST(scot."moneyType" AS VARCHAR(10)) AS moneyType,
    CAST(scot."updateDate" AS VARCHAR(14)) AS updateDate
FROM {{ ref('stg_client_order_trans') }}  AS scot
    LEFT JOIN {{ ref('int_order_attributes') }} AS ioa
        ON scot."clientOrderId" = ioa."clientOrderId"
WHERE ioa.is_auto_canceled = 0 AND ioa.is_canceled = 0 AND ioa.is_applied_cancel = 0
