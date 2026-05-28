-- Netflix project ---

drop table if exists netflix;
create table netflix (
	show_id	varchar(20) primary key not null,
	type	varchar(50),
	title	varchar(150),
	director	varchar(250),
	casts	varchar(900),
	country	varchar(300),
	date_added	varchar(50),
	release_year	int, 
	rating	varchar(50),
	duration	varchar(500),
	listed_in	varchar(300),
	description varchar(500)

);

select * from netflix;

select count(*) as total_content
from netflix;


select distinct(type) as type_of_content
from netflix;


-- 15 Business Problems & Solutions
---------------------------------------------------------------------
-- 1. Count the number of Movies vs TV Shows.

select 
	type,
	count(*) as no_of_shows
from netflix
	group by 1;

---------------------------------------------------------------------
-- 2. Find the most common rating for movies and TV shows

select 
	type, 
	rating, 
	number_of_rating
from(
		select 
				type,
				rating,
				count(rating) as number_of_rating,
				rank() over(partition by type order by count(rating) desc) as ranking
		from netflix
			group by 1,2
	) as t1

where ranking=1;
------------------------------------------------------------------------------

-- 3. List all movies released in a specific year (e.g., 2020)

select 
	*
from netflix
	where type='Movie'
	and 
	release_year='2021';

-------------------------------------------------------------------------------

-- 4. Find the top 5 countries with the most content on Netflix

select 
	unnest(string_to_array(country,',')) as new_country,
	count(*) as number_of_content
from netflix
	group by 1
	order by 2 desc
	limit 5;

-----------------------------------------------------------------------------

-- 5. Identify the longest movie

select * from netflix
where type='Movie'
and
duration=(select max(duration) from netflix)


--------------------------------------------------------------------------------
-- 6. Find content added in the last 5 years
-- select * from netflix 
	to_date(date_added, 'DD-Month-YY') as date_addeded
-- from netflix
-- where  current_date - date_added <5

-------------------------------------------------------------------------------

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
 select * from netflix
 where director like '%Rajiv Chilaka%';


 -----------------------------------------------------------------------------

 --8. List all TV shows with more than 5 seasons

select *
	
from netflix
	where type='TV Show'
	and
	split_part(duration, ' ', 1)::numeric > 5;
	
-------------------------------------------------------------------------------

-- 9. Count the number of content items in each genre

select 
	unnest(string_to_array(listed_in, ',')) as genere,
	count(*)
from netflix
	group by 1

--------------------------------------------------------------------------------

-- 10.Find each year and the average numbers of content release in India on netflix. 

select country, release_year,
		avg(*)
		from
(select show_id, release_year,
	unnest(string_to_array(country,',')) as country
from netflix) as t1
	group by 1,2
	

------------------------------------------------------------------------
-- 11. List all movies that are documentaries
select * from
(select *,
	unnest(string_to_array(listed_in,',')) as types_of_content
from netflix


where type ='Movie'
) as t1
where types_of_content='Documentaries'


select * from netflix
where listed_in ilike '%documentaries%'
and type='Movie'

-------------------------------------------------------------------------------
-- 12. Find all content without a director
select * from netflix
where director is null


------------------------------------------------------------------------------
-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select 
*
from netflix
where casts ilike '%salman Khan%'
and 
release_year > extract(year from current_date )-10

-----------------------------------------------------------------------------------------
-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select 
	cast_name,
	count(*)
from(
		select*, 
			unnest(string_to_array(casts,',')) as cast_name
		from netflix
		where country ilike '%India%'
	) as t1
group by 1
order by 2 desc
limit 10


---------------------------------------------------------------------------------------------

15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.



with new_table as 
	(	select*, 
			case 
				when description ilike '%kill%'
					or description ilike '%voilence%' then 'Bad content'
				else 'Good content'
			end category
		from netflix
	)
select 
category,
count(*) as total_content
from new_table
group by 1
order by 2 desc

or 