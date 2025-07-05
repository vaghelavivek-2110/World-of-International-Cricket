CREATE TABLE Player(
    Player_ID VARCHAR(8), 
    Player_Name VARCHAR(50),
    Batting_style VARCHAR(50),
    Bowling_style VARCHAR(50), 
    Gender VARCHAR (8), 
    DOB VARCHAR, 
    PRIMARY KEY (Player_ID)
	
); 

CREATE TABLE Performance(
    Player_ID VARCHAR(8),
    Match_type VARCHAR(15),
    Debute_Year DATE,
    Total_Runs INT, 
    Batting_Average DECIMAL, 
    Batting_Strike_rate DECIMAL, 
    Fifties INT, 
    Centuries INT, 
    Bowling_Average DECIMAL,
    Bowling_Strike_rate DECIMAL,
    Total_Wickets INT, 
    Five_WI INT,
    Catches INT,
    Runouts INT,
    Stumping INT, 
    PRIMARY KEY (Player_ID,Match_type), 
    FOREIGN KEY (Player_ID) REFERENCES Player(Player_ID) ON DELETE CASCADE ON UPDATE CASCADE
); 

CREATE TABLE Board(
    Board_ID VARCHAR(8),
    Board_Name VARCHAR(60), 
    Chairman_Name VARCHAR(50),  
    Country_Name VARCHAR(25),
    PRIMARY KEY (Board_ID)
); 

CREATE TABLE Victory(
    Board_ID VARCHAR(8), 
    Match_type VARCHAR(25), 
    No_of_cups INT, 
    FOREIGN KEY (Board_ID) REFERENCES Board(Board_ID) ON DELETE CASCADE ON UPDATE CASCADE, 
    PRIMARY KEY(Board_ID,Match_type) 
); 



CREATE TABLE Umpire(
    Umpire_ID VARCHAR(25) ,
    Umpire_Name  VARCHAR(50), 
    Country VARCHAR(15),  
    Decision_Accuracy DECIMAL, 
    PRIMARY KEY (Umpire_ID)

); 



CREATE TABLE Stadium(
    Stadium_ID VARCHAR(8),
    Stadium_Name  VARCHAR(60), 
    Capacity INT,
    Country VARCHAR(15), 
    Pitch_type VARCHAR(25), 
    PRIMARY KEY(Stadium_ID)

); 



CREATE TABLE Event(
    Event_ID VARCHAR(8),
    Host_Country  VARCHAR(25), 
    Year INT,
    Match_type VARCHAR(25), 
    No_of_teams INT,
    Player_of_the_tournament VARCHAR(8),
	Winner VARCHAR(8),
	Runner_up VARCHAR(8),
    PRIMARY KEY (Event_ID),
    FOREIGN KEY (Player_of_the_tournament) REFERENCES Player(Player_ID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Winner) REFERENCES Board(Board_ID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Runner_up) REFERENCES Board(Board_ID) ON DELETE CASCADE ON UPDATE CASCADE 
); 

CREATE TABLE Event_Participation(
    Event_ID VARCHAR(8),
    Board_ID VARCHAR(8),
    Rank INT,
    Most_Runs VARCHAR(8), 
    Most_Wickets VARCHAR(8),
    FOREIGN KEY (Board_ID) REFERENCES Board(Board_ID) ON DELETE CASCADE ON UPDATE CASCADE, 
    FOREIGN KEY (Event_ID) REFERENCES Event(Event_ID) ON DELETE CASCADE ON UPDATE CASCADE, 
	FOREIGN KEY (Most_Runs) REFERENCES Player(Player_ID) ON DELETE CASCADE ON UPDATE CASCADE, 
	FOREIGN KEY (Most_Wickets) REFERENCES Player(Player_ID) ON DELETE CASCADE ON UPDATE CASCADE, 
    PRIMARY KEY(Event_ID,Board_ID)
); 



