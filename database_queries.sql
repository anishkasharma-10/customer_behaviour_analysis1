select * from customer limit 20

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'customer';

SELECT "Gender", SUM("Puchrase amount") AS revenue
FROM customer
GROUP BY "Gender";

--Ques 3. Which customer used a discount but still spent more than average amount?
SELECT "Customer ID", "Puchrase amount"
FROM customer
WHERE "Discount applied" = 'Yes'
AND "Puchrase amount" >= (
    SELECT AVG("Puchrase amount")
    FROM customer ID
);
--Ques 4. top 5 products with average review rating 
SELECT "Item purchage",
       AVG("Review Rate") AS "Average Product Rating"
FROM customer
GROUP BY "Item purchage"
ORDER BY AVG("Review Rate") DESC
LIMIT 5;

--Ques 5. Compare the average purchase amount between standard and express shipping
SELECT "Shpping type",
       ROUND(AVG("Puchrase amount"),2)
FROM customer
WHERE "Shpping type" IN ('Standard','Express')
GROUP BY "Shpping type";
do subscribes customers spend more? compare average spend and total revenue
---between subscibers and non-subscribers
SELECT "Subscription Status",
       COUNT("Customer ID") AS total_subscribers,
       ROUND(AVG("Puchrase amount"), 2) AS avg_spend,
       ROUND(SUM("Puchrase amount"), 2) AS total_revenue
FROM customer
GROUP BY "Subscription Status"
ORDER BY total_revenue DESC, avg_spend DESC;

--Ques 6. which 5 products have  highest percentage of purchases with discounts applied
SELECT "Item purchage",
       ROUND(
           SUM(CASE WHEN "Discount applied" = 'Yes' THEN 1 ELSE 0 END) * 100.0
           / COUNT(*),
           2
       ) AS discount_rate
FROM customer
GROUP BY "Item purchage"
ORDER BY discount_rate DESC
LIMIT 5;


--ques 7 .segment customers into new, returning and loyal based on their total number of previous purchases and show count of each segment
--ques 7 .segment customers into new, returning and loyal based on their total number of previous purchases and show count of each segment

WITH customer_type AS (
    SELECT "Customer ID",
           "Previous purchages",
           CASE
               WHEN "Previous purchages" = 1 THEN 'NEW'
               WHEN "Previous purchages" BETWEEN 2 AND 10 THEN 'Returning'
               ELSE 'loyal'
           END AS customer_segment
    FROM customer
)

SELECT customer_segment,
       COUNT(*) AS "Number of customers"
FROM customer_type
GROUP BY customer_segment;


-- ques8  what are top three purchases within each category

WITH item_counts AS (
    SELECT "Category",
           "Item purchage",
           COUNT("Customer ID") AS total_orders,
           ROW_NUMBER() OVER (
               PARTITION BY "Category"
               ORDER BY COUNT("Customer ID") DESC
           ) AS item_rank
    FROM customer
    GROUP BY "Category", "Item purchage"
)

SELECT item_rank,
       "Category",
       "Item purchage",
       total_orders
FROM item_counts
WHERE item_rank <= 3;

-- ques 9 are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?

SELECT "Subscription Status",
       COUNT("Customer ID") AS repeat_buyers
FROM customer
WHERE "Previous purchages" > 5
GROUP BY "Subscription Status";


-- ques 10 what is revenue  contribution of each age group?



SELECT "Age",
       SUM("Puchrase amount") AS total_revenue
FROM customer
GROUP BY "Age"
ORDER BY total_revenue DESC;

