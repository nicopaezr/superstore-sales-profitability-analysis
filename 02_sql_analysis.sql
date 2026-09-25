-- Superstore Sales & Profitability Analysis
-- SQL Analysis

-- SQL - System used: DuckDB
-- File used: superstore_cleaned_dataset.csv
-- The following statement creates the table used throughout this analysis:

CREATE TABLE superstore AS
SELECT *
FROM read_csv('data/superstore_cleaned_dataset.csv');

-- =======================================================================
-- 1. OVERALL SALES AND PROFIT PERFORMANCE
-- =======================================================================
-- Purpose: Validate the overall performance metrics calculated during the 
-- initial Python analysis to establish a baseline for the superstore analysis. 

-- * What is the overall size of the business?
SELECT 
    COUNT(DISTINCT "Order ID") AS total_orders, 
    COUNT(DISTINCT "Customer ID") AS total_customers, 
    COUNT(DISTINCT "Product ID") AS total_products 
FROM superstore;

-- * What are the total sales and profit?
SELECT 
    SUM(Sales) AS total_sales, 
    SUM(Profit) AS total_profit 
FROM superstore;

-- * What is the profit margin?
SELECT
    (SUM(Profit) / SUM(Sales)) * 100 AS profit_margin 
FROM superstore;

-- Are sales and profit growing?
SELECT
    "Year",
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY "Year"
ORDER BY "Year";
-- Sales and profit increased overall from 2014 to 2017, with both reaching
-- their highest levels in 2017.

-- =======================================================================
-- 2. PRODUCT PERFORMANCE
-- =======================================================================
-- Purpose: Identify which products and categories are actually driving 
-- sales and profitability.

-- * Which product categories generate the most sales and profit?
SELECT
    Category,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY Category
ORDER BY total_sales DESC;
-- Technology has the highest sales and highest profit. 
-- Although Furniture has the second-highest sales, it has the lowest profit.

-- * Which product sub-categories contribute the most to sales and profit?
SELECT
    "Sub-Category",
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY "Sub-Category"
ORDER BY total_sales DESC;
-- Phones, Chairs, and Storage generate the most sales.
-- Copiers, Phones, and Accessories generate the most profit.
-- Three sub-categories generate negative profit: Supplies, Bookcases, and Tables.

-- * Which individual products generate the most sales?
SELECT
    "Product Name",
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY "Product Name"
ORDER BY total_sales DESC
LIMIT 10;
-- The Canon imageCLASS 2200 Advanced Copier generates the highest sales.
-- Several products with high sales generate little or negative profit.

-- * Which individual products generate the most profit?
SELECT
    "Product Name",
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY "Product Name"
ORDER BY total_profit DESC
LIMIT 10;
-- The Canon imageCLASS 2200 Advanced Copier also generates the highest profit by far.

-- * Which products are losing money?
SELECT
    "Product Name",
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY "Product Name"
HAVING total_profit < 0
ORDER BY total_profit ASC
LIMIT 10;
-- The Cubify CubeX 3D Printer Double Head Print has the largest loss at approximately $8,880.

-- =======================================================================
-- 3. CUSTOMER ANALYSIS
-- =======================================================================
-- Purpose: Identify which types of customers are most valuable to the business.

-- * Which customer segments generate the most sales and profit?
SELECT
    Segment,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY Segment
ORDER BY total_sales DESC;
-- Consumer customers generate the highest sales and profit among the three segments.

-- * Which individual customers generate the most sales?
SELECT
    "Customer ID",
    "Customer Name",
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY "Customer ID", "Customer Name"
ORDER BY total_sales DESC
LIMIT 10;
-- Sean Miller generates the highest sales among customers but results in a loss of approximately $1,980.

-- * Which individual customers generate the most profit?
SELECT
    "Customer ID",
    "Customer Name",
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY "Customer ID", "Customer Name"
ORDER BY total_profit DESC
LIMIT 10;
-- Tamara Chand generates the highest profit, with approximately $8,980 in profit.

-- * Which customers generate high sales but negative profit?
SELECT
    "Customer ID",
    "Customer Name",
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY "Customer ID", "Customer Name"
HAVING SUM(Sales) > 10000
   AND SUM(Profit) < 0
ORDER BY total_sales DESC;
-- Two customers with high sales generate negative profit, showing that
-- high customer sales do not necessarily translate into profitability.

-- =======================================================================
-- 4. REGIONAL ANALYSIS
-- =======================================================================
-- Purpose: Identify which regions are driving sales and profitability to 
-- establish where performance may need further investigation.

-- * Which regions generate the most sales and profit?
SELECT
    Region,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY Region
ORDER BY total_sales DESC;
-- The West generates the highest sales and profit.
-- The Central region generates the lowest profit despite having higher sales than the South.

-- * Which states generate the most sales?
SELECT
    "Region",
    "State",
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY "Region", "State"
ORDER BY total_sales DESC
LIMIT 10;
-- California and New York generate the highest sales by a considerable margin.
-- Half of the ten highest-sales states generate negative profit.
-- Texas ranks third in sales but generates approximately $25.7K in losses.

-- * Which states generate the most profit?
SELECT
    "Region",
    "State",
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY "Region", "State"
ORDER BY total_profit DESC
LIMIT 10;
-- California and New York generate substantially more profit than the other states in the top 10.

-- * Which states generate negative profit?
SELECT
    "Region",
    "State",
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY "Region", "State"
HAVING total_profit < 0
ORDER BY total_profit ASC;
-- Ten states across all four regions generate negative profit.
-- Texas has the largest loss despite generating $170,188 in sales.

-- =======================================================================
-- 5. DISCOUNTS AND PROFITABILITY ANALYSIS
-- =======================================================================
-- Purpose: Determine how discounts affect profitability.

-- * How does profitability change across different discount levels?
SELECT
    Discount,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
FROM superstore
GROUP BY Discount
ORDER BY Discount DESC;
-- Discount levels above 20% generate negative total profit.
-- The highest discount levels produce substantial losses despite generating sales.

-- How many of the transactions are being sold at high discount levels? What is the profit
-- associated with these transactions?
SELECT
    COUNT(*) AS total_transactions,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore
WHERE Discount >= 0.3;
-- There were 1,393 transactions with discounts of 30% or more and generated 
-- approximately $362,800 in sales but resulted in an overall loss of around $135,400.

-- ==================================================================================
-- The analysis identified key differences in sales and profitability across
-- products, customers, regions, and discount levels. Several areas showed
-- strong sales but comparatively low or negative profit. 
-- ==================================================================================