# QUARTERLY-DEFERRED-INCOME-SQL-SCRIPT-FOR-FINANCE-DEPARTMENT

SQL scripts for generating quarterly deferred income and repayment summaries for the Finance Department of a tech company. Includes support for Legacy, B7/B9, and L1 platforms, with clear segmentation by reporting period (Q1 &amp; Q3 2024).


# 📊 Quarterly Deferment Reporting Scripts – Finance Department

This repository contains SQL scripts used by the Finance Department of a tech company to generate quarterly deferment and repayment reports across various platforms (B7/B9, Legacy, and L1). These scripts are designed to extract and aggregate financial data used for deferred revenue analysis, compliance reporting, and financial planning.

---

## 📁 Files

### `quarterly_deferment_report_q1_q3_2024.sql`

This script includes three main sections:

1. **Legacy Contracts (Q1 2024)**  
   Aggregates deferment and repayment data for legacy contracts as of March 31, 2024.

2. **B7_B9 Platform Contracts (Q3 2024)**  
   Pulls contract activity and repayment summaries for B7/B9 customers for the quarter ending September 30, 2024.

3. **L1 Platform Contracts (Q3 2024)**  
   Extracts deferment and repayment data from the L1 platform, excluding outright purchase plans.

Click to access the SQL Script Link: [QUARTERLY DEFERRED INCOME SQL SCRIPT FOR FINANCE DEPARTMENT](https://github.com/Oladipupo09/QUARTERLY-DEFERRED-INCOME-SQL-SCRIPT-FOR-FINANCE-DEPARTMENT/blob/main/quarterly_deferment_report_q1_q3_2024.sql)
---

## 🗂️ Data Sources

- `b9_b7_status`, `b9_b7_status_table`, `b9_b7_mar_customer_status`: Status and lifecycle data of contracts.
- `b9_b7_paidperiod`: Tracks paid periods for B7/B9 customers.
- `b9_b7_repayment_data_lake`: Detailed repayment transactions, filtered for valid records only.
- `upya_activity_log`, `upya_daily_transactions`: Activity logs and financial transactions on the L1 platform.

---

## 📅 Reporting Dates

- Q1 2024: February 1, 2024 – March 31, 2024
- Q3 2024: July 1, 2024 – September 30, 2024

These time windows are defined in the scripts using `WHERE` clauses to filter by relevant `report_date` and `payment_date` fields.

---

## 🛠️ Usage

1. Open the SQL script in your preferred SQL IDE (e.g., MySQL Workbench, DBeaver).
2. Update the `report_date`, `payment_date`, or table names if needed.
3. Execute the script to generate quarterly deferment summary reports.
4. Export results for integration with financial reporting tools (e.g., Power BI, Excel, ERP systems).

---

## 🔒 Disclaimer

This script is designed for internal use by the Finance and Analytics teams. It assumes access to proprietary tables and fields. Do not share outside the organization without necessary approvals.

---

## 👨‍💻 Author

Prepared by: [Wasiu Musa Oladipupo] |[Linkedin](https://www.linkedin.com/in/musa-wasiu/)  
Role: Data Analyst / BI Analyst  
Team: Data Science & Analytics  
Date: April 2025  
