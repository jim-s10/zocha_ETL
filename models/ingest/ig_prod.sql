{{
  config(
    materialized='incremental',
    unique_key='"prodId"',
    incremental_strategy='merge',
    tags=['ingest']
  )
}}

WITH base AS (
    SELECT
        "prodId",
        "carNo",
        "disName",
        "catProdId",
        "storeId",
        "plusInsurance",
        birthday,
        "buyDate",
        "buyDistance",
        "nowDistance",
        status,
        "updateDate",
        updator,
        "prodCatId",
        -- "pic1",
        -- "pic2",
        -- "pic3",
        -- "pic4",
        "officeImg",
        "describeImg",
        "prodPriceRowId",
        "monthStartDistance",
        "clientOrderId",
        "contractMonthOfDate",
        "engineId",
        color,
        "insuranceDueDate",
        lat,
        lng,
        "locatUpdateDate",
        "enabledDistance",
        "ccType",
        "carNoDisName",
        "contractMileage",
        "deductibleMileage",
        "keyBoxDoorId",
        "ecoAuto",
        "enabledEco",
        "maintainDistance",
        "maintainDays",
        "lastMaintainDistance",
        "lastMaintainDate",
        "carOwner",
        "statusChangeMsg",
        "statusChangeDate",
        "iotType",
        "isPutKeyBox"
    FROM {{ ref('prod') }}
)

SELECT * FROM base
{% if is_incremental() %}
    WHERE "updateDate" > (SELECT MAX("updateDate") FROM {{ this }})
{% endif %}
