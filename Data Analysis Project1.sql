select * from project_1.store;

/* Create Table */

CREATE TABLE IF NOT EXISTS store (
Row_ID SERIAL,
Order_ID CHAR(25),
Order_Date DATE,
Ship_Date DATE,
Ship_Mode VARCHAR(50),
Customer_ID CHAR(25),
Customer_Name VARCHAR(75),
Segment VARCHAR(25),
Country VARCHAR(50),
City VARCHAR(50),
States VARCHAR(50),
Postal_Code INT,
Region VARCHAR(12),
Product_ID VARCHAR(75),
Category VARCHAR(25),
Sub_Category VARCHAR(25),
Product_Name VARCHAR(255),
Sales FLOAT,
Quantity INT,
Discount FLOAT,
Profit FLOAT,
Discount_amount FLOAT,
Years INT,
Customer_Duration VARCHAR(50),
Returned_Items VARCHAR(50),
Return_Reason VARCHAR(255)
);

/* checking the raw Table */
select count(*) from store;

-- DATASET  INFORMATION
-- Customer_Name   : Customer's Name
-- Customer_Id  : Unique Id of Customers
-- Segment : Product Segment
-- Country : United States
-- City : City of the product ordered
-- State : State of product ordered
-- Product_Id : Unique Product ID
-- Category : Product category
-- Sub_Category : Product sub category
-- Product_Name : Name of the product
-- Sales : Sales contribution of the order
-- Quantity : Quantity Ordered
-- Discount : % discount given
-- Profit : Profit for the order
-- Discount_Amount : discount  amount of the product 
-- Customer Duration : New or Old Customer
-- Returned_Item :  whether item returned or not
-- Returned_Reason : Reason for returning the item

/* Count Number of columns in table */
SELECT COUNT(*) AS column_count
FROM information_schema.columns
WHERE table_schema = 'project_1'
  AND table_name = 'store';
  
  -- Show Table Information 
  show columns from store;
  describe project_1.store;

-- Check Null values in table
SELECT * FROM store
WHERE (select column_name
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='store') IS NULL;

/* Check the count of United States */
select count(Country) from project_1.store
where Country='United States';

/* PRODUCT LEVEL ANALYSIS*/
-- What are the unique product categories? 
select distinct(category) from project_1.store;

-- What is the number of products in each category?
select Category,count(Product_ID) from project_1.store group by Category;

-- Find the number of Subcategories products that are divided into.
select count(distinct(Sub_Category)) as No_of_Sub_Category from project_1.store; 

--  Find the number of products in each sub-category.
select Sub_Category, count(Product_ID) from project_1.store group by Sub_Category;

-- Find the number of unique product names.
select count(distinct(Product_Name)) as Unique_products from project_1.store; 

-- Which are the Top 10 Products that are ordered frequently?
select product_name, count(product_id) from project_1.store group by Product_Name order by count(Product_ID) desc limit 10;

/* Calculate the cost for each Order_ID with respective Product Name. */
select product_name,order_id,round(sum(sales-profit),2) as Cost from project_1.store group by Product_Name,Order_ID order by Cost desc;

/* Calculate % profit for each Order_ID with respective Product Name. */
select Order_ID,product_name, round(((profit/(sales-profit))*100),2) as Profit_percentage from project_1.store group by Order_ID,product_name, Profit_percentage;

/* Calculate the overall profit of the store. */
select round(sum(profit),3) as Overall_Profit from project_1.store;

/* Calculate percentage profit and group by them with Product Name and Order_Id. */
select order_id, Product_Name, round((profit/(sales-profit))*100),2) as Percentage_profit from project_1.store group by order_id,Product_Name,Percentage_Profit order by percentage_Profit desc;

/* Where can we trim some loses? 
   In Which products?
   We can do this by calculating the average sales and profits, and comparing the values to that average.
   If the sales or profits are below average, then they are not best sellers and 
   can be analyzed deeper to see if its worth selling thema anymore. */
   
select Product_id, Sales,Profit,
case 
 when Sales > (select AVG(Sales) from store) and  Profit > (select avg(Profit) from store) then "Best Seller"
 else "Bad Seller"
end as Case1
from project_1.store
group by Product_ID,Sales,Profit;

-- Average sales per sub-cat
select Sub_Category, round(avg(Sales),2) as Avg_sales
from project_1.store
group by Sub_Category
order by Avg_sales desc;

-- Average profit per sub-cat
select Sub_Category, round(avg(Profit),2) as Avg_profit
from project_1.store 
group by Sub_Category
order by Avg_profit desc;

/* CUSTOMER LEVEL ANALYSIS*/
/* What is the number of unique customer IDs? */
select count(distinct(Customer_ID)) as Unique_cust_id from project_1.store;

/* Find those customers who registered during 2014-2016. */
select Years, Customer_id, Customer_name
from project_1.store
where Years between 2014 and 2016
order by Years;

/* Calculate Total Frequency of each order id by each customer Name in descending order. */
select Customer_name,Order_id, count(Order_id) as Order_frequency
from project_1.store
group by Customer_Name, Order_id
order by Order_frequency desc;

