--STORES database

--TABLES:

/*-Customers: customer data
-Employees: all employee information
-Offices: sales office information
-Orders: customers' sales orders
-OrderDetails: sales order line for each sales order
-Payments: customers' payment records
-Products: a list of scale model cars
-ProductLines: a list of product line categories*/

/* Question 1: Which products should we order more of or less of?
Question 2: How should we tailor marketing and communication strategies to customer behaviors?
Question 3: How much can we spend on acquiring new customers? */

/*EXPLORING PRODUCTS*/


--STEP 1: Getting the names of all the tables
--selects all the table names
SELECT name AS table_name
  FROM sqlite_schema 
 WHERE type='table'

--PRINTS the table name along with its row_num and coloumn_num all in a single table

select 'customers' as table_name,count(*) as column_count,(select count(*) from customers) as row_count from pragma_table_info('customers')
union ALL
select 'employees' as table_name,count(*) as column_count,(select count(*) from employees) as row_count from pragma_table_info('employees')
union ALL
select 'offices' as table_name,count(*) as column_count,(select count(*) from offices) as row_count from pragma_table_info('offices')
union ALL
select 'orderdetails' as table_name,count(*) as column_count,(select count(*) from orderdetails) as row_count from pragma_table_info('orderdetails')
union ALL
select 'orders' as table_name,count(*) as column_count,(select count(*) from orders) as row_count from pragma_table_info('orders')
union ALL
select 'payments' as table_name,count(*) as column_count,(select count(*) from payments) as row_count from pragma_table_info('payments')
union ALL
select 'productlines' as table_name,count(*) as column_count,(select count(*) from productlines) as row_count from pragma_table_info('productlines')
union ALL
select 'products' as table_name,count(*) as column_count,(select count(*) from products) as row_count from pragma_table_info('products')

--STEP 2: Getting the low stock value of top 10 products

SELECT productCode, 
       ROUND(SUM(quantityOrdered) * 1.0 / (SELECT quantityInStock
                                             FROM products p
                                            WHERE od.productCode = p.productCode), 2) AS low_stock
  FROM orderdetails od
 GROUP BY productCode
 ORDER BY low_stock
 LIMIT 10;

--STEP 3: Getting product performance of top 10 products

SELECT productCode, ROUND(SUM(quantityOrdered * priceEach), 2) AS product_performance
  FROM orderdetails
 GROUP BY productCode
 ORDER BY product_performance DESC
 LIMIT 10;

--STEP 4: Finally getting the combined table to analyse which are the --products with high performance which are on the brink of being out of 
--stock.

SELECT ls.productCode, ls.low_stock, pp.product_performance
FROM (SELECT productCode, 
       ROUND(SUM(quantityOrdered) * 1.0 / (SELECT quantityInStock
                                             FROM products p
                                            WHERE od.productCode = p.productCode), 2) AS low_stock
       FROM orderdetails od
      GROUP BY productCode
      ORDER BY low_stock
      ) ls
 JOIN (SELECT productCode, ROUND(SUM(quantityOrdered * priceEach), 2) AS product_performance
         FROM orderdetails
        GROUP BY productCode
        ORDER BY product_performance DESC
        ) pp
   ON ls.productCode = pp.productCode
 ORDER BY ls.low_stock,pp.product_performance DESC;

--STEP 5: Top 10 products which are low on stock

WITH 

low_stock_table AS (
SELECT productCode, 
       ROUND(SUM(quantityOrdered) * 1.0/(SELECT quantityInStock
                                           FROM products p
                                          WHERE od.productCode = p.productCode), 2) AS low_stock
  FROM orderdetails od
 GROUP BY productCode
 ORDER BY low_stock
 LIMIT 10
)

SELECT productCode, 
       SUM(quantityOrdered * priceEach) AS prod_performance
  FROM orderdetails od
 WHERE productCode IN (SELECT productCode
                         FROM low_stock_table)
 GROUP BY productCode 
 ORDER BY prod_performance DESC
 LIMIT 10;


/*EXPLORING CUSTOMERS*/


--STEP 6: Selecting top 5 VIP customers who bring in the maximum profit.

SELECT c.customerNumber, c.customerName AS VIP_customer_names, c.phone, c.country, n.profit
  FROM customers c
  JOIN (SELECT o.customerNumber, ROUND(SUM(od.quantityOrdered * (od.priceEach - p.buyPrice)),2) AS profit
						    FROM orders o
							JOIN orderdetails od
							  ON o.orderNumber = od.orderNumber
							JOIN products p
							  ON od.productCode = p.productCode
						   GROUP BY o.customerNumber
						   ORDER BY profit DESC
						   LIMIT 5) n
    ON c.customerNumber = n.customerNumber;

--STEP 7 : Selecting least engaged customers

SELECT c.customerNumber, c.customerName AS least_engaged_customer_names, c.phone, c.country, n.profit
  FROM customers c
  JOIN (SELECT o.customerNumber, ROUND(SUM(od.quantityOrdered * (od.priceEach - p.buyPrice)),2) AS profit
						    FROM orders o
							JOIN orderdetails od
							  ON o.orderNumber = od.orderNumber
							JOIN products p
							  ON od.productCode = p.productCode
						   GROUP BY o.customerNumber
						   ORDER BY profit
						   LIMIT 5) n
    ON c.customerNumber = n.customerNumber;

--STEP 8 : To determine how much money we can spend acquiring new customers, we can compute the Customer --Lifetime Value (LTV)

WITH 

money_in_by_customer_table AS (
SELECT o.customerNumber, SUM(quantityOrdered * (priceEach - buyPrice)) AS revenue
  FROM products p
  JOIN orderdetails od
    ON p.productCode = od.productCode
  JOIN orders o
    ON o.orderNumber = od.orderNumber
 GROUP BY o.customerNumber
)

SELECT AVG(mc.revenue) AS ltv
  FROM money_in_by_customer_table mc;
