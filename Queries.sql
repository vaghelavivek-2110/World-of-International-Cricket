-- List all the male players who have played more than 3 worldcups.

SELECT Player_ID,Player_Name FROM
(SELECT Player_ID, count (Event_ID) AS Played_Events
FROM Event_Player_Data
GROUP BY Player_ID
HAVING count(Event_ID) > 3) as r 
NATURAL JOIN Player 
WHERE Gender = 'Male';

--list all the female players who have played less than 2 world cups

SELECT Player_ID,Player_Name FROM Player
NATURAL JOIN
(SELECT Player_ID FROM Player
WHERE Player_ID
NOT IN
(SELECT Player_ID FROM Event_Player_Data 
GROUP BY Player_ID
HAVING count (Event_ID) > 2)) AS r
WHERE Gender='Female';

--list top 3 the players who have won most Player of the tournament Award till now.
 
SELECT Player_ID,Player_Name FROM 
(
SELECT Player_of_the_tournament, count (Event_ID) AS No_of_Awards 
FROM Event GROUP BY Player_of_the_tournament
ORDER BY No_of_Awards
DESC LIMIT 3
) AS r JOIN Player ON Player_of_the_tournament = Player_ID;

--Print out the player name, batting and bowling strike rate and avarage of the top 3 players who have won most Player of the tournament Award till now 

SELECT Player_Name, Match_type, Batting_Average, Batting_Strike_rate, Bowling_Average, Bowling_Strike_rate FROM
(
SELECT Player_of_the_tournament, count (Event_ID) AS No_of_Awards FROM Event
GROUP BY Player_of_the_tournament
ORDER BY No_of_Awards
DESC LIMIT 3) AS R JOIN Performance 
NATURAL JOIN Player ON Player_of_the_tournament = Player_ID;

--Print board name who has won most world cups in all format including male , female

SELECT Board_Name FROM (SELECT Board_ID FROM Victory
ORDER BY No_of_cups
DESC LIMIT 1) AS r NATURAL JOIN Board; 

-- List out top 5 players who have scored most runs in all ODI world cups till now 

SELECT Player_ID,Player_Name, Total_Runs FROM 
(SELECT Player_ID, sum (Total_Runs) AS Total_Runs
FROM
(SELECT * FROM Event_Player_Data NATURAL JOIN
(SELECT Event_ID FROM Event
WHERE Match_type = 'ODI') AS r
)AS r2
GROUP BY Player_ID
ORDER BY Total_Runs
DESC LIMIT 5) AS r3 NATURAL JOIN player;

-- List out top 4 players who have taken most wickets in all TEST and T20I world cups till now

SELECT Player_ID, Player_Name, Total_Wickets FROM 
(SELECT Player_ID, sum (Total_Wickets) AS Total_Wickets
FROM
(SELECT * FROM Event_Player_Data NATURAL JOIN
(SELECT Event_ID FROM Event WHERE Match_type = 'TEST' or Match_Type='T201') AS r
) AS r2
GROUP BY Player_ID
ORDER BY Total_Wickets
DESC LIMIT 4
) AS r3 NATURAL JOIN player; 

-- List out top 10 Umpires with most Accuracy

SELECT Umpire_ID, Umpire_Name FROM Umpire 
WHERE Country = 'India' 
ORDER BY Decision_Accuracy 
DESC LIMIT 3;


--listout all the Australian stadiums with the capacity more than 40000

SELECT Stadium_name FROM Stadium
WHERE Country = 'Australia' AND capacity>40000;

--list out the details of the top 3 boards with highest victory in bilateral series

SELECT Board_ID,Board_Name, Country_Name ,Chairman_Name FROM 
(SELECT Winner,count(Bilateral_ID) AS Victories FROM Bilateral_Series 
GROUP BY Winner 
ORDER BY Victories 
DESC LIMIT 3) AS r JOIN Board 
ON Board_ID = Winner;

