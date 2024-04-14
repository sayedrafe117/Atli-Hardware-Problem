-- SUPPLY CHAIN BASICS SIMPLIFIED
Absolute net error percentage is = sum of net error/Total Forecast
Forecast accuracy= 1-Net Eroor / 1- Absolute net error

# Forecast acuracy for all customers for a given fiscal year
As a product owner,I need an aggreagate forecast accuracy repoprt for all the customer
for a given fisccal year. So that I can track accuracy of the forecast we make for these customer

The report should have 
1. Customer Code,Name,Market
2. Total soldwty
3.Net error
4. Absolute error
5. Forecast accuracy %




-- CREATE A HELPER TABLE
Create a new table where we have both forecast and actuals data

create table fact_act_est(
select 
		s.date as date,
		s.fiscal_year as fiscal_year,
		s.product_code as product_code,
		s.customer_code as customer_code,
		s.sold_quantity as sold_quantity,
		f.forecast_quantity as forecast_quantity
from 
		fact_sales_monthly s
left join fact_forecast_monthly f 
using (date, customer_code, product_code) # We are using "using" instead of on because for the join both column names are same
union
select 
		f.date as date,
		f.fiscal_year as fiscal_year,
		f.product_code as product_code,
		f.customer_code as customer_code,
		s.sold_quantity as sold_quantity,
		f.forecast_quantity as forecast_quantity
from 
		fact_forecast_monthly  f
left join fact_sales_monthly s 
using (date, customer_code, product_code))