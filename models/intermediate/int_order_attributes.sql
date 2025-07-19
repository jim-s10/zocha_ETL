{{
  config(
    materialized='incremental',
    unique_key='"clientOrderId"',
    incremental_strategy='delete+insert',
    tags=['intermediate']
  )
}}

-- creating master data of order
WITH auto_cancel_order AS (
    SELECT
        co."clientOrderId",
        1 AS is_auto_canceled
    FROM {{ ref('ig_client_order') }} AS co
    LEFT JOIN {{ ref('ig_client_order_history') }} AS coh
        ON co."clientOrderId" = coh."clientOrderId"
    WHERE co.flow = '1200'AND coh.flow IN ('10', '50')
    GROUP BY 1
    HAVING COUNT(*) > 1
)

base AS (
    SELECT
        co."clientOrderId",
        co."clientUserId",
        co."createDate",--訂單預約時間
        co."updateDate",
        pc."isPbgnProd", --車種類型
        pc.prod_cat_name, --租用車款
        co.price, --實際租借時長
        co."sDate" AS renting_start_date, --訂單金額
        s.area_name, --租借方案
        s.store_name,--店家類型
        coq."usePurpose" AS use_purpose, --租車的時段
        cot."moneyType" AS payment_method, --區域
        co."sDate" AS expect_renting_time, --站點
        (co."realEndDate" - co."realEndDate") AS renting_period, --預約原因
        CASE
            WHEN co."rentDateType" = '1' THEN '長租'
            ELSE '短租'
        END AS renting_type,--付款方式
        CASE
            WHEN s."isNoStaffStore" = 'F' THEN '無人'
            ELSE '門市'
        END AS store_type, --租車的時段
        COALESCE(p."disName", '') AS promotion_code_name, --優惠券名稱
        CASE
            WHEN cocf."clientOrderId" IS NOT NULL THEN 1 ELSE 0
        END AS is_applied_cancel, --是(1)/否(0) 為申請取消
        CASE WHEN aco."is_auto_canceled" = 1 THEN 1 ELSE 0 END AS is_auto_canceled, --是(1)/否(0) 為自動取消單
        CASE
            WHEN co.flow IN ('1100', '1000') THEN 1
            ELSE 0
        END AS is_canceled, --是(1)/否(0) 為已訂單取消
        CASE
            WHEN co."promotionCode" IS NOT NULL THEN 1
            ELSE 0
        END AS promotion_code_usage_cnt,--是(1)/否(0) 使用優惠券
        COALESCE(cod."accessoriesRaincoat", 0) AS "accessoriesRaincoat" --加購雨衣次數
    FROM {{ ref('ig_client_order') }} AS co
    LEFT JOIN
        {{ ref('stg_prod_cat') }} AS pc
        ON
            co."clientOrderId" = pc."clientOrderId"
    LEFT JOIN
        auto_cancel_order AS aco
        ON co."clientOrderId" = aco."clientOrderId"
    LEFT JOIN {{ ref('stg_store_area') }} AS s ON co."storeId" = s."storeId"
    LEFT JOIN
        {{ ref('ig_client_order_questionnaire') }} AS coq
        ON
            co."clientOrderId" = coq."clientOrderId"
    LEFT JOIN
        {{ ref('ig_client_order_trans') }} AS cot --TODO: 有多重歷史，需要確認
        ON
            co."clientOrderId" = cot."clientOrderId"
    LEFT JOIN {{ ref('ig_promotion') }} AS p ON co."promotionCode" = p.code
    LEFT JOIN
        {{ ref('ig_client_order_detail') }} AS cod
        ON
            co."clientOrderId" = cod."parentDocId"
    LEFT JOIN
        {{ ref('ig_client_order_apply_cancel_form') }} AS cocf
        ON
            co."clientOrderId" = cocf."clientOrderId"

)

SELECT * FROM base
{% if is_incremental() %}
    WHERE "updateDate" > (SELECT MAX("updateDate") FROM {{ this }})
{% endif %}
