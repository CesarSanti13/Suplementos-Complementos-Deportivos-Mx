# 🏋️‍♂️ Suplementos Deportivos — Data Pipeline ETL & Analytics

## 🎯 Project Overview
**Objective:**  
Standardize, automate, and centralize all historical sales data to improve strategic decision-making across marketing, production, and customer relationship management.  

This project implements a **complete data pipeline**:  
- Source data from Excel exports (from the company’s internal system).  
- ETL automation with **n8n** and **Python (pandas)**.  
- Centralized storage on **MySQL hosted on a VPS (Hostinger)**.  
- Interactive dashboards in **Looker Studio** powered by SQL views connected to MySQL on VPS.
---
## 📊 Exploratory Data Analysis (EDA) — Insights Discovery Phase

Before developing the ETL automation, an **Exploratory Data Analysis (EDA)** was conducted using Python to better understand sales behavior and identify early business insights that guided the data modeling and BI dashboard design.

**Objectives**
- Detect and quantify **sales trends** by *category, brand, and product line*.
- Identify **top-performing customers** based on total revenue and units sold.
- Measure **average margins and commissions** to validate profitability assumptions.
- Detect **data inconsistencies** and define normalization rules for later ETL implementation.

---
## 🔁 ETL Automation (n8n)

**Data source:** Excel files exported from the company’s sales management software.

**ETLs implemented:**
1. **Sales ETL** → Cleans and loads sales into MySQL.  
2. **Sales Detail ETL** → Cleans, calculates commissions/margins and real Total Sale, loads into MySQL and sends a QA copy to Google Sheets.
3. **Inventory ETL** → Cleans inventory structure (no database storage, only standardization for sharing with Clients).

**Execution trigger:**  
- **Google Drive node** activates when a new file is created in a specific path.  
- Each ETL flow standardizes column names and formats according to the MySQL schema.

**Target:** MySQL service storage data hosted on **Hostinger VPS (Easy Panel)**.

<img width="910" height="158" alt="image" src="https://github.com/user-attachments/assets/f2554b5e-8665-420f-b08c-b7eb4d986b6f" />
<img width="962" height="292" alt="image" src="https://github.com/user-attachments/assets/13eb169e-8170-4537-bad5-db3dbb6e8503" />
<img width="642" height="366" alt="image" src="https://github.com/user-attachments/assets/5f83f99c-a598-4634-85da-fafdd274f358" />

---
## 🧠 Data Cleaning & Transformation (Python in n8n)

**Processes:**
- Standardizes column formats for MySQL insertion.  
- Converts dates into SQL-compatible format.  
- Generates missing columns (e.g., `UnitPrice`,`commissions`,`Business real Margin`).  
- Renames fields to match database schema.  
- Type casting (int, float).
- Removes unnecessary or sensitive columns as requested by the client.

**Execution:** Python code node in **n8n**.  
**Libraries used:** `Pandas`, `Datetime`.  
**Outputs:**
- **Sales:** inserted directly into MySQL.  
- **Sales Detail:** inserted into MySQL and also exported to Google Sheets for QA.  
- **Inventory:** cleaned only (no storage).
---
- ## 🗄️ Database Model (MySQL on VPS)
A **fully relational database** was **designed and implemented from scratch** in **MySQL**, hosted on a **private VPS (Hostinger)**.  
The schema was modeled specifically for analytical purposes, ensuring data normalization, referential integrity, and scalability for future BI, automation layers and own software for business.

**Main tables:**
- `Cliente`, `Producto`, `Venta`, `Detalleventa`, `Direcciones`, `Empleados`, `Marca`, `Categoria`, `Cotizacion`,`DetalleCotizacion`.

**Generated Columns:**
- `DetalleVenta`: `costoSnapShotTotal`, `subTotalDetalleVenta`, `totalDetalleVenta`, `margen`, `montoComision`, `margenEmpresa`.  
- `Venta`: `totalVenta`.  

