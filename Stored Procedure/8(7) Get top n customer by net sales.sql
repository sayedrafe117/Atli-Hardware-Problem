CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_n_sutomer_by_net_sales`(
		in_market varchar(45),
        in_fiscal_year int,
        in_top_n int
)
BEGIN
  select customer,sum(net_sales)/1000000 as net_sales_miln
	from net_sales n
	join dim_customer  c
	on n.customer_code=c.customer_code
	where fiscal_year=in_fiscal_year and n.market=in_market
	group by customer
	order by net_sales_miln desc
	limit in_top_n;
END