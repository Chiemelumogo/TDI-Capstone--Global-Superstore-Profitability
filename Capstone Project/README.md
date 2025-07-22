# Global Superstore Profitablity Analytics Project

This project analyzes transactional data from a fictional Global Superstore to uncover key business insights, identify growth opportunities, and provide actionable recommendations. Using SQL and data visualization tools, we explored customer behavior, product performance, seasonal trends, and regional profitability to support data-driven decision-making.

---

## Project Overview

- **Goal:** To analyze and derive strategic insights from Global Superstore data to improve sales, profitability, and operational efficiency.
- **Scope:** Customer segmentation, sales trends, product profitability, shipping logistics, regional performance, and discount effectiveness.
- **Tools Used:**  
  - SQL Server (Data cleaning, transformation, querying)   
  - Excel (Data export, pivoting)  

---

## Objectives

-  Evaluate Products and Categories Performance  
-  Understand Customer Behavior  
-  Analyze Time-Based/Seasonal Trends  
-  Assess Performance Based on Locations  

---

## Data Cleaning & Transformation

- Loaded the dataset into SQL Server with correct data types
- Created separate `Customers` and `Products` tables
- Removed redundant columns, standardized text, checked for duplicates
- Created calculated columns: `Cost` and `Profit Margin`
- Postal Code was the only field with null values

---

## Key Metrics (2011–2014)

| Metric                        | Value             |
|------------------------------|-------------------|
| Revenue                      | $12.64 Million    |
| Profit                       | $1.46 Million     |
| Profit Margin                | 4.74%             |
| Total Orders                 | 51,290            |
| Total Customers              | 1,590             |
| Products Sold                | 10,768            |
| Countries                    | 147               |
| Customer Segments            | 3                 |
| Product Categories           | 3                 |

---

## Insights Summary

### Customer Behavior
- Consumer segment generated the most revenue and profit
- 67 customers accounted for a loss of $65,513  
- Top 10 customers can be targeted for loyalty rewards

### Seasonal Trends
- Peak months: **June, August–December** (esp. November & December)
- Low performance: **January, February, April, July**
- Weekends (Sat/Sun): Lowest revenue and profit days

### Product Performance
- Technology had the highest profit share (45%)  
- 3,032 unprofitable products → $558,757 in losses (28.2%)  
- Office Supplies had the highest number of loss-making products

### Regional Analysis
- Southeast Asia had high revenue but negative profit margins  
- Canada had low revenue but the **highest** profit margin (24.75%)  
- 29 countries experienced losses worth $447,899  
  - EMEA ($245k), Africa ($177k), Central region ($176k)

---

## Recommendations

- Reward high-value customers to retain loyalty  
- Reevaluate or phase out unprofitable products  
- Boost campaigns during underperforming months  
- Optimize stock levels for peak seasons  
- Review pricing/cost models in loss-making regions  
- Consider weekend cost reduction strategies (e.g., closing Sundays)  
- Drill down into products, customers, and regions for targeted actions  

---

## Deliverables

- Global Superstore csv file
- SQL Scripts for data transformation and analysis
- PowerPoint Presentation (.pptx)
