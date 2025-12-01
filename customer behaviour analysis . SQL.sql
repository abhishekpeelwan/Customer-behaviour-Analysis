select * from customer;

--Q1. what is the total revanue genrated by male and female customer's ?

select gender , sum(porchase_amount) as revenue from customer
group by gender

--Q2. which customer used a discount but still spent more then the average purchase amount ?

select customer_id ,porchase_amount from customer
where porchase_amount >= (select AVG(porchase_amount) from customer)


--Q3. which sre the top 5 prodect with the highest average review rating ?

select item_purchased , avg(review_rating) as average_product_rating
from customer 
group by item_purchased
order by (average_product_rating) desc
limit 5;


--Q4. compare the average purchase amount between standerd and express shiping ?

select shipping_type , AVG(porchase_amount)
from customer
where shipping_type in ('Standard','Express')
group by shipping_type


--Q5. Do subscribed customers spend more ? compare average spend and total revanue 
--between subscribers and non subscribers.

select subscription_status,
count(customer_id) as total_customer,
ROUND(avg(porchase_amount),2) as average_spend ,
ROUND(sum(porchase_amount),2) as total_revanue from customer
group by subscription_status
order by total_revanue ;

--Q6. which 5 product have the highest percentage of purchase with discount applied ?

select item_purchased ,
ROUND(100 * SUM(CASE WHEN discount_applied = 'yes' THEN 1 ELSE 0 END )/COUNT(*) ,2) as discount_rate
from customer
group by item_purchased
order by discount_rate  desc
limit 5 ;


--Q7. segment customers into new , Returning and loyal based on their total 
--number of previous purchases , and show the count of each segment .
with customer_type as (
select customer_id , previous_purchases,
case 
	when previous_purchases = 1 then 'new'
	when previous_purchases between 2 and 10 then 'returning'
	else 'loyal'
	end as customer_segment
from customer
)
select customer_segment , count (*) as "number_of_customers"
from customer_type
group by customer_segment;

--Q8. what are the top 3 product purchased within each category ? 

with item_count as (
select category, item_purchased,
count(customer_id) as total_orders,
row_number() over(partition by category order by count (customer_id)desc) as item_rank
from customer
group by category, item_purchased 
)

select item_rank , category , item_purchased , total_orders
from item_count
where item_rank <= 3;



--Q9. Are customer who are repeat buyers (more then 5 previous purchased ) also lokely to subscrube ?

select subscription_status,
count (customer_id) as repeat_buyers
from customer 
where previous_purchases > 5
group by subscription_status; 


--Q10. what is the revenue contribution of each age group ?

select age_group , sum (porchase_amount) as total_revanue
from customer
group by age_group
order by total_revanue desc ;
