CREATE TEMP SEQUENCE import_seq START 1;

DO $$
DECLARE
    file_path TEXT;
    total_rows INTEGER;
    temp_table TEXT;
    customer_offset INTEGER := 0;
    seller_offset INTEGER := 0;
    product_offset INTEGER := 0;
    file_index INTEGER;
    shift_step INTEGER := 1000;
BEGIN
    FOR file_index IN 0..9 LOOP
        file_path := '/data/MOCK_DATA' || file_index || '.csv';
        temp_table := 'temp_import_' || file_index;

        EXECUTE format('CREATE TEMP TABLE %I (LIKE mock_data INCLUDING DEFAULTS) ON COMMIT DROP', temp_table);

        EXECUTE format('COPY %I FROM %L WITH (FORMAT csv, HEADER true)', temp_table, file_path);

        EXECUTE format('SELECT COUNT(*) FROM %I', temp_table) INTO total_rows;

        customer_offset := (file_index * shift_step);
        seller_offset := (file_index * shift_step);
        product_offset := (file_index * shift_step);

        EXECUTE format('
            INSERT INTO mock_data (
                id,
                customer_first_name,
                customer_last_name,
                customer_age,
                customer_email,
                customer_country,
                customer_postal_code,
                customer_pet_type,
                customer_pet_name,
                customer_pet_breed,
                seller_first_name,
                seller_last_name,
                seller_email,
                seller_country,
                seller_postal_code,
                product_name,
                product_category,
                product_price,
                product_quantity,
                sale_date,
                sale_customer_id,
                sale_seller_id,
                sale_product_id,
                sale_quantity,
                sale_total_price,
                store_name,
                store_location,
                store_city,
                store_state,
                store_country,
                store_phone,
                store_email,
                pet_category,
                product_weight,
                product_color,
                product_size,
                product_brand,
                product_material,
                product_description,
                product_rating,
                product_reviews,
                product_release_date,
                product_expiry_date,
                supplier_name,
                supplier_contact,
                supplier_email,
                supplier_phone,
                supplier_address,
                supplier_city,
                supplier_country
            )
            SELECT 
                nextval(''import_seq''),
                customer_first_name,
                customer_last_name,
                customer_age,
                customer_email,
                customer_country,
                customer_postal_code,
                customer_pet_type,
                customer_pet_name,
                customer_pet_breed,
                seller_first_name,
                seller_last_name,
                seller_email,
                seller_country,
                seller_postal_code,
                product_name,
                product_category,
                product_price,
                product_quantity,
                sale_date,
                sale_customer_id + %s,
                sale_seller_id + %s,
                sale_product_id + %s,
                sale_quantity,
                sale_total_price,
                store_name,
                store_location,
                store_city,
                store_state,
                store_country,
                store_phone,
                store_email,
                pet_category,
                product_weight,
                product_color,
                product_size,
                product_brand,
                product_material,
                product_description,
                product_rating,
                product_reviews,
                product_release_date,
                product_expiry_date,
                supplier_name,
                supplier_contact,
                supplier_email,
                supplier_phone,
                supplier_address,
                supplier_city,
                supplier_country
            FROM %I
        ', customer_offset, seller_offset, product_offset, temp_table);

        EXECUTE format('DROP TABLE IF EXISTS %I', temp_table);
    END LOOP;
END $$;

DROP SEQUENCE import_seq;
