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

