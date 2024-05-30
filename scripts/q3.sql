-- Task 3: Calculate the average points scored by each team per season over the last decade
-- Aggregate the points scored by each team (both home and away) per season and get the average.

WITH team_scores AS (
    -- Points scored by home teams
    SELECT
        season,
        home_team AS team,
        home_score AS points
    FROM
        games
    WHERE
        season >= YEAR(CURRENT_DATE) - 10

    UNION ALL

    -- Points scored by away teams
    SELECT
        season,
        away_team AS team,
        away_score AS points
    FROM
        games
    WHERE
        season >= YEAR(CURRENT_DATE) - 10
)

-- Calculate the average points scored per team per season
SELECT
    season,
    team,
    AVG(points) AS avg_points
FROM
    team_scores
GROUP BY
    season,
    team
ORDER BY
    season,
    team;