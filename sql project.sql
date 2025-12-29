CREATE DATABASE ENERGYDB2;
USE ENERGYDB2;

-- 1. country table
CREATE TABLE country (
    CID VARCHAR(10) PRIMARY KEY,
    Country VARCHAR(100) UNIQUE
);

SELECT * FROM COUNTRY;

-- 2. emission_3 table
CREATE TABLE emission_3 (
    country VARCHAR(100),
    energy_type VARCHAR(50),
    year INT,
    emission INT,
    per_capita_emission DOUBLE,
    FOREIGN KEY (country) REFERENCES country(Country)
);

SELECT * FROM EMISSION_3;


-- 3. population table
CREATE TABLE population (
    countries VARCHAR(100),
    year INT,
    Value DOUBLE,
    FOREIGN KEY (countries) REFERENCES country(Country)
);

SELECT * FROM POPULATION;

-- 4. production table
CREATE TABLE production (
    country VARCHAR(100),
    energy VARCHAR(50),
    year INT,
    production INT,
    FOREIGN KEY (country) REFERENCES country(Country)
);


SELECT * FROM PRODUCTION;

-- 5. gdp_3 table
CREATE TABLE gdp_3 (
    Country VARCHAR(100),
    year INT,
    Value DOUBLE,
    FOREIGN KEY (Country) REFERENCES country(Country)
);

SELECT * FROM GDP_3;

-- 6. consumption table
CREATE TABLE consumption (
    country VARCHAR(100),
    energy VARCHAR(50),
    year INT,
    consumption INT,
    FOREIGN KEY (country) REFERENCES country(Country)
);

SELECT * FROM CONSUMPTION;

-- alter
ALTER TABLE emission_3

add FOREIGN KEY (country) REFERENCES country(Country);

ALTER TABLE population

add FOREIGN KEY (countries) REFERENCES country(Country);

ALTER TABLE gdp_3
add FOREIGN KEY (country) REFERENCES country(Country);

ALTER TABLE consumption
add FOREIGN KEY (country) REFERENCES country(Country);

ALTER TABLE production
add FOREIGN KEY (country) REFERENCES country(Country);

-- What is the total emission per country for the most recent year available?

SELECT 
    country, SUM(emission) AS total_emission
FROM
    emission_3
WHERE
    year = (SELECT 
            MAX(year)
        FROM
            emission_3)
GROUP BY country
ORDER BY total_emission DESC;

-- The emission_3 table was used because it directly contains emission data by country and year.
-- MAX(year) was used to select the most recent year dynamically.
-- The WHERE clause filters data to that year only.
-- SUM(emission) aggregates emissions recorded across multiple entries.
-- GROUP BY country was used to calculate total emissions separately for each country.
-- ORDER BY was used to make comparison easier by ranking countries based on total emissions.

-- 2. What are the top 5 countries by GDP in the most recent year?
SELECT Country,Value AS GDP
FROM gdp_3
WHERE year = (
    SELECT MAX(year) FROM gdp_3
)
ORDER BY GDP DESC
LIMIT 5;
-- The gdp_3 table was used because it stores GDP values by country and year.
-- MAX(year) identifies the most recent year dynamically.
-- Results are ordered by GDP in descending order, and LIMIT 5 returns the top five countries

-- 3.Compare energy production and consumption by country and year. 

SELECT p.country,p.energy,p.year,p.production,c.consumption
FROM production p
JOIN consumption c ON p.country = c.country
AND p.energy = c.energy
AND p.year = c.year
ORDER BY p.country, p.year, p.energy;

-- The production and consumption tables were used because they store energy data by country, year, and energy type.
-- The JOIN matches rows on country, year, and energy type to compare the same energy for the same country and year.
-- The SELECT statement shows both production and consumption side by side.
-- ORDER BY organizes the results by country, year, and energy type for easy reading.

-- Trend Analysis Over Time
-- How have global emissions changed year over year?

SELECT year, SUM(emission) AS total_emissions
FROM emission_3
GROUP BY year
ORDER BY year;

-- 5).What is the trend in GDP for each country over the given years?

select country,year,sum(value) as gdp
from gdp_3
group by country,year
order by country,year;
-- This query gives the yearly GDP for each country and shows how it changes year over year, both as absolute numbers and percentages.

-- 6).How has population growth affected total emissions in each country?

select  * from population;
select  * from emission_3;

select population.countries,population.year,sum(emission_3.emission)
from population
inner join emission_3
on population.year=emission_3.year
and population.countries=emission_3.country
group by population.countries,population.year,population.value
order by population.year,population.countries;

-- The query joins population and emission data by country and year, aggregates emissions to get total emissions,
--  and helps analyze how population growth influences emissions.



-- 7).Has energy consumption increased or decreased over the years for major economies?

select sum(consumption),year,country as total_consumption
from consumption
where country in(
'United States',
    'China',
    'India',
    'Japan',
    'Germany')

group by year,country
order by year,country;

-- 8).What is the average yearly change in emissions per capita for each country?

select year, avg(per_capita_emission),country 
from emission_3
group by country,year
order by country,year;

SELECT
    country,
    AVG(per_capita_emission - prev_per_capita_emission) AS avg_yearly_change
