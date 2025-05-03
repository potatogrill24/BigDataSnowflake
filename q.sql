-- 1. Топ-10 покупателей по общей сумме покупок
SELECT 
    customer_first_name,
    customer_last_name,
    SUM(sale_total_price) AS total_spent
FROM mock_data
GROUP BY customer_first_name, customer_last_name
ORDER BY total_spent DESC
LIMIT 10;

-- 2. Количество продаж по категориям продуктов
SELECT 
    product_category,
    COUNT(*) AS num_sales
FROM mock_data
GROUP BY product_category
ORDER BY num_sales DESC;

-- 3. Средняя цена товара по бренду
SELECT 
    product_brand,
    AVG(product_price) AS avg_price
FROM mock_data
GROUP BY product_brand
ORDER BY avg_price DESC LIMIT 25;

-- 4. Продажи по странам покупателей
SELECT 
    customer_country,
    SUM(sale_total_price) AS total_sales
FROM mock_data
GROUP BY customer_country
ORDER BY total_sales DESC LIMIT 20;

-- 5. Сколько товаров продано каждым продавцом
SELECT 
    seller_first_name,
    seller_last_name,
    SUM(sale_quantity) AS total_sold
FROM mock_data
GROUP BY seller_first_name, seller_last_name
ORDER BY total_sold DESC LIMIT 10;

-- 6. Продажи по времени: количество продаж по годам
SELECT 
    EXTRACT(YEAR FROM sale_date) AS sale_year,
    COUNT(*) AS sales_count
FROM mock_data
GROUP BY sale_year
ORDER BY sale_year;

-- 7. Средний рейтинг товаров по категориям
SELECT 
    product_category,
    AVG(product_rating) AS avg_rating
FROM mock_data
GROUP BY product_category
ORDER BY avg_rating DESC;
