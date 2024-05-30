-- Task 6: Analyze team performance trends over the last decade
-- Calculate the average points scored per game and the average points allowed per game for each team per season.

-- First CTE to gather points scored and points allowed for each game
WITH game_scores AS (
    -- Points scored and allowed in home games
    SELECT
        season,
        home_team AS team,
        home_score AS points_scored,
        away_score AS points_allowed
    FROM
        games
    WHERE
        season >= YEAR(CURRENT_DATE) - 10

    UNION ALL

    -- Points scored and allowed in away games
    SELECT
        season,
        away_team AS team,
        away_score AS points_scored,
        home_score AS points_allowed
    FROM
        games
    WHERE
        season >= YEAR(CURRENT_DATE) - 10
),

-- Second CTE to calculate the average points scored and allowed for each team per season
team_performance AS (
    SELECT
        team,
        season,
        AVG(points_scored) AS avg_points_scored,
        AVG(points_allowed) AS avg_points_allowed
    FROM
        game_scores
    GROUP BY
        team,
        season
)

-- Display the results
SELECT
    team,
    season,
    avg_points_scored,
    avg_points_allowed
FROM
    team_performance
ORDER BY
    team,
    season;
