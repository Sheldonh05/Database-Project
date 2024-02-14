/* Orders within year */
select orders.order_status, orders.order_dates, Inventory.quantity, Inventory.date_added
from Inventory full outer join orders on Inventory.quantity = orders.quantity
where Inventory.date_added between '2019-01-01' and '2019-12-30';

/* Inventory Variance */
select product_name, date_added, (quantity - quantity_shipped) as difference
from Inventory;

/* Complete orders */
select order_id, order_status, order_dates, customer_id 
from Orders
where order_status = 'Completed'
order by customer_id;

/* Inventory quantity */
select quantity, date_added, product_name
from Inventory
where date_added between '2019-01-01' and '2023-12-30'
order by product_name;

/* Order status */
select total_price, order_dates, order_status
from Orders
where order_dates between '2018-01-01' and '2023-12-30'
order by order_dates ASC;

/* Total Inventory */
select quantity, date_added, product_name, Count(quantity) as Total_Inventory
from Inventory;

/* Average inventory */
select quantity, date_added, product_name, ((quantity * quantity)/ 10) as avg_quant
from Inventory
where date_added between '2019-01-01' and '2019-12-30' and product_name >= avg_quant;

/* Demographic feedback */
Select Demographics.race as Target_Demographic, count(*) as Sales_Count
from customer join Demographics on customer.demographics_id = Demographics.demographics_id;
