# SQL_DataAnalytics

# Global Layoffs Data Analysis Using SQL

## Project Overview
This project analyzes global layoff trends using SQL. The dataset contains information about companies, industries, locations, funding, and the number of employees laid off.

The project focuses on two major stages:

1. Data Cleaning & Preparation
2. Exploratory Data Analysis (EDA)

The objective is to transform raw layoff data into a clean dataset and extract meaningful business insights through SQL queries.

---

## Tools Used

- MySQL
- SQL
- Window Functions
- Common Table Expressions (CTEs)
- Aggregate Functions
- Data Cleaning Techniques

---

## Dataset Features

The dataset includes:

- Company Name
- Industry
- Location
- Country
- Date
- Total Employees Laid Off
- Percentage Laid Off
- Funding Raised
- Company Stage

---

## Data Cleaning Process

### 1. Duplicate Removal
- Identified duplicate records using `ROW_NUMBER()`
- Created a cleaned table containing unique records only

### 2. Standardization
- Trimmed unnecessary spaces from company names
- Standardized company categories (e.g., Crypto companies)
- Corrected location formatting issues
- Standardized country names
- Converted date column into proper SQL Date format

### 3. Handling Missing Values
- Replaced blank values with NULLs
- Filled missing industry values using existing company records
- Removed rows where both layoff count and layoff percentage were unavailable

### 4. Final Dataset Preparation
- Removed temporary columns used during cleaning
- Prepared the final dataset for analysis

---

## Exploratory Data Analysis

### Key Questions Answered

### Company Analysis
- Which companies had the largest single layoffs?
- Which companies laid off the highest number of employees overall?

### Geographic Analysis
- Layoffs by location
- Layoffs by country

### Industry Analysis
- Industries with the highest layoffs
- Industry-wise trends

### Time-Series Analysis
- Layoffs by year
- Monthly layoffs trend
- Rolling cumulative layoffs over time

### Startup & Funding Analysis
- Companies with 100% workforce layoffs
- Relationship between funding raised and layoffs

### Ranking Analysis
- Top companies with the highest layoffs each year
- Used `DENSE_RANK()` to identify yearly leaders

---

## SQL Concepts Demonstrated

- Data Cleaning
- Joins
- Aggregate Functions
- GROUP BY
- ORDER BY
- Window Functions
  - ROW_NUMBER()
  - DENSE_RANK()
  - SUM() OVER()
- Common Table Expressions (CTEs)
- Date Functions
- Data Transformation

---

## Key Insights

- Several startups experienced 100% workforce layoffs, indicating complete shutdowns.
- Technology and crypto-related companies were among the most impacted sectors.
- Layoffs peaked during specific economic downturn periods.
- A small number of companies contributed significantly to total layoffs globally.
- Rolling trend analysis revealed periods of accelerated workforce reductions.
