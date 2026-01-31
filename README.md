# Automated E-Commerce Sales Intelligence & Anomaly Detection

**Real-time business dashboards • Automatic anomaly alerts • Zero manual monitoring**

Turn raw sales data into actionable intelligence with automated analytics pipelines, live Power BI dashboards, and intelligent anomaly detection—exactly what analytics consulting firms sell.

## 🎯 Project Overview

This project demonstrates an enterprise-grade analytics solution that automatically:
- Ingests daily sales data from SQL/CSV sources
- Computes KPIs (revenue, order volume, AOV, category performance)
- Visualizes metrics in interactive Power BI dashboards
- Detects anomalies using rule-based statistical methods
- Sends automated alerts via email when anomalies occur
- Logs incidents for compliance and audit trails

**Business Impact:**
- ✅ Faster issue detection (minutes, not days)
- ✅ Zero manual dashboard monitoring
- ✅ Real-time, data-driven insights
- ✅ Automated decision workflows

---

## 🏗️ Architecture

```
┌─────────────────┐
│   Data Source   │  SQL Database / CSV
│  (Orders Table) │
└────────┬────────┘
         │
         ▼
┌──────────────────────┐
│  SQL Transformations │  GROUP BY, Window Functions
│   (KPI Queries)      │  Trend Analysis
└─────────┬────────────┘
          │
          ├──────────────────────┐
          │                      │
          ▼                      ▼
    ┌──────────────┐      ┌──────────────────┐
    │  Power BI    │      │   Anomaly Rules  │
    │  Dashboards  │      │  (SQL Queries)   │
    └──────────────┘      └────────┬─────────┘
                                   │
                                   ▼
                          ┌─────────────────┐
                          │   n8n Workflow  │
                          │  (Daily Cron)   │
                          └────────┬────────┘
                                   │
                          ┌────────┴────────┐
                          │                 │
                          ▼                 ▼
                       Email             Logging
                       Alert            (Incident)
```

### Components

1. **Data Layer**: PostgreSQL/MySQL with orders table
2. **Analytics Layer**: SQL views for KPIs and anomaly detection
3. **BI Layer**: Power BI for interactive dashboards
4. **Automation**: n8n workflow for scheduled anomaly checks and alerts

---

## 📁 Project Structure

```
ecommerce-sales-intel/
├── db/
│   ├── schema.sql              # Table definitions
│   ├── seed.sql                # Sample data (3-6 months)
│   └── README.md               # DB setup instructions
│
├── analytics/
│   ├── kpi_queries.sql         # Daily revenue, orders, AOV, category perf
│   ├── trend_analysis.sql      # WoW growth, moving averages
│   ├── anomaly_rules.sql       # Detection logic (revenue drops, spikes)
│   └── README.md               # Query documentation
│
├── automation/
│   ├── n8n_workflow.json       # Export from n8n (Cron + Check + Alert)
│   └── README.md               # n8n setup & deployment guide
│
├── dashboards/
│   ├── Ecommerce_Sales_Intel.pbix
│   └── README.md               # Power BI file guide
│
├── docs/
│   ├── architecture.md         # System design deep-dive
│   ├── deployment.md           # Local + cloud setup
│   └── sample_alerts.md        # Example anomaly reports
│
└── README.md                   # This file
```

---

## 🚀 Quick Start

### 1. Database Setup

```bash
# Clone the repository
git clone https://github.com/Keerthanagr12/automated-ecommerce-sales-intel.git
cd automated-ecommerce-sales-intel

# Set up PostgreSQL (local or Docker)
docker run --name ecommerce-db -e POSTGRES_PASSWORD=yourpwd -p 5432:5432 -d postgres:14

# Import schema and sample data
psql -U postgres -h localhost -f db/schema.sql
psql -U postgres -h localhost -f db/seed.sql
```

### 2. Verify SQL Queries

Test KPI queries from your SQL client or CLI:

```bash
psql -U postgres -h localhost -d ecommerce_sales -f analytics/kpi_queries.sql
psql -U postgres -h localhost -d ecommerce_sales -f analytics/anomaly_rules.sql
```

### 3. Set Up Power BI

1. Open Power BI Desktop
2. **Get Data** → PostgreSQL
3. Connect to your database (host: localhost, port: 5432)
4. Import the `orders` table and KPI views
5. Create visuals:
   - Revenue trends (line chart)
   - Category breakdown (stacked column)
   - Anomaly indicators (cards + highlights)
6. Save as `dashboards/Ecommerce_Sales_Intel.pbix`

### 4. Deploy n8n Workflow

```bash
# Option A: Local n8n
npm install -g n8n
n8n start

# Option B: Docker
docker run -it --rm --name n8n -p 5678:5678 \
  -e DB_TYPE=postgresdb \
  -e DB_POSTGRESDB_HOST=host.docker.internal \
  n8nio/n8n:latest
```

