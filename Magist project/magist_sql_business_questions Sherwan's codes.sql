USE magist;



# 1:
SELECT * 
FROM product_category_name_translation
WHERE product_category_name_english LIKE "%tech%"
	OR product_category_name_english LIKE "%audio%"
    OR product_category_name_english LIKE "%dvds%"
    OR product_category_name_english LIKE "%game%"
    OR product_category_name_english LIKE "%electronics"
    OR product_category_name_english LIKE "%computer%"
    OR product_category_name_english LIKE "%signal%"
    OR product_category_name_english LIKE "%tablet"
    OR product_category_name_english LIKE "%telephon%";


SELECT * 
FROM product_category_name_translation
WHERE product_category_name_english IN ("audio", "computers", "computers_accessories","electronics", 
					"signaling_and_security", "tablets_printing_image", "telephony", "watches_gifts", 
                    "dvds_blu_ray" , "pc_gamer", "consoles_games");


# 2:
WITH tech_product_categories AS (
SELECT product_category_name, product_category_name_english
FROM product_category_name_translation
WHERE product_category_name_english LIKE "%tech%"
	OR product_category_name_english LIKE "%audio%"
    OR product_category_name_english LIKE "%dvds%"
    OR product_category_name_english LIKE "%game%"
    OR product_category_name_english LIKE "%electronics"
    OR product_category_name_english LIKE "%computer%"
    OR product_category_name_english LIKE "%signal%"
    OR product_category_name_english LIKE "%tablet"
    OR product_category_name_english LIKE "%telephon%")
    
SELECT tech_product_categories.product_category_name_english, COUNT(order_items.product_id) AS n_sales
FROM tech_product_categories
	JOIN products
		ON tech_product_categories.product_category_name = products.product_category_name
	JOIN order_items
		ON products.product_id = order_items.product_id
GROUP BY 1
ORDER BY 2 DESC;
    
SELECT ROUND(17660 / COUNT(*) * 100 , 2) AS percent_of_sales
FROM order_items;
    
# 3:
    
SELECT ROUND(AVG(price),2) AS avarage_price
FROM order_items;
	
# 4:
WITH product_sold_count AS (
SELECT COUNT(product_id) AS n_sold
FROM order_items
GROUP BY product_id)
SELECT AVG(n_sold)
FROM product_sold_count;

WITH tech_product_categories AS (
SELECT product_category_name, product_category_name_english
FROM product_category_name_translation
WHERE product_category_name_english LIKE "%tech%"
	OR product_category_name_english LIKE "%audio%"
    OR product_category_name_english LIKE "%dvds%"
    OR product_category_name_english LIKE "%game%"
    OR product_category_name_english LIKE "%electronics"
    OR product_category_name_english LIKE "%computer%"
    OR product_category_name_english LIKE "%signal%"
    OR product_category_name_english LIKE "%tablet"
    OR product_category_name_english LIKE "%telephon%")
    
SELECT products.product_id, 
	tech_product_categories.product_category_name_english AS category_name, 
	COUNT(order_items.product_id) AS n_sales,
    ROUND(AVG(order_items.price),2) As average_product_price,
    CASE 
		WHEN COUNT(order_items.product_id) > 3 * 3.4187 THEN "very popular"
        WHEN COUNT(order_items.product_id) > 2 * 3.4187 THEN "popular"
        WHEN COUNT(order_items.product_id) > 3.4187 THEN "normal"
        ELSE "not popular"
	END AS popularity
FROM tech_product_categories
	JOIN products
		ON tech_product_categories.product_category_name = products.product_category_name
	JOIN order_items
		ON products.product_id = order_items.product_id
GROUP BY 1 
HAVING AVG(order_items.price) >= (3 *120.6)
ORDER BY 4 DESC;


# 5:
SELECT COUNT(DISTINCT YEAR(order_approved_at) ,MONTH(order_approved_at)) AS num_of_months
FROM orders;

SELECT  YEAR(order_approved_at) ,MONTH(order_approved_at)
FROM orders
GROUP BY 1, 2
ORDER BY 1, 2;

# 6:
SELECT COUNT(*)
FROM sellers;

WITH tech_product_categories AS (
SELECT product_category_name, product_category_name_english
FROM product_category_name_translation
WHERE product_category_name_english LIKE "%tech%"
	OR product_category_name_english LIKE "%audio%"
    OR product_category_name_english LIKE "%dvds%"
    OR product_category_name_english LIKE "%game%"
    OR product_category_name_english LIKE "%electronics"
    OR product_category_name_english LIKE "%computer%"
    OR product_category_name_english LIKE "%signal%"
    OR product_category_name_english LIKE "%tablet"
    OR product_category_name_english LIKE "%telephon%")

SELECT COUNT(DISTINCT o.seller_id)
FROM tech_product_categories t
	JOIN products  p
		ON t.product_category_name = p.product_category_name
	JOIN order_items o
		ON p.product_id = o.product_id;
        
# 548 / 3095 *100 = 17.70

# 7:
SELECT ROUND(SUM(o_i.price),2) AS total_earnd_amount 
FROM orders o 
	JOIN order_items o_i
		ON o.order_id = o_i.order_id
WHERE o.order_status != "canceld";

