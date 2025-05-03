-- dim_pet
INSERT INTO dim_pet (pet_type, pet_name, pet_breed, pet_category)
SELECT DISTINCT
    customer_pet_type, customer_pet_name, customer_pet_breed, pet_category
FROM mock_data;

-- dim_customer_location
INSERT INTO dim_customer_location (country, postal_code)
SELECT DISTINCT customer_country, customer_postal_code
FROM mock_data;

-- dim_customer
INSERT INTO dim_customer (
    first_name, last_name, age, email, country, postal_code, pet_id
)
SELECT DISTINCT
    m.customer_first_name,
    m.customer_last_name,
    m.customer_age,
    m.customer_email,
    m.customer_country,
    m.customer_postal_code,
    p.pet_id
FROM mock_data m
JOIN dim_pet p ON
    m.customer_pet_type = p.pet_type AND
    m.customer_pet_name = p.pet_name AND
    m.customer_pet_breed = p.pet_breed;

-- dim_seller
INSERT INTO dim_seller (
    first_name, last_name, email, country, postal_code
)
SELECT DISTINCT
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code
FROM mock_data;

-- dim_product
INSERT INTO dim_product (
    name, category, brand, material, color, size, weight,
    description, rating, reviews, release_date, expiry_date, price
)
SELECT DISTINCT
    product_name, product_category, product_brand, product_material,
    product_color, product_size, product_weight,
    product_description, product_rating, product_reviews,
    product_release_date, product_expiry_date, product_price
FROM mock_data;

-- dim_store
INSERT INTO dim_store (
    name, location, city, state, country, phone, email
)
SELECT DISTINCT
    store_name, store_location, store_city, store_state,
    store_country, store_phone, store_email
FROM mock_data;

-- dim_supplier
INSERT INTO dim_supplier (
    name, contact, email, phone, address, city, country
)
SELECT DISTINCT
    supplier_name, supplier_contact, supplier_email,
    supplier_phone, supplier_address, supplier_city, supplier_country
FROM mock_data;

-- dim_date
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

-- fact_sales
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
    m.store_name = st.name AND
    m.store_city = st.city
JOIN dim_supplier sp ON
    m.supplier_name = sp.name AND
    m.supplier_email = sp.email
JOIN dim_customer_location cl ON
    m.customer_country = cl.country AND
    m.customer_postal_code = cl.postal_code;

DROP TABLE mock_data;
