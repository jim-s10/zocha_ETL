{{
  config(
    materialized='view',
    tags=['mart']
  )
}}

WITH base AS (
    SELECT
        CAST(ioa."clientOrderId" AS VARCHAR(45)) AS clientOrderId,
        CAST(ioa."isPbgnProd" AS VARCHAR(2)) AS isPbgnProd, -- 車種類型
        CAST(ioa.prod_cat_name AS VARCHAR(20)) AS prodCatName, -- 租用車款
        CAST(ioa.renting_period AS INTERVAL) AS rentingPeriod, -- 實際租借時長
        CAST(ioa.renting_type AS VARCHAR(20)) AS rentingType, -- 租借方案(短租/長租)
        CAST(ioa.store_type AS VARCHAR(20)) AS storeType, -- 店家類型(無人/門市)
        CAST(ioa.expect_renting_time AS VARCHAR(14)) AS expectRentingTime, -- 租車的時段
        CAST(ioa.promotion_code_name AS VARCHAR(20)) AS promotionCodeName, -- 優惠券名稱
        CAST(ioa.area_name AS VARCHAR(255)) AS areaName, -- 區域
        CAST(ioa.store_name AS VARCHAR(45)) AS storeName -- 站點
    FROM {{ ref('int_order_attributes') }} AS ioa
    WHERE
        ioa.is_auto_canceled = 0  -- 自動取消單
        AND ioa.is_canceled = 0 -- 已取消訂單
        AND ioa.is_applied_cancel = 0 -- 申請取消訂單
)

SELECT * FROM base