WITH tech_product_categories AS (
SELECT product_category_name, product_category_name_english
FROM product_category_name_translation
WHERE product_category_name_english LIKE "%tech%"
	OR product_category_name_english LIKE "%audio%"
    OR product_category_name_english LIKE "%dvds%"
    OR product_category_name_english LIKE "%game%"
    OR product_category_name_english LIKE "%electronics"
    OR product_category_name_english LIKE "%computer%"
    OR product_category_name_english LIKE "%signal%"
    OR product_category_name_english LIKE "%tablet"
    OR product_category_name_english LIKE "%telephon%")
    
SELECT ROUND(SUM(o_i.price),2) AS tech_earnd_amount 
FROM orders o 
	JOIN order_items o_i
		ON o.order_id = o_i.order_id
	JOIN products p 
		ON o_i.product_id = p.product_id
	JOIN tech_product_categories t_p_c
		ON p.product_category_name = t_p_c.product_category_name
WHERE o.order_status != "canceld";


# 8:
SELECT o_i.seller_id, AVG(o_i.price) AS average_sell
FROM orders o 
	JOIN order_items o_i
		ON o.order_id = o_i.order_id
WHERE o.order_status != "canceld"
GROUP BY 1
ORDER BY 2 DESC ;

SELECT o_i.seller_id, AVG(o_i.price) AS average_sell
FROM products p
	JOIN product_category_name_translation p_c
		ON p.product_category_name = p_c.product_category_name
	JOIN order_items o_i
		ON p.product_id = o_i.product_id
	JOIN orders o
		ON o_i.order_id = o.order_id  
WHERE o.order_status != "canceld"
	AND p_c.product_category_name_english IN ("audio", "computers", "computers_accessories","electronics", 
					"signaling_and_security", "tablets_printing_image", "telephony", "watches_gifts", 
                    "dvds_blu_ray" , "pc_gamer", "consoles_games")
GROUP BY 1
ORDER BY 2 DESC ;

# 9:
SELECT AVG(datediff(order_delivered_customer_date , order_approved_at)) AS AVG_DateDiff
FROM orders
WHERE order_status != "canceld";

# 10:

SELECT COUNT(*) AS aLL_DeliVeReD
FROM orders
WHERE order_status = "delivered";
        
SELECT COUNT(*) AS oN_TiMe_DeliVeReD
FROM orders
WHERE datediff(order_delivered_customer_date , order_estimated_delivery_date) <= 0 
		AND order_status = "delivered";
       
SELECT COUNT(*) AS DeLayeD_DeliVeReD
FROM orders
WHERE datediff(order_delivered_customer_date , order_estimated_delivery_date) > 0 
		AND order_status = "delivered";
        
# 11:
SELECT AVG(datediff(o.order_delivered_customer_date, o.order_estimated_delivery_date)) AS avg_delayed_delivery,
		AVG(p.product_weight_g) , AVG(p.product_height_cm),
        AVG(p.product_length_cm), AVG(p.product_width_cm)
FROM orders o
	JOIN order_items oi
		ON o.order_id = oi.order_id
	JOIN products p
		ON oi.product_id = p.product_id 
WHERE datediff(o.order_delivered_customer_date , o.order_estimated_delivery_date) > 0 
		AND o.order_status = "delivered";

SELECT AVG(datediff(o.order_delivered_customer_date , o.order_estimated_delivery_date)) AS avg_early_deliverd, 
		AVG(p.product_weight_g) , AVG(p.product_height_cm) , 
        AVG(p.product_length_cm), AVG(p.product_width_cm)
FROM orders o
	JOIN order_items oi
		ON o.order_id = oi.order_id
	JOIN products p
		ON oi.product_id = p.product_id 
WHERE datediff(o.order_delivered_customer_date , o.order_estimated_delivery_date) <= 0 
		AND o.order_status = "delivered";

SELECT AVG(datediff(o.order_delivered_customer_date , o.order_estimated_delivery_date)) AS avg_all_delivered,
		AVG(p.product_weight_g) , AVG(p.product_height_cm) ,
		AVG(p.product_length_cm), AVG(p.product_width_cm)
FROM orders o
	JOIN order_items oi
		ON o.order_id = oi.order_id
	JOIN products p
		ON oi.product_id = p.product_id 
WHERE o.order_status = "delivered";

SELECT 
	CASE
		WHEN p.product_weight_g >= 2500 THEN 'very_high_weight'
        WHEN p.product_weight_g >= 2000 THEN 'high_weight'
        WHEN p.product_weight_g >= 1500 THEN 'medium_weight'
        WHEN p.product_weight_g >= 1000 THEN 'low_weight'
        WHEN p.product_weight_g >= 500 THEN 'very_low_weight'
        ELSE 'Light_weight'
	END AS weight_range,
		AVG(datediff(o.order_delivered_customer_date , o.order_estimated_delivery_date)) AS avg_delay_delivered
FROM orders o
	JOIN order_items oi
		ON o.order_id = oi.order_id
	JOIN products p
		ON oi.product_id = p.product_id 
WHERE datediff(o.order_delivered_customer_date , o.order_estimated_delivery_date) > 0
		AND o.order_status = "delivered"
GROUP BY weight_range;