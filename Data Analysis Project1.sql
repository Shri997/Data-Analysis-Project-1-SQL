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

select count(*) from store;

SELECT COUNT(*) AS column_count
FROM information_schema.columns
WHERE table_schema = 'project_1'
  AND table_name = 'store';
  
  show columns from store;
  describe project_1.store;

SELECT * FROM store
WHERE (select column_name
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='store') IS NULL;

select count(Country) from project_1.store
where Country='United States';

select distinct(category) from project_1.store;

select Category,count(Product_ID) from project_1.store group by Category;

select count(distinct(Sub_Category)) as No_of_Sub_Category from project_1.store; 

select Sub_Category, count(Product_ID) from project_1.store group by Sub_Category;

select count(distinct(Product_Name)) as Unique_products from project_1.store; 

select product_name, count(product_id) from project_1.store group by Product_Name order by count(Product_ID) desc limit 10;

select product_name,order_id,round(sum(sales-profit),2) as Cost from project_1.store group by Product_Name,Order_ID order by Cost desc;

select Order_ID,product_name, round(((profit/(sales-profit))*100),2) as Profit_percentage from project_1.store group by Order_ID,product_name, Profit_percentage;

select round(sum(profit),3) as Overall_Profit from project_1.store;

select order_id, Product_Name, round((profit/(sales-profit))*100),2) as Percentage_profit from project_1.store group by order_id,Product_Name,Percentage_Profit order by percentage_Profit desc;

select Product_id, Sales,Profit,
case 
 when Sales > (select AVG(Sales) from store) and  Profit > (select avg(Profit) from store) then "Best Seller"
 else "Bad Seller"
end as Case1
from project_1.store
group by Product_ID,Sales,Profit;

select Sub_Category, round(avg(Sales),2) as Avg_sales
from project_1.store
group by Sub_Category
order by Avg_sales desc;

select Sub_Category, round(avg(Profit),2) as Avg_profit
from project_1.store 
group by Sub_Category
order by Avg_profit desc;

select count(distinct(Customer_ID)) as Unique_cust_id from project_1.store;

select Years, Customer_id, Customer_name
from project_1.store
where Years between 2014 and 2016
order by Years;

select Customer_name,Order_id, count(Order_id) as Order_frequency
from project_1.store
group by Customer_Name, Order_id
order by Order_frequency desc;

select Customer_Name, round((Sales-Profit),2) as Cost
from project_1.store
group by Customer_Name,Cost;

select Region, count(Customer_id) as No_Of_Customers
from project_1.store
group by Region
order by No_of_Customers desc;

select Customer_Name,count(Customer_ID) as No_Of_Customers
from project_1.store
group by Customer_ID,Customer_Name
order by count(Customer_ID) desc
limit 10;

select Customer_ID, Customer_Name,Country, States,City, Postal_Code,Region,Customer_Duration
from project_1.store
where States = 'California' and Postal_Code = 90032
order by Customer_ID;

select Customer_ID,Customer_Name, round(sum(Profit),2) Total_Profit
from project_1.store
group by Customer_ID,Customer_Name
order by sum(Profit) desc
limit 20;

select States, round(sum(sales),2) Total_sales
from project_1.store
group by States
order by Total_sales desc
limit 10;

select count(distinct(Order_ID)) as Unique_orders
from project_1.store;

select round(sum(Sales),2) as Total_sales
from project_1.store;

select Order_ID,Order_Date,(Ship_Date-Order_Date) as Delivery_days, Ship_Mode
from project_1.store
order by Order_ID;

select Customer_ID, Order_ID, Years, Quantity
from project_1.store
order by Years;
-- OR
select Customer_ID,Order_ID, Quantity,year(Order_Date) as Yearss
from project_1.store
order by Yearss desc;

SELECT EXTRACT(YEAR from Order_Date), Sales, round((profit/((sales-profit))*100),2) as profit_percentage
FROM store
GROUP BY EXTRACT(YEAR from Order_Date), Sales, profit_percentage
order by  profit_percentage 
limit 20;

select Category, Sub_Category, round(sum(Sales),2) as Prod_sales
from project_1.store
group by Category,Sub_Category
order by Prod_sales desc;

select Sub_Category, round(sum(Sales),2) as Prod_sales
from project_1.store
group by Category,Sub_Category
order by Prod_sales desc
limit 10;

select Category, round(sum(Sales),2) as Prod_sales
from project_1.store
group by Category
order by Prod_sales
limit 10;

select Category, round(sum(Sales),2) as Prod_sales
from project_1.store
group by Category
order by Prod_sales desc
limit 10;

select Sub_Category, round(sum(Sales),2) as Prod_sales
from project_1.store
group by Sub_Category
order by Prod_sales
limit 10;

select count(Order_ID) as Purchases,
round(sum(Sales),2) as Total_Sales,
round(sum(((profit/((sales-profit))*100)))/ count(*),2) as avg_percentage_profit,
min(Order_date) as first_purchase_date,
max(Order_date) as Latest_purchase_date,
count(distinct(Product_Name)) as Products_Purchased,
count(distinct(City)) as Location_count
from store;

select count(Returned_Items) from project_1.store
where Returned_Items = "Returned";

select Sub_Category, count(Returned_Items)
from project_1.store
where Returned_Items = 'Returned'
group by Sub_Category
order by count(Returned_Items) desc
limit 10;

select Customer_ID, Customer_name,Customer_Duration,count(Returned_Items)
from project_1.store
where Returned_Items = 'Returned'
group by Customer_ID, Customer_name,Customer_Duration
order by count(Returned_Items) desc
limit 10;

select City, Postal_Code, States, count(Returned_Items)
from project_1.store
where Returned_Items = 'Returned'
group by City, Postal_Code, States
order by  count(Returned_Items) desc
limit 20;

select Customer_ID, Customer_Name, Customer_Duration, count(Returned_Items)
from project_1.store
where Customer_Duration = 'new customer' and Returned_Items = 'Returned'
group by Customer_ID, Customer_Name, Customer_Duration
order by count(Returned_Items);

select Return_Reason, count(Return_Reason)
from project_1.store
where Return_Reason not like 'Not%'
group by Return_Reason
order by count(Return_Reason) desc;
