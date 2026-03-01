SELECT 
    State,
    SUM(Production) / SUM(Area) AS weighted_yield
FROM clean_agriculture_data
GROUP BY State
ORDER BY weighted_yield DESC
LIMIT 5;

SELECT 
    Crop,
    SUM(Production) AS total_production
FROM clean_agriculture_data
GROUP BY Crop
ORDER BY total_production DESC
LIMIT 5;

SELECT 
    Crop_Year,
    SUM(Production) AS total_production
FROM clean_agriculture_data
GROUP BY Crop_Year
ORDER BY total_production DESC
LIMIT 5;

SELECT 
    Season,
    AVG(Yield) AS avg_yield
FROM clean_agriculture_data
GROUP BY Season
ORDER BY avg_yield DESC;

SELECT 
    State,
    SUM(Production) / SUM(Area) AS weighted_yield,
    RANK() OVER (ORDER BY SUM(Production) / SUM(Area) DESC) AS state_rank
FROM clean_agriculture_data
GROUP BY State;

SELECT *
FROM (
    SELECT 
        State,
        Crop,
        SUM(Production) AS total_production,
        RANK() OVER (
            PARTITION BY State 
            ORDER BY SUM(Production) DESC
        ) AS crop_rank
    FROM clean_agriculture_data
    GROUP BY State, Crop
) ranked
WHERE crop_rank <= 3;

SELECT 
    State,
    AVG(CASE WHEN Decade = 1990 THEN Yield END) AS yield_1990s,
    AVG(CASE WHEN Decade = 2010 THEN Yield END) AS yield_2010s,
    (
        AVG(CASE WHEN Decade = 2010 THEN Yield END) -
        AVG(CASE WHEN Decade = 1990 THEN Yield END)
    ) AS yield_change
FROM clean_agriculture_data
GROUP BY State
HAVING yield_change < 0
ORDER BY yield_change ASC;