--list all the female players who have played more than 2 world cups

SELECT Player_ID,Player_Name
FROM
(SELECT Player_ID, count (Event_ID) AS Played_Events
FROM Event_Player_Data
GROUP BY Player_ID
HAVING count (Event_ID) > 2) as r NATURAL JOIN Player
WHERE Gender = 'Female';

-- list board id who got first rank in female most time in T20I series till now

SELECT Board_ID, Board_Name, Country_Name FROM
( SELECT Board_ID,Rank,Gender,Match_Type,count(Year) AS cnt 
FROM Board_Ranking
GROUP BY Board_ID,Rank,Gender,Match_Type
HAVING Rank = 1 AND Match_Type = 'T20I' AND Gender = 'Women'
ORDER BY cnt
DESC LIMIT 1
) AS r NATURAL JOIN Board;

-- list players who have participated in Event matches but not in bileteral matches

SELECT Player_ID, Player_Name FROM
(  
SELECT Player_ID FROM Event_Player_Data
EXCEPT
SELECT Player_ID FROM Bilateral_Player_Data
) 
NATURAL JOIN Player;

-- List out all players who have not participated in any bilateral series and world cup amd age>30.

SELECT Player_ID, Player_Name, DOB FROM
( SELECT Player_ID FROM player
WHERE Gender = 'Female'
EXCEPT
(
SELECT Player_ID FROM Bilateral_Player_Data
UNION
SELECT Player_ID FROM Event_Player_Data
)
) AS r NATURAL JOIN Player
WHERE EXTRACT(YEAR FROM AGE(current_date, DOB)) > 30;

-- list players data have age more than 30 with lefty batting style and scored run more than 3000 till now

SELECT DISTINCT Player_ID,Player_Name,DOB FROM
( SELECT Player_ID
FROM Player 
WHERE EXTRACT(YEAR FROM AGE(current_date, DOB))>=30 AND Batting_style = 'Left-handed'
) AS r
NATURAL JOIN Performance NATURAL JOIN Player
WHERE Total_Runs>=3000;

-- list players who have participated in bileteral matches but not in any world cup

SELECT Player_ID, Player_Name FROM
( SELECT Player_ID FROM Bilateral_Player_Data
EXCEPT
SELECT Player_ID FROM Event_Player_Data
) 
NATURAL JOIN Player;

--List out all the player data who have scored more than or equal to 1500 runs and taken more than 60 wickets 
--in bilateral matches and event matches till now

SELECT Player_ID,Player_Name, sum(Total_Runs) AS Total_Runs, sum(Total_Wickets) AS Total_Wickets
FROM Player NATURAL JOIN (
SELECT Player_ID, sum(Total_Runs) AS Total_Runs, sum(Total_Wickets) AS Total_Wickets
FROM Bilateral_Player_Data
GROUP BY Player_ID
UNION ALL
SELECT Player_ID, sum(Total_Runs) AS Total_Runs, sum(Total_Wickets) AS Total_Wickets
FROM Event_Player_Data
GROUP BY Player_ID
)AS r1
GROUP BY Player_ID,Player_name
HAVING sum(Total_Runs)>=1500 AND sum(Total_Wickets)>=60;

-- list out all umpires who have umpired(As on_field_umpire1, on_field_umpire2 and TV_umpire) in most matches of india 

