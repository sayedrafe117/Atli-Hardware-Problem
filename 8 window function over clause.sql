--- Window Functions: Over Clause
new database random_table

SELECT * FROM random_tables.expenses;
I want to know what is the percentage expense for a given item
compare to total expenses

Ans: 
select  *, amount*100/sum(amount) over() as pct
from expenses
order by category

Now i want to get the pct but not with the total pct but 
for the individual category

select  *, amount*100/sum(amount) over(partition by category) as pct
from expenses
order by category


Now i want to show cumulative expenses ( cumulative expenses is like for joto date jachhe amr category te ami koto expense kortese)
on each dy what is my cumulative expenses on a given category;

select * ,
		sum(amount) over(partition by category	order by date) as total_expenses_till_date
from expenses
order by category,date




-- Window function using in a task
As a product owner,I want to see a bar chart for fy=2021for top 10 markets by 
% net sales .

with cte1 as(
  select customer,
		sum(net_sales)/1000000 as net_sales_miln
	from net_sales n
	join dim_customer  c
	on n.customer_code=c.customer_code
	where n.fiscal_year=2021
	group by customer)

select * ,
		net_sales_miln*100/sum(net_sales_miln) over() as pct
from  cte1
order by net_sales_miln desc

EX: As a product owner,I want to see region wise % net sales breakdown by 
customers in a respective region so that i can perform my regional analysis on 
financial performance of the compnay

explain analyze
with cte1 as(
  select c.customer,
		c.region,
		sum(net_sales)/1000000 as net_sales_miln
	from net_sales n
	join dim_customer  c
	on n.customer_code=c.customer_code
	where n.fiscal_year=2021
	group by c.customer,c.region)

select * ,
		net_sales_miln*100/sum(net_sales_miln) over(partition by region ) as pct
from  cte1
order by c.region,net_sales_miln desc











-- Widow Function Row_number, Rank, Dense Rank
# Show top 2 expenses in each Category

select *,
		row_number() over(partition by category order by amount desc) as rn
from expenses
order by category


#rank and dense rank
select *,
	row_number() over(partition by category order by amount desc) as rn,
    rank() over(partition by category order by amount desc) as rnk,
    dense_rank() over(partition by category order by amount desc) as drn
from expenses
order by category

# now for the ans
with cte2 as (
select *,
	row_number() over(partition by category order by amount desc) as rn,
    rank() over(partition by category order by amount desc) as rnk,
    dense_rank() over(partition by category order by amount desc) as drn
from expenses
order by category)
select * from cte2 where drn<=2;



#I want give books for the top 5 people thats why i can use the dense rank

SELECT *,
	row_number() over(order by marks desc) as rn,
    rank() over(order by marks desc) as rnk,
    dense_rank() over(order by marks desc) as drn

 FROM random_tables.student_marks;
 
 
 
 # Write a stored procedure for getting the top n products in each devision 
 by theier quantity sold in a given financial year 2021
 
 with cte1 as(select p.division,
		p.product,
		sum(sold_quantity) as total_qty
from fact_sales_monthly s
join dim_product p
on 
	p.product_code=s.product_code
where fiscal_year=2021
group by p.division,p.product),
cte2 as(
	select *,
			dense_rank() over(partition by division order by total_qty desc) as drnk
	from cte1)
select * from cte2
where drnk<=3






