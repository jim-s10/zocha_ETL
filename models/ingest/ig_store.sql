{{
  config(
    materialized='incremental',
    unique_key='"storeId"',
    incremental_strategy='delete+insert',
    tags=['ingest']
  )
}}

WITH base AS (
    SELECT
        "storeId",
        "disName",
        addr,
        "areaId",
        "gpsLat",
        "gpsLng",
        "createDate",
        phone,
        status,
        -- "pic",
        "updateDate",
        updator,
        descp,
        "payCash",
        "payCredit",
        "payLINE",
        "payIcp",
        "withoutMofunInvoice",
        "payEndPriceAtRent",
        "alertEmail",
        "alertChannel",
        "priceType",
        "saleInsuranceAbled",
        "frontInsuranceDesc",
        "checkOnlyClientLicense",
        "checkAdminUserCode",
        "frontDisName",
        "outsideServiceReturn",
        "frontRefundRuleDesc",
        "pdfDisName",
        "isFrontRentable",
        "keyBoxId",
        "isNoStaffStore",
        "storeGroupId",
        "oneDayRentAble",
        "isForeignRentOnSite",
        "isShowStoreInfoBtn",
        "isPaymentRequired",
        "entranceType",
        "exitType",
        "memoNote",
        "skipProdImgType",
        "payEndPriceAtDeposit"
    FROM {{ ref('store') }}

)

SELECT * FROM base
{% if is_incremental() %}
    WHERE "updateDate" > (SELECT MAX("updateDate") FROM {{ this }})
{% endif %}
