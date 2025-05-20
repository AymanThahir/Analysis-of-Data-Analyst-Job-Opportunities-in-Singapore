SELECT * FROM sg_companies;


ALTER TABLE sg_companies
MODIFY `COMPANY NAME` varchar(50);

ALTER TABLE sg_companies
MODIFY `JOB TITLE` varchar(50);


ALTER TABLE sg_companies
MODIFY `SKILLS` varchar(50);


ALTER TABLE sg_companies
MODIFY `SALARY` int;


ALTER TABLE sg_companies
MODIFY `WEEK` int;


UPDATE sg_companies
SET `EXPERIENCE` = NULL
WHERE `EXPERIENCE` = 'Intern';


ALTER TABLE sg_companies
MODIFY `EXPERIENCE` int;


WITH dim_exp AS(
    SELECT DISTINCT COALESCE(EXPERIENCE, 'Intern') AS EXPERIENCE, COUNT(`COMPANY NAME`) AS COUNT
    FROM sg_companies
    GROUP BY COALESCE(EXPERIENCE, 'Intern')
    ORDER BY `EXPERIENCE`
)
SELECT * FROM dim_exp

WITH dim_exp AS (
    SELECT 
        COALESCE(`EXPERIENCE`, 'Intern') AS `EXPERIENCE`,
        COUNT(`COMPANY NAME`) AS COUNT
    FROM sg_companies
    GROUP BY COALESCE(`EXPERIENCE`, 'Intern')
),
ranked_exp AS (
    SELECT *,
        CASE 
            WHEN `EXPERIENCE` = 'Intern' THEN 0
            WHEN `EXPERIENCE` = '0' THEN 1
            WHEN `EXPERIENCE` = '1' THEN 2
            WHEN `EXPERIENCE` = '2' THEN 3
            WHEN `EXPERIENCE` = '3' THEN 4
            WHEN `EXPERIENCE` = '4' THEN 5
            WHEN `EXPERIENCE` = '5' THEN 6
            WHEN `EXPERIENCE` = '6' THEN 7
            WHEN `EXPERIENCE` = '7' THEN 8
            WHEN `EXPERIENCE` = '8' THEN 9
            WHEN `EXPERIENCE` = '9' THEN 10
            WHEN `EXPERIENCE` = '10' THEN 11
            ELSE 99 -- unknowns go at the end
        END AS sort_order
    FROM dim_exp
)
SELECT `EXPERIENCE`, COUNT
FROM ranked_exp
ORDER BY sort_order;


WITH RECURSIVE split_skills AS (
    SELECT 
        `COMPANY NAME`,
        `EXPERIENCE`,
        SUBSTRING_INDEX(`SKILLS`, ',', 1) AS skill,
        SUBSTRING(`SKILLS`, LENGTH(SUBSTRING_INDEX(`SKILLS`, ',', 1)) + 2) AS remaining
    FROM sg_companies

    UNION ALL

    SELECT 
        `COMPANY NAME`,
        `EXPERIENCE`,
        SUBSTRING_INDEX(remaining, ',', 1),
        SUBSTRING(remaining, LENGTH(SUBSTRING_INDEX(remaining, ',', 1)) + 2)
    FROM split_skills
    WHERE remaining != ''
)
SELECT 
    TRIM(skill) AS SKILL,
    COUNT(*) AS COUNT
FROM split_skills
GROUP BY TRIM(SKILL)
ORDER BY COUNT DESC;


WITH Exp_Salary AS(
SELECT 
COALESCE(`EXPERIENCE`, 'Intern') AS `EXPERIENCE`,
MAX(SALARY) AS MAX,
AVG(SALARY) AS AVERAGE,
MIN(SALARY) AS MIN,
CASE 
    WHEN `EXPERIENCE` = 'Intern' THEN 1
    WHEN `EXPERIENCE` = '0' THEN 2
    WHEN `EXPERIENCE` = '1' THEN 3
    WHEN `EXPERIENCE` = '2' THEN 4
    WHEN `EXPERIENCE` = '3' THEN 5
    WHEN `EXPERIENCE` = '4' THEN 6
    WHEN `EXPERIENCE` = '5' THEN 7
    WHEN `EXPERIENCE` = '6' THEN 8
    WHEN `EXPERIENCE` = '7' THEN 9
    WHEN `EXPERIENCE` = '8' THEN 10
    WHEN `EXPERIENCE` = '9' THEN 11
    WHEN `EXPERIENCE` = '10' THEN 12
    ELSE 0 
END AS sort_order
FROM sg_companies
GROUP BY `EXPERIENCE`
)
SELECT
COALESCE(`EXPERIENCE`, 'Intern') AS `EXPERIENCE`,
MAX,
AVERAGE,
MIN
FROM `Exp_Salary`
ORDER BY sort_order

WITH Exp_Count AS(
SELECT 
COALESCE(EXPERIENCE, 'Intern') AS EXPERIENCE,
COUNT(*) AS COUNT,
CASE 
    WHEN `EXPERIENCE` = 'Intern' THEN 1
    WHEN `EXPERIENCE` = '0' THEN 2
    WHEN `EXPERIENCE` = '1' THEN 3
    WHEN `EXPERIENCE` = '2' THEN 4
    WHEN `EXPERIENCE` = '3' THEN 5
    WHEN `EXPERIENCE` = '4' THEN 6
    WHEN `EXPERIENCE` = '5' THEN 7
    WHEN `EXPERIENCE` = '6' THEN 8
    WHEN `EXPERIENCE` = '7' THEN 9
    WHEN `EXPERIENCE` = '8' THEN 10
    WHEN `EXPERIENCE` = '9' THEN 11
    WHEN `EXPERIENCE` = '10' THEN 12
    ELSE 0 
END AS sort_order
FROM sg_companies
GROUP BY EXPERIENCE
)
SELECT 
EXPERIENCE,
COUNT
FROM `Exp_Count`
ORDER BY sort_order;


SELECT
`COMPANY NAME`,
AVG(`SALARY`) AS `AVERAGE SALARY`
FROM
sg_companies
GROUP BY `COMPANY NAME`
ORDER BY AVG(`SALARY`) DESC

SELECT 
WEEK,
COUNT(*) AS `COUNT`
FROM sg_companies
GROUP BY WEEK
ORDER BY WEEK


DROP TABLE sg_companies;