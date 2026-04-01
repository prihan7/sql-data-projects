CREATE DATABASE icc_cricket;
USE icc_cricket;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- 1.	Import the csv file to a table in the database.
SELECT * FROM icc_test_batting_figures;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- 2.	Remove the column 'Player Profile' from the table.
ALTER TABLE icc_test_batting_figures DROP COLUMN `Player Profile`;

SELECT * FROM icc_test_batting_figures;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- 3.	Extract the country name and player names from the given data and store it in separate columns for further usage.
ALTER TABLE icc_test_batting_figures ADD COLUMN Country varchar(10);

SELECT @@sql_safe_updates; 
SET sql_safe_updates=0;

UPDATE icc_test_batting_figures 
SET country = substr(Player,position('(' IN Player) + 1, length(Player) - position('(' IN Player) - 2);

ALTER TABLE icc_test_batting_figures ADD COLUMN player_name varchar(30);

UPDATE icc_test_batting_figures 
SET player_name = substr(Player,1, position('(' IN Player) - 1);

SELECT * FROM icc_test_batting_figures;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- 4.	From the column 'Span' extract the start_year and end_year and store them in separate columns for further usage.
ALTER TABLE icc_test_batting_figures ADD COLUMN start_year int;

UPDATE icc_test_batting_figures SET start_year = substr(Span, 1,4);

ALTER TABLE icc_test_batting_figures ADD COLUMN end_year int;

UPDATE icc_test_batting_figures SET end_year = substr(Span, 6, 4);

SELECT * FROM icc_test_batting_figures;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- 5.	The column 'HS' has the highest score scored by the player so far in any given match. The column also has details if the player had completed the match in a NOT OUT status. Extract the data and store the highest runs and the NOT OUT status in different columns.
ALTER TABLE icc_test_batting_figures ADD COLUMN highest_runs text;

UPDATE icc_test_batting_figures SET highest_runs = substring_index(HS,'*',1);

ALTER TABLE icc_test_batting_figures ADD COLUMN Not_out varchar(3);

UPDATE icc_test_batting_figures SET Not_out = if(position('*' IN HS) = 0, 'No', 'Yes');

SELECT * FROM icc_test_batting_figures;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- 6.	Using the data given, considering the players who were active in the year of 2019, create a set of batting order of best 6 players using the selection criteria of those who have a good average score across all matches for India.

SELECT player_name, Country, end_year, Avg FROM icc_test_batting_figures
WHERE end_year = 2019 AND country like '%INDIA%'
ORDER BY AVG DESC
limit 6;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- 7.	Using the data given, considering the players who were active in the year of 2019, create a set of batting order of best 6 players using the selection criteria of those who have the highest number of 100s across all matches for India.

SELECT player_name, Country, `100` FROM icc_test_batting_figures
WHERE end_year = 2019 and country like '%INDIA%'
ORDER BY `100` DESC
limit 6;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- 8.	Using the data given, considering the players who were active in the year of 2019, create a set of batting order of best 6 players using 2 selection criteria of your own for India.

SELECT player_name, `100`, end_year, Country, Avg FROM icc_test_batting_figures
WHERE end_year = 2019 and country like '%INDIA%'
ORDER BY `100` DESC, Avg DESC
limit 6;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- 9.	Create a View named ‘Batting_Order_GoodAvgScorers_SA’ using the data given, considering the players who were active in the year of 2019, create a set of batting order of best 6 players using the selection criteria of those who have a good average score across all matches for South Africa.

CREATE VIEW Batting_Order_GoodAvgScorers_SA AS 
SELECT player_name, Avg, end_year, country FROM icc_test_batting_figures
WHERE end_year = 2019 and (country = 'SA' OR country LIKE '%SA%')
ORDER BY Avg DESC
LIMIT 6;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- 10.	Create a View named ‘Batting_Order_HighestCenturyScorers_SA’ Using the data given, considering the players who were active in the year of 2019, create a set of batting order of best 6 players using the selection criteria of those who have highest number of 100s across all matches for South Africa.

CREATE VIEW Batting_Order_HighestCenturyScorers_SA AS
SELECT player_name, `100`, end_year, Country FROM icc_test_batting_figures
WHERE end_year = 2019 and (country = 'SA' OR country LIKE '%SA%')
ORDER BY `100` DESC
LIMIT 6;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- 11.	Using the data given, Give the number of player_played for each country.
SELECT Country , COUNT(player_name) AS No_of_player_played FROM icc_test_batting_figures
GROUP BY COUNTRY;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- 12.	Using the data given, Give the number of player_played for Asian and Non-Asian continent
SELECT
CASE
WHEN Country IN ('INDIA', 'PAK', 'SL', 'BDESH', 'AFG') THEN 'Asian'
ELSE 'Non-Asian'
END AS Continent,
COUNT(DISTINCT Player_Name) AS PlayerCount
FROM icc_test_batting_figures
GROUP BY Continent;

  



