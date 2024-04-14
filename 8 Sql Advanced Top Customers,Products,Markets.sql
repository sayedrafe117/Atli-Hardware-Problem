-- Problem statement and pre invoice discount report
As a product owner,I want a report for top markets,products,customer by
net sales for a given financial year so that I can have a holiistic view
of our performance and can take appropriate actions

1. Report by top market
2. Report by top products
3. Report by top customer


Ans:
# Gettting the pre invoice discount pct
SELECT s.date,s.product_code,
		p.product,p.variant,s.sold_quantity,
        g.gross_price,
        Round(s.sold_quantity * g.gross_price,2) as gross_price_total,
        pre.pre_invoice_discount_pct
       
FROM fact_sales_monthly s
join dim_product p
on p.product_code=s.product_code
join dim_date dt
  on dt.calendar_date=s.date
  
join fact_gross_price g
on 
	g.product_code=s.product_code and
    g.fiscal_year=dt.fiscal_year
    
join fact_pre_invoice_deductions pre
on 
	pre.customer_code=s.customer_code and
    pre.fiscal_year=dt.fiscal_year
    
where
    get_fiscal_year(date)=2021
order by date asc


-- Performance Improvement 1

-- Performance Improvement 2
add fiscal year in the fact sales monthlty column
learnt new things
you can add a calculated column from the engineering part in mysql
this is called generated column



SELECT s.date,s.product_code,
		p.product,p.variant,s.sold_quantity,
        g.gross_price,
        Round(s.sold_quantity * g.gross_price,2) as gross_price_total,
        pre.pre_invoice_discount_pct
       
FROM fact_sales_monthly s
join dim_product p
on p.product_code=s.product_code
  
join fact_gross_price g
on 
	g.product_code=s.product_code and
    g.fiscal_year=s.fiscal_year
    
join fact_pre_invoice_deductions pre
on 
	pre.customer_code=s.customer_code and
    pre.fiscal_year=s.fiscal_year
    
where
    s.fiscal_year=2021
order by date asc



-- Database view introduction
# It is like a virtual table

with cte1 as(SELECT s.date,s.product_code,
		p.product,p.variant,s.sold_quantity,
        g.gross_price,
        Round(s.sold_quantity * g.gross_price,2) as gross_price_total,
        pre.pre_invoice_discount_pct
       
FROM fact_sales_monthly s
join dim_product p
on p.product_code=s.product_code
  
join fact_gross_price g
on 
	g.product_code=s.product_code and
    g.fiscal_year=s.fiscal_year
    
join fact_pre_invoice_deductions pre
on 
	pre.customer_code=s.customer_code and
    pre.fiscal_year=s.fiscal_year
    
where
    s.fiscal_year=2021
order by date asc)

select *,
		(gross_price_total - gross_price_total*pre_invoice_discount_pct) as net_invoice_sales
from cte1


-- After having the view option
select *,
		(gross_price_total - gross_price_total*pre_invoice_discount_pct) as net_invoice_sales
from sales_preinv_discount






-- Database View: Post invoice discounts,Net sales
# join with post invoice deduction to get the post invoice deduction

select *,
		(gross_price_total - gross_price_total*pre_invoice_discount_pct) as net_invoice_sales,
        (po.discounts_pct+po.other_deductions_pct) as post_invoice_discount_pct
from sales_preinv_discount s
join fact_post_invoice_deductions po
on 
	s.date=po.date and
    s.product_code=po.product_code and
    s.customer_code=po.customer_code
    
# now use the view sales_pre_invoce to get the net sales
SELECT *,
		(1-post_invoice_discount_pct)*net_invoice_sales as net_sales
 FROM gdb0041.sales_postinv_discount;



-- Top market and customers
select market,sum(net_sales)/1000000 as net_sales_miln
from net_sales
where fiscal_year=2021
group by market
order by net_sales_miln desc
limit 5

- customer
select customer,sum(net_sales)/1000000 as net_sales_miln
from net_sales n
join dim_customer  c
on n.customer_code=c.customer_code
where fiscal_year=2021
group by customer
order by net_sales_miln desc
limit 5



Erercise
select product,sum(net_sales)/1000000 as net_sales_miln
from net_sales n
join dim_customer  c
on n.customer_code=c.customer_code
where fiscal_year=2021
group by product
order by net_sales_miln desc
limit 5








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