1. Open http://localhost:5678
2. Import `automation/n8n_workflow.json`
3. Configure:
   - PostgreSQL connection (host, port, credentials)
   - Email settings (SMTP, recipient)
4. Enable the workflow and set cron to daily at 09:00 AM

---

## 📊 Key Metrics & Features

### KPIs Calculated

| Metric | Query | Frequency | Use Case |
|--------|-------|-----------|----------|
| **Daily Revenue** | `SUM(revenue) GROUP BY date` | Daily | Track sales performance |
| **Order Volume** | `COUNT(*) GROUP BY date` | Daily | Monitor transaction activity |
| **AOV** | `AVG(revenue) GROUP BY date` | Daily | Assess customer spending |
| **Category Performance** | `SUM/COUNT GROUP BY category` | Daily | Product-level insights |
| **WoW Growth %** | `LAG() OVER (ORDER BY week)` | Weekly | Trend analysis |

### Anomaly Detection Rules

```sql
-- Rule 1: Revenue drops > 30% vs 7-day moving average
WHERE daily_revenue < ma_7d * 0.7

-- Rule 2: Revenue spikes > 50% vs 7-day moving average
WHERE daily_revenue > ma_7d * 1.5

-- Rule 3: Order volume unusual (similar logic)
WHERE order_count < avg_7d * 0.7 OR order_count > avg_7d * 1.5
```

When anomalies are detected:
1. Query triggers in n8n (cron: 09:00 AM daily)
2. Results aggregated into alert message
3. Email sent to analytics team with:
   - Anomaly date & metric
   - % deviation from baseline
   - Suggested next steps
4. Incident logged for audit trail

---

## 📈 Dashboard Views

### Page 1: Executive Overview
- KPI cards (Revenue, Orders, AOV)
- Revenue trend line chart
- Revenue by region (bar)
- Date range slicer

### Page 2: Category Performance
- Stacked column (revenue by category over time)
- Category performance table
- Category-level AOV and order count

### Page 3: Anomaly Monitor
- Anomaly incidents table (date, metric, deviation %)
- Incident count KPI
- Revenue line with anomaly markers (red highlights)

---

## 🔔 Alert Examples

**Email Subject**: `[ALERT] E-commerce Anomaly Detected - 2025-01-31`

**Email Body**:
```
Hello,

An anomaly was detected in your e-commerce sales data:

📉 REVENUE DROP
Date: 2025-01-31
Daily Revenue: $45,230
7-Day Average: $62,100
Deviation: -27.1%

Recommended Actions:
- Check for operational issues (downtime, outages)
- Review marketing campaigns
- Contact customer support for feedback

Full details: [Link to Power BI Dashboard]
Incident ID: INC-20250131-001

---
Automated E-Commerce Analytics
```

---

## 🛠️ Tech Stack

- **Database**: PostgreSQL 14+
- **SQL Engine**: Native queries (window functions, CTEs)
- **BI Tool**: Power BI Desktop / Power BI Service
- **Automation**: n8n (low-code workflow engine)
- **Notifications**: SMTP (email)
- **Version Control**: Git + GitHub

---

## 📚 Documentation

Detailed guides are in the `/docs` folder:

- **`architecture.md`**: System design, data flow, scalability notes
- **`deployment.md`**: Cloud deployment (Azure, AWS) & Docker setup
- **`sample_alerts.md`**: Example anomaly reports and incident logs

---

## 🎓 Learning Outcomes

This project demonstrates:

✅ **Data Engineering**: ETL pipelines, SQL optimization, data quality  
✅ **Analytics**: KPI design, trend analysis, statistical reasoning  
✅ **BI**: Interactive dashboards, data visualization best practices  
✅ **Automation**: Scheduled workflows, event-driven logic, notifications  
✅ **DevOps**: Database setup, local development, deployment  

---

## 🚦 Getting Help

- Check the `/docs` folder for detailed setup guides
- Review SQL queries in `/analytics` for metric definitions
- Inspect n8n workflow in `/automation` for automation logic
- See `/db/README.md` for database troubleshooting

---

## 📝 License

MIT License - Feel free to use this as a portfolio project or learning resource.

---

## 🙌 What This Demonstrates

This is a **realistic analytics engineering project** that mirrors what you'd find at:
- Analytics consulting firms (McKinsey, Accenture BI practices)
- Enterprise data teams (data warehousing + BI + automation)
- E-commerce analytics platforms

Perfect for:
- **Portfolio**: Shows full-stack analytics capability
- **Interviews**: Demonstrates SQL, BI, automation, and problem-solving
- **Learning**: Hands-on experience with modern analytics stack
