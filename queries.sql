-- Create the leagues table
CREATE TABLE leagues (
    leagueID SERIAL PRIMARY KEY,
    name VARCHAR(100),
    understatNotation VARCHAR(100)
);

-- Create the teams table
CREATE TABLE teams (
    teamID SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

-- Create the games table
CREATE TABLE games (
    gameID SERIAL PRIMARY KEY,
    leagueID INT REFERENCES leagues(leagueID) ON DELETE CASCADE,
    season VARCHAR(20),
    date DATE,
    homeTeamID INT REFERENCES teams(teamID) ON DELETE CASCADE,
    awayTeamID INT REFERENCES teams(teamID) ON DELETE CASCADE,
    homeGoals INT,
    awayGoals INT,
    homeProbability FLOAT,
    drawProbability FLOAT,
    awayProbability FLOAT,
    homeGoalsHalfTime INT,
    awayGoalsHalfTime INT,
    B365H FLOAT,
    B365D FLOAT,
    B365A FLOAT,
    BWH FLOAT,
    BWD FLOAT,
    BWA FLOAT,
    IWH FLOAT,
    IWD FLOAT,
    PSH FLOAT,
    PSD FLOAT,
    PSA FLOAT,
    WHH FLOAT,
    WHD FLOAT,
    WHA FLOAT,
    VCH FLOAT,
    VCD FLOAT,
    VCA FLOAT,
    PSCH FLOAT,
    PSCD FLOAT,
    PSCA FLOAT
);

-- Create the players table
CREATE TABLE players (
    playerID SERIAL PRIMARY KEY,
    name VARCHAR(200)
);

-- Create the appearances table
CREATE TABLE appearances (
    gameID INT REFERENCES games(gameID) ON DELETE CASCADE,
    playerID INT REFERENCES players(playerID) ON DELETE CASCADE,
    goals INT,
    ownGoals INT,
    xGoals FLOAT,
    xGoalsChain FLOAT,
    xGoalsBuildup FLOAT,
    assists INT,
    position VARCHAR(100),
    positionOrder INT,
    yellowCard INT,
    redCard INT,
    time INT,
    substituteIn INT,
    substituteOut INT,
    leagueID INT REFERENCES leagues(leagueID) ON DELETE CASCADE
);

-- Create the shots table
CREATE TABLE shots (
    gameID INT REFERENCES games(gameID) ON DELETE CASCADE,
    shooterID INT REFERENCES players(playerID) ON DELETE CASCADE,
    assisterID INT REFERENCES players(playerID) ON DELETE CASCADE,
    minute INT,
    situation VARCHAR(255),
    lastAction VARCHAR(255),
    shotType VARCHAR(255),
    shotResult VARCHAR(255),
    xGoal FLOAT,
    positionX FLOAT,
    positionY FLOAT
);

-- Create the teamstats table
CREATE TABLE teamstats (
    gameID INT REFERENCES games(gameID) ON DELETE CASCADE,
    teamID INT REFERENCES teams(teamID) ON DELETE CASCADE,
    season INT,
    date DATE,
    location VARCHAR(50),
    goals INT,
    xGoals FLOAT,
    shots INT,
    shotsOnTarget INT,
    deep INT,
    ppda FLOAT,
    fouls INT,
    corners INT,
    yellowCards FLOAT,
    redCards INT,
    result VARCHAR(10)
);

COPY leagues (leagueID, name, understatNotation)
FROM 'C:/Program Files/PostgreSQL/17/data/leagues.csv'
DELIMITER ','
CSV HEADER;

COPY teams (teamID, name)
FROM 'C:/Program Files/PostgreSQL/17/data/teams.csv'
DELIMITER ','
CSV HEADER;

ALTER TABLE games
ADD COLUMN IWA FLOAT;

COPY games (gameID, leagueID, season, date, homeTeamID, awayTeamID, homeGoals, awayGoals, homeProbability, drawProbability, awayProbability, homeGoalsHalfTime, awayGoalsHalfTime, B365H, B365D, B365A, BWH, BWD, BWA, IWH, IWD, IWA, PSH, PSD, PSA, WHH, WHD, WHA, VCH, VCD, VCA, PSCH, PSCD, PSCA)
FROM 'C:/Program Files/PostgreSQL/17/data/games3.csv'
DELIMITER ','
CSV HEADER;

COPY players(playerID, name)
FROM 'C:/Program Files/PostgreSQL/17/data/players.csv'
WITH (FORMAT csv, ENCODING 'LATIN1', HEADER);

ALTER TABLE appearances
ADD COLUMN shots INT,
ADD COLUMN keyPasses INT,
ADD COLUMN xAssists FLOAT;

COPY appearances(gameID, playerID, goals, ownGoals, shots, xGoals, xGoalsChain, xGoalsBuildup, assists, keyPasses, xAssists, position, positionOrder, yellowCard, redCard, time, substituteIn, substituteOut, leagueID)
FROM 'C:/Program Files/PostgreSQL/17/data/appearances.csv'
DELIMITER ','
CSV HEADER;

COPY shots
FROM 'C:/Program Files/PostgreSQL/17/data/shots4.csv'
DELIMITER ','
CSV HEADER;

COPY teamstats
FROM 'C:/Program Files/PostgreSQL/17/data/teamstats.csv'
DELIMITER ','
CSV HEADER;

-- COUNTING THE NUMBER OF LEAGUES AND GAMES

SELECT COUNT(*)
FROM leagues;

SELECT COUNT(*)
FROM games;

-- FINDING THE LEAGUE WITH THE MOST GAMES PLAYED
WITH num_games AS (
SELECT g.leagueID, l.name, COUNT(gameID) AS game_count
FROM games AS g
LEFT JOIN leagues AS l
ON g.leagueID = l.leagueID
GROUP BY g.leagueID, l.name
)

SELECT leagueID, name, game_count
FROM num_games
WHERE game_count = (SELECT MAX(game_count) FROM num_games);


-- Retrieving the first and last game dates for each league
SELECT g.leagueID, l.name, season, MIN (date) AS first_match, MAX(date) AS last_match
FROM games AS g
INNER JOIN leagues as l
ON g.leagueID = l.leagueID
GROUP BY g.leagueID, l.name, season
ORDER BY season, g.leagueID;

-- Finding the highest homeGoals and awayGoals
WITH MaxGoals AS (
SELECT MAX(homeGoals) AS maxHomeGoals, MAX(awayGoals) AS maxAwayGoals
FROM games)

SELECT gameID, homeTeamID, awayTeamId, homeGoals, awayGoals
FROM games
WHERE homeGoals = (SELECT maxHomeGoals FROM MaxGoals) OR awayGoals = (SELECT maxAwayGoals FROM MaxGoals);

-- Calculating the averagae homeGoals and awayGoals per league
SELECT g.leagueID, l.name, ROUND(AVG(homeGoals), 2) AS avg_home_goal, ROUND(AVG(awayGoals), 2) AS avg_away_goal
FROM games as g
INNER JOIN leagues as l
USING (leagueID)
GROUP BY g.leagueID, l.name;

-- number of games with a draw result in each league
SELECT g.leagueID, l.name, COUNT(*) AS no_of_draws
FROM games AS g
INNER JOIN leagues AS l
USING (leagueID)
WHERE g.homeGoals = g.awayGoals
GROUP BY g.leagueID, l.name
ORDER BY no_of_draws DESC;

-- finding the league with the highest average homeProbability
SELECT g.leagueID, l.name, ROUND(AVG(homeProbability)::NUMERIC, 4) AS avg_home_probability
FROM games AS g
INNER JOIN leagues AS l
USING (leagueID)
GROUP BY g.leagueID, l.name
ORDER BY avg_home_probability DESC
LIMIT 1;

-- Listing games where drawProbability exceeds 0.5
SELECT gameID
FROM games
WHERE drawProbability>0.5; 

-- Ranking leagues by the total number of goals scored across all their games
WITH CTE AS (
SELECT g.leagueID AS leagueID, l.name AS league_name, SUM(homeGoals+awayGoals) AS total_goals
FROM games AS g
INNER JOIN leagues AS l
USING (leagueID)
GROUP BY g.leagueID, l.name
)

SELECT leagueID, league_name, DENSE_RANK() OVER(ORDER BY total_goals DESC) AS rank_per_goal
FROM CTE;

-- Calculate the running total of goals scored by players in a season
WITH CTE AS (
SELECT a.gameID, a.playerID, a.goals, g.season
FROM appearances AS a
INNER JOIN games as g
ON a.gameID = g.gameID
)

SELECT gameID, playerID, season, COUNT(goals) OVER(PARTITION BY season ORDER BY goals DESC)
FROM CTE;

-- Ranking teams by their performance over last five seasons 
-- and based on the number of games won, and order them within each league.
SELECT t.name AS team_name, l.name AS league_name,
COUNT(CASE WHEN
		(t.teamID = g.homeTeamID AND g.homeGoals >g.awayGoals)
		OR 
		(t.teamID = g.awayTeamID AND g.awayGoals>g.homeGoals) THEN 1 END) AS games_won,
RANK() OVER(PARTITION BY l.leagueID ORDER BY 
COUNT(CASE WHEN
		(t.teamID = g.homeTeamID AND g.homeGoals >g.awayGoals)
		OR 
		(t.teamID = g.awayTeamID AND g.awayGoals>g.homeGoals) THEN 1 END) DESC) AS rank_within_league
FROM teams AS t
INNER JOIN games AS g
ON t.teamID = g.homeTeamID OR t.teamId = g.awayTeamID
INNER JOIN leagues AS l ON l.leagueID = g.leagueID
GROUP BY t.teamID, l.leagueID
ORDER BY l.leagueID, rank_within_league;

-- calculating the running total of goals scored by a team in all the games it played ordered by date
SELECT t.teamID, t.name AS team_name, g.gameID, g.date,
CASE WHEN t.teamId = g.homeTeamID THEN g.homeGoals ELSE g.awayGoals END AS goals_scored,
SUM(CASE WHEN t.teamID = g.homeTeamID THEN g.homeGoals ELSE g.awayGoals END) OVER(PARTITION BY t.teamID
	ORDER BY g.date) AS running_total
FROM teams AS t
INNER JOIN games AS g ON t.teamID = g.homeTeamID OR t.teamID = g.awayTeamID
ORDER BY t.teamID, g.date;

-- top 3 scorers in each league
SELECT *
FROM (
SELECT l.name AS league_name, p.name AS player_name,
SUM(a.goals) AS total_goals,
RANK() OVER (PARTITION BY l.leagueID ORDER BY SUM(a.goals) DESC) AS rank_within_league
FROM appearances AS a
INNER JOIN players AS p ON a.playerID = p.playerID
INNER JOIN leagues AS l ON l.leagueID = a.leagueID
GROUP BY l.leagueID, l.name, p.playerID, p.name
HAVING SUM(a.goals)>0
ORDER BY l.leagueID, rank_within_league) AS goal_scorers
WHERE rank_within_league<=3;

-- 3-game moving average of goals scored for each team
SELECT t.teamID, t.name AS team_name, 
CASE WHEN t.teamId = homeTeamID THEN homeGoals ELSE awayGoals END AS goals_scored, 
ROUND(AVG(CASE WHEN t.teamId = homeTeamID THEN homeGoals ELSE awayGoals END)
	OVER(PARTITION BY t.teamID ORDER BY g.date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)::NUMERIC,2) AS moving_avg_goals
FROM games AS g
INNER JOIN teams AS t
ON t.teamID = g.homeTeamID OR t.teamID = g.awayTeamID;

-- Comparing how the team's score compares to the league's average score in that match day
SELECT g.gameID, g.date AS match_date, l.name AS league_name, t.name AS team_name,
CASE WHEN t.teamID = g.homeTeamID THEN g.homeGoals ELSE g.awayGoals END AS team_score,
AVG(CASE WHEN t.teamID = g.homeTeamID THEN g.homeGoals ELSE g.awayGoals END) OVER(PARTITION BY l.leagueID, g.date)
AS league_avg_score
FROM games AS g
INNER JOIN teams AS t 
ON t.teamID = g.homeTeamID or t.teamID = g.awayTeamID
INNER JOIN leagues AS l
ON l.leagueID  = g.leagueID
ORDER BY g.date, league_name, team_name;

-- CREATING A FUNCTION THAT INSERTS A NEW GAME INTO games TABLE WITH params for league, teams and score
CREATE OR REPLACE FUNCTION add_new_game(
p_leagueID INT,
p_homeTeamID INT,
p_awayTeamID INT,
p_homeGoals INT,
p_awayGoals INT,
p_gameDate DATE
)
RETURNS VOID AS $$
BEGIN
	INSERT INTO games(leagueID, homeTeamID, awayTeamID, homeGoals, awayGoals, date)
	VALUES (p_leagueID, p_homeTeamID, p_awayTeamID, p_homeGoals, p_awayGoals, p_gameDate);
 
END;
$$ LANGUAGE plpgsql;

SELECT add_new_game(3, 177, 181, 1, 0, '2021-05-29');

SELECT *
FROM games
WHERE date = '2021-05-29';

-- CREATING A PROCEDURE TO UPDATE team's name BASED ON teamID
CREATE OR REPLACE PROCEDURE update_team_name(n_teamID INT, n_name VARCHAR(100))
LANGUAGE plpgsql AS $$
BEGIN
UPDATE teams
SET name = n_name
WHERE teamID = n_teamID;

END;
$$;

CALL update_team_name(85, 'Stoke FC');

SELECT *
FROM teams
WHERE teamID = 85;

-- CREATING A FUNCTION WITH PARAM leagueID and returns the summary of all the games played
CREATE OR REPLACE FUNCTION summary(n_leagueID int)
RETURNS TABLE (leagueID INT, league_name VARCHAR, num_of_games INT, total_goals INT) AS $$
BEGIN
RETURN QUERY
SELECT g.leagueID, l.name, (COUNT(g.gameID)::INT) AS num_of_games, (SUM(g.homeGoals+g.awayGoals)::INT) AS total_goals_scored
FROM games AS g
INNER JOIN leagues as l
ON g.leagueID = l.leagueID
WHERE g.leagueID = n_leagueID
GROUP BY g.leagueID, l.name;
END;
$$ LANGUAGE plpgsql;

SELECT leagueID, league_name, num_of_games, total_goals FROM summary(1);

-- CREATING A STORED PROCEDURE THAT REMOVES A GAMES BASED ON gameId
CREATE OR REPLACE PROCEDURE game_remover(n_gameID INT)
LANGUAGE plpgsql AS $$
BEGIN
DELETE FROM games
WHERE gameID = n_gameID;
END;
$$;

CALL game_remover(2);
CALL game_remover(3);

SELECT COUNT(*)
FROM games;


