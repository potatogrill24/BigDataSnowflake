-- Удаляем старые таблицы, если они существуют
DROP TABLE IF EXISTS fact_sales CASCADE;
DROP TABLE IF EXISTS dim_customer_location CASCADE;
DROP TABLE IF EXISTS dim_date CASCADE;
DROP TABLE IF EXISTS dim_supplier CASCADE;
DROP TABLE IF EXISTS dim_store CASCADE;
DROP TABLE IF EXISTS dim_product CASCADE;
DROP TABLE IF EXISTS dim_seller CASCADE;
DROP TABLE IF EXISTS dim_customer CASCADE;
DROP TABLE IF EXISTS dim_pet CASCADE;
DROP TABLE IF EXISTS dim_store_location CASCADE;
DROP TABLE IF EXISTS dim_material CASCADE;
DROP TABLE IF EXISTS dim_color CASCADE;
DROP TABLE IF EXISTS dim_customer_address CASCADE;
DROP TABLE IF EXISTS dim_supplier_address CASCADE;
DROP TABLE IF EXISTS dim_supplier_contact CASCADE;

-- Измерение: Домашние животные
CREATE TABLE dim_pet (
    pet_id SERIAL PRIMARY KEY,
    pet_type VARCHAR(20),
    pet_name VARCHAR(50),
    pet_breed VARCHAR(50),
    pet_category VARCHAR(50)
);

-- Измерение: Адрес покупателя
CREATE TABLE dim_customer_address (
    address_id SERIAL PRIMARY KEY,
    country VARCHAR(50),
    postal_code VARCHAR(20)
);

-- Измерение: Покупатели
CREATE TABLE dim_customer (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    email VARCHAR(100),
    address_id INT REFERENCES dim_customer_address(address_id),
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

-- Измерение: Материалы
CREATE TABLE dim_material (
    material_id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

-- Измерение: Цвет
CREATE TABLE dim_color (
    color_id SERIAL PRIMARY KEY,
    name VARCHAR(30)
);

-- Измерение: Продукты
CREATE TABLE dim_product (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    brand VARCHAR(50),
    material_id INT REFERENCES dim_material(material_id),
    color_id INT REFERENCES dim_color(color_id),
    size VARCHAR(20),
    weight DECIMAL(6,2),
    description TEXT,
    rating DECIMAL(3,1),
    reviews INT,
    release_date DATE,
    expiry_date DATE,
    price DECIMAL(10,2)
);

-- Измерение: Местоположение магазина
CREATE TABLE dim_store_location (
    location_id SERIAL PRIMARY KEY,
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

-- Измерение: Магазины
CREATE TABLE dim_store (
    store_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    location_id INT REFERENCES dim_store_location(location_id),
    phone VARCHAR(20),
    email VARCHAR(100)
);

-- Измерение: Адрес поставщика
CREATE TABLE dim_supplier_address (
    address_id SERIAL PRIMARY KEY,
    address VARCHAR(200),
    city VARCHAR(50),
    country VARCHAR(50)
);

-- Измерение: Контакт поставщика
CREATE TABLE dim_supplier_contact (
    contact_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20)
);

-- Измерение: Поставщики
CREATE TABLE dim_supplier (
    supplier_id SERIAL PRIMARY KEY,
    supplier_contact_id INT REFERENCES dim_supplier_contact(contact_id),
    supplier_address_id INT REFERENCES dim_supplier_address(address_id)
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
