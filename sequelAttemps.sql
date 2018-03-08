CREATE TABLE movies (id INTEGER PRIMARY KEY,
  name TEXT,
  year INTEGER,
  rank REAL);

SELECT * FROM movies WHERE year = 1992;

SELECT * FROM movies GROUP BY year;
-- this produces only unique years with first movie from each year

SELECT COUNT(*) FROM movies WHERE year = 1982;

-- SELECT COUNT(*) FROM movies WHERE year = 1982 GROUP BY year;

-- Find actors who have "stack" in their last name.

-- SELECT FROM table_name
-- WHERE column LIKE '%XXXX%'

SELECT first_name, COUNT(*) FROM actors GROUP BY first_name;
-- counts how many by each name

SELECT * FROM actors WHERE last_name LIKE '%stack%';

SELECT       last_name,
             COUNT(*) AS Occurences
    FROM     actors
    GROUP BY last_name
    ORDER BY Occurences DESC
    LIMIT    10;


    SELECT       first_name,
             COUNT(*) AS Occurences
    FROM     actors
    GROUP BY first_name
    ORDER BY Occurences DESC
    LIMIT    10;

--10 common first and last names
    SELECT       first_name || last_name,
             COUNT(*) AS Occurences
    FROM     actors
    GROUP BY first_name || last_name
    ORDER BY Occurences DESC
    LIMIT    10;

-- number of movies per year descending
        SELECT       year,
             COUNT(*) AS Occurences
    FROM     movies
    GROUP BY year
    ORDER BY Occurences DESC;

--numbers of roles per actor
SELECT first_name, last_name,
COUNT(*) AS numberRoles
FROM actors
JOIN roles ON roles.actor_id = actors.id
GROUP BY actor_id
-- actors.id ok here too
ORDER BY numberRoles DESC
LIMIT 100;

--least popular genres
SELECT genre,
COUNT(*) AS moviesByGenre
FROM movies_genres
JOIN movies ON movies.id = movies_genres.movie_id
GROUP BY genre
ORDER BY moviesByGenre
LIMIT 100;

-- easier way
SELECT genre, COUNT(*) as num_movies
FROM movies_genres
GROUP BY genre
ORDER BY num_movies;

-- actors in Braveheart
SELECT first_name, last_name FROM actors
JOIN roles ON actors.id = roles.actor_id
JOIN movies
ON roles.movie_id = movies.id
AND movies.name = 'Braveheart'
AND movies.year = 1995
ORDER BY last_name;

--directors of Film-Noir of movies released on leap years
SELECT * FROM movies AS m
 JOIN movies_genres AS mg
 ON m.id = mg.movie_id
 AND mg.genre = 'Film-Noir'
    JOIN movies_directors AS md ON m.id = md.movie_id
      JOIN directors AS d ON md.director_id = d.id
WHERE year % 4 = 0;

-- actors who worked with Kevin Bacon
SELECT *, a.first_name || " " || a.last_name AS full_name
FROM actors AS a
  JOIN roles AS r ON r.actor_id = a.id
  JOIN movies AS m ON r.movie_id = m.id
  JOIN movies_genres AS mg
    ON mg.movie_id = m.id
    AND mg.genre = 'Drama'
WHERE m.id IN (
  SELECT m2.id
  FROM movies AS m2
    JOIN roles AS r2 ON r2.movie_id = m2.id
    JOIN actors AS a2
    ON r2.actor_id = a2.id
    AND a2.first_name = 'Kevin'
    AND a2.last_name = 'Bacon'
    )
AND full_name != 'Kevin Bacon'
ORDER BY a.last_name;

--immortals (actors in movies before 1900 and after 2000)
SELECT actors.id, actors.first_name, actors.last_name
FROM actors
JOIN roles ON roles.actor_id = actors.id
JOIN movies ON movies.id = roles.movie_id
WHERE movies.year < 1900
INTERSECT
SELECT actors.id, actors.first_name, actors.last_name
FROM actors
JOIN roles ON roles.actor_id = actors.id
JOIN movies ON movies.id = roles.movie_id
WHERE movies.year > 2000;

--amount of roles people played in same movie
--make sure roles are unique by count(DISTINCT roles.role)
SELECT COUNT(DISTINCT roles.role) AS num_roles_in_movies, *
FROM actors
JOIN roles ON roles.actor_id = actors.id
JOIN movies ON roles.movie_id = movies.id
WHERE movies.year > 1990
GROUP BY actors.id, movies.id
HAVING num_roles_in_movies >= 5
-- BECAUSE WE CAN'T HAVE THE AGGREGATE VALUE WE CREATED IN THE WHERE CLAUSE
--Having is also for total result at the end as opposed to where which is for each line of
-- result coming in
-- HAVING applies conditions to grouped values as opposed to individual values



--female only

SELECT movies.year, COUNT(*) AS movies_in_year_without_female
FROM movies
WHERE movies.id NOT IN (
SELECT DISTINCT movies.id
FROM movies
JOIN roles ON movies.id = roles.movie_id
JOIN actors
ON roles.actor_id = actors.id
AND actors.gender = 'M'
)
AND movies.id IN (
  SELECT DISTINCT movies.id
FROM movies
JOIN roles ON movies.id = roles.movie_id
JOIN actors
ON roles.actor_id = actors.id
AND actors.gender = 'F'
)

GROUP BY movies.year;


