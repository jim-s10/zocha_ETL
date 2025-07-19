{{
  config(
    materialized='view',
    tags=['mart']
  )
}}

WITH base AS (
    SELECT
        soa."clientOrderId",
        soa."clientUserId",
        soa."createDate", --訂單預約時間
        soa."isPbgnProd", --車種類型
        soa.prod_cat_name,--租用車款
        soa.renting_period,--實際租借時長
        soa.price,--單次訂單金額
        soa.renting_type,--租借方案(短租/長租)
        soa.store_type, --店家類型(無人/門市)
        soa.expect_renting_time, --租車的時段
        soa.promotion_code_name, --優惠券名稱
        soa.area_name,--區域
        soa.store_name,--站點
        soa.use_purpose, --預約原因
        soa.payment_method --付款方式
    FROM {{ ref('int_order_attributes') }} AS soa
    WHERE
        soa.is_auto_canceled = 0  -- 自動取消單
        AND soa.is_canceled = 0 -- 已取消訂單
        AND soa.is_applied_cancel = 0 -- 申請取消訂單
)

SELECT * FROM base