/* Calculate  cost of each customer name. */
select Customer_Name, round((Sales-Profit),2) as Cost
from project_1.store
group by Customer_Name,Cost;

/* Display No of Customers in each region in descending order. */
select Region, count(Customer_id) as No_Of_Customers
from project_1.store
group by Region
order by No_of_Customers desc;

/* Find Top 10 customers who order frequently. */
select Customer_Name,count(Customer_ID) as No_Of_Customers
from project_1.store
group by Customer_ID,Customer_Name
order by count(Customer_ID) desc
limit 10;

/* Display the records for customers who live in state California and Have postal code 90032. */
select Customer_ID, Customer_Name,Country, States,City, Postal_Code,Region,Customer_Duration
from project_1.store
where States = 'California' and Postal_Code = 90032
order by Customer_ID;

/* Find Top 20 Customers who benefitted the store.*/
select Customer_ID,Customer_Name, round(sum(Profit),2) Total_Profit
from project_1.store
group by Customer_ID,Customer_Name
order by sum(Profit) desc
limit 20;

-- Which state(s) is the superstore most succesful in? Least?
-- Top 10 results:
select States, round(sum(sales),2) Total_sales
from project_1.store
group by States
order by Total_sales desc
limit 10;

/* ORDER LEVEL ANALYSIS */
/* number of unique orders */
select count(distinct(Order_ID)) as Unique_orders
from project_1.store;

/* Find Sum Total Sales of Superstore. */
select round(sum(Sales),2) as Total_sales
from project_1.store;

/* Calculate the time taken for an order to ship and converting the no. of days in int format. */
select Order_ID,Order_Date,(Ship_Date-Order_Date) as Delivery_days, Ship_Mode
from project_1.store
order by Order_ID;

/* Extract the year  for respective order ID and Customer ID with quantity. */
select Customer_ID, Order_ID, Years, Quantity
from project_1.store
order by Years;

-- OR

select Customer_ID,Order_ID, Quantity,year(Order_Date) as Yearss
from project_1.store
order by Yearss desc;

/* What is the Sales impact? */
SELECT EXTRACT(YEAR from Order_Date), Sales, round((profit/((sales-profit))*100),2) as profit_percentage
FROM store
GROUP BY EXTRACT(YEAR from Order_Date), Sales, profit_percentage
order by  profit_percentage 
limit 20;

-- Breakdown by Top vs Worst Sellers:
select Category, Sub_Category, round(sum(Sales),2) as Prod_sales
from project_1.store
group by Category,Sub_Category
order by Prod_sales desc;

-- Find Top 5 Sub-Categories. :
select Sub_Category, round(sum(Sales),2) as Prod_sales
from project_1.store
group by Category,Sub_Category
order by Prod_sales desc
limit 5;

-- Find Worst Category.:
select Category, round(sum(Sales),2) as Prod_sales
from project_1.store
group by Category
order by Prod_sales
limit 1;

-- Find Worst 5 Sub-Categories. :
select Sub_Category, round(sum(Sales),2) as Prod_sales
from project_1.store
group by Sub_Category
order by Prod_sales
limit 5;

/* Show the Basic Order information. */
select count(Order_ID) as Purchases,
round(sum(Sales),2) as Total_Sales,
round(sum(((profit/((sales-profit))*100)))/ count(*),2) as avg_percentage_profit,
min(Order_date) as first_purchase_date,
max(Order_date) as Latest_purchase_date,
count(distinct(Product_Name)) as Products_Purchased,
count(distinct(City)) as Location_count
from store;


/* RETURN LEVEL ANALYSIS */
/* Find the number of returned orders. */
select count(Returned_Items) from project_1.store
where Returned_Items = "Returned";

-- Find Top 10  Returned Sub-Categories.:
select Sub_Category, count(Returned_Items)
from project_1.store
where Returned_Items = 'Returned'
group by Sub_Category
order by count(Returned_Items) desc
limit 10;

-- Find Top 10 Customers Returned Frequently.:
select Customer_ID, Customer_name,Customer_Duration,count(Returned_Items)
from project_1.store
where Returned_Items = 'Returned'
group by Customer_ID, Customer_name,Customer_Duration
order by count(Returned_Items) desc
limit 10;

-- Find Top 20 cities and states having higher return.
select City, Postal_Code, States, count(Returned_Items)
from project_1.store
where Returned_Items = 'Returned'
group by City, Postal_Code, States
order by  count(Returned_Items) desc
limit 20;

-- Check whether new customers are returning higher or not.
select Customer_ID, Customer_Name, Customer_Duration, count(Returned_Items)
from project_1.store
where Customer_Duration = 'new customer' and Returned_Items = 'Returned'
group by Customer_ID, Customer_Name, Customer_Duration
order by count(Returned_Items);

-- Find Top  Reasons for returning.
select Return_Reason, count(Return_Reason)
from project_1.store
where Return_Reason not like 'Not%'
group by Return_Reason
order by count(Return_Reason) desc;