FROM (
    SELECT
        e.country,
        e.year,
        (SUM(e.emission) / p.Value) AS per_capita_emission,
        LAG(SUM(e.emission) / p.Value)
            OVER (PARTITION BY e.country ORDER BY e.year) AS prev_per_capita_emission
    FROM emission_3 e
    JOIN population p
        ON e.country = p.countries
        AND e.year = p.year
    GROUP BY e.country, e.year, p.Value
) t
WHERE prev_per_capita_emission IS NOT NULL
GROUP BY country
ORDER BY country;

-- Ratio & Per Capita Analysis
-- 9).What is the emission-to-GDP ratio for each country by year?

select (sum(emission)/p.value) as ratio,e.country,e.year
from emission_3 as e
inner join gdp_3 as p
on e.country=p.country
and e.year=p.year
group by e.country,e.year,p.value
order by e.country,e.year;
-- The query joins emission and GDP tables by country and year, aggregates emissions using SUM, 
-- calculates the emission-to-GDP ratio, and orders the results for clear analysis.

-- 10).What is the energy consumption per capita for each country over the last decade?

 SELECT
    SUM(consumption) / p.value AS per_capita,
    c.country,
    c.year
FROM consumption AS c
INNER JOIN population AS p
    ON c.country = p.countries
    AND c.year = p.year
GROUP BY c.country, c.year, p.value
ORDER BY c.country, c.year;

-- The query joins consumption and population data, sums total energy consumption,
--  and divides it by population to calculate energy consumption per capita.

-- 11).How does energy production per capita vary across countries?

select sum(production)/p1.value as per_capita ,p.country,p.year
from production as p
inner join population as p1
on p.country=p1.countries
and p.year=p1.year

group by p.country,p1.value,p.year
order by p.country,p.year;

-- The query calculates energy production per capita by dividing
-- total energy production by the population for each country and year

-- 12)Which countries have the highest energy consumption relative to GDP?

select sum(consumption)/g.value as energy_gdp_ratio,c.country,c.year
from consumption as c
inner join gdp_3 as g
on c.country=g.country
and c.year=g.year
group by c.country,c.year,g.value
order by energy_gdp_ratio desc
limit 1;

-- The query joins energy consumption and GDP data by country and year, 
-- calculates energy consumption relative to GDP by dividing total consumption by GDP,
-- sorts the results in descending order, and uses the LIMIT clause to display only the
-- country with the highest value.

-- 13)What is the correlation between GDP growth and energy production growth?

WITH gdp_growth AS (
    SELECT
        Country AS country,
        year,
        Value AS gdp,
        Value - LAG(Value) OVER (PARTITION BY Country ORDER BY year) AS gdp_change
    FROM gdp_3
),
production_growth AS (
    SELECT
        country,
        year,
        SUM(production) AS total_production,
        SUM(production) - LAG(SUM(production)) 
            OVER (PARTITION BY country ORDER BY year) AS production_change
    FROM production
    GROUP BY country, year
)
SELECT
    g.country,
    g.year,
    g.gdp_change,
    p.production_change
FROM gdp_growth g
JOIN production_growth p
    ON g.country = p.country
   AND g.year = p.year
ORDER BY g.country, g.year;
-- The query uses the LAG() function to calculate year-to-year changes in GDP and energy production
-- and compares these changes to analyze their correlation.

-- 14).What are the top 10 countries by population and how do their emissions compare?
select p.value,sum(e.emission) as total_emission,p.year,p.countries
from population as  p
inner join emission_3 as e
on p.countries=e.country
and p.year=e.year
group by p.value,p.year,p.countries
order by p.value desc,p.countries,p.year desc
limit 10;

-- The query finds the top 10 countries by population and shows their total emissions 
-- by joining population and emission data and sorting by population.


-- 15).Which countries have improved (reduced) their per capita emissions the most over the last decade?

SELECT
    country,
    MAX(per_capita_emission) - MIN(per_capita_emission) AS reduction_in_per_capita_emission
FROM emission_3
WHERE year BETWEEN (SELECT MAX(year) - 10 FROM emission_3)
               AND (SELECT MAX(year) FROM emission_3)
GROUP BY country
ORDER BY reduction_in_per_capita_emission DESC;
-- The query checks per capita emissions for the last 10 years, finds how much each country has reduced them, 
-- and shows the countries with the biggest reduction.
 
 -- 16).What is the global share (%) of emissions by country?

select sum(emission)/(select sum(emission ) from emission_3)*100 as emission_share ,country
from emission_3
group by country
order by emission_share desc;
-- The query finds each country’s percentage contribution to total global emissions by dividing 
-- its emissions by global emissions and sorting the results.

-- 17)What is the global average GDP, emission, and population by year?

SELECT
    g.year,
    AVG(g.Value) AS avg_gdp,
    SUM(e.total_emission) AS total_emission,
    SUM(p.Value) AS total_population
FROM gdp_3 g

JOIN population p
    ON p.countries = g.Country
   AND p.year = g.year

JOIN (
    SELECT
        country,
        year,
        SUM(emission) AS total_emission
    FROM emission_3
    GROUP BY country, year
) e
    ON e.country = g.Country
   AND e.year = g.year

GROUP BY g.year
ORDER BY g.year;
-- The query first combines emission, GDP, and population data correctly by year and country,
-- then calculates global yearly values without duplication.

