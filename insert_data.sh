#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [ $YEAR != "year" ]
  then
    #get team_id
    #if not found
    #insert team_id
    #get new team_id
    ####
    TEAM1=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #TEAM_ID2 = $($PSQL "SELECT team_id FROM teams WHERE team_id='$OPPONENT'")
    #if not found 
    if [[ -z $TEAM1 ]] 
    then 
      $($PSQL "INSERT INTO teams(name) VALUES('$WINNER')") 
      #get new id
      TEAM1=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    TEAM2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #if not found 
    if [[ -z $TEAM2 ]] 
    then 
      $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')") 
      #get new id
      TEAM2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    #games table
    $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND'
    ,$TEAM1, $TEAM2, $WINNER_GOALS, $OPPONENT_GOALS)")

  fi
done