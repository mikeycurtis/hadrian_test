-- Task 1: Retrieve the top 10 highest-scoring games in the last decade
-- The total score for a game is the sum of home_score and away_score.
-- Filter the games to include only those played in the last decade.

SELECT
    game_id,
    season,
    date,
    home_team,
    away_team,
    home_score,
    away_score,
    (home_score + away_score) AS total_score
FROM
    games
WHERE
    season >= YEAR(CURRENT_DATE) - 10
ORDER BY
    total_score DESC
LIMIT 10;
