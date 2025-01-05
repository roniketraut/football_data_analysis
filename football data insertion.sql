-- inserting data into tables

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
