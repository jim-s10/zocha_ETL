{{
  config(
    materialized='incremental',
    unique_key=['order_number'],
    incremental_strategy='merge',
    tags=['mart']
  )
}}

WITH base AS (
    SELECT
        CAST(ioa."clientOrderId" AS VARCHAR(45)) AS order_number
        , CAST(ioa."clientUserId" AS VARCHAR(20)) AS member_id
        , CAST(ioa.partition AS SMALLINT) AS "partition"
        , CAST(ioa."isPbgnProd" AS BOOLEAN) AS is_pbgn_prod -- 車種類型
        , CAST(ioa.prod_cat_name AS VARCHAR(20)) AS prod_cat_name -- 租用車款
        , CAST(ioa.renting_period AS INTERVAL) AS renting_period -- 實際租借時長
        , CAST(ioa.renting_type AS SMALLINT) AS renting_type -- 租借方案(短租/長租)
        , CAST(ioa.store_type AS BOOLEAN) AS store_type -- 店家類型(無人/門市)
        , CAST(ioa.promotion_code_name AS VARCHAR(20)) AS promotion_code_name -- 優惠券名稱
        , CAST(ioa.area_name AS VARCHAR(255)) AS area_name -- 區域
        , CAST(ioa.store_name AS VARCHAR(45)) AS store_name -- 站點
        , CAST(ioa."usePurpose" AS VARCHAR(1)) AS reason_to_use -- 使用目的
        , CAST(ioa."sDate" AS TIMESTAMP) AS renting_start_date -- 租車開始時間
        , CAST(ioa."eDate" AS TIMESTAMP) AS renting_end_date -- 租車結束時間

    FROM {{ ref('int_order_attributes') }} AS ioa
    WHERE
        ioa.is_auto_canceled = 0  -- 自動取消單
        AND ioa.is_canceled = 0 -- 已取消訂單
        AND ioa.is_applied_cancel = 0 -- 申請取消訂單
)

SELECT * FROM base
