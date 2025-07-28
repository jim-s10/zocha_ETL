{{
  config(
    materialized='view',
    tags=['mart']
  )
}}


WITH base_user_attributes AS (
    SELECT
        "clientUserId",
        COUNT(*) AS promotion_code_received_cnt
    FROM {{ ref('ig_client_user_promotion_trans') }}
    GROUP BY "clientUserId"
),

user_attributes AS (
    SELECT
        soa."clientUserId",
        COUNT(DISTINCT soa."clientOrderId") AS order_cnt, --累計租借金額
        SUM(soa.price) AS total_price, --加購雨衣次數
        SUM(soa."accessoriesRaincoat") AS total_raincoat_cnt, --平均租借金額
        AVG(soa.price) AS avg_price,  --訂單取消次數
        SUM(soa.is_canceled) AS cancel_cnt, --自動取消次數
        SUM(soa.is_auto_canceled) AS auto_cancel_cnt, --優惠券使用次數
        SUM(soa.promotion_code_usage_cnt) AS promotion_code_usage_cnt -- 優惠券領用次數
    FROM {{ ref('int_order_attributes') }} AS soa
    GROUP BY soa."clientUserId"
),

final_user_attributes AS (
    SELECT
        CAST(scu."clientUserId" AS VARCHAR(20)) AS "clientUserId",
        CAST(scu.phone AS VARCHAR(45)) AS phone,
        CAST(scu.sex AS VARCHAR(300)) AS gender,
        CAST(scu.birthday AS VARCHAR(45)) AS birthday,
        CAST(scu.month_of_birthday AS SMALLINT) AS month_of_birthday,
        CAST(scu.years_old AS SMALLINT) AS years_old,
        CAST(scu."createDate" AS VARCHAR(14)) AS "createDate",
        CAST(scu.country AS VARCHAR(4)) AS country,
        CAST(scu.addr AS VARCHAR(255)) AS addr,
        CAST(scu.email AS VARCHAR(255)) AS email,
        CAST(bua.promotion_code_received_cnt AS SMALLINT) AS promotion_code_received_cnt,
        CAST(ua.order_cnt AS SMALLINT) AS order_cnt,
        CAST(ua.total_price AS INTEGER) AS total_price,
        CAST(ua.total_raincoat_cnt AS SMALLINT) AS total_raincoat_cnt,
        CAST(ua.avg_price AS NUMERIC) AS avg_price,
        CAST(ua.cancel_cnt AS SMALLINT) AS cancel_cnt,
        CAST(ua.auto_cancel_cnt AS SMALLINT) AS auto_cancel_cnt,
        CAST(ua.promotion_code_usage_cnt AS SMALLINT) AS promotion_code_usage_cnt
    FROM {{ ref('stg_client_user') }} AS scu
    LEFT JOIN user_attributes AS ua ON scu."clientUserId" = ua."clientUserId"
    LEFT JOIN base_user_attributes AS bua ON scu."clientUserId" = bua."clientUserId"
)

SELECT *
FROM final_user_attributes
