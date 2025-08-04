## 架構設計

### 數據層級架構

```
Raw Data (Seeds/CSV) → Ingest → Staging → Intermediate → Mart
```

- **Ingest Layer** (`models/ingest/`): 原始數據攝取層，負責從 CSV seeds 讀取並進行基本的數據類型轉換
- **Staging Layer** (`models/staging/`): 數據清洗和標準化層，處理數據質量問題
- **Intermediate Layer** (`models/intermediate/`): 業務邏輯處理層，進行複雜的數據轉換
- **Mart Layer** (`models/mart/`): 數據集市層，提供面向業務分析的最終數據表

### 核心數據主題

#### 客戶相關
- **客戶基本信息** (`client_user`): 用戶註冊信息、聯絡方式、人口統計資料
- **客戶屬性** (`mart_user_attributes`): 用戶行為分析指標，包含訂單統計、促銷使用情況等

#### 訂單相關
- **訂單主檔** (`client_order`): 租車訂單的基本信息
- **訂單詳情** (`client_order_detail`): 訂單明細，包含產品、配件、價格等信息
- **訂單屬性** (`mart_order_attributes`): 訂單分析指標
- **交易信息** (`client_order_trans`): 交易記錄和支付信息

#### 產品與門店
- **產品資訊** (`prod`): 租車產品目錄
- **產品分類** (`prod_cat`): 產品分類體系
- **門店資訊** (`store`): 門店位置和基本信息
- **區域資訊** (`area`): 服務區域劃分

#### 營銷相關
- **促銷活動** (`promotion`): 促銷方案設定
- **促銷使用記錄** (`client_user_promotion_trans`): 用戶促銷券使用歷史

## 技術棧

- **數據轉換**: dbt Core 1.10.3+
- **數據庫**: PostgreSQL 16 (開發環境通過 Docker 運行)
- **容器化**: Docker & Docker Compose
- **Python 環境**: Python 3.9+
- **包管理**: uv (Python package manager)
- **增量處理**: 支持增量更新策略

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
  - Mart: `view` (為了靈活性)
- **增量策略**: `merge` (delete + insert + update)

### 數據庫配置

- **時區**: Asia/Taipei (UTC+8)
- **連接埠**: 5432
- **資料庫**: postgres
- **用戶**: postgres

## 開發路徑圖

### 🚧 待開發功能

#### 1. Order & Order Detail 後端規範改動
- [X] 更新 `client_order` 模型以符合新的後端 API 規範
- [X] 重構 `client_order_detail` 模型的數據結構
- [ ] 調整相關的 staging 和 mart 層模型
- [ ] 更新增量處理邏輯以支持新的數據格式

#### 2. Airbyte 整合
- [ ] 將現有的 dbt seeds 轉換為 Airbyte source connectors
- [ ] 設定 Airbyte 與 PostgreSQL 的連接

#### 3. 數據品質提升(可選)
- [ ] 增加更多的 dbt tests 以確保數據品質
- [ ] 實施數據血緣追蹤
- [ ] 建立數據異常監控和告警機制

### 📋 近期更新歷史

- **feat: update lineid into user attributes** - 在用戶屬性中加入 Line ID 欄位
- **feat: define all column types at final layer models** - 在最終層模型中明確定義所有欄位類型
- **feat: dbt models** - 初始 dbt 模型實作

## 目錄結構

```
zocha_cdp/
├── models/
│   ├── ingest/          # 數據攝取層
│   │   ├── ig_client_order.sql
│   │   ├── ig_client_order_detail.sql
│   │   ├── ig_client_user.sql
│   │   └── ...
│   ├── staging/         # 數據清洗層
│   │   ├── stg_client_user.sql
│   │   ├── stg_client_order_trans.sql
│   │   └── ...
│   ├── intermediate/    # 中間處理層
│   └── mart/           # 數據集市層
│       ├── mart_user_attributes.sql
│       ├── mart_order_attributes.sql
│       └── mart_order_trans_info.sql
├── seeds/              # 種子數據 (CSV 文件)
├── tests/              # 數據測試
├── macros/             # dbt 宏
├── snapshots/          # 數據快照
├── docker-compose.yml  # Docker 配置
├── dbt_project.yml     # dbt 項目配置
└── pyproject.toml      # Python 依賴配置
```
