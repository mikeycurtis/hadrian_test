import requests
import pandas as pd
from datetime import date
import duckdb
import time

api_key = "#"  # Replace with your own api key

headers = {"X-RapidAPI-Key": api_key, "X-RapidAPI-Host": "v2.nba.api-sports.io"}

teams_url = "https://v2.nba.api-sports.io//teams"
games_url = "https://v2.nba.api-sports.io//games"

# Get teams from the standard league in both west and east conferences
teams_response_west = requests.get(
    teams_url, headers=headers, params={"league": "standard", "conference": "west"}
)
teams_response_east = requests.get(
    teams_url, headers=headers, params={"league": "standard", "conference": "east"}
)

# Get teams data
teams_data_west = teams_response_west.json()["response"]
teams_data_east = teams_response_east.json()["response"]

# Clean teams data
ids = []
names = []
conferences = []
divisions = []

for team in teams_data_west:
    if not team["allStar"]:
        ids.append(team["id"])
        names.append(team["name"])
        conferences.append(team["leagues"]["standard"]["conference"])
        divisions.append(team["leagues"]["standard"]["division"])

for team in teams_data_east:
    if not team["allStar"]:
        ids.append(team["id"])
        names.append(team["name"])
        conferences.append(team["leagues"]["standard"]["conference"])
        divisions.append(team["leagues"]["standard"]["division"])


# Create teams df
data = {
    "team_id": ids,
    "team_name": names,
    "conference": conferences,
    "division": divisions,
}
teams_df = pd.DataFrame(data).sort_values(by="team_name")


# Get games data
game_ids = []
seasons = []
dates = []
home_teams = []
away_teams = []
home_scores = []
away_scores = []

today = date.today()

# Loop through each year in the past 11 years for this test (starting from the most recent)
# Note: I picked data from the last 11 years to cover the queries in the test. It's arbitrary and can be adjusted if more data is wanted.
for year in range(today.year - 11 + 1, today.year + 1):
    games_response = requests.get(
        games_url, headers=headers, params={"season": str(year)}
    )
    games_data = games_response.json()["response"]

    for game in games_data:
        if game["teams"]["home"]["name"] in ["Utah Blue", "Utah White"] or game[
            "teams"
        ]["visitors"]["name"] in ["Utah Blue", "Utah White"]:
            continue
        if (
            game["teams"]["home"]["name"] in names
            and game["teams"]["visitors"]["name"] in names
        ):
            game_ids.append(game["id"])
            seasons.append(game["season"])
            dates.append(game["date"]["start"].split("T")[0])
            home_teams.append(game["teams"]["home"]["name"])
            away_teams.append(game["teams"]["visitors"]["name"])
            home_scores.append(game["scores"]["home"]["points"])
            away_scores.append(game["scores"]["visitors"]["points"])
    time.sleep(5)  # Wait 5 seconds so that our api account doesn't get suspended

# Create games df
data = {
    "game_id": game_ids,
    "season": seasons,
    "date": dates,
    "home_team": home_teams,
    "away_team": away_teams,
    "home_score": home_scores,
    "away_score": away_scores,
}
games_df = pd.DataFrame(data)


# Save to DuckDB
con = duckdb.connect("nba_data.duckdb")
# Drop existing tables (if needed)
con.execute("DROP TABLE IF EXISTS teams")
con.execute("DROP TABLE IF EXISTS games")
# Create tables from pandas dfs
con.execute("CREATE TABLE teams AS SELECT * FROM teams_df")
con.execute("CREATE TABLE games AS SELECT * FROM games_df")
