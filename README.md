# Zocha CDP - Customer Data Platform

## 架構設計

### 數據層級架構

```
Raw Data (Seeds/CSV) → Ingest → Staging → Intermediate → Mart
```

- **Ingest Layer** (`models/ingest/`): 原始數據攝取層，負責從 CSV seeds 讀取並進行基本的數據類型轉換
- **Staging Layer** (`models/staging/`): 數據清洗和標準化層，處理數據質量問題
- **Intermediate Layer** (`models/intermediate/`): 業務邏輯處理層，進行複雜的數據轉換和分析指標計算
- **Mart Layer** (`models/mart/`): 數據集市層，提供面向業務分析的最終會員數據表

### 核心數據主題

#### 會員管理體系
- **會員基礎資料** (`member_memberprofile`): 會員註冊信息、聯絡方式、人口統計資料、RFM 分析等
- **系統會員** (`system_member`): 會員全域識別碼，用於追蹤會員狀態
- **會員交易統計** (`member_transaction`): 會員交易行為匯總分析，包含 RFM 分數計算

#### 訂單分析體系
- **會員訂單** (`member_order`): 會員租車訂單主檔
- **訂單詳情** (`member_orderdetail`): 訂單明細，包含租車產品、配件、區域、時間等詳細信息
- **交易明細** (`member_transactiondetail`): 付款階段詳細記錄，支援分階段付款追蹤

#### 基礎數據
- **產品資訊** (`ig_prod`): 租車產品目錄
- **產品分類** (`ig_prod_cat`): 產品分類體系（電車/油車等）
- **門店資訊** (`ig_store`): 門店位置和營運資訊
- **區域資訊** (`ig_area`): 服務區域劃分

#### 營銷與客服
- **促銷活動** (`ig_promotion`): 促銷方案設定
- **促銷使用記錄** (`ig_client_user_promotion_trans`): 會員促銷券使用歷史
- **訂單問卷** (`ig_client_order_questionnaire`): 租車目的調查
- **取消申請** (`ig_client_order_apply_cancel_form`): 訂單取消申請記錄
- **訂單歷史** (`ig_client_order_history`): 訂單狀態變更歷程

## 技術棧

- **數據轉換**: dbt Core 1.10.3+
- **數據庫**: PostgreSQL 16 (開發環境通過 Docker 運行)
- **分析引擎**: DuckDB 1.3.1+ (用於本地分析)
- **容器化**: Docker & Docker Compose
- **Python 環境**: Python 3.9+
- **包管理**: uv (Python package manager)
- **增量處理**: 支持增量更新策略 (merge: delete + insert + update)
- **代碼品質**: SQLFluff 3.4.2+ (SQL 格式化與檢查)

## 快速開始

### 環境準備

1. **安裝依賴**
```bash
# 使用 uv 安裝 Python 依賴
uv sync
```

2. **啟動數據庫**
```bash
# 啟動 PostgreSQL 容器
docker-compose up -d postgres
```

3. **初始化數據**
```bash
# 載入種子數據
dbt seed --threads 16 --full-refresh

# 運行所有模型
dbt run --threads 16 --full-refresh
```

### 開發工作流

1. **增量更新**
```bash
# 僅運行有變更的模型
dbt run --select +modified

# 運行特定模型及其下游依賴
dbt run --select +model_name+
```

2. **文檔生成**
```bash
# 生成並查看文檔
dbt docs generate
dbt docs serve
```
## 項目配置

### dbt 配置

- **Profile**: `zocha_cdp`
- **物化策略**:
  - Ingest & Staging: `table` (為了更好的性能)
  - Intermediate: `incremental` (merge 策略)
  - Mart: `incremental` (merge 策略，支援複雜欄位排除邏輯)
- **增量策略**: `merge` (delete + insert + update)
- **分區支援**: 透過 `get_user_partition` macro 實現會員數據分區

### 特殊功能

