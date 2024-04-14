# Joins 
select m.movie_id,title,budget,revenue,currency,unit
from movies m
join financials f
on m.movie_id=f.movie_id;

select m.movie_id,title,budget,revenue,currency,unit
from movies m
left join financials f
on m.movie_id=f.movie_id

union #By having union i can make a full join one thing need to remember i need to have same column for left and right to make the join
select f.movie_id,title,budget,revenue,currency,unit
from movies m
right join financials f
on m.movie_id=f.movie_id;

# Using
select movie_id,title,budget,revenue,currency,unit
from movies m
left join financials f
using (movie_id) # I can give two column name based on realtionship


#Cross Join 
SELECT * FROM food_db.items
cross join variants

# Analytics on tables
select m.movie_id,title,budget,revenue,currency,unit,
      (revenue-budget) as profit
from movies m
join financials f
on m.movie_id=f.movie_id;


select m.movie_id,title,budget,revenue,currency,unit,
		case 
          when unit="thousands" then (revenue-budget)/1000
          when unit="billions" then (revenue-budget)*1000
          else (revenue-budget)
      end as profit_mln
from movies m
join financials f
on m.movie_id=f.movie_id
order by profit_mln desc;


#JOIN MORE THAN TWO TABLE
SELECT m.title,group_concat(a.name)
from movies m
join movie_actor ma 
on m.movie_id=ma.movie_id
join actors a
on a.actor_id=ma.actor_id
group by m.title

 i want to get the actor name and then the movie they did;
 
 SELECT a.name,group_concat(m.title) as movies,
        count(m.title) as movie_count
from movies m
join movie_actor ma 
on m.movie_id=ma.movie_id
join actors a
on a.actor_id=ma.actor_id
group by a.name;


# Eecersize
1) Generate a report of all Hindi movies sorted by their revenue amount in millions. 
Print movie name, revenue, currency, and unit

	SELECT 
		title, revenue, currency, unit, 
			CASE 
					WHEN unit="Thousands" THEN ROUND(revenue/1000,2)
			WHEN unit="Billions" THEN ROUND(revenue*1000,2)
					ELSE revenue 
			END as revenue_mln
	FROM movies m
	JOIN financials f
			ON m.movie_id=f.movie_id
	JOIN languages l
			ON m.language_id=l.language_id
	WHERE l.name="Hindi"
	ORDER BY revenue_mln DESC

