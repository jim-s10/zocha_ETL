{{
  config(
    materialized='incremental',
    unique_key=['order_number'],
    incremental_strategy='merge',
    tags=['mart'],
  )
}}

WITH base AS (
    SELECT
        CAST(ioa."clientOrderId" AS VARCHAR(45)) AS order_number
        , CAST(ioa."clientUserId" AS VARCHAR(20)) AS member
        , CAST(ioa."partition" AS INTEGER) AS "partition"
        , CAST(ioa."createDate"::DATE AS DATE) AS purchase_date -- 訂單預約時間
        , CAST(ioa.price AS INTEGER) AS total_amount -- 單次訂單金額
        , CAST(ioa."updateDate" AS TIMESTAMP) AS updated_at -- 訂單更新時間
    FROM {{ ref('int_order_attributes') }} AS ioa
    WHERE
        ioa.is_auto_canceled = 0  -- 自動取消單
        AND ioa.is_canceled = 0 -- 已取消訂單
        AND ioa.is_applied_cancel = 0 -- 申請取消訂單
)

SELECT * FROM base
{% if is_incremental() %}
    WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}
