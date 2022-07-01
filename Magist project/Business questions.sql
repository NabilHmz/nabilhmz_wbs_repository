use magist;

# Eniac has two main concerns:
	# Is Magist a good fit for high-end tech products?
	# Are orders delivered on time?
    
# Business questions
	# Note: translate business terms into tables, columns and aggregations
    #		make your own educated guesses or assumptions (e.g. what can be considered a “tech” or an “expensive” product).
    
# Quesntions in relation to the products:
	# 1. What categories of tech products does Magist have?
SELECT 
    *
FROM
    product_category_name_translation;
		# audio, cds_dvds_musicals, console_games, dvds_blu_ray, home_appliances, home_appliances_2, electronics, small_appliances, computer_accessories, pc_gamer, computers, small_appliances_home_oven_and_coffee, portable_kitchen_food_processors, signaling_and_security, tablets_printing_image, telephony, fixed_telephony.
        # Simon's list: ("audio", "computers", "computers_accessories", "electronics", "signaling_and_security", "tablets_printing_image", "telephony", "watches_gifts")
        
	# 2.1. How many products of these tech categories have been sold?
SELECT 
    COUNT(*) AS tech_products_sold
FROM
    product_category_name_translation
        JOIN
    products ON product_category_name_translation.product_category_name = products.product_category_name
        JOIN
    order_items ON products.product_id = order_items.product_id
WHERE
    product_category_name_translation.product_category_name_english IN ('audio', 
		'computers',
        'computers_accessories',
        'electronics',
        'signaling_and_security',
        'tablets_printing_image',
        'telephony',
        'watches_gifts');
		# tech_products_sold = 21979
    
    # 2.2. What percentage does that represent from the overall number of products sold?
SELECT 
    ROUND(21979 / COUNT(*) * 100, 2)
FROM
    order_items;  
        # 19.51 % of total products sold are tech products
        
	# 3. What’s the average price of the products being sold?
SELECT 
    ROUND(AVG(price), 2) AS avg_price
FROM
    order_items;
            # the average price of all products being sold = 120.65
            
            # What is the average price of tech products being sold?
SELECT 
    ROUND(AVG(price), 2) AS tech_products_avg_price
FROM
    product_category_name_translation
        JOIN
    products ON product_category_name_translation.product_category_name = products.product_category_name
        JOIN
    order_items ON products.product_id = order_items.product_id
WHERE
    product_category_name_translation.product_category_name_english IN ('audio' , 'computers',
        'computers_accessories',
        'electronics',
        'signaling_and_security',
        'tablets_printing_image',
        'telephony',
        'watches_gifts');
                # the average price of tech products being sold is 132.11
                
	# 4. Are expensive tech products popular? * TIP: Look at the function CASE WHEN to accomplish this task.
SELECT 
    CASE
        WHEN price <= 132.11 THEN 'cheap'
        ELSE 'expensive'
    END AS price_category,
    COUNT(*) AS orders,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND((COUNT(*) * AVG(price)), 2) AS total_sales_per_cat
FROM
    product_category_name_translation
        JOIN
    products ON product_category_name_translation.product_category_name = products.product_category_name
        JOIN
    order_items ON products.product_id = order_items.product_id
WHERE
    product_category_name_translation.product_category_name_english IN ('audio' , 'computers',
        'computers_accessories',
        'electronics',
        'signaling_and_security',
        'tablets_printing_image',
        'telephony',
        'watches_gifts')
GROUP BY 1;	
        # the sales of expensive tech products is 72.45 % of the total sales with an avg price of 324.14 % and 6490 orders while for cheap category, avg price is 51.64 and orders are 15489.

		# What is the total sales of tech products?
SELECT 
    round(sum(price), 2) AS tech_products_sales
FROM
    product_category_name_translation
        JOIN
    products ON product_category_name_translation.product_category_name = products.product_category_name
        JOIN
    order_items ON products.product_id = order_items.product_id
WHERE
    product_category_name_translation.product_category_name_english IN ('audio', 
		'computers',
        'computers_accessories',
        'electronics',
        'signaling_and_security',
        'tablets_printing_image',
        'telephony',
        'watches_gifts');
		# the total sales of tech products is 2903563.53
        
# Quesntions in relation to the sellers:
	# 5. How many months of data are included in the Magist database?
SELECT DISTINCT
    (YEAR(order_purchase_timestamp))
FROM
    orders
ORDER BY YEAR(order_purchase_timestamp);
		# we have years 2016 to 2018

SELECT 
    COUNT(DISTINCT (MONTH(order_purchase_timestamp)))
FROM
    orders
WHERE
    YEAR(order_purchase_timestamp) = '2016';
			# 3 months

