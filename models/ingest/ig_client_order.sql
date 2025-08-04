{{
  config(
    materialized='incremental',
    unique_key='"clientOrderId"',
    incremental_strategy='merge',
    tags=['ingest']
  )
}}

WITH base AS (

    SELECT
        co."clientOrderId",
        co."clientUserId",
        co."createDate",
        co.flow,
        co.price,
        co."finishDate",
        co."updateDate",
        co.updator,
        co."storeId",
        co."disName",
        co."startDistance",
        co."endDistance",
        co."payId",
        co."prePrice",
        co."payDate",
        co."plusPrice",
        co."checkTitle",
        co."checkUniNo",
        co."cancelNote",
        co.email,
        co."clientType",
        co."reserveNote",
        co."clientNote",
        co.deposit,
        co."returnStoreId",
        co."rentDateType",
        co."vatNo",
        co."vatCompanyTitle",
        co."promotionCode",
        co.discount,
        co."depositPayMethod",
        co."endPayMethod",
        co."beforePay",
        co."beforePayMethod",
        co."beforePrice",
        co."beforeOrginPrice",
        co."beforeDiscount",
        co."cancelReasonType",
        co.qty,
        co."carrierNum",
        co."getType",
        co."rentKeyBoxId",
        co."returnKeyBoxId",
        co."ecoNo",
        co."asiaMilesId",
        co."plusCancelInsurance",
        CASE
            WHEN
                co."realStartDate" IS NOT NULL
                AND co."realStartDate" != ''
                AND co."realStartDate" ~ '^[0-9]+$'
                THEN TO_TIMESTAMP(co."realStartDate", 'YYYYMMDDHH24MISS')
        END AS "realStartDate",
        CASE
            WHEN
                co."realEndDate" IS NOT NULL
                AND co."realEndDate" != ''
                AND co."realEndDate" ~ '^[0-9]+$'
                THEN TO_TIMESTAMP(co."realEndDate", 'YYYYMMDDHH24MISS')
        END AS "realEndDate",
        CASE
            WHEN
                co."sDate" IS NULL
                OR co."sDate" = ''
                OR co."sDate" !~ '^[0-9]+$'
                THEN NULL
            WHEN LENGTH(co."sDate") = 12
                THEN TO_TIMESTAMP(co."sDate" || '00', 'YYYYMMDDHH24MISS')
            WHEN LENGTH(co."sDate") = 14
                THEN TO_TIMESTAMP(co."sDate", 'YYYYMMDDHH24MISS')
        END AS "sDate",
        CASE
            WHEN
                co."eDate" IS NULL
                OR co."eDate" = ''
                OR co."eDate" !~ '^[0-9]+$'
                THEN NULL
            WHEN LENGTH(co."eDate") = 12
                THEN TO_TIMESTAMP(co."eDate" || '00', 'YYYYMMDDHH24MISS')
            WHEN LENGTH(co."eDate") = 14
                THEN TO_TIMESTAMP(co."eDate", 'YYYYMMDDHH24MISS')
        END AS "eDate"

    FROM {{ ref('client_order') }} AS co
)

SELECT * FROM base
{% if is_incremental() %}
    WHERE "updateDate" > (SELECT MAX("updateDate") FROM {{ this }})
{% endif %}
