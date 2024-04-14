-- SUBQUERIES
# Print movie name with minimum and maximum rating
   # Return a list of value
select * from movies
where imdb_rating in ( 
		(select min(imdb_rating) from movies),
        (select max(imdb_rating) from movies));
	
    #Return a table
-- Select all the actors whose age > 70 and < 85
select * from 
(select name,year(curdate())-birth_year as age
from actors) as actors_age
where age>70 and age<85


-- ANY,ALL Operators
# Select actors who acted in any of these movies(101,110,121)
select * from actors where actor_id in(
select actor_id from movie_actor where movie_id in(101,110,121))
# both are showing the same results
select * from actors where actor_id= any(
select actor_id from movie_actor where movie_id in(101,110,121))

# select all movies whose rating is greater than any of the marvel movie rating
SELECT title,imdb_rating FROM moviesdb.movies
where imdb_rating > any(
select imdb_rating from movies where studio='Marvel Studios')

SELECT title,imdb_rating FROM moviesdb.movies
where imdb_rating > some(
select imdb_rating from movies where studio='Marvel Studios')

# Any and some are same


-- CO-RELATED SUBQUERY
# Select the actor id,actor name and the total number of movies they acted in
select a.actor_id,a.name, count(*) as movies_count
from movie_actor ma
join actors a on a.actor_id=ma.actor_id
group by actor_id
order by movies_count desc

explain analyze
select 
    actor_id,
    name,
    (select count(*)
		from movie_actor where actor_id=actors.actor_id) as movies_count
from actors
order by movies_count desc 
# This is subquery

EX1.
select all the movies with minimum and maximum release_year. Note that there 
can be more than one movies in min and max year hence output rows can be more than 2
select * from movies
where release_year in ( 
		(select min(release_year) from movies),
        (select max(release_year) from movies))


limit 2

2. Select all the rows 
from the movies table whose imdb_rating is higher than the average rating

select * from movies
where imdb_rating > (select avg(imdb_rating) from movies)



-- COMMON TABLE ECPRESSION(CTE)
with actors_age as(
		select name,year(curdate())-birth_year as age
		from actors)
select *
from actors_age
where age>70 and age <80

# in cte we can give the name of the columns
with actors_age(actor_name,agesss) as(
		select name,year(curdate())-birth_year as age
		from actors)
select *
from actors_age
where agesss>70 and agesss <80

# movies that produced 500% prfit and their rating was less than
avg rating for all movies

SELECT *,
		(revenue-budget)*100/budget as pct
FROM financials
where (revenue-budget)*100/budget>=500

# their rating was less than average rating
select * from movies 
where imdb_rating<(select avg(imdb_rating) from movies)

with x as(SELECT *,
		(revenue-budget)*100/budget as pct
		FROM financials),
	y as(select * from movies 
where imdb_rating<(select avg(imdb_rating) from movies))
select x.movie_id,x.pct,
		y.title,y.imdb_rating
from x
join y
on x.movie_id=y.movie_id
where x.pct>500




EX2 Select all Hollywood movies released after the year 2000 
that made more than 500 million $ profit or more profit.

with x as(SELECT *,
		(revenue-budget)*100/budget as pct
		FROM financials),
	y as(select * from movies 
		where release_year>2000 and industry='Hollywood')
select x.movie_id,y.title,x.pct		
from x
join y
on x.movie_id=y.movie_id
where x.pct>500
