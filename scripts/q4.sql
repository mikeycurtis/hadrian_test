-- Task 4: Determine which conference (East or West) has had the most wins in the last decade
-- Calculate the total number of wins per conference by joining the win data with the teams table.

WITH win_loss AS (
    -- Home team wins
    SELECT
        home_team AS team,
        COUNT(*) AS wins
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
        COUNT(*) AS wins
    FROM
        games
    WHERE
        season >= YEAR(CURRENT_DATE) - 10
        AND away_score > home_score
    GROUP BY
        away_team
),

team_conferences AS (
    -- Select team and conference data
    SELECT
        team_name,
        conference
    FROM
        teams
)

-- Summarize the total wins per conference
SELECT
    conference,
    SUM(wins) AS total_wins
FROM
    win_loss
JOIN
    team_conferences ON win_loss.team = team_conferences.team_name
GROUP BY
    conference
ORDER BY
    total_wins DESC;