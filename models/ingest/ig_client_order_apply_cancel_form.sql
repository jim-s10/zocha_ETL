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
        coac."applyDate",
        coac."applyStatus",
        coac."moneyType",
        coac.note,
        coac."updateDate",
        coac.updator,
        coac."clientUserBankName",
        coac."clientUserBankAccount",
        coac."plusFee",
        coac."clientUserBankBranch",
        coac."clientUserName",
        coac.refund,
        coac."cancelReasonType",
        coac."userDisName",
        coac."userPhone",
        CAST(coac."clientOrderId" AS VARCHAR(45)) AS "clientOrderId"

    FROM {{ ref('client_order_apply_cancel_form') }} AS coac
)

SELECT * FROM base
{% if is_incremental() %}
    WHERE "updateDate" > (SELECT MAX("updateDate") FROM {{ this }})
{% endif %}
