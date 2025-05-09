-- Вставка данных в таблицу dim_pet
INSERT INTO dim_pet (pet_type, pet_name, pet_breed, pet_category)
SELECT DISTINCT
    customer_pet_type, customer_pet_name, customer_pet_breed, pet_category
FROM mock_data;

-- Вставка данных в таблицу dim_customer_address
INSERT INTO dim_customer_address (country, postal_code)
SELECT DISTINCT customer_country, customer_postal_code
FROM mock_data;

-- Вставка данных в таблицу dim_customer
INSERT INTO dim_customer (first_name, last_name, age, email, address_id, pet_id)
SELECT DISTINCT
    m.customer_first_name,
    m.customer_last_name,
    m.customer_age,
    m.customer_email,
    ca.address_id,
    p.pet_id
FROM mock_data m
JOIN dim_pet p ON
    m.customer_pet_type = p.pet_type AND
    m.customer_pet_name = p.pet_name AND
    m.customer_pet_breed = p.pet_breed
JOIN dim_customer_address ca ON
    m.customer_country = ca.country AND
    m.customer_postal_code = ca.postal_code;

-- Вставка данных в таблицу dim_seller
INSERT INTO dim_seller (first_name, last_name, email, country, postal_code)
SELECT DISTINCT
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code
FROM mock_data;

-- Вставка данных в таблицу dim_material
INSERT INTO dim_material (name)
SELECT DISTINCT product_material
FROM mock_data;

-- Вставка данных в таблицу dim_color
INSERT INTO dim_color (name)
SELECT DISTINCT product_color
FROM mock_data;

-- Вставка данных в таблицу dim_product
INSERT INTO dim_product (
    name, category, brand, material_id, color_id, size, weight,
    description, rating, reviews, release_date, expiry_date, price
)
SELECT DISTINCT
    product_name, product_category, product_brand, 
    mat.material_id, c.color_id, product_size, product_weight,
    product_description, product_rating, product_reviews,
    product_release_date, product_expiry_date, product_price
FROM mock_data m
JOIN dim_material mat ON m.product_material = mat.name
JOIN dim_color c ON m.product_color = c.name;

-- Вставка данных в таблицу dim_store_location
INSERT INTO dim_store_location (city, state, country)
SELECT DISTINCT store_city, store_state, store_country
FROM mock_data;

-- Вставка данных в таблицу dim_store
INSERT INTO dim_store (name, location_id, phone, email)
SELECT DISTINCT
    store_name, sl.location_id, store_phone, store_email
FROM mock_data m
JOIN dim_store_location sl ON
    m.store_city = sl.city AND m.store_state = sl.state AND m.store_country = sl.country;

-- Вставка данных в таблицу dim_supplier_address
INSERT INTO dim_supplier_address (address, city, country)
SELECT DISTINCT supplier_address, supplier_city, supplier_country
FROM mock_data;

-- Вставка данных в таблицу dim_supplier_contact
INSERT INTO dim_supplier_contact (name, email, phone)
SELECT DISTINCT supplier_contact, supplier_email, supplier_phone
FROM mock_data;

-- Вставка данных в таблицу dim_supplier
INSERT INTO dim_supplier (supplier_contact_id, supplier_address_id)
SELECT DISTINCT
    sc.contact_id, sa.address_id
FROM mock_data m
JOIN dim_supplier_contact sc ON m.supplier_contact = sc.name
JOIN dim_supplier_address sa ON m.supplier_address = sa.address;

-- Вставка данных в таблицу dim_date
INSERT INTO dim_date (full_date, year, month, day, day_of_week, week, quarter)
SELECT DISTINCT
    sale_date,
    EXTRACT(YEAR FROM sale_date),
    EXTRACT(MONTH FROM sale_date),
    EXTRACT(DAY FROM sale_date),
    TO_CHAR(sale_date, 'Day'),
    EXTRACT(WEEK FROM sale_date),
    EXTRACT(QUARTER FROM sale_date)
FROM mock_data;

-- Вставка данных в таблицу dim_customer_location
INSERT INTO dim_customer_location (country, postal_code)
SELECT DISTINCT customer_country, customer_postal_code
FROM mock_data;

-- Вставка данных в таблицу fact_sales
INSERT INTO fact_sales (
    sale_date_id, customer_id, seller_id, product_id,
    store_id, supplier_id, customer_location_id, quantity, total_price
)
SELECT
    d.date_id,
    c.customer_id,
    s.seller_id,
    p.product_id,
    st.store_id,
    sp.supplier_id,
    cl.location_id,
    m.sale_quantity,
    m.sale_total_price
FROM mock_data m
JOIN dim_date d ON m.sale_date = d.full_date
JOIN dim_pet pet ON
    m.customer_pet_type = pet.pet_type AND
    m.customer_pet_name = pet.pet_name AND
    m.customer_pet_breed = pet.pet_breed
JOIN dim_customer c ON
    m.customer_first_name = c.first_name AND
    m.customer_last_name = c.last_name AND
    m.customer_email = c.email AND
    c.pet_id = pet.pet_id
JOIN dim_seller s ON
    m.seller_first_name = s.first_name AND
    m.seller_last_name = s.last_name AND
    m.seller_email = s.email
JOIN dim_product p ON
    m.product_name = p.name AND
    m.product_category = p.category AND
    m.product_price = p.price
JOIN dim_store st ON
    m.store_name = st.name
JOIN dim_supplier_contact spc ON
    m.supplier_contact = spc.name AND
    m.supplier_email = spc.email
JOIN dim_supplier sp ON
    sp.supplier_contact_id = spc.contact_id
JOIN dim_customer_location cl ON
    m.customer_country = cl.country AND
    m.customer_postal_code = cl.postal_code;

-- Удаляем старую таблицу mock_data
DROP TABLE mock_data;
