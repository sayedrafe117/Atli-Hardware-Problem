CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_n_market_by_net_sales`(
		in_fiscal_year int,
		in_top_n int
)
BEGIN
   select market,sum(net_sales)/1000000 as net_sales_miln
	from net_sales
	where fiscal_year=in_fiscal_year
	group by market
	order by net_sales_miln desc
	limit in_top_n;
END