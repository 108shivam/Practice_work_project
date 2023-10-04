use sales;
select * from us_regional_sales;
desc us_regional_sales;


select `sales channel` from us_regional_sales group by `sales channel`;
update us_regional_sales set `sales channel` = 'Wholesale' where `sales channel`= 'Whole#_sale';
update us_regional_sales set `sales channel` = 'In-Store' where `sales channel`= 'In___Store';
update us_regional_sales set `sales channel` = 'Distributor' where `sales channel`= 'Dis  _tributor';
update new_us_regional_sales set `sales channel` = 'Online' where `sales channel` = 'On line';
select min(orderdate), max(orderdate) from us_regional_sales;
alter table us_regional_sales modify column procureddate date;

select * from new_us_regional_sales where OrderDate = '09haw';
delete from new_us_regional_sales where OrderDate = '09haw';
select min(orderdate), max(orderdate) from new_us_regional_sales;
select * from us_regional_sales where OrderDate = '';

select * from new_us_regional_sales;

update new_us_regional_sales set new_ord_date = str_to_date(orderdate, '%d-%m-%Y');
alter table new_us_regional_sales modify column new_ord_date date;

desc new_us_regional_sales;
alter table new_us_regional_sales drop column OrderDate;
alter table new_us_regional_sales modify column new_ord_date date after Procureddate;
alter table new_us_regional_sales change column new_ord_date OrderDate date;
select * from new_us_regional_sales where year(orderdate)<2019;
Delete from new_us_regional_sales where year(OrderDate) > 2020;
select min(ProcuredDate), max(ProcuredDate), min(ShipDate),max(ShipDate), min(deliverydate), max(DeliveryDate) from new_us_regional_sales;

update new_us_regional_sales set ProcuredDate = str_to_date(ProcuredDate, '%d-%m-%Y');
update new_us_regional_sales set ShipDate = str_to_date(ShipDate, '%d-%m-%Y');
update new_us_regional_sales set DeliveryDate = str_to_date(DeliveryDate, '%d-%m-%Y');

alter table new_us_regional_sales modify column ProcuredDate date;
alter table new_us_regional_sales modify column ShipDate date;
alter table new_us_regional_sales modify column DeliveryDate date;

-- Total quantity ordered in every sales channel--
select sales_channel as 'Sales Channel', sum(order_quantity) as 'Sold Unit' from new_us_regional_sales group by sales_channel;

-- Total profit by sales channel--
select year(orderdate) as Year, sales_channel, round(sum(unit_price),0) as 'Selling Price', 
round(sum(unit_cost),0) as 'Cost Price', 
round((sum(unit_price) - sum(unit_cost)),0) as 'Profit' 
from new_us_regional_sales group by sales_channel, year(orderdate) order by year(orderdate);

-- Total profit by region --
select year(OrderDate) as 'Year', r.Region, round(sum(unit_price),0) as 'Selling Price', round(sum(unit_cost),0) as 'Cost Price', round(sum(unit_price)-sum(unit_cost),0) as 'Profit' 
from new_us_regional_sales n
join sales_team s on n.SalesTeamID = s.SalesTeamID 
join region_data r on s.Region = r.Region 
group by r.region, year(OrderDate);

-- Total revenue by product name --
select p.Product_name as 'Product Name', round(sum(unit_price),0) as 'Total Revenue', round(sum(unit_price)-sum(unit_cost),0) as 'Total Profit' 
from product_data p join new_us_regional_sales n
on p.ProductID=n.ProductID group by p.product_name order by round(sum(unit_price),0) desc, round(sum(unit_price)-sum(unit_cost),0) desc;

 
-- Revenue by Product Category--
SELECT
    p.Product_name AS 'Product Name',
    ROUND(SUM(unit_price), 0) AS 'Total Revenue',
    ROUND(SUM(unit_price) - SUM(unit_cost), 0) AS 'Total Profit',
    CASE
        WHEN SUM(unit_price) >= 400000 THEN 'Popular Product'
        WHEN SUM(unit_price) >= 350000 AND SUM(unit_price) < 400000 THEN 'Moderate Product'
        ELSE 'Low Product'
    END AS 'Product Category'
FROM
    product_data p
JOIN
    new_us_regional_sales n ON p.ProductID = n.ProductID
GROUP BY
    p.product_name
ORDER BY
    ROUND(SUM(unit_price), 0) DESC,
    ROUND(SUM(unit_price) - SUM(unit_cost), 0) DESC;
    
with my_cte as (SELECT
    p.Product_name AS 'Product Name',
    ROUND(SUM(unit_price), 0) AS 'Total Revenue',
    ROUND(SUM(unit_price) - SUM(unit_cost), 0) AS 'Total Profit',
    CASE
        WHEN SUM(unit_price) >= 400000 THEN 'Popular Product'
        WHEN SUM(unit_price) > 300000 AND SUM(unit_price) < 400000 THEN 'Moderate Product'
        ELSE 'Low Product'
    END AS 'Product Category'
FROM
    product_data p
JOIN
    new_us_regional_sales n ON p.ProductID = n.ProductID
GROUP BY
    p.product_name
ORDER BY
    ROUND(SUM(unit_price), 0) DESC,
    ROUND(SUM(unit_price) - SUM(unit_cost), 0) DESC
    )
select max(`total revenue`), min(`total revenue`), avg(`total revenue`) from my_cte;

-- Total Sales by products
select p.product_name as 'Product Name', sum(order_quantity) as 'Sold Unit' 
from product_data p join new_us_regional_sales n on p.ProductID = n.ProductID 
group by p.Product_Name 
order by sum(Order_Quantity) desc;


-- Profit by Country

select s.country,s.State, round(sum(n.unit_price-n.unit_cost),0) as Profit from new_us_regional_sales n join store_location s on n.StoreID = s.StoreID group by s.country,s.state;

select sum(order_quantity) from new_us_regional_sales;
select round(sum(n.unit_price),0)-round(sum(n.unit_cost),0) as profit from new_us_regional_sales n;

