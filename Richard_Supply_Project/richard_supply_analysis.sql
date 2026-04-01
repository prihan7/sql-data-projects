-- 1.	Company sells the product at different discounted rates. Refer actual product price in product table and selling price in the orderitem 
-- table. Write a query to find out total amount saved in each order then display the orders from highest to lowest amount saved. 
SELECT p.id, p.productName, sum(p.UnitPrice) AS "actual product price", SUM(oi.UnitPrice) AS "actual selling price", SUM(p.UnitPrice)-SUM(oi.UnitPrice) AS Saved_Amount
FROM product p  
JOIN orderitem oi ON p.id = oi.ProductId
GROUP BY p.id, p.productName
ORDER BY Saved_Amount DESC;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- 2.	Mr. Kavin want to become a supplier. He got the database of "Richard's Supply" for reference. Help him to pick: 
-- a. List few products that he should choose based on demand.
-- b. Who will be the competitors for him for the products suggested in above questions.
SELECT p.id, p.ProductName, SUM(oi.Quantity) AS "Demand"
FROM product p JOIN orderitem oi 
ON p.id = oi.ProductId 
GROUP BY p.id, p.ProductName
HAVING SUM(oi.Quantity)>=900
ORDER BY SUM(oi.Quantity) DESC;

SELECT s.id AS competitor_Id, s.CompanyName AS competitor_Company, s.ContactName AS Competitor_Name, p.ProductName, p.id AS ProductId , SUM(oi.Quantity) AS demand FROM supplier s 
JOIN product p ON s.id = p.SupplierId 
JOIN orderitem oi ON p.id = oi.ProductId
JOIN orders o ON oi.OrderId = o.id
WHERE p.id IN (60,59,31,56,16,75,24,40,62,2,71,21,41,76,17,55)
GROUP BY s.id, p.id
ORDER BY demand DESC;

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- 3.	Create a combined list to display customers and suppliers details considering the following criteria 
-- Both customer and supplier belong to the same country
-- Customer who does not have supplier in their country
-- Supplier who does not have customer in their country

SELECT Customer.FirstName, Customer.LastName, Customer.Country, Supplier.Country , Supplier.CompanyName FROM Customer
LEFT JOIN Supplier
ON Customer.Country = Supplier.Country
UNION
SELECT Customer.FirstName, Customer.LastName, Customer.Country , Supplier.Country , Supplier.CompanyName FROM Customer
RIGHT JOIN Supplier
ON Customer.Country = Supplier.Country;


-- -----------------------------------------------------------------------------------------------------------------------------------------
-- 4.	Every supplier supplies specific products to the customers. Create a view of suppliers and total sales made by their products and write a query on this view to find out top 2 suppliers (using windows function) in each country by total sales done by the products.

CREATE VIEW Total AS
SELECT SupplierId, Country, SUM(product_sales) AS Supp_sales 
FROM (SELECT ProductId, SUM(orderitem.UnitPrice * Quantity) AS product_sales, supplier.Country, product.SupplierId
FROM orderitem
INNER JOIN product
ON orderitem.ProductId = product.Id
INNER JOIN supplier
ON product.SupplierId = supplier.Id
GROUP BY ProductId) AS AA
GROUP BY SupplierId;

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- 5.	Find out for which products, UK is dependent on other countries for the supply. List the countries which are supplying these products in the same list.

SELECT customer.id, CONCAT(firstname, ' ', lastname)
AS 'Name', product.productname, OrderId,
IFNULL(quantity,0) AS Product_Qty,
IFNULL(quantity * product.unitprice, 0) AS Subtotal
FROM customer
LEFT JOIN orders
ON customer.id = orders.id
LEFT JOIN orderitem
ON orders.id = orderitem.id
LEFT JOIN product
ON orderitem.id = product.id
ORDER BY customer.id;

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- 6.	Create two tables as ‘customer’ and ‘customer_backup’ as follow - 
-- ‘customer’ table attributes -
-- Id, FirstName,LastName,Phone
-- ‘customer_backup’ table attributes - 
-- Id, FirstName,LastName,Phone

-- Create a trigger in such a way that It should insert the details into the  ‘customer_backup’ table when you delete the record from the ‘customer’ table automatically.

CREATE TABLE customer_backup_table (
    Id INT,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    City VARCHAR(255),
    Country VARCHAR(255),
    Phone VARCHAR(255)
);

DELIMITER $$
CREATE TRIGGER customer_delete_trigger
AFTER DELETE
ON `Customer`
FOR EACH ROW
BEGIN
    INSERT INTO customer_backup_table (Id, FirstName, LastName, City, Country, Phone)
    VALUES (OLD.Id, OLD.FirstName, OLD.LastName, OLD.City, OLD.Country, OLD.Phone);
END $$
DELIMITER ;
