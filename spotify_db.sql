DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
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


SELECT COUNT(*) FROM spotify;
SELECT COUNT(DISTINCT artist) FROM spotify;
SELECT DISTINCT album_type FROM spotify;
SELECT MAX(duration_min) FROM spotify;
SELECT MIN(duration_min) FROM spotify;
SELECT * FROM spotify
WHERE duration_min=0

DELETE FROM spotify
WHERE duration_min=0

SELECT DISTINCT channel FROM spotify;

SELECT DISTINCT most_played_on FROM spotify;

-----------------------
--Data Analysis 
-----------------------

--1. Retrive the names of all tracks have more than 1 billion srteams.
SELECT * FROM spotify
WHERE stream>1000000000

--2. List all the albums along with their respective artists.

SELECT album,artist FROM spotify ;

--3.Get the total number of comments from tracks where licensed=TRUE.
SELECT SUM(comments) FROM spotify
WHERE licensed='TRUE'


--4.Find all the tracks that belongs to the album type single.

SELECT * FROM spotify
WHERE album_type='single'


--5.Count the total number of track by each artist.

SELECT artist,
  COUNT(*) as total_no_songs FROM spotify
GROUP BY artist
ORDER BY 2



----------------------------------------------------------

--1. calculate the average dancability of track in each album.

SELECT album,  AVG(danceability) as avg_danceability FROM spotify
GROUP BY 1
ORDER BY 2



--2. Find top 5 tracks with the highest energy values.

SELECT track,MAX(energy) FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5



--3. List all tracks along with their views,likes where official_video=true.

SELECT track,
SUM(views) as total_views,
SUM(likes) as total_likes FROM spotify
WHERE official_video='true'
GROUP BY 1
ORDER BY 2 desc


--4. For each album,calculate total views of all associated tracks.
SELECT album,track,SUM(views) as total_views FROM spotify
GROUP BY 1,2
ORDER BY 3 desc

--5.REtrive the track name that have been srteam on spotify.
SELECT track,

COALESCE(SUM(CASE WHEN most_played_on='Spotify' THEN stream END ),0) as stream_on_spotify

FROM SPOTIFY
GROUP BY 1 
ORDER BY 2 DESC



----------------------------------------------------------

--1.find the top three most viewed tracks for each artist using window function.
WITH ranking_artist
AS
(
SELECT artist,track,
SUM(views) as total_views,
DENSE_RANK()OVER(PARTITION BY artist ORDER BY SUM(views) DESC) as rank
FROM spotify
GROUP BY 1,2
ORDER BY 1,3 DESC
)
SELECT * FROM ranking_artist
WHERE rank<=3


--2.Write a query to find tracks where the liveness score is above the average.
SELECT 
track,
artist,
liveness

FROM spotify
WHERE liveness >(SELECT AVG(liveness) FROM spotify)

--3.use a WITH clause to calculate the difference b/w the highest and lowest energy values for tracks in each album.
WITH difference
AS
(SELECT album,
MAX(energy) as highest,
MIN(energy) as lowest
FROM spotify
GROUP BY 1
)
SELECT album,
highest-lowest as diff
FROM difference
ORDER BY 2 DESC


--4.Find the tracks where the energy to liveness ratio is greater than 1.2.
WITH ratio
AS
(SELECT track,
energy/liveness as ratio

FROM spotify

)
SELECT track,ratio
FROM ratio
WHERE ratio> 1.2

--5. calculate the cumulative sum of likes track ordered by the
--numberof views,using window function.

SELECT track,
likes,
views,
SUM(likes) OVER (ORDER BY views) AS cumulative_likes
--ORDER BY 3 DESC 
FROM spotify;



