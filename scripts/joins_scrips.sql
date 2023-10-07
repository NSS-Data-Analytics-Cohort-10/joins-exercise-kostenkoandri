-- ** Movie Database project. See the file movies_erd for table\column info. **

-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.
SELECT s.film_title as name,
	s.release_year,
	cast(r.worldwide_gross as money)
FROM specs s
LEFT JOIN revenue r USING(movie_id)
WHERE r.worldwide_gross = (SELECT MIN(worldwide_gross) FROM revenue);

-- 2. What year has the highest average imdb rating?
-- 1991
SELECT s.release_year,
	AVG(r.imdb_rating) AS average_rating
FROM specs s
LEFT JOIN rating r USING(movie_id)
GROUP BY s.release_year
ORDER BY average_rating DESC
LIMIT 1;

-- 3. What is the highest grossing G-rated movie? Which company distributed it?
-- Toy Story 4, Walt Disney
SELECT s.film_title,
	CAST(r.worldwide_gross AS money) as gross,
	d.company_name
FROM specs s
LEFT JOIN revenue r USING(movie_id)
LEFT JOIN distributors d ON s.domestic_distributor_id = d.distributor_id
WHERE s.mpaa_rating ilike 'G'
ORDER BY gross DESC
LIMIT 1;

-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies 
-- table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.
SELECT d.company_name, 
	COUNT(*) AS number_of_movies
FROM distributors d
LEFT JOIN specs s ON s.domestic_distributor_id = d.distributor_id
GROUP BY d.company_name;


-- 5. Write a query that returns the five distributors with the highest average movie budget.
SELECT company_name,
	CAST(AVG(film_budget) AS money) as budget
FROM distributors d 
INNER JOIN specs s ON s.domestic_distributor_id = d.distributor_id
INNER JOIN revenue USING(movie_id)
GROUP BY company_name
ORDER BY budget DESC
LIMIT 5;
-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?
-- 2
-- Dirty Dancing
SELECT film_title,
	company_name,
	headquarters,
	imdb_rating
FROM specs s
INNER JOIN distributors d ON s.domestic_distributor_id = d.distributor_id
INNER JOIN rating r USING(movie_id)
WHERE headquarters NOT ILIKE '%, ca'
ORDER BY imdb_rating DESC;

-- SELECT * FROM DISTRIBUTORS;
-- select * from specs where domestic_distributor_id = 86144;

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?
-- over 2 hours
SELECT AVG(imdb_rating) AS rating,
	case
		when length_in_min > 120 then 'over 2 hours'
		WHEN length_in_min < 120 then 'under 2 hours'
		ELSE 'exactly 2 hours'
	END AS category
FROM specs s
INNER JOIN rating r USING(movie_id)
GROUP BY category;
