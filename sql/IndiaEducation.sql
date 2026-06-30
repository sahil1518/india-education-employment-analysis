
USE master;
GO

CREATE DATABASE IndiaEducationDB;
GO

USE IndiaEducationDB;
GO


USE IndiaEducationDB;

SELECT 'dropout_rates'   AS table_name, COUNT(*) AS rows FROM dropout_rates
UNION ALL
SELECT 'state_indicators', COUNT(*) FROM state_indicators
UNION ALL
SELECT 'education_stats',  COUNT(*) FROM education_stats;


USE IndiaEducationDB;
GO

-- =============================================
-- Query 1: For each state show literacy 2011, unemployment 2011, poverty 2011, income 2011, and rank by literacy descending.
-- =============================================
SELECT
    state,
    literacy_2011,
    unemployment_2011,
    poverty_2011,
    income_2011,
    RANK() OVER (ORDER BY literacy_2011 DESC) AS literacy_rank
FROM state_indicators
ORDER BY literacy_rank;
GO

-- =============================================
-- Query 2: Show states where literacy is above 75% but unemployment is also above 10.
--          These are the "educated but jobless" states — paradox analysis.
-- =============================================
SELECT
    state,
    literacy_2011,
    unemployment_2011,
    poverty_2011
FROM state_indicators
WHERE literacy_2011 > 75
AND unemployment_2011 > 10
ORDER BY unemployment_2011 DESC;
GO

-- =============================================
-- Query 3: From education_stats table show each state's male literacy, female literacy, 
--          and the gap between them. Order by gap descending — widest gap first.
-- =============================================
SELECT
    state,
    male_literacy,
    female_literacy,
    CAST(male_literacy - female_literacy AS DECIMAL(5,2)) AS gender_gap
FROM education_stats
ORDER BY gender_gap DESC;
GO

-- =============================================
-- Query 4: From dropout_rates table calculate average Primary Total dropout rate per state across all years. 
--          Show top 10 states with highest dropout. Order by avg dropout descending.
-- =============================================
SELECT TOP 10
    State_UT,
    CAST(AVG(Primary_Total) AS DECIMAL(5,2))    AS avg_primary_dropout,
    CAST(AVG([Secondary _Total]) AS DECIMAL(5,2))  AS avg_secondary_dropout,
    CAST(AVG(HrSecondary_Total) AS DECIMAL(5,2)) AS avg_hrsecondary_dropout
FROM dropout_rates
GROUP BY State_UT
ORDER BY avg_primary_dropout DESC;
GO

-- =============================================
-- Query 5: From dropout_rates show average dropout rate per year for Primary, Upper Primary, Secondary and Higher Secondary levels. Order by year.
-- =============================================
SELECT
    year,
    CAST(AVG(Primary_Total)      AS DECIMAL(5,2)) AS avg_primary_dropout,
    CAST(AVG([Upper Primary_Total]) AS DECIMAL(5,2)) AS avg_upperprimary_dropout,
    CAST(AVG([Secondary _Total]) AS DECIMAL(5,2)) AS avg_secondary_dropout,
    CAST(AVG(HrSecondary_Total)  AS DECIMAL(5,2)) AS avg_hrsecondary_dropout
FROM dropout_rates
GROUP BY year
ORDER BY year;
GO

-- =============================================
-- Query 6: From state_indicators show states that improved literacy the most between 2001 and 2011. Calculate literacy improvement = literacy_2011 minus literacy_2001.
--          Order by improvement descending. Top 10.
-- =============================================
SELECT TOP 10
    state,
    literacy_2001,
    literacy_2011,
    CAST(literacy_2011 - literacy_2001 AS DECIMAL(5,2)) AS literacy_improvement
FROM state_indicators
ORDER BY literacy_improvement DESC;
GO

-- =============================================
-- Query 7: From education_stats show each state's total schools, total teachers, total enrollment and calculate students per teacher ratio.
--          Order by ratio descending — highest ratio means most overburdened teachers.
-- =============================================
SELECT
    state,
    total_schools,
    total_teachers,
    total_enrollment,
    CAST(total_enrollment * 1.0 / total_teachers AS DECIMAL(10,2)) AS students_per_teacher
FROM education_stats
ORDER BY students_per_teacher DESC;
GO

-- =============================================
-- Query 8:  Join state_indicators with education_stats on state name. Show poverty 2011, overall literacy, dropout rate context.
---          Order by poverty descending.
-- =============================================
SELECT
    s.state,
    s.poverty_2011,
    s.literacy_2011,
    s.unemployment_2011,
    e.total_enrollment,
    e.total_schools,
    CAST(e.total_enrollment * 1.0 / e.total_schools AS DECIMAL(10,2)) AS enrollment_per_school
FROM state_indicators s
JOIN education_stats e
    ON s.state = e.state
ORDER BY s.poverty_2011 DESC;
GO