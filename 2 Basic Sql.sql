SELECT * FROM moviesdb.movies where imdb_rating between 6 and 8;

# For three years
SELECT * 
FROM moviesdb.movies
 where release_year in (2022,2019,2018)

SELECT * 
FROM moviesdb.movies
where studio in ("Marvel Studios","Zee Studios")
 
 
# For second highest imdb rating (To limit the rating the first one is index 0 second one is 1)
SELECT * 
FROM moviesdb.movies
where industry ="hollywood"
order by imdb_rating desc limit 5 offset 1

#EX 2
1. Print all movies in the order of their release year (latest first)
select *
From movies
order by release_year desc

2. All movies released in the year 2022
select *
From movies
where  release_year=2022

3. Now all the movies released after 2020
select *
From movies
where  release_year>2020

4. All movies after the year 2020 that have more than 8 rating
select *
From movies
where  release_year>2020 and imdb_rating> 8

5. Select all movies that are by Marvel studios and Hombale Films
select *
From movies
where studio in ("Marvel Studios","Hombale Films")

6) select all thor movies by their release year
select title, release_year from movies 
where title like '%thor%' order by release_year asc

7. Select all movies that are not from Marvel Studios
select *
From movies
where studio!="Marvel Studios"


# Group By
Select industry, count(*) as total_movies
from movies
group by industry

Select studio, count(*) as total_movies
from movies
where studio!=""
group by studio
order by total_movies desc 
select * from movies

# EX3
1. How many movies were released between 2015 and 2022
select count(*) as total
from movies
where release_year between 2015 and 2022

3. Print a year and how many movies were released in that year starting with the latest year
select release_year,count(*) as movie_realease
from movies
group by release_year
order by release_year desc


# HAving clause
select release_year,count(*) as movie_realease
from movies
group by release_year
having movie_realease>2 #Having column must need to be presented in the select statement
order by release_year desc

the format is from>where>groupby>having>orderby


# Cureent year
select *,year(current_date())-birth_year as age
from actors

# IF statement
SELECT *,
if(currency='USD',revenue*77,revenue) as revenue_inr
 FROM moviesdb.financials;
 
#Case Statement
SELECT *,
    case 
    when unit="thousands" then revenue/1000
    when unit="billions" then revenue*1000
    else revenue
    end as revenue_mln
 FROM moviesdb.financials;