SELECT Umpire_ID,Umpire_name FROM Umpire  NATURAL JOIN
(
SELECT Umpire_ID,sum(cnt1) as cnt FROM
(
SELECT On_field_umpire1 AS Umpire_ID, count(Match_ID) AS cnt1
FROM Matches_of_Event
WHERE Team1 = 'BCCI' OR Team2 = 'BCCI'
GROUP BY On_field_umpire1
UNION ALL
SELECT On_field_umpire1 AS Umpire_ID,count(Match_ID)
FROM Bilateral_Participation NATURAL JOIN Matches_of_Bilateral_series
WHERE Bilateral_ID = 'BCCI'
GROUP BY On_field_umpire1
UNION ALL
SELECT On_field_umpire2 AS Umpire_ID, count(Match_ID)
FROM Matches_of_Event
WHERE Team1 = 'BCCI' OR Team2 = 'BCCI'
GROUP BY On_field_umpire2
UNION ALL
SELECT On_field_umpire2 AS Umpire_ID,count(Match_ID)
FROM Bilateral_Participation NATURAL JOIN Matches_of_Bilateral_series
WHERE Bilateral_ID = 'BCCI'
GROUP BY On_field_umpire2
UNION ALL    
SELECT TV_umpire AS Umpire_ID, count(Match_ID)
FROM Matches_of_Event
WHERE Team1 = 'BCCI' OR Team2 = 'BCCI'
GROUP BY TV_umpire
UNION ALL
SELECT TV_umpire AS Umpire_ID,count(Match_ID)
FROM Bilateral_Participation NATURAL JOIN Matches_of_Bilateral_series
WHERE Bilateral_ID = 'BCCI'
GROUP BY TV_umpire
) AS r1
GROUP BY Umpire_ID ) as r2
ORDER BY cnt 
DESC LIMIT 1;

--list all the male players who have played less than 2 world cups

SELECT Player_ID,Player_Name FROM
(
SELECT Player_ID FROM Player
EXCEPT
(SELECT Player_ID FROM Event_Player_Data
GROUP BY Player_ID
HAVING count (Event_ID) > 2)
)
NATURAL JOIN Player
WHERE Gender='Male';

-- list players whenever he/she played in event, in that event his/her board always got first rank

SELECT Player_id , Player_name FROM Player NATURAL JOIN 
( SELECT Player_id FROM
(SELECT Board_ID,Count(Event_ID) AS No_of_cups FROM
( SELECT Event_ID, Board_ID FROM Event_Participation 
WHERE Rank=1 and substring(Event_ID,1,3)='MWC') AS r
GROUP BY Board_ID) AS Q1
NATURAL JOIN
(SELECT Player_id,Board_id,count(Event_id) AS champion FROM
(SELECT Event_ID, Board_ID,player_id FROM Event_Player_data 
NATURAL JOIN Event_Participation 
WHERE Rank=1) AS r
GROUP BY Player_id,Board_iD) AS Q2
WHERE No_of_cups=Champion
UNION
SELECT Player_id FROM
(SELECT Board_ID,Count(Event_ID) AS No_of_cups FROM
( SELECT Event_ID, Board_ID FROM Event_Participation 
WHERE Rank=1 and substring(Event_ID,1,3)='WWC') AS r
GROUP BY Board_ID) AS Q1
NATURAL JOIN
(SELECT Player_id,Board_id,count(Event_id) AS champion FROM
(SELECT Event_ID, Board_ID,player_id FROM Event_Player_data 
NATURAL JOIN Event_Participation 
WHERE Rank=1) AS r
GROUP BY Player_id,Board_iD) AS Q2
WHERE No_of_cups=Champion ) AS Q

--list player id who wins most awards till now

SELECT Player_id , Player_name,No_of_Awards FROM Player 
NATURAL JOIN
(SELECT Player_id,count(Award_name) AS No_of_Awards
FROM Awards 
GROUP BY Player_id
ORDER BY No_of_Awards 
DESC LIMIT 1)
AS r1;

-- Find details of top 10 stadiums that have maximum capacity

SELECT Stadium_ID,Stadium_name,Capacity,Pitch_type,Country FROM Stadium
ORDER BY Capacity DESC LIMIT 10;

--top 3 bowlers with highest wickets in ODI world cup

SELECT Player_id,Player_name, sum(Total_wickets) AS Total_wickets FROM Player
NATURAL JOIN
(SELECT Player_id,Total_wickets FROM Event_player_data
NATURAL JOIN
(SELECT Event_id FROM Event 
WHERE match_Type = 'ODI') AS r
)
GROUP BY Player_id
ORDER BY sum(Total_wickets)
DESC LIMIT 3;

