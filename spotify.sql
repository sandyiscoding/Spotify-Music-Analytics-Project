-- Advanced SQL Project -- Spotify Datasets

CREATE TABLE spotify
(
	artist VARCHAR(255),
	track VARCHAR(255),
	album VARCHAR(255),
	album_type VARCHAR(255),
	danceability FLOAT,
	energy FLOAT,
	loudness FLOAT,
	speechiness FLOAT,
	acousticness FLOAT,
	instrumentalness FLOAT,
	liveness FLOAT,
	valence FLOAT,
	tempo FLOAT,
	duration_min FLOAT,
	title VARCHAR(255),
	channel VARCHAR(255),
	views FLOAT,
	likes BIGINT,
	comments BIGINT,
	licensed BOOLEAN,
	official_video BOOLEAN,
	stream BIGINT,
	energy_liveness FLOAT,
	most_played_on VARCHAR(50)
);

-- EDA
SELECT COUNT(*) FROM spotify;

SELECT COUNT(DISTINCT album) FROM spotify;

SELECT COUNT(DISTINCT artist) FROM spotify;

SELECT DISTINCT album_type FROM spotify;


SELECT MAX(duration_min) FROM spotify;

SELECT MIN(duration_min) FROM spotify;

SELECT * FROM spotify
WHERE duration_min = 0

DELETE FROM spotify
WHERE duration_min = 0;

SELECT * FROM spotify
WHERE duration_min = 0

SELECT DISTINCT channel FROM spotify;


SELECT DISTINCT most_played_on FROM spotify;

-- -------------------------------
-- Data Analysis -- Easy category
-- -------------------------------

-- Q1. Retrieve the names of all tracks that have more than 1 billion streams.

SELECT 
	track
FROM spotify
WHERE 
	stream > 1000000000; 

-- Q2. List all albums along with their respective artists.

SELECT 
	album,
	artist
FROM spotify;

--Q3. Get the total number of comments for tracks where licensed = TRUE.

SELECT 
	SUM(comments) as total_comments	
FROM spotify
WHERE 
	licensed = 'true'


-- Q4. Find all tracks that belong to the album type single.

SELECT
	track
FROM spotify
WHERE
	album_type ILIKE 'single'
	
-- Q5. Count the total number of tracks by each artist.

SELECT
	artist,
	COUNT(track) as total_number_of_tracks
FROM spotify
GROUP BY artist
ORDER BY total_number_of_tracks

-- -------------------------------
-- Data Analysis -- Medium category
-- -------------------------------

-- Q6. Calculate the average danceability of tracks in each album.

SELECT
	album,
	AVG(danceability) as avg_danceability
FROM spotify
GROUP BY album
ORDER BY avg_danceability DESC
	

-- Q7. Find the top 5 tracks with the highest energy values.

SELECT
	track,
	MAX(energy) as energy_value
FROM spotify
GROUP BY track
ORDER BY energy_value DESC
LIMIT 5

-- Q8. List all tracks along with their views and likes where official_video = TRUE.

SELECT 
	track,
	SUM(views) as total_views,
	SUM(likes) as total_likes
FROM spotify
GROUP BY track
ORDER BY total_views DESC
	
-- Q9. For each album, calculate the total views of all associated tracks.

SELECT
	album,
	track,
	SUM(views) as total_views
FROM spotify
GROUP BY album, track
ORDER BY total_views DESC

-- Q10. Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT *
FROM
(
SELECT
	track,
	--most_played_on,
	COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) as streamed_on_youtube,
	COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) as streamed_on_spotify
FROM spotify
GROUP BY track
) as t1
WHERE
	streamed_on_spotify > streamed_on_youtube
	AND
	streamed_on_youtube <> 0

-- -------------------------------
-- Data Analysis -- Advanced category
-- -------------------------------

-- Q11. Find the top 3 most-viewed tracks for each artist using window functions.

SELECT *
FROM
(SELECT
	artist,
	track,
	SUM(views) as total_views,
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) as rank
FROM spotify
GROUP BY artist, track
) as t1
WHERE
	rank <=3


-- Q12. Write a query to find tracks where the liveness score is above the average.

SELECT 
	track,
	liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify)

-- Q13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH energy_table
AS
(
	SELECT 
		album,
		MAX(energy) as highest_energy,
		MIN(energy) as lowest_energy
	FROM spotify
	GROUP BY album
	ORDER BY album
)

SELECT
	album,
	highest_energy - lowest_energy as difference
FROM energy_table
ORDER BY difference DESC

