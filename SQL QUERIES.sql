create database Customer_behavior;
use Customer_behavior;
select * from customer limit 10;
/*Q1: what is the total revenue generate by male vs female customer*/

SELECT gender , sum(purchase_amount) as "REVENUE" from customer group by (gender);

/*Q2: which customer used a discount but still spent more than the average purchase amount?*/

select customer_id, purchase_amount from customer where discount_applied ='Yes' 
and purchase_amount>=(select avg(purchase_amount) from customer);

/*Q3 which are the top 5 products with the highest average review rating?*/

select item_purchased , ROUND(avg(review_rating),2) as "AVERAGE_PRODUCT_RATING" from customer group by item_purchased 
order by AVERAGE_PRODUCT_RATING DESC LIMIT 5;

/*Q4 Compare the average purchase amounts between standard and express shipping*/
select shipping_type,ROUND(avg(purchase_amount),2 )from customer where shipping_type  in ('Standard','Express') group by shipping_type; 

/*Q5 Do subscribed customer spend more? compare avg spend and total revenue between subscribers and non subscribers*/

select subscription_status,count(customer_id) as "total_customers", round(avg(purchase_amount),2) as "AVG_SPEND",
ROUND(SUM(purchase_amount),2) as "REVENUE" FROM customer group by subscription_status order by "REVENUE";

/*Q6 Which 5 products have the highest percentage of purchases with discount applied*/
select item_purchased ,round(100 * sum(case when discount_applied='yes' then 1 else 0 end)/count(*),2) as "Discount_Rate" from customer 
 group by item_purchased order by Discount_Rate desc limit 5;
 
 /*Q7 Segment customers into new , returning and loyal based on their total number of previous purchases and show count of each segment */
WITH CUSTOMER_TYPE AS (
SELECT CUSTOMER_ID,PREVIOUS_PURCHASES ,CASE
	WHEN PREVIOUS_PURCHASES =1 THEN "NEW"
    WHEN PREVIOUS_PURCHASES BETWEEN 2 AND 10 THEN "RETURNING"
    ELSE "LOYAL"
    END AS CUSTOMER_SEGMENT FROM CUSTOMER)
SELECT CUSTOMER_SEGMENT ,COUNT(*) AS "NUMBER OF CUSTOMERS" FROM CUSTOMER_TYPE GROUP BY CUSTOMER_SEGMENT;
 
 /*Q8 What are the top 3 most purchased product in each category */
 with item_count as (select category,item_purchased ,count(customer_id) as "total_orders", row_number() OVER (PARTITION BY CATEGORY ORDER 
 BY COUNT(customer_id) desc) as item_rank from customer group by category ,item_purchased)
 select item_rank,category ,item_purchased ,total_orders from item_count where item_rank<=3;
 
  /*Q9 Are customers who are repeat buyers(more than 5 previous purchases) also likely to subscribe?*/
  select subscription_status,count(customer_id) as "REPEAT_BUYERS"
  FROM CUSTOMER WHERE PREVIOUS_PURCHASES >5 group by subscription_status;
  
    /*Q10 What is the revenue contribution of each age group ?*/
    select age_group,sum(purchase_amount) as 'revenue' from customer group by age_group order by age_group desc;