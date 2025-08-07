{{
  config(
    materialized='incremental',
    unique_key='member_id',
    incremental_strategy='merge',
    merge_exclude_columns=[
        'member_id',
        'email_failure_count',
        'email_blocked',
        'phone_blocked',
        'app_blocked',
        'notes',
        'additional_info',
        'sms_do_not_disturb',
        'edm_do_not_disturb'
    ],
    tags=['mart']
  )
}}


WITH first_order_time AS (
    SELECT
        scu."clientUserId"
        , MIN(ioa."createDate") AS first_purchase_datetime
    FROM {{ ref('stg_client_user') }} AS scu
    LEFT JOIN {{ ref('int_order_attributes') }} AS ioa
        ON scu."clientUserId" = ioa."clientUserId"
    WHERE
        ioa.is_auto_canceled = 0  -- 自動取消單
        AND ioa.is_canceled = 0 -- 已取消訂單
        AND ioa.is_applied_cancel = 0 -- 申請取消訂單
    GROUP BY 1
),
{% if is_incremental() %}
base AS (
    SELECT
        member_id
        ,email_failure_count
        ,email_blocked
        ,phone_blocked
        ,app_blocked
        ,notes
        ,additional_info
        ,sms_do_not_disturb
        ,edm_do_not_disturb
    FROM {{ this }}
),
{% endif %}
final_user_attributes AS (
    SELECT
        CAST(scu."clientUserId" AS VARCHAR(20)) AS member_id
        , CAST(scu.partition AS SMALLINT) AS "partition"
        , CAST(scu.sex AS VARCHAR(300)) AS gender --性別
        , CAST(scu.age AS SMALLINT) AS age --年齡
        , CAST(scu."disName" AS VARCHAR(60)) AS name --姓名
        , CAST(scu.email AS VARCHAR(255)) AS email --電子信箱
        , CAST(scu.phone AS VARCHAR(45)) AS phone --手機號碼
        , CAST(scu.addr AS VARCHAR(255)) AS contact_address_city--聯絡地址城市
        , CAST(scu.birthday AS VARCHAR(45)) AS birthday --生日
        , CAST(scu.month_of_birthday AS SMALLINT) AS birthday_month --月份壽星
        , CAST(scu."registerDate" AS TIMESTAMP) AS join_datetime --會員加入日期
        , CAST(scu.country AS VARCHAR(4)) AS country --國家
        , CAST(scu."lineId" AS VARCHAR(200)) AS line_uid --Line ID
        , CAST(fot.first_purchase_datetime AS TIMESTAMP) AS first_purchase_datetime --首次購買時間
        , CAST(scu.email IS NULL AS BOOLEAN) AS has_email
        , CAST(scu.phone IS NULL AS BOOLEAN) AS has_phone
        , CAST(scu."updateDate" AS TIMESTAMP) AS update_time
        {% if not is_incremental() %}
        , CAST(0 AS INTEGER) AS email_failure_count
        , CAST(FALSE AS BOOLEAN) AS email_blocked
        , CAST(FALSE AS BOOLEAN) AS phone_blocked
        , CAST(FALSE AS BOOLEAN) AS app_blocked
        , CAST(NULL AS TEXT) AS notes
        , CAST('{}' AS JSONB) AS additional_info
        , CAST(FALSE AS BOOLEAN) AS sms_do_not_disturb
        , CAST(FALSE AS BOOLEAN) AS edm_do_not_disturb
        {% else %}
        , CAST(prev.email_failure_count AS INTEGER) AS email_failure_count
        , CAST(prev.email_blocked AS BOOLEAN) AS email_blocked
        , CAST(prev.phone_blocked AS BOOLEAN) AS phone_blocked
        , CAST(prev.app_blocked AS BOOLEAN) AS app_blocked
        , CAST(prev.notes AS TEXT) AS notes
        , CAST(prev.additional_info AS JSONB) AS additional_info
        , CAST(prev.sms_do_not_disturb AS BOOLEAN) AS sms_do_not_disturb
        , CAST(prev.edm_do_not_disturb AS BOOLEAN) AS edm_do_not_disturb
        {% endif %}

    FROM {{ ref('stg_client_user') }} AS scu
    LEFT JOIN first_order_time AS fot
        ON scu."clientUserId" = fot."clientUserId"
    {% if is_incremental() %}
        LEFT JOIN {{ this }} AS prev
            ON scu."clientUserId" = prev.member_id
    {% endif %}
)

SELECT *
FROM final_user_attributes
{% if is_incremental() %}
  WHERE update_time > (SELECT MAX(update_time) FROM {{ this }})
{% endif %}
