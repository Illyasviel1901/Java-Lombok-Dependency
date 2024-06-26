DROP DATABASE IF EXISTS shop;
CREATE DATABASE IF NOT EXISTS shop;
use shop;

CREATE TABLE product (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    price DOUBLE NOT NULL,
    expiration_date DATE
);

CREATE TABLE client (
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    birthdate DATE
);

CREATE TABLE client_product (
	client_id INT,
    product_id INT,
    PRIMARY KEY (client_id, product_id),
    FOREIGN KEY (client_id) REFERENCES client(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE
);

INSERT INTO product (name, price, expiration_date) VALUES
('Jucarie', 150, '9999-12-31'),
('Ketchup', 20, '2024-12-12'),
('Apa', 10, '2024-10-13'),
('Bere', 30, '2025-01-17');

INSERT INTO client (name, birthdate) VALUES
('Ion Popescu', '1984-08-10'),
('Sirghi Catalin', '2004-10-01');

INSERT INTO client_product (client_id, product_id) VALUES
(1, 1), (1, 3), (2, 2), (2, 4);

SELECT product.name FROM product 
JOIN client_product ON product.id = client_product.product_id
JOIN client ON client.id = client_product.client_id
WHERE client.name = 'Sirghi Catalin'
