erDiagram
    member_memberprofile {
        VARCHAR(20) member_id PK "會員ID"
        INTEGER partition "分區"
        VARCHAR(300) gender "性別"
        INTEGER age "年齡"
        VARCHAR(60) name "姓名"
        VARCHAR(255) email "電子信箱"
        VARCHAR(45) phone "手機號碼"
        VARCHAR(255) contact_address_city "聯絡地址城市"
        DATE birthday "生日"
        INTEGER birthday_month "月份壽星"
        DATE join_datetime "會員加入日期"
        VARCHAR(4) country "國家"
        VARCHAR(200) line_uid "Line ID"
        TIMESTAMP first_purchase_datetime "首次購買時間"
        BOOLEAN has_email "是否有Email"
        BOOLEAN has_phone "是否有電話"
        TIMESTAMP updated_at "更新時間"
        INTEGER email_failure_count "Email失敗次數"
        BOOLEAN email_blocked "Email封鎖狀態"
        BOOLEAN phone_blocked "電話封鎖狀態"
        BOOLEAN app_blocked "App封鎖狀態"
        VARCHAR(100) notes "備註"
        JSONB additional_info "額外資訊"
        BOOLEAN sms_do_not_disturb "簡訊免打擾"
        BOOLEAN edm_do_not_disturb "EDM免打擾"
    }

    member_order {
        VARCHAR(45) order_number PK "訂單號碼"
        VARCHAR(20) member FK "會員ID"
        INTEGER partition "分區"
        DATE purchase_date "訂單預約時間"
        INTEGER total_amount "單次訂單金額"
        TIMESTAMP update_date "訂單更新時間"
    }

    member_orderdetail {
        VARCHAR(45) order_number PK "訂單號碼"
        VARCHAR(20) member_id FK "會員ID"
        INTEGER partition "分區"
        VARCHAR(10) is_pbgn_prod "車種類型"
        VARCHAR(20) prod_cat_name "租用車款"
        DECIMAL(20,3) renting_period "實際租借時長"
        VARCHAR(10) renting_type "租借方案(短租/長租)"
        VARCHAR(10) store_type "店家類型(無人/門市)"
        VARCHAR(20) promotion_code_name "優惠券名稱"
        VARCHAR(255) area_name "區域"
        VARCHAR(45) store_name "站點"
        VARCHAR(10) reason_to_use "使用目的"
        TIMESTAMP renting_start_time "租車開始時間"
        TIMESTAMP renting_end_time "租車結束時間"
        TIMESTAMP update_date "訂單更新時間"
    }

    member_transaction {
        VARCHAR(20) member_id PK "會員ID"
        INTEGER partition "分區"
        INTEGER purchased_count "租車次數"
        INTEGER total_price "累計租借金額"
        DECIMAL(20,3) average_purchased_price "平均訂單金額"
        INTEGER promotion_code_received_cnt "優惠券領用次數"
        INTEGER total_raincoat_cnt "加購雨衣次數"
        INTEGER cancel_cnt "訂單取消次數"
        INTEGER auto_cancel_cnt "自動取消數量"
        INTEGER promotion_code_usage_cnt "優惠券使用次數"
        INTEGER rfm_r_score "RFM R分數"
        INTEGER rfm_f_score "RFM F分數"
        INTEGER rfm_m_score "RFM M分數"
        INTEGER rfm_total_score "RFM總分數"
        TIMESTAMP updated_at "更新時間"
    }

    member_transactiondetail {
        VARCHAR(91) surrogate_key PK "代理鍵(訂單號+付款階段)"
        VARCHAR(45) order_number FK "訂單號碼"
        VARCHAR(20) member_id FK "會員ID"
        INTEGER partition "分區"
        VARCHAR(10) transaction_stage "付款時間點(預付/尾款/補款等)"
        VARCHAR(10) transaction_type "付款方式(信用卡/現金/轉帳等)"
        TIMESTAMP updated_at "交易更新時間"
    }

    system_member {
        VARCHAR(20) gid PK "會員全域ID"
        INTEGER gid_partition "會員ID分區"
        TIMESTAMP updated_at "更新時間"
    }
    %% 關聯關係 - 根據實際欄位名稱更新
    member_memberprofile ||--o{ member_order : "member_id"
    member_memberprofile ||--|| member_transaction : "member_id"
    member_order ||--|| member_orderdetail : "order_number/order"
    member_order ||--o{ member_transactiondetail : "order_number/order"
    member_memberprofile ||--o{ member_transactiondetail : "member_id"
    system_member ||--|| member_memberprofile : "gid/member_id"

    %% 業務流程註解
    member_order {
        string business_note_1 "會員在建立租車訂單之後會出現這個資料"
    }

    member_orderdetail {
        string business_note_2 "每筆訂單包含租車詳細資訊，一對一關係"
    }

    member_transaction {
        string business_note_3 "會員的所有交易統計資料匯總，包含RFM分析"
    }

    member_transactiondetail {
        string business_note_4 "每筆訂單付款的詳細狀況，可能分階段付款"
    }

    system_member {
        string business_note_5 "系統層級的會員識別資料，用於追蹤會員狀態"
    }
