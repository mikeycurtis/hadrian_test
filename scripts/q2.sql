-- Task 2: Calculate the win-loss record for each team over the last decade
-- Determine the wins and losses for each team by checking the scores of home and away games.

WITH win_loss AS (
    -- Home team wins
    SELECT
        home_team AS team,
        COUNT(*) AS wins,
        0 AS losses
    FROM
        games
    WHERE
        season >= YEAR(CURRENT_DATE) - 10
        AND home_score > away_score
    GROUP BY
        home_team

    UNION ALL

    -- Away team wins
    SELECT
        away_team AS team,
        COUNT(*) AS wins,
        0 AS losses
    FROM
        games
    WHERE
        season >= YEAR(CURRENT_DATE) - 10
        AND away_score > home_score
    GROUP BY
        away_team

    UNION ALL

    -- Home team losses
    SELECT
        home_team AS team,
        0 AS wins,
        COUNT(*) AS losses
    FROM
        games
    WHERE
        season >= YEAR(CURRENT_DATE) - 10
        AND home_score < away_score
    GROUP BY
        home_team

    UNION ALL

    -- Away team losses
    SELECT
        away_team AS team,
        0 AS wins,
        COUNT(*) AS losses
    FROM
        games
    WHERE
        season >= YEAR(CURRENT_DATE) - 10
        AND away_score < home_score
    GROUP BY
        away_team
)

-- Summarize the total wins and losses for each team
SELECT
    team,
    SUM(wins) AS total_wins,
    SUM(losses) AS total_losses
FROM
    win_loss
GROUP BY
    team
ORDER BY
    total_wins DESC, total_losses ASC;