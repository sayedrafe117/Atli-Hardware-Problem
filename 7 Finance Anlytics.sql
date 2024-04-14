# 3 popular relational databases are oracle,ms sql server,mysql
Gross price 30$
- Pre invoice deduction 2
=Net invoice sales 28
-Post invoice deductions 3
=Net Sales 25
-Cost of Goods Sold(COGS) 20
=Gross Mragin 5
Gross margin % of Net Sales(GM/NS) 20%























-- USER DEFINED SQL FUNCTION

PL1: As a product oowner i want to generate a report of individual product sales
(aggregated on a monthly basis at the product code level) 
for croma india customer for FY=2021
so that i can track individual product sales and 
run further product analytics on it in excel

The report should have
1. month
2.Product Name
3. Variant
4.Sold Quantity
5. Gross price per item
6.Gross price total

ANS
SELECT * FROM gdb0041.fact_sales_monthly
where
	customer_code=90002002 and 
    year(date_add(date,interval 4 month))=2021 # This is where fiscal year has been added by adding 4 months to date and then extract the year
order by date asc

#Use of user defined function
SELECT * FROM gdb0041.fact_sales_monthly
where
	customer_code=90002002 and 
    get_fiscal_year(date)=2021 # This is where fiscal year has been added by adding 4 months to date and then extract the year
order by date asc



-- EXERCISE User defined SQl function
# Get the quater from date
SELECT * FROM gdb0041.fact_sales_monthly
where
	customer_code=90002002 and 
    get_fiscal_year(date)=2020  and
    get_fiscal_quater(date)="Q2"
order by date asc




-- Gross Sales report monthly product transactions
# Final result
SELECT s.date,s.product_code,
		p.product,p.variant,s.sold_quantity,
        g.gross_price,
        Round(s.sold_quantity * g.gross_price,2) as gross_price_total
       
FROM fact_sales_monthly s
join dim_product p
on p.product_code=s.product_code

join fact_gross_price g
on 
	g.product_code=s.product_code and
    g.fiscal_year=get_fiscal_year(s.date)
    
where
	customer_code=90002002 and 
    get_fiscal_year(date)=2021
order by date asc




-- Gross Sale report: Total Sales Amount
2nd task: 
As a product owner ,I  need an aggregate monthly gorss sales report for croma India customer so that i can track
how much sales this particular customer is generating for atliq and manage 
our relationship accordingly

This report should have the following fields
1.Month
2.Total Gross sales amount to croma india in this month

ANS:

SELECT s.date,
        sum(Round(s.sold_quantity * g.gross_price,2)) as gross_price_total
       
FROM fact_sales_monthly s
join fact_gross_price g
on 
	g.product_code=s.product_code and
    g.fiscal_year=get_fiscal_year(s.date)
    
where
	customer_code=90002002
group by s.date
order by s.date asc


Exercise: 
Generate a yearly report for Croma India where there are two columns

1. Fiscal Year
2. Total Gross Sales amount In that year from Croma

SELECT g.fiscal_year,
        sum(Round(s.sold_quantity * g.gross_price,2)) as gross_price_total
       
FROM fact_sales_monthly s
join fact_gross_price g
on 
	g.product_code=s.product_code and
    g.fiscal_year=get_fiscal_year(s.date)
    
where
	customer_code=90002002
group by g.fiscal_year
order by s.date asc



-- Stored Procedures: Monthly Gorss Sales Report




-- Stored Procedure: Market BAdge
Create a stored procedure that can 
determine the market badge based on the following logic

if total sold quantity > 5 million that maket is considered gold else it is silver

My input will be 
market
fiscal_year

Output 
market badge

Ans: 
select sum(sold_quantity) as total_qty
from fact_sales_monthly s
join dim_customer c
on s.customer_code=c.customer_code
where get_fiscal_year(s.date)=2021 and c.market="India"
group by c.market

