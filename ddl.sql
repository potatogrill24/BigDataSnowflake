-- Правильный порядок:
DROP TABLE IF EXISTS fact_sales CASCADE;
DROP TABLE IF EXISTS dim_customer_location CASCADE;
DROP TABLE IF EXISTS dim_date CASCADE;
DROP TABLE IF EXISTS dim_supplier CASCADE;
DROP TABLE IF EXISTS dim_store CASCADE;
DROP TABLE IF EXISTS dim_product CASCADE;
DROP TABLE IF EXISTS dim_seller CASCADE;
DROP TABLE IF EXISTS dim_customer CASCADE;
DROP TABLE IF EXISTS dim_pet CASCADE;


-- Измерение: Домашние животные
CREATE TABLE dim_pet (
    pet_id SERIAL PRIMARY KEY,
    pet_type VARCHAR(20),
    pet_name VARCHAR(50),
    pet_breed VARCHAR(50),
    pet_category VARCHAR(50)
);

-- Измерение: Покупатели
CREATE TABLE dim_customer (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    email VARCHAR(100),
    country VARCHAR(50),
    postal_code VARCHAR(20),
    pet_id INT REFERENCES dim_pet(pet_id)
);

-- Измерение: Продавцы
CREATE TABLE dim_seller (
    seller_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    country VARCHAR(50),
    postal_code VARCHAR(20)
);

-- Измерение: Товары
CREATE TABLE dim_product (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    brand VARCHAR(50),
    material VARCHAR(50),
    color VARCHAR(30),
    size VARCHAR(20),
    weight DECIMAL(6,2),
    description TEXT,
    rating DECIMAL(3,1),
    reviews INT,
    release_date DATE,
    expiry_date DATE,
    price DECIMAL(10,2)
);

-- Измерение: Магазины
CREATE TABLE dim_store (
    store_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100)
);

-- Измерение: Поставщики
CREATE TABLE dim_supplier (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    contact VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(200),
    city VARCHAR(50),
    country VARCHAR(50)
);

-- Измерение: Дата
CREATE TABLE dim_date (
    date_id SERIAL PRIMARY KEY,
    full_date DATE,
    year INT,
    month INT,
    day INT,
    day_of_week VARCHAR(10),
    week INT,
    quarter INT
);

-- Измерение: География покупателя
CREATE TABLE dim_customer_location (
    location_id SERIAL PRIMARY KEY,
    country VARCHAR(50),
    postal_code VARCHAR(20)
);

-- Таблица фактов: Продажи
CREATE TABLE fact_sales (
    sale_id SERIAL PRIMARY KEY,
    sale_date_id INT REFERENCES dim_date(date_id),
    customer_id INT REFERENCES dim_customer(customer_id),
    seller_id INT REFERENCES dim_seller(seller_id),
    product_id INT REFERENCES dim_product(product_id),
    store_id INT REFERENCES dim_store(store_id),
    supplier_id INT REFERENCES dim_supplier(supplier_id),
    customer_location_id INT REFERENCES dim_customer_location(location_id),
    quantity INT,
    total_price DECIMAL(10,2)
);