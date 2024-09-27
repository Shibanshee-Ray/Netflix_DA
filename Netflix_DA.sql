-- Retrieve specific show
select * from netflix_raw 
where show_id='s5023';

-- Handling foreign characters

-- Remove duplicates 
select show_id, COUNT(*) 
from netflix_raw
group by show_id 
having COUNT(*) > 1;

-- Detect duplicate shows based on title and type
select * from netflix_raw
where concat(upper(title), type) in (
select concat(upper(title), type) 
from netflix_raw
group by upper(title), type
having COUNT(*) > 1
)
order by title;

-- Creating a common table expression (CTE) and filtering duplicates
with ranked_shows as (
select *, ROW_NUMBER() over(partition by title, type order by show_id) as row_number
from netflix_raw
)
select show_id, type, title, cast(date_added as date) as date_added, release_year, 
rating, case when duration is null then rating else duration end as duration, description
into netflix
from ranked_shows;

-- Check the modified table
select * from netflix;

-- Splitting genre into a separate table
select show_id, trim(value) as genre
into netflix_genre
from netflix_raw
cross apply string_split(listed_in, ',');

-- Display original data for reference
select * from netflix_raw;

-- Populating missing values for country and duration based on director
insert into netflix_country
select show_id, m.country 
from netflix_raw nr
inner join (
select director, country
from netflix_country nc
inner join netflix_directors nd on nc.show_id = nd.show_id
group by director, country
) m on nr.director = m.director
where nr.country is null;

-- Check rows with specific director
select * from netflix_raw where director='Ahishor Solomon';

-- Retrieve director and country data
select director, country
from netflix_country nc
inner join netflix_directors nd on nc.show_id = nd.show_id
group by director, country;

-- Identifying rows with missing duration
select * from netflix_raw where duration is null;

-- Netflix data analysis queries

-- 1. Count of movies and TV shows for each director
select nd.director, 
COUNT(distinct case when n.type = 'Movie' then n.show_id end) as movie_count,
COUNT(distinct case when n.type = 'TV Show' then n.show_id end) as tv_show_count
from netflix n
inner join netflix_directors nd on n.show_id = nd.show_id
group by nd.director
having COUNT(distinct n.type) > 1;

-- 2. Country with the highest number of comedy movies
select top 1 nc.country, COUNT(distinct ng.show_id) as comedy_movie_count
from netflix_genre ng
inner join netflix_country nc on ng.show_id = nc.show_id
inner join netflix n on ng.show_id = n.show_id
where ng.genre = 'Comedies' and n.type = 'Movie'
group by nc.country
order by comedy_movie_count desc;

-- 3. Director with the maximum number of movies added each year
with yearly_movies as (
select nd.director, YEAR(date_added) as year_added, count(n.show_id) as movie_count
from netflix n
inner join netflix_directors nd on n.show_id = nd.show_id
where type = 'Movie'
group by nd.director, YEAR(date_added)
),
ranked_yearly_movies as (
select *, ROW_NUMBER() over(partition by year_added order by movie_count desc, director) as rank_num
from yearly_movies
)
select * from ranked_yearly_movies where rank_num = 1;

-- 4. Average duration of movies in each genre
select ng.genre, avg(cast(REPLACE(duration, ' min', '') AS int)) as avg_duration_minutes
from netflix n
inner join netflix_genre ng on n.show_id = ng.show_id
where type = 'Movie'
group by ng.genre;

-- 5. Directors who created both comedy and horror movies
select nd.director, 
count(distinct case when ng.genre = 'Comedies' then n.show_id end) as comedy_count,
count(distinct case when ng.genre = 'Horror Movies' then n.show_id end) as horror_count
from netflix n
inner join netflix_genre ng on n.show_id = ng.show_id
inner join netflix_directors nd on n.show_id = nd.show_id
where type = 'Movie' and ng.genre in ('Comedies', 'Horror Movies')
group by nd.director
having COUNT(distinct ng.genre) = 2;

-- 6. Check genres for a specific director
select * from netflix_genre where show_id in 
(select show_id from netflix_directors where director = 'Steve Brill')
order by genre;
