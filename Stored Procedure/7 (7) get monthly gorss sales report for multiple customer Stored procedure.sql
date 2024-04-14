CREATE DEFINER=`root`@`localhost` PROCEDURE `get_monthly_gross_sales_for_multiple_customer`(
	in_customer_codes text
)
BEGIN
SELECT s.date,
        sum(Round(s.sold_quantity * g.gross_price,2)) as gross_price_total
       
FROM fact_sales_monthly s
join fact_gross_price g
on 
	g.product_code=s.product_code and
    g.fiscal_year=get_fiscal_year(s.date)
    
where
	find_in_set(s.customer_code,in_customer_codes)>0
group by s.date;
END