-- list umpires id who  serve as the third umpire in events and as on-field umpires in bilateral series, specifically for matches between India and Pakistan till now

SELECT * FROM
((SELECT TV_umpire AS UMPIRE
FROM Matches_of_Event 
WHERE team1 IN ('BCCI', 'PCB') AND team2 IN ('BCCI', 'PCB'))
INTERSECT
SELECT * FROM
((SELECT On_field_umpire1 
FROM Matches_of_Bilateral_series NATURAL JOIN Bilateral_series
WHERE Host_Country IN ('BCCI', 'PCB') AND Guest_Country IN ('BCCI', 'PCB'))
UNION
(SELECT On_field_umpire2 FROM 
Matches_of_Bilateral_series NATURAL JOIN Bilateral_series
WHERE Host_Country IN ('India', 'Pakistan') AND Guest_Country IN ('India', 'Pakistan')) 
));

-- List Board id whose whose country won most matches per year in events

SELECT Q1.year,winner AS Country,No_of_won_matches FROM
(SELECT year , max(No_of_won_matches) AS max_won FROM  
(SELECT Winner , year , count(Match_id) AS No_of_won_matches FROM 
Matches_of_Event NATURAL JOIN Event GROUP BY Winner , year )
GROUP BY year )AS Q1 
JOIN
(SELECT Winner , year , count(Match_id) AS No_of_won_matches FROM 
Matches_of_Event NATURAL JOIN Event GROUP BY Winner , year ) AS Q2
ON max_won = No_of_won_matches AND Q1.year = Q2.year;

-- list out all the stadium name where no single match has been played

SELECT Stadium_id,Stadium_name,Country FROM stadium
WHERE stadium_id
NOT IN
( SELECT Venue as Stadium_id 
FROM Matches_of_Bilateral_series
UNION
SELECT Venue as Stadium_id 
FROM Matches_of_Event
) 

-- List Player id who took most wicket per year 

SELECT player_id,player_name,Q.year, Q.Wickets FROM
(SELECT Q1.year , Player_id , Q1.Wickets FROM
(SELECT year , max(Wickets) AS Wickets FROM
(SELECT Player_id,year , sum(Total_Wickets) AS Wickets FROM
(SELECT Player_id,year ,Match_type, Total_Wickets FROM 
Event NATURAL JOIN Event_Player_Data 
UNION ALL
SELECT Player_id,year ,Match_type, Total_Wickets FROM 
Bilateral_Series NATURAL JOIN Bilateral_Player_Data  )GROUP BY Player_id,year)
GROUP BY year) AS Q1
JOIN 
(SELECT Player_id,year , sum(Total_Wickets) AS Wickets FROM
(SELECT Player_id,year ,Match_type, Total_Wickets FROM 
 Event NATURAL JOIN Event_Player_Data 
 UNION ALL
 SELECT Player_id,year ,Match_type, Total_Wickets FROM 
 Bilateral_Series NATURAL JOIN Bilateral_Player_Data  )
 GROUP BY Player_id,year) AS Q2
 ON Q1.year = Q2.year AND Q1.Wickets = Q2.Wickets 
 ORDER BY Q1.year ASC)AS Q 
 NATURAL JOIN player;



-- find non indian umpire_id, umpire_name, country who have decision accuracy more than 85 and  
-- umpired in  match of events where runner up is India 

SELECT Umpire_ID,Umpire_Name,Country FROM
((SELECT Umpire_ID,Umpire_name,country FROM Umpire 
WHERE Decision_Accuracy > 85 AND Country != 'India'
) AS r1
JOIN
(SELECT On_field_umpire1,On_field_umpire2,TV_umpire FROM Event 
NATURAL JOIN Matches_of_Event
WHERE Runner_up='BCCI' 
) AS r2
ON r2.On_field_umpire1=r1.Umpire_ID 
OR r2.On_field_umpire2=r1.Umpire_ID 
OR r2.TV_umpire=r1.Umpire_ID
)As r

