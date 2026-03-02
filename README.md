# Cards Analysis using SQL

This is a beginner-level SQL project where I analyzed a credit card dataset using PostgreSQL (pgAdmin).  
The goal of this project was to practice real-world SQL analysis by exploring card distribution, customer behavior, and credit exposure patterns.

---

## Dataset

Source - https://www.kaggle.com/datasets/computingvictor/transactions-fraud-datasets 

The dataset contains information about:
- card brand and card type
- client IDs
- credit limits
- chip availability
- number of cards issued
- card usage attributes

---

## Project Workflow

### 1. Data Validation
- verified total rows loaded
- previewed dataset structure
- checked null values
- explored distinct card categories

### 2. Data Preparation
The `credit_limit` column was stored as text (with `$` and commas).  
Converted this into a numeric column to allow aggregation and calculations.

### 3. Analysis Performed
The following questions were answered using SQL:

- total cards and unique clients
- card distribution by brand and type
- average credit limit comparison across brands
- top clients by total credit exposure
- identification of multi-card customers
- credit limit segmentation (low / medium / high)
- card issuance distribution
- chip vs non-chip comparison
- ranking brands by total credit exposure

---

## SQL Concepts Used
- SELECT, WHERE
- GROUP BY, HAVING
- Aggregate functions (COUNT, SUM, AVG)
- CASE statements
- Data cleaning using UPDATE
- Window function: `RANK()`

uthor
SQL learning portfolio project.
