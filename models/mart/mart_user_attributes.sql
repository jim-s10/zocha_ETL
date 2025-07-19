WITH base_user_attributes AS (
    SELECT
        "clientUserId",
        SUM(CASE
            WHEN used = 'Y' THEN 1
            ELSE 0
        END) AS coupon_received_cnt
    FROM {{ ref('ig_client_user_promotion_trans') }}
    GROUP BY "clientUserId"
),

user_attributes AS (
    SELECT
        soa."clientUserId",
        bua.coupon_received_cnt, --租車次數
        COUNT(DISTINCT soa."clientOrderId") AS order_cnt, --累計租借金額
        SUM(soa.price) AS total_price, --加購雨衣次數
        SUM(soa."accessoriesRaincoat") AS total_raincoat_cnt, --平均租借金額
        AVG(soa.price) AS avg_price,  --訂單取消次數
        SUM(soa.is_canceled) AS cancel_cnt, --自動取消次數
        SUM(soa.is_auto_canceled) AS auto_cancel_cnt, --優惠券使用次數
        SUM(soa.promotion_code_usage_cnt) AS promotion_code_usage_cnt -- 優惠券領用次數
    FROM {{ ref('int_order_attributes') }} AS soa
    LEFT JOIN
        base_user_attributes AS bua
        ON soa."clientUserId" = bua."clientUserId"
    GROUP BY soa."clientUserId", bua.coupon_received_cnt
),

final_user_attributes AS (
    SELECT
        icu."clientUserId",
        icu.phone,
        icu.sex,
        icu.birthday,
        icu.month_of_birthday,
        icu.years_old,
        icu."createDate",
        icu.country,
        icu.addr,
        icu.email,
        ua.coupon_received_cnt,
        ua.order_cnt,
        ua.total_price,
        ua.total_raincoat_cnt,
        ua.avg_price,
        ua.cancel_cnt,
        ua.auto_cancel_cnt,
        ua.promotion_code_usage_cnt
    FROM {{ ref('stg_client_user') }} AS icu
    LEFT JOIN user_attributes AS ua ON icu."clientUserId" = ua."clientUserId"
)

SELECT *
FROM final_user_attributes
