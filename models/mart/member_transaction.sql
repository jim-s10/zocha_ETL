{{
  config(
    materialized='incremental',
    unique_key='member_id',
    incremental_strategy='merge',
    tags=['mart']
  )
}}
-- TODO: Adding these fields:
--   rfm_r_score
--   rfm_f_score
--   rfm_m_score
--   rfm_total_score

WITH base_user_attributes AS (
    SELECT
        "clientUserId"
        , COUNT(*) AS promotion_code_received_cnt
    FROM {{ ref('ig_client_user_promotion_trans') }}
    GROUP BY "clientUserId"
),

user_attributes AS (
    SELECT
        soa."clientUserId"
        , COUNT(DISTINCT soa."clientOrderId") AS purchased_count --累計租借金額
        , SUM(soa.price) AS total_price --加購雨衣次數
        , SUM(soa."accessoriesRaincoat") AS total_raincoat_cnt --平均租借金額
        , AVG(soa.price) AS avg_price --訂單取消次數
        , SUM(soa.is_canceled) AS cancel_cnt --自動取消次數
        , SUM(soa.is_auto_canceled) AS auto_cancel_cnt --優惠券使用次數
        , SUM(soa.promotion_code_usage_cnt) AS promotion_code_usage_cnt -- 優惠券領用次數
    FROM {{ ref('int_order_attributes') }} AS soa
    GROUP BY soa."clientUserId"
),
rfm_values AS (
    -- 1. 計算每個會員的 RFM 值
    SELECT
        "clientUserId" AS member_id,
        EXTRACT(DAY FROM (CURRENT_TIMESTAMP - MAX("createDate"))) AS recency_days,
        COUNT(DISTINCT "clientOrderId") AS frequency,
        SUM(price) AS monetary
    FROM {{ ref('int_order_attributes') }}
    GROUP BY "clientUserId"
),

rfm_data AS (
    -- 2. 根據 RFM 值分配分數
    SELECT
        member_id,
        NTILE(5) OVER (ORDER BY recency_days ASC) AS rfm_r_score,
        NTILE(5) OVER (ORDER BY frequency DESC) AS rfm_f_score,
        NTILE(5) OVER (ORDER BY monetary DESC) AS rfm_m_score
    FROM rfm_values
),

final_user_attributes AS (
    SELECT
        CAST(scu."clientUserId" AS VARCHAR(20)) AS member_id
        , CAST(scu.partition AS INTEGER) AS "partition"
        , CAST(COALESCE(ua.purchased_count, 0) AS INTEGER) AS purchased_count --租車次數
        , CAST(COALESCE(ua.total_price, 0) AS INTEGER) AS total_price --累計租借金額
        , CAST(COALESCE(ua.avg_price, 0) AS DECIMAL(20,3)) AS average_purchased_price --平均訂單金額
        , CAST(COALESCE(bua.promotion_code_received_cnt, 0) AS INTEGER) AS promotion_code_received_cnt --優惠券領用次數
        , CAST(COALESCE(ua.total_raincoat_cnt, 0) AS INTEGER) AS total_raincoat_cnt --加購雨衣次數
        , CAST(COALESCE(ua.cancel_cnt, 0) AS INTEGER) AS cancel_cnt --訂單取消次數
        , CAST(COALESCE(ua.auto_cancel_cnt, 0) AS INTEGER) AS auto_cancel_cnt --自動取消數量
        , CAST(COALESCE(ua.promotion_code_usage_cnt, 0) AS INTEGER) AS promotion_code_usage_cnt --優惠券使用次數
        , CAST(COALESCE(rfm.rfm_r_score, 0) AS INTEGER) AS rfm_r_score
        , CAST(COALESCE(rfm.rfm_f_score, 0) AS INTEGER) AS rfm_f_score
        , CAST(COALESCE(rfm.rfm_m_score, 0) AS INTEGER) AS rfm_m_score
        , CAST(COALESCE(rfm.rfm_r_score, 0) + COALESCE(rfm.rfm_f_score, 0) + COALESCE(rfm.rfm_m_score, 0) AS INTEGER) AS rfm_total_score
        , CURRENT_TIMESTAMP AS updated_at --更新時間
    FROM {{ ref('stg_client_user') }} AS scu
    LEFT JOIN user_attributes AS ua ON scu."clientUserId" = ua."clientUserId"
    LEFT JOIN base_user_attributes AS bua ON scu."clientUserId" = bua."clientUserId"
    LEFT JOIN rfm_data AS rfm ON scu."clientUserId" = rfm.member_id
)

SELECT *
FROM final_user_attributes
