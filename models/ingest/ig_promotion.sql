{{
  config(
    materialized='incremental',
    unique_key='"rowId"',
    incremental_strategy='merge',
    tags=['ingest']
  )
}}


SELECT
    "rowId"
    , code
    , "disName"
    , discount
    , "limitLowerPrice"
    , "restCount"
    , "startDate"
    , "endDate"
    , type
    , "updateDate"
    , updator
    , "orgQty"
    , "limitNewClientUser"
    , "backDisName"
    , "useType"
    , "autoSentType"
    , "autoSentSDate"
    , "autoSentEDate"
    , "limitDays"
    , "limitType"
    , "uniqueCode"
FROM {{ ref('promotion') }}
{% if is_incremental() %}
    WHERE "updateDate" > (SELECT MAX("updateDate") FROM {{ this }})
{% endif %}