**SQL Views:**
- `FeedLookerStudio` aggregates:
  - Total sales
  - Margins
  - Real company profit (after commissions)
  - Sales by product, category, brand, client, and region.

**Hosting:**  
MySQL hosted on **Hostinger VPS** via **Easy Panel**, managed with **phpMyAdmin**.

---

- ## 🧱 ER Diagram
<img width="700" height="700" alt="image" src="SQL Data Base/E-R Data Base Suplementos & Complementos Deportivos Mx.png" />

The database follows a **3NF relational structure** optimized for analytics, with consistent relationships, generated columns for margin and commissions, and a view (`FeedLookerStudio`) designed for BI consumption.

---
## 📊 Business Intelligence Dashboard (Looker Studio)

**Key metrics:**
- Monthly and yearly **sales trends**.  
- **Top-selling brands** and **highest-margin categories**.  
- **Total sales, margins, commissions, and real company profit** per month.  
- **Heatmaps** by state for market presence.  
- **Top 10 products** and **top customers** by contribution.  

**Charts used:** bars, lines, maps, KPI cards.  
**Filters:** date, brand, category, state.  
**Users:** business management and marketing teams for driven decisions.  
**Connection:** direct SQL view (`FeedLookerStudio`) from VPS database.

---

## ⚙️ Tech Stack

| Layer | Tool / Technology | Description |
|-------|-------------------|-------------|
| Infrastructure | **Hostinger VPS (Linux + Easy Panel)** | Self-hosted database and automation environment owned by client |
| Database | **MySQL** | Relational model with generated columns and views |
| ETL Automation | **n8n** | Workflow automation and trigger management |
| Data Transformation | **Python** (`Pandas`, `Datetime`) | Cleaning and data standardization |
| QA Layer | **Google Sheets** | Optional layer for data insertion validation |
| BI Visualization | **Looker Studio** | Real-time analytics dashboards |

---

## 🚀 Business Impact

- Enabled **data-driven decision-making** for marketing and logistics.  
- Identified **top-performing brands, categories and products** by margin and units sold.  
- Mapped **regional presence** for focused marketing campaigns.  
- Supported **manufacturing decisions** — producing more of what sells best on a specific brand.  
- Reduced manual workload from hours to **automated ETLs in minutes**.  
- Delivered a single source of truth for all KPIs and commissions.

---

## 🔒 Confidentiality & Intellectual Property Notice

This repository has been published **with the express authorization of the client** for the purpose of showcasing the **technical architecture, database design, and ETL workflows** developed during the project.  

All information presented here — including the data model, SQL schema, and ETL logic — reflects the actual structure implemented for the client’s analytics ecosystem.  
However, **no real business data, financial information, or client identifiers** are included. All datasets, screenshots, and visuals have been **sanitized, anonymized, or reconstructed** using simulated data solely for demonstration purposes.

This publication aims to **demonstrate the engineering, analytical, and architectural capabilities** behind the project, while maintaining full respect for the client’s intellectual property and data privacy.
 ---
![Python](https://img.shields.io/badge/Python-3.10+-blue)
![Pandas](https://img.shields.io/badge/Pandas-Data%20Handling-green)
![Jupyter](https://img.shields.io/badge/Jupyter-Notebooks-orange)
![MySQL](https://img.shields.io/badge/MySQL-Database-orange)
![SQL](https://img.shields.io/badge/SQL-Queries-blue)
![phpMyAdmin](https://img.shields.io/badge/phpMyAdmin-Management-lightgrey)
![n8n](https://img.shields.io/badge/n8n-Automation-red)
![ETL](https://img.shields.io/badge/ETL-Data%20Pipeline-green)
![Hostinger](https://img.shields.io/badge/Hostinger-VPS-lightgrey)
![Linux](https://img.shields.io/badge/Linux-Server-black)
![Looker Studio](https://img.shields.io/badge/Looker%20Studio-BI%20Dashboard-purple)