SELECT 
    COUNT(DISTINCT (MONTH(order_purchase_timestamp)))
FROM
    orders
WHERE
    YEAR(order_purchase_timestamp) = '2017';
			# 12 months

SELECT 
    COUNT(DISTINCT (MONTH(order_purchase_timestamp)))
FROM
    orders
WHERE
    YEAR(order_purchase_timestamp) = '2018';
            # 10 months
	
		# Magist database includes 25 months of data ranging from 2016 to 2018. 
        
	# 6.1. How many sellers are there?     
SELECT 
    COUNT(DISTINCT seller_id)
FROM
    sellers;		
        # there are 3095 sellers
    
    # 6.2. How many Tech sellers are there?
SELECT 
    COUNT(DISTINCT oi.seller_id) AS tech_sellers_num,
    (3095 - COUNT(DISTINCT oi.seller_id)) AS non_tech_sellers_num
FROM
    products p
        JOIN
    product_category_name_translation pcnt ON p.product_category_name = pcnt.product_category_name
        JOIN
    order_items oi ON p.product_id = oi.product_id
WHERE
    pcnt.product_category_name_english IN ('audio' , 'computers',
        'computers_accessories',
        'electronics',
        'signaling_and_security',
        'tablets_printing_image',
        'telephony',
        'watches_gifts'); 
		# 549 are tech sellers and 2546 are non tech sellers.
        
    # 6.3. What percentage of overall sellers are Tech sellers?		
        # 21.56 % of the total sellers are tech sellers that is few competition
        
	# 7.1. What is the total amount earned by all sellers?
SELECT 
    ROUND(SUM(price), 2) AS total_amount_earned
FROM
    order_items;
		# the total amount earned by all sellers is 13591643.7
 
	# 7.2. What is the total amount earned by all Tech sellers?
SELECT 
    ROUND(SUM(price), 2)
FROM
    order_items
        JOIN
    products ON order_items.product_id = products.product_id
        JOIN
    product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name
WHERE
    product_category_name_translation.product_category_name_english IN ('audio' , 'computers',
        'computers_accessories',
        'electronics',
        'signaling_and_security',
        'tablets_printing_image',
        'telephony',
        'watches_gifts');
			# the total amount earned by all Tech sellers is 2903563.53

		# 7.3. Can you work out the average monthly income of all sellers?         
			# the avg monthly income of all sellers is 13591643.7 / 25 = 543665.75
            
		# 7.4. Can you work out the average monthly income of Tech sellers?
            # the average monthly income of Tech sellers is 2903563.53 / 25 = 116142.54
            # the avg monthly revenue of Eniac is 1011256 €. So it is interesting to integrate the Brezilian market.
        
# Questions in relation to the delivery time:
	# 8. What’s the average time between the order being placed and the product being delivered?
SELECT 
    AVG(DATEDIFF(order_delivered_customer_date,
            order_purchase_timestamp)) AS avg_delivery_time
FROM
    orders; 
		# where order_status = "delivered"; we might also add this line of code but it generates the same result.
		# the average time is 12.50 days
    
	# 9. How many orders are delivered on time vs orders delivered with a delay?
SELECT 
    COUNT(*)
FROM
    orders
WHERE
    order_status = 'delivered';
		# total orders 96478

SELECT 
    COUNT(*)
FROM
    orders
WHERE
    DATEDIFF(order_estimated_delivery_date,
            order_delivered_customer_date) >= 0;
		# orders delivered on time 89810 that is 93.01 % of the total orders

SELECT 
    COUNT(*)
FROM
    orders
WHERE
    DATEDIFF(order_estimated_delivery_date,
            order_delivered_customer_date) < 0;		
        # order delayed 6666 that is 6.91% of the total orders

    # 10. Is there any pattern for delayed orders, e.g. big products being delayed more often?
SELECT 
    ROUND(AVG(product_weight_g), 2)
FROM
    products;
		# 2276.75

SELECT 
    products.product_weight_g,
    CASE
        WHEN products.product_weight_g > 2276.75 THEN 'heavy'
        ELSE 'light'
    END AS product_weight_cat,
    AVG(DATEDIFF(order_estimated_delivery_date,
            order_delivered_customer_date))
FROM
    products
        JOIN
    order_items ON products.product_id = order_items.product_id
        JOIN
    orders ON orders.order_id = order_items.order_id
WHERE
    DATEDIFF(order_estimated_delivery_date,
            order_delivered_customer_date) < 0
GROUP BY product_weight_cat
ORDER BY AVG(DATEDIFF(order_estimated_delivery_date,
        order_delivered_customer_date)) DESC;