#### 會員分區機制
透過 `get_user_partition` macro 實現會員數據的分區處理，支援多種數據庫類型：
- PostgreSQL: MD5 雜湊演算法
- BigQuery: FARM_FINGERPRINT
- Snowflake: SHA2 雜湊
- Redshift: MD5 雜湊

#### RFM 分析
在 `member_transaction` 模型中實現完整的 RFM (Recency, Frequency, Monetary) 分析：
- **R Score**: 最近購買時間分析
- **F Score**: 購買頻率分析
- **M Score**: 購買金額分析
- **Total Score**: 綜合評分

## 數據模型設計

### 實體關係圖
詳見 `ER_Diagram.md` 文件，包含完整的數據表關係和欄位說明。

### 關鍵業務邏輯

#### 訂單狀態分類
- **自動取消訂單**: flow = '1200' 且歷史記錄包含 '10', '50'
- **已取消訂單**: flow = '1100' 或 '1000'
- **申請取消訂單**: 存在取消申請記錄

#### 租車類型分類
- **短租**: rentDateType = '1'
- **長租/環島**: rentDateType = '2'
- **電車 vs 油車**: 基於 isPbgnProd 欄位判斷，電車為 'Y'，油車為 'N'

#### 門店類型
- **門市**: isNoStaffStore = 'F'
- **無人站點**: isNoStaffStore = 'T'

## 目錄結構

```
zocha_cdp/
├── models/
│   ├── ingest/              # 數據攝取層 (13 個模型)
│   │   ├── ig_area.sql
│   │   ├── ig_client_order.sql
│   │   ├── ig_client_order_apply_cancel_form.sql
│   │   ├── ig_client_order_detail.sql
│   │   ├── ig_client_order_history.sql
│   │   ├── ig_client_order_questionnaire.sql
│   │   ├── ig_client_order_trans.sql
│   │   ├── ig_client_user.sql
│   │   ├── ig_client_user_promotion_trans.sql
│   │   ├── ig_prod.sql
│   │   ├── ig_prod_cat.sql
│   │   ├── ig_promotion.sql
│   │   └── ig_store.sql
│   ├── staging/             # 數據清洗層 (4 個模型)
│   │   ├── stg_client_order_trans.sql
│   │   ├── stg_client_user.sql
│   │   ├── stg_prod_cat.sql
│   │   └── stg_store_area.sql
│   ├── intermediate/        # 中間處理層 (1 個模型)
│   │   └── int_order_attributes.sql
│   └── mart/               # 數據集市層 (6 個模型)
│       ├── member_memberprofile.sql
│       ├── member_order.sql
│       ├── member_orderdetail.sql
│       ├── member_transaction.sql
│       ├── member_transactiondetail.sql
│       └── system_member.sql
├── seeds/                  # 種子數據 (CSV 文件)
├── tests/                  # 數據測試
├── macros/                 # dbt 宏
│   └── get_user_partition.sql
├── snapshots/              # 數據快照
├── init-scripts/           # 數據庫初始化腳本
├── docker-compose.yml      # Docker 配置
├── dbt_project.yml         # dbt 項目配置
├── pyproject.toml          # Python 依賴配置
├── postgresql.conf         # PostgreSQL 配置
└── ER_Diagram.md          # 實體關係圖
```

## 數據治理

### 命名規範
- **Ingest Layer**: `ig_` 前綴
- **Staging Layer**: `stg_` 前綴
- **Intermediate Layer**: `int_` 前綴
- **Mart Layer**: `member_` 前綴 (會員相關) 或 `system_` 前綴 (系統相關)

### 增量處理策略
所有 mart 層模型都使用 `incremental` 物化策略，支援：
- 基於 `updated_at` 欄位的增量判斷
- `merge` 策略處理 upsert 邏輯
- 複雜的欄位排除邏輯 (避免覆寫手動維護的欄位)

### 資料品質保證
- 使用 dbt 的 `unique_key` 確保主鍵唯一性
- 透過 staging 層進行數據清洗和標準化
- 實現完整的數據血緣追蹤
