----Creating the database Retail_data

CREATE DATABASE RETAIL_DATA

USE RETAIL_DATA

----IMPORTING THE RETAIL DATA INTO THE DATABASE
SELECT * FROM data_retail

----Identifies products with prices higher than the average price within their category.
SELECT Category,AVG(PRICE) FROM data_retail
group by Category
 
 ----
WITH CategoryAveragePrice AS (
    SELECT Category, AVG(Price) AS AvgPrice 
    FROM data_retail
    GROUP BY Category
)
SELECT dr.Product_ID, dr.Product_Name, dr.Category, dr.Price      
FROM data_retail dr
INNER JOIN CategoryAveragePrice cap
ON dr.Category = cap.Category
WHERE dr.Price > cap.AvgPrice;


/*The products with prices higher than the average price within their category are:
Electronics and Home*/

---------------------------------------------------------------------------

------Finding Categories with Highest Average Rating Across Products

select * from data_retail
SELECT Category,Product_Name,AVG(PRICE) as average_rating FROM data_retail
group by Category,Product_Name
order by average_rating desc

---------------------------------------------------------------------------

---Find the most reviewed product in each warehouse

select * from data_retail

SELECT Warehouse, Product_Name, Reviews
FROM (
    SELECT Warehouse, Product_Name, COUNT(*) AS Reviews,
           ROW_NUMBER() OVER (PARTITION BY Warehouse ORDER BY COUNT(*) DESC) AS rn
    FROM data_retail
    GROUP BY Warehouse, Product_Name
) subquery
WHERE rn = 1;

-------------------------------------------------------------------------------

--find products that have higher-than-average prices within their category, along with their discount and supplier.

WITH CategoryAveragePrices AS 
(SELECT Category,AVG(Price) AS avg_price FROM data_retail dr
GROUP BY Category)
SELECT
    dr.Product_ID,
    dr.Product_Name,
    dr.Price,
    dr.Category,
    dr.Discount,
    dr.Supplier
FROM
    data_retail dr
JOIN
    CategoryAveragePrices cap ON dr.Category = cap.Category
WHERE
    dr.Price > cap.avg_price
ORDER BY
    dr.Category, dr.Price DESC;

-----------------------------------------------------------------

----Query to find the top 2 products with the highest average rating in each category

with CategoryRating as(
select Category,Product_ID,Product_Name,Rating,
rank() over (partition by category order by rating desc) as ranking from data_retail)
SELECT Category,Product_ID,Product_Name,Rating FROM CategoryRating
WHERE ranking <= 2
ORDER BY Category, ranking;

----------------------------------------------------------------------

-----Analysis Across All Return Policy Categories(Count, Avgstock, total stock, weighted_avg_rating, etc)

select Return_Policy,count(*) as Product_Count , Avg(Stock_Quantity) as Average_Stock , sum(Stock_Quantity) as Total_stock , 
SUM(Rating * Stock_Quantity) / SUM(Stock_Quantity) AS weighted_avg_rating from data_retail
group by Return_Policy
order by Return_Policy

----------------------------------------------------------------------


