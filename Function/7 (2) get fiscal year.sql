CREATE DEFINER=`root`@`localhost` FUNCTION `get_fiscal_year`(
     calendar_date date
 ) RETURNS int
    DETERMINISTIC
BEGIN
    declare fiscal_year int; 
	set fiscal_year=year(Date_Add(calendar_date,Interval 4 Month));
    Return fiscal_year;
END