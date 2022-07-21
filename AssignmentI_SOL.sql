use supply_db ;


-- Question : Golf related products

-- List all products in categories related to golf. Display the Product_Id, Product_Name in the output. Sort the output in the order of product id.
-- Hint: You can identify a Golf category by the name of the category that contains golf.


select info.product_id as product_id, info.product_name as product_name
from 
category catg
inner join 
product_info info
on catg.id = info.category_id
where name like 'Golf%'
order by product_id;







-- **********************************************************************************************************************************

-- /*
-- Question : Most sold golf products

-- Find the top 10 most sold products (based on sales) in categories related to golf. Display the Product_Name and Sales column in the output. 
-- Sort the output in the descending order of sales.
-- Hint: You can identify a Golf category by the name of the category that contains golf.

-- HINT:
-- Use orders, ordered_items, product_info, and category tables from the Supply chain dataset.


with T1 as
(
select ord.order_id, items.order_item_id, items.sales, items.item_id
from orders ord
inner join 
ordered_items items
using (order_id)
order by sales desc
),

T2 as
(
select info.product_name, a.sales, catg.Name as category_name
from T1 as a
inner join 
product_info info
on a.item_id = info.product_id
inner join 
category catg
on 
info.category_id = catg.id
)
 select product_name, sum(sales) as total_sales
 from T2
 where category_name like 'Golf%'
 group by product_name
 order by sales desc;











-- */

-- **********************************************************************************************************************************

/*
Question: Segment wise orders

Find the number of orders by each customer segment for orders. Sort the result from the highest to the lowest 
number of orders.The output table should have the following information:
-Customer_segment
-Orders
*/
select segment as customer_segment, count(order_id) as Orders
 from
 customer_info cust 
 inner join 
 orders ord 
 on id = customer_id
 group by customer_segment
 order by orders desc;





-- **********************************************************************************************************************************
/*
Question : Percentage of order split

Description: Find the percentage of split of orders by each customer segment for orders that took six days 
to ship (based on Real_Shipping_Days). Sort the result from the highest to the lowest percentage of split orders,
rounding off to one decimal place. The output table should have the following information:
-Customer_segment
-Percentage_order_split

HINT:
Use the orders and customer_info tables from the Supply chain dataset.


*/

-- **********************************************************************************************************************************
WITH Seg_Orders AS
(
SELECT
cust.Segment AS customer_segment,
COUNT(ord.Order_Id) AS Orders
FROM
orders AS ord
LEFT JOIN
customer_info AS cust
ON ord.Customer_Id = cust.Id
WHERE Real_Shipping_Days=6
GROUP BY 1
)
SELECT
a.customer_segment,
ROUND(a.Orders/SUM(b.Orders)*100,1) AS percentage_order_split
FROM
Seg_Orders AS a
JOIN
Seg_Orders AS b
GROUP BY 1
ORDER BY 2 DESC;
