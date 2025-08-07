erDiagram
    MemberProfile {
        VARCHAR(20) member_id PK "會員ID"
        SMALLINT partition "分區"
        VARCHAR(300) gender "性別"
        SMALLINT age "年齡"
        VARCHAR(60) name "姓名"
        VARCHAR(255) email "電子信箱"
        VARCHAR(45) phone "手機號碼"
        VARCHAR(255) contact_address_city "聯絡地址城市"
        VARCHAR(45) birthday "生日"
        SMALLINT birthday_month "月份壽星"
        TIMESTAMP join_datetime "會員加入日期"
        VARCHAR(4) country "國家"
        VARCHAR(200) line_uid "Line ID"
        TIMESTAMP first_purchase_datetime "首次購買時間"
        BOOLEAN has_email "是否有Email"
        BOOLEAN has_phone "是否有電話"
        TIMESTAMP update_time "更新時間"
        INTEGER email_failure_count "Email失敗次數"
        BOOLEAN email_blocked "Email封鎖狀態"
        BOOLEAN phone_blocked "電話封鎖狀態"
        BOOLEAN app_blocked "App封鎖狀態"
        TEXT notes "備註"
        JSONB additional_info "額外資訊"
        BOOLEAN sms_do_not_disturb "簡訊免打擾"
        BOOLEAN edm_do_not_disturb "EDM免打擾"
    }

    Order {
        VARCHAR(45) order_number PK "訂單號碼"
        VARCHAR(20) member FK "會員ID"
        SMALLINT partition "分區"
        TIMESTAMP purchase_date "訂單預約時間"
        INTEGER total_amount "單次訂單金額"
        TIMESTAMP update_date "訂單更新時間"
    }

    OrderDetail {
        VARCHAR(45) order_number PK "訂單號碼"
        VARCHAR(20) member_id FK "會員ID"
        SMALLINT partition "分區"
        BOOLEAN is_pbgn_prod "車種類型"
        VARCHAR(20) prod_cat_name "租用車款"
        INTERVAL renting_period "實際租借時長"
        SMALLINT renting_type "租借方案(短租/長租)"
        BOOLEAN store_type "店家類型(無人/門市)"
        VARCHAR(20) promotion_code_name "優惠券名稱"
        VARCHAR(255) area_name "區域"
        VARCHAR(45) store_name "站點"
        VARCHAR(1) reason_to_use "使用目的"
        TIMESTAMP renting_start_date "租車開始時間"
        TIMESTAMP renting_end_date "租車結束時間"
        TIMESTAMP update_date "訂單更新時間"
    }

    Transaction {
        VARCHAR(20) member_id PK "會員ID"
        SMALLINT partition "分區"
        SMALLINT order_cnt "租車次數"
        INTEGER total_price "累計租借金額"
        DECIMAL average_purchased_price "平均訂單金額"
        SMALLINT promotion_code_received_cnt "優惠券領用次數"
        SMALLINT total_raincoat_cnt "加購雨衣次數"
        SMALLINT cancel_cnt "訂單取消次數"
        SMALLINT auto_cancel_cnt "自動取消數量"
        SMALLINT promotion_code_usage_cnt "優惠券使用次數"
    }

    TransactionDetail {
        VARCHAR(91) surrogate_key PK "代理鍵(訂單號+付款階段)"
        VARCHAR(45) order_number FK "訂單號碼"
        VARCHAR(20) member_id FK "會員ID"
        SMALLINT partition "分區"
        VARCHAR(10) transaction_stage "付款時間點(預付/尾款/補款等)"
        VARCHAR(10) transaction_type "付款方式(信用卡/現金/轉帳等)"
        TIMESTAMP update_date "交易更新時間"
    }

    %% 關聯關係
    MemberProfile ||--o{ Order : "creates"
    MemberProfile ||--|| Transaction : "has_order and makes_payments"
    Order ||--|| OrderDetail : "has_details"
    Order ||--o{ Transaction : "has_payments"
    MemberProfile ||--o{ TransactionDetail : "makes_payments"
    Transaction ||--o{ TransactionDetail : "make_payments"

    %% 業務流程註解
    Order {
        string 只是註解不是真的欄位 "會員在建立租車訂單之後會出現這個欄位"
    }

    OrderDetail {
        string business_note_2 "每筆訂單包含租車詳細資訊"
    }

    Transaction {
        string business_note_5 "所有會員資料的總計"
    }

    TransactionDetail {
        string business_note_3 "每筆訂單付款的狀況，可能分階段付款，如：預付、尾款、押金、違約金等"
    }