-- find the Board_ID,Board_Name,Country_Name that is stay at position 1 most of the time 

SELECT Board_ID,Board_Name,Country_Name,sum(rank) AS No_of_Times FROM 
Board_Ranking NATURAL JOIN board
WHERE rank = 1
GROUP BY Board_ID,Board_Name,Country_Name
ORDER BY No_of_Times 
DESC LIMIT 1

-- list out Player_ID,Total_runs,Fifties,centuries and Debute_Year of the most senior player from New Zealand out of 
-- all the players who participated in any event from New Zealand. 

SELECT Player_ID,Total_runs,Fifties,centuries,Debute_Year FROM Performance 
WHERE Player_id LIKE 'NZ%' AND Player_ID IN 
(SELECT Player_ID 
FROM Event_Player_Data)
ORDER BY Debute_Year LIMIT 1;

-- Find out all the  playerid,player name and eventid of the players who have scored more than 500 runs and taken more than 15 wickets in any ICC events

SELECT Player_id,Player_name,Event_id FROM Event_Player_Data
NATURAL JOIN Player
WHERE Total_Runs>=500 AND Total_Wickets>=15

-- Find out players who is left hander batter and right hander bowler or vice-versa. 

SELECT Player_name,Bowling_style,Batting_style FROM  
Player NATURAL JOIN 
(SELECT Player_ID from Player 
WHERE (Batting_style = 'Right-handed' AND Bowling_style LIKE '%Left-arm%') OR 
(Batting_style = 'Left-handed' AND Bowling_style LIKE '%Right-arm%') ) as r; 

-- Find out all the stadiums where India has player matches and give count of wins on that stadium. 

select r1.stadium_id, no_of_matches,wins from 
(SELECT venue as stadium_id,count(*) as no_of_matches FROM (
SELECT Match_ID,Venue,Winner FROM Matches_of_Event 
WHERE Team1 = 'BCCI' OR Team2 = 'BCCI'
UNION ALL 
SELECT Match_ID,Venue,Winner FROM Matches_of_Bilateral_series 
NATURAL JOIN Bilateral_Participation  
WHERE  Board_ID = 'BCCI' ) as r 
GROUP BY venue) as r1 
LEFT JOIN
(
( SELECT venue as stadium_id, count(*) as wins,winner FROM 
(SELECT Match_ID,Venue,Winner FROM Matches_of_Event 
WHERE Team1 = 'BCCI' OR Team2 = 'BCCI'
UNION ALL 
SELECT Match_ID,Venue,Winner FROM Matches_of_Bilateral_series 
NATURAL JOIN Bilateral_Participation  
WHERE  Board_ID = 'BCCI') as r 
GROUP BY venue,winner 
HAVING winner='BCCI' ) ) as r2
ON r1.stadium_id=r2.stadium_id; 

-- Print out all the bilateral_id, event_id where host country is the winner 

SELECT Board_id ,Board_name,Event_id AS event FROM 
Board join event 
on winner= Board_ID where Host_Country=Country_Name 
UNION All 
SELECT DISTINCT Board.Board_id,Board_name,bilateral_id  FROM
(
Bilateral_Series NATURAL JOIN Bilateral_Participation) AS r join 
Board 
on r.winner= Board.Board_ID where r.Host_Country=Country_Name; 

-- List player_id,no_of_5wi taken by right-arm off break bowler

select Player_ID,FIVE_wi
from
(
SELECT Player_ID,FIVE_wi
FROM  Performance NATURAL JOIN PLAYER where Bowling_style='Right-arm off break'
) as r
ORDER BY FIVE_WI 
DESC LIMIT 5;