CREATE TABLE  Matches_of_Event(
    Match_ID VARCHAR(8),
    Event_ID VARCHAR(8),
    Date DATE,
    Venue VARCHAR(15),
    On_field_umpire1 VARCHAR(25),
    On_field_umpire2 VARCHAR(25),
    TV_umpire VARCHAR(25),
    Team1 VARCHAR(15),
    Team2 VARCHAR(15),
    Winner VARCHAR(15),
    PRIMARY KEY (Match_ID),
    FOREIGN KEY (Event_ID) REFERENCES Event(Event_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Venue) REFERENCES Stadium(Stadium_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (On_field_umpire1) REFERENCES Umpire(Umpire_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (On_field_umpire2) REFERENCES Umpire(Umpire_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (TV_umpire) REFERENCES Umpire(Umpire_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Team1) REFERENCES Board(Board_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Team2) REFERENCES Board(Board_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Winner) REFERENCES Board(Board_ID) ON DELETE CASCADE ON UPDATE CASCADE

    
);


CREATE TABLE Event_Player_Data(
    Event_ID VARCHAR(8),
    Player_ID VARCHAR(8),
    Total_Runs INT,
    Total_Wickets INT,
    Total_Catches INT,
    Total_Stumping INT,
    PRIMARY KEY (Event_ID ,Player_ID),
    FOREIGN KEY (Event_ID) REFERENCES Event(Event_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Player_ID) REFERENCES Player(Player_ID) ON DELETE CASCADE ON UPDATE CASCADE
    
    
);

CREATE TABLE Bilateral_Series(
    Bilateral_ID VARCHAR(9) PRIMARY KEY,
    Host_Country  VARCHAR(15), 
    Year INT,
    Match_type VARCHAR(15), 
    Guest_Country VARCHAR(15),
    Number_of_Matches INT, 
	Winner VARCHAR(8),
    Player_of_the_series VARCHAR(15),
	FOREIGN KEY (Winner) REFERENCES  Board(Board_ID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Player_of_the_series) REFERENCES Player(Player_ID) ON DELETE CASCADE ON UPDATE CASCADE
	
);

CREATE TABLE Bilateral_Participation(
    Bilateral_ID VARCHAR(25),
    Board_ID VARCHAR(25),
    Most_Runs  VARCHAR(25), 
    Most_Wickets VARCHAR(25),
    PRIMARY KEY (Bilateral_ID ,Board_ID),
    FOREIGN KEY (Bilateral_ID) REFERENCES Bilateral_Series(Bilateral_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Board_ID) REFERENCES Board(Board_ID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Most_Runs) REFERENCES Player(Player_ID) ON DELETE CASCADE ON UPDATE CASCADE, 
	FOREIGN KEY (Most_Wickets) REFERENCES Player(Player_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE  Matches_of_Bilateral_series(      
    Match_ID VARCHAR(25),
    Bilateral_ID VARCHAR(25),
    Date Date,
    Venue VARCHAR(17),
    On_field_umpire1 VARCHAR(25),
    On_field_umpire2 VARCHAR(25),
    TV_umpire VARCHAR(25),
    Winner VARCHAR(20),
    PRIMARY KEY (Match_ID),
    FOREIGN KEY (Bilateral_ID) REFERENCES Bilateral_Series(Bilateral_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Venue) REFERENCES Stadium(Stadium_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (On_field_umpire1) REFERENCES Umpire(Umpire_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (On_field_umpire2) REFERENCES Umpire(Umpire_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (TV_umpire) REFERENCES Umpire(Umpire_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Winner) REFERENCES Board(Board_ID) ON DELETE CASCADE ON UPDATE CASCADE   
); 

CREATE TABLE Player_Ranking(
    Match_type VARCHAR(25),
    Year INT, 
    Rank INT, 
    Category VARCHAR(15), 
    Gender VARCHAR(7), 
    Rating INT, 
    Player_ID VARCHAR(25), 
    FOREIGN KEY (Player_ID) REFERENCES Player(Player_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY(Match_type,Year,Rank,Category,Gender)
	
);


CREATE TABLE Bilateral_Player_data(

    Bilateral_ID VARCHAR(25),
    Player_ID VARCHAR(25),
    Total_Runs INT,
    Total_Wickets INT,
    Total_Catches INT,
    Total_Stumpings INT,
    PRIMARY KEY(Bilateral_ID,Player_ID),
    FOREIGN KEY (Player_ID) REFERENCES Player(Player_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Bilateral_ID) REFERENCES Bilateral_Series(Bilateral_ID) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Board_Ranking(
    Match_type VARCHAR(25),
    Year INT, 
    Rank INT, 
    Gender VARCHAR(7), 
    Rating INT, 
    Board_ID VARCHAR(20), 
    
    PRIMARY KEY(Match_type,Year,Rank,Gender),
    FOREIGN KEY (Board_ID) REFERENCES Board(Board_ID) ON DELETE CASCADE ON UPDATE CASCADE
); 



CREATE TABLE Awards(
    Player_ID VARCHAR(25),
    Year INT, 
    Award_Name VARCHAR(50), 
    PRIMARY KEY(Player_ID,Year,Award_Name),
    FOREIGN KEY (Player_ID) REFERENCES Player(Player_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

