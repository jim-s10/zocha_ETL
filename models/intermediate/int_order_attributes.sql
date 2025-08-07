{{
  config(
    materialized='incremental',
    unique_key='"clientOrderId"',
    incremental_strategy='merge',
    tags=['intermediate']
  )
}}

-- creating master data of order
WITH auto_cancel_order AS (
    SELECT
        co."clientOrderId"
        , 1 AS is_auto_canceled
    FROM {{ ref('ig_client_order') }} AS co
    LEFT JOIN {{ ref('ig_client_order_history') }} AS coh
        ON co."clientOrderId" = coh."clientOrderId"
    WHERE co.flow = '1200'AND coh.flow IN ('10', '50')
    GROUP BY 1
    HAVING COUNT(*) > 1
),

base AS (
    SELECT
        co."clientOrderId"
        , co."clientUserId"
        , scu.partition
        , co."createDate"
        , co."updateDate"
        , (CASE WHEN pc."isPbgnProd" = 'T' THEN true ELSE false END) AS "isPbgnProd" -- 車種類型
        , pc.prod_cat_name -- 租用車款
        , co.price -- 訂單總金額
        , co."sDate" -- 租車開始時間
        , s.area_name -- 租車地區
        , s.store_name -- 租車門市
        , coq."usePurpose" -- 租車用途
        , co."eDate" -- 租車結束時間
        , (co."realEndDate" - co."realStartDate") AS renting_period -- 實際租借時長
        , CASE
            WHEN co."rentDateType" = '1' THEN 1 -- 短租
            WHEN co."rentDateType" = '2' THEN 2 -- 長租/環島
            ELSE 0 --測試資料看到有NULL以防萬一
        END AS renting_type -- 租借方案(短租/長租)
        , CASE
            WHEN s."isNoStaffStore" = 'F' THEN true
            ELSE false
        END AS store_type -- 店家類型(無人/門市)
        , COALESCE(p."disName", '') AS promotion_code_name
        , CASE
            WHEN cocf."clientOrderId" IS NOT NULL THEN 1 ELSE 0
        END AS is_applied_cancel
        , CASE WHEN aco."is_auto_canceled" = 1 THEN 1 ELSE 0 END AS is_auto_canceled -- 自動取消訂單
        , CASE
            WHEN co.flow IN ('1100', '1000') THEN 1
            ELSE 0
        END AS is_canceled
        , CASE
            WHEN co."promotionCode" IS NOT NULL THEN 1
            ELSE 0
        END AS promotion_code_usage_cnt -- 優惠券使用次數
        , COALESCE(cod."accessoriesRaincoat", 0) AS "accessoriesRaincoat" -- 雨衣加購次數
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
    LEFT JOIN {{ ref('ig_promotion') }} AS p ON co."promotionCode" = p.code
    LEFT JOIN
        {{ ref('ig_client_order_detail') }} AS cod
        ON
            co."clientOrderId" = cod."parentDocId"
    LEFT JOIN
        {{ ref('ig_client_order_apply_cancel_form') }} AS cocf
        ON
            co."clientOrderId" = cocf."clientOrderId"
    JOIN {{ ref('stg_client_user') }} AS scu ON co."clientUserId" = scu."clientUserId"

)

SELECT * FROM base
{% if is_incremental() %}
    WHERE "updateDate" > (SELECT MAX("updateDate") FROM {{ this }})
{% endif %}
