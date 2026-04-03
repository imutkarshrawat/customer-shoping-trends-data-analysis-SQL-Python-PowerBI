select * from customer limit 10;

-- Q1- What is the total revenue genrated by male vs female customers ?
select gender , sum(purchase_amount)
from customer
group by gender;


-- Q2- which customer used a discoutn but still spent more then the average purchase amount?
select customer_id,purchase_amount 
from customer 
where discount_applied='Yes' and
purchase_amount > (select avg(purchase_amount) from customer);


--Q3-  what are the top 5 product with the highest average rating ?
select item_purchased, 
round(avg(review_rating::numeric),2) as avg_rating 
from customer
group by item_purchased
order by round(avg(review_rating::numeric),2) desc limit 5;


--Q4 - Compare the average purchase amount between Standard and Express shipping ?
select shipping_type ,
avg(purchase_amount) as avg_purchase_amount 
from customer 
where shipping_type in ('Express','Standard')
group by shipping_type;


--Q5- Do subsribed customers spend more ? compare average spend and total revenue between subsriber and non-subsriber ?
select subscription_status,count(customer_id) as total_customer,
sum(purchase_amount) as total_sales ,
round(avg(purchase_amount::numeric),2) as avg_sales 
from customer
group by subscription_status
order by total_sales;

--Q6- which 5 products have the highest percentatge of purchase with discount applied ?

select distinct item_purchased,
count(item_purchased) 
from customer
where discount_applied='Yes'
group by item_purchased 
order by count(item_purchased) desc
limit 5;


--Q7- Segment customers into New, Returning and loyal based on there total number of previous putchases ?
-- (show the count of each segment)
with customer_type as
(select customer_id, previous_purchases,
case
	When previous_purchases=1 then 'New'
	When previous_purchases between 2 and 10 then 'Returning'
	else 'loyal'
end as customer_segment
from customer)

select customer_segment,
count(*) as "number of customers"
from customer_type
group by customer_segment;


-- Q8- What are the top 3 most purchased products within each category ?
with  item_counts as
(select item_purchased, category,
count(*) as total_quantity,
row_number() over(partition by category order by count(customer_id) desc) as item_rank
from customer
group by item_purchased,category
)

select item_purchased,category,total_quantity 
from item_counts
where item_rank<=3
;


-- Q9- Are customers who are repeay buyes (more then 5 previous purchases) also likely to subscribe ?
select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases>5
group by subscription_status;


-- Q9- what is the revenue contribution of each age group ?
select age,
sum(purchase_amount) total_sales
from customer
group by age
order by total_sales;


