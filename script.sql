/*************************************************************
+created by: kaushika weerakoon
+email:kaushikaslk@gail.com

-STORE API DATABSE-
**************************************************************/

DROP SCHEMA IF EXISTS storeapi;
CREATE SCHEMA storeapi;
USE storeapi;
DROP PROCEDURE if EXISTS getActiveOrdersByCustomerId;
--
-- Table structure for table `customer`
--

CREATE TABLE
  customer (
    user_id INT NOT NULL auto_increment,
    user_name VARCHAR(30),
    email VARCHAR(20),
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    created_on DATETIME,
    is_active BOOLEAN,
    PRIMARY KEY (user_id)
  );

--
-- Table structure for table `supplier`
--

CREATE TABLE
  supplier (
    supplier_id INT NOT NULL auto_increment,
    supplier_name VARCHAR(50),
    created_on DATETIME,
    is_active BOOLEAN,
    PRIMARY KEY (supplier_id)
  );

--
-- Table structure for table `product`
--

CREATE TABLE
  product (
    product_id INT NOT NULL auto_increment,
    product_name VARCHAR(50),
    unit_price DECIMAL,
    supplier_id INT,
    created_on DATETIME,
    is_active BOOLEAN,
    PRIMARY KEY (product_id),
    FOREIGN KEY (supplier_id) REFERENCES supplier (supplier_id) ON DELETE CASCADE
  );

--
-- Table structure for table `orders`
--

CREATE TABLE
  orders (
    order_id INT NOT NULL auto_increment,
    product_id INT,
    order_status INT (1),
    order_type INT (1),
    order_by INT,
    ordered_on DATETIME,
    shipped_on DATETIME,
    is_active BOOLEAN,
    PRIMARY KEY (order_id),
    FOREIGN KEY (order_by) REFERENCES customer (user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product (product_id) ON DELETE CASCADE
  );
  
#Get Active Orders by Customer (Stored procedure)
DELIMITER //
CREATE DEFINER ="root"@"localhost" PROCEDURE getActiveOrdersByCustomerId(in customerId int)
begin
	SELECT 
  o.order_id,
  o.product_id,
  p.product_name,
  p.supplier_id,
  s.supplier_name,
  p.unit_price,
  o.order_status,
  o.order_type,
  o.order_by,
  o.ordered_on,
  o.shipped_on,
  o.is_active
FROM orders o
INNER JOIN customer c ON c.user_id = o.order_by
INNER JOIN product p ON o.product_id = p.product_id
INNER JOIN supplier s ON p.supplier_id = s.supplier_id
WHERE o.is_active = TRUE and c.user_id = customerId;
end //
DELIMITER ;



#Dummy data sets-----------------------------------------------------------------------

INSERT INTO customer (user_name, email, first_name, last_name, created_on, is_active)
VALUES
  ('user1', 'user1@example.com', 'John', 'Doe', '2023-01-01 12:00:00', 1),
  ('user2', 'user2@example.com', 'Jane', 'Smith', '2023-02-15 10:30:00', 1),
  ('user3', 'user3@example.com', 'Emily', 'Johnson', '2023-03-20 08:45:00', 1),
  ('user4', 'user4@example.com', 'Michael', 'Williams', '2023-04-10 15:20:00', 1),
  ('user5', 'user5@example.com', 'Sarah', 'Brown', '2023-05-05 17:00:00', 1);
  
  INSERT INTO supplier (supplier_name, created_on, is_active)
VALUES
  ('Supplier A', '2023-01-05 09:00:00', 1),
  ('Supplier B', '2023-02-10 11:45:00', 1),
  ('Supplier C', '2023-03-18 13:30:00', 1),
  ('Supplier D', '2023-04-22 14:20:00', 1);
  
  INSERT INTO product (product_name, unit_price, supplier_id, created_on, is_active)
VALUES
  ('Product 1', 25.99, 1, '2023-01-10 08:00:00', 1),
  ('Product 2', 39.99, 2, '2023-02-20 10:30:00', 1),
  ('Product 3', 15.50, 3, '2023-03-25 12:45:00', 1),
  ('Product 4', 49.99, 4, '2023-04-05 14:00:00', 1),
  ('Product 5', 19.99, 1, '2023-05-15 16:00:00', 1);
  
  INSERT INTO orders (product_id, order_status, order_type, order_by, ordered_on, shipped_on, is_active)
VALUES
  (1, 1, 1, 1, '2023-01-15 09:30:00', '2023-01-18 12:00:00', 1),
  (2, 1, 2, 2, '2023-02-25 11:00:00', '2023-02-28 15:30:00', 1),
  (3, 0, 1, 2, '2023-03-30 13:45:00', '2023-04-02 16:00:00', 1),
  (4, 0, 2, 2, '2023-04-15 15:00:00', '2023-04-18 18:30:00', 0),
  (5, 1, 1, 5, '2023-05-20 17:30:00', '2023-05-23 20:00:00', 1);
  
  
  