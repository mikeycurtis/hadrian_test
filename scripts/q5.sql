-- Task 5: Find the team with the highest average margin of victory in the last decade
-- Calculate the margin of victory for each game and then find the average margin for each team.

WITH game_margins AS (
    -- Margin of victory for home team wins
    SELECT
        home_team AS team,
        (home_score - away_score) AS margin
    FROM
        games
    WHERE
        season >= YEAR(CURRENT_DATE) - 10
        AND home_score > away_score

    UNION ALL

    -- Margin of victory for away team wins
    SELECT
        away_team AS team,
        (away_score - home_score) AS margin
    FROM
        games
    WHERE
        season >= YEAR(CURRENT_DATE) - 10
        AND away_score > home_score
)

-- Calculate the average margin of victory per team
SELECT
    team,
    AVG(margin) AS avg_margin
FROM
    game_margins
GROUP BY
    team
ORDER BY
    avg_margin DESC
LIMIT 1;