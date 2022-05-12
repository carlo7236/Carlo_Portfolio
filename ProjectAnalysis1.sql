
SELECT * FROM COVIDPROJECT22.coviddeaths;

-- chances of dying per country 
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS chance_of_death
FROM COVIDPROJECT22.coviddeaths
order by 1,2; 

-- chances of dying from Covid in US 
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS death_chance_US
FROM COVIDPROJECT22.coviddeaths
WHERE location like '%states%'; 

-- Rate of new cases from total per day 
SELECT location, date, total_cases, new_cases, (new_cases/total_cases) * 100
FROM COVIDPROJECT22.coviddeaths
WHERE location like '%states%'; 

-- Top 5 countries with highest case count 
SELECT location,MAX(total_cases) AS max_cases_per_country 
FROM COVIDPROJECT22.coviddeaths
WHERE continent not like ''
GROUP BY location
ORDER BY MAX(total_cases) DESC 
LIMIT 5; 

-- Look at cases vs death rate in countries with highest case rates to date 
SELECT location,  MAX(total_cases), MAX(CAST(total_deaths AS UNSIGNED)) ,(MAX(CAST(total_deaths AS UNSIGNED))/MAX(total_cases)) *100
AS death_rate_per_case
FROM COVIDPROJECT22.coviddeaths
WHERE continent not like ''
GROUP BY location
ORDER BY MAX(total_cases) DESC
LIMIT 5;

-- Look at total death rate  per population total
SELECT location,  population, MAX(total_cases) AS HighestInfectionCount, MAX(CAST(total_deaths AS UNSIGNED))
AS max_deaths,(MAX(CAST(total_deaths AS UNSIGNED))/population) *100 tot_death_per_pop
FROM COVIDPROJECT22.coviddeaths
WHERE continent not like ''
GROUP BY location, population
ORDER BY MAX(total_cases) DESC
LIMIT 5;

-- Picking New Zealand as NZ has had low cases/deaths 
SELECT location, date,population, new_cases, total_cases, new_deaths, total_deaths
FROM COVIDPROJECT22.coviddeaths
WHERE location like '%zealand%';

-- chances of dying from Covid in NZ
SELECT location, date,population,total_deaths, total_cases, (total_deaths/total_cases) * 100
FROM COVIDPROJECT22.coviddeaths
WHERE location like '%zealand%' ;

-- Compare NZ to U.S
SELECT location, MAX(CAST(total_deaths as UNSIGNED)) AS total_death
FROM COVIDPROJECT22.coviddeaths
WHERE location like '%zealand%' or location like '%states%'
GROUP BY location; 

-- Compare 'big 3' global powers to one another in terms of cases and death 

SELECT location, MAX(CAST(total_deaths as UNSIGNED)) AS tot_deaths
FROM COVIDPROJECT22.coviddeaths
WHERE location like '%states%' OR location like 'russia' OR location like 'china'
GROUP BY location;

SELECT location, population, MAX(CAST(total_deaths as UNSIGNED)) AS tot_deaths, MAX(total_deaths)/population AS percentage_of_tot_death
FROM COVIDPROJECT22.coviddeaths
WHERE location like '%states%' OR location like 'russia' OR location like 'china'
GROUP BY location, population
ORDER BY 1,2;

-- Global Deaths
SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, (SUM(new_deaths)/SUM(new_cases)) * 100
AS global_death_rate
FROM COVIDPROJECT22.coviddeaths
WHERE continent not like ''
ORDER BY 1,2;


-- total vaccination rate per country 
SELECT death.location, MAX(vac.total_vaccinations), death.population, (MAX(vac.total_vaccinations)/death.population) * 100 AS vacc_rate
from COVIDPROJECT22.coviddeaths death
JOIN COVIDPROJECT22.covidvaccinations vac
ON death.location = vac.location 
AND death.date = vac.date
GROUP BY 1, 3;

-- Top 5 countries with highest vaccine rates per population 

SELECT death.location, MAX(vac.total_vaccinations), death.population, (MAX(vac.total_vaccinations)/death.population) * 100 AS vacc_rate
from COVIDPROJECT22.coviddeaths death
JOIN COVIDPROJECT22.covidvaccinations vac
ON death.location = vac.location 
AND death.date = vac.date
WHERE death.location not like ''
GROUP BY 1, 3 
ORDER BY 4 DESC 
LIMIT 5;

-- Top 5 countries with lowest vaccine rates 

SELECT death.location, MAX(vac.total_vaccinations), death.population, (MAX(vac.total_vaccinations)/death.population) * 100 AS vacc_rate
from COVIDPROJECT22.coviddeaths death
JOIN COVIDPROJECT22.covidvaccinations vac
ON death.location = vac.location 
AND death.date = vac.date
WHERE death.location not like '' AND vac.total_vaccinations not like ''
GROUP BY 1, 3 
ORDER BY 4
LIMIT 5;

-- Show new vaccination accumalation per day 

with popvsvac ( Location, population,Date, new_vaccinations, RollingPeopleVaccinated)

as

(SELECT death.location, death.population,death.date, vac.new_vaccinations, SUM(vac.new_vaccinations) 
OVER (partition by location order by location, date) AS RollingPeopleVaccinated
from COVIDPROJECT22.coviddeaths death
JOIN COVIDPROJECT22.covidvaccinations vac
ON death.location = vac.location 
AND death.date = vac.date
WHERE death.location not like '' AND vac.total_vaccinations not like ''
)
select *,(RollingPeopleVaccinated/population) * 100 from popvsvac;






















