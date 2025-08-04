{{
  config(
    materialized='view',
    tags=['mart']
  )
}}

WITH base AS (
    SELECT
        CAST(ioa."clientOrderId" AS VARCHAR(45)) AS clientOrderId,
        CAST(ioa."clientUserId" AS VARCHAR(20)) AS clientUserId,
        CAST(ioa."createDate" AS VARCHAR(14)) AS createDate, -- 訂單預約時間
        CAST(ioa.price AS INTEGER) AS price -- 單次訂單金額
    FROM {{ ref('int_order_attributes') }} AS ioa
    WHERE
        ioa.is_auto_canceled = 0  -- 自動取消單
        AND ioa.is_canceled = 0 -- 已取消訂單
        AND ioa.is_applied_cancel = 0 -- 申請取消訂單
)

SELECT * FROM base
