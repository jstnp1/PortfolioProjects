/*
COVID-19 Data Exploration

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

SELECT *
FROM Portfolio_Project..Covid_19_deaths
WHERE continent is not null
ORDER BY 3,4

-- Select Data that we are going to be starting with

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio_Project..Covid_19_deaths
ORDER BY 1,2


-- Total Cases versus the Total Deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM Portfolio_Project..Covid_19_deaths
WHERE location like '%states%'
ORDER BY 1,2


-- Total Cases vs Population
-- Shows what percentage of the population is infected with COVID-19

SELECT location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM Portfolio_Project..Covid_19_deaths
WHERE location like '%states%'
ORDER BY 1,2



-- Countries with Highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM Portfolio_Project..Covid_19_deaths
GROUP BY location, population
ORDER BY PercentPopulationInfected desc



-- Countries with Highest Death Count per Population

SELECT location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM Portfolio_Project..Covid_19_deaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc


-- Countries with Highest Death Count per Population

SELECT continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM Portfolio_Project..Covid_19_deaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc


-- Global Numbers

SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM Portfolio_Project..Covid_19_deaths
-- WHERE location like '%states%'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2


-- Total Cases and Deaths

SELECT sum(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM Portfolio_Project..Covid_19_deaths
-- WHERE location like '%states%'
WHERE continent is not null
ORDER BY 1,2



-- Total Population vs New Vaccinations per Day
-- Shows Percentage of Population that has received at least one COVID vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.date) as RollingVaccinatedPeople
, 
FROM Portfolio_Project..Covid_19_deaths dea
JOIN Portfolio_Project..Covid_19_vaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3



-- Using CTE to perform calculation on PARTITION BY in previous query

WITH PopvsVac (continent, location, date, population,new_vaccinations, RollingPeopleVaccinated)
as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.date) as RollingVaccinatedPeople
FROM Portfolio_Project..Covid_19_deaths dea
JOIN Portfolio_Project..Covid_19_vaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac




-- Using Temp Table to perform calculation on PARTITION BY in previous query

DROP TABLE IF exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.date) as RollingVaccinatedPeople
FROM Portfolio_Project..Covid_19_deaths dea
JOIN Portfolio_Project..Covid_19_vaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null

SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated



-- Creating view to store data for visualizations

CREATE VIEW PercentPopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.date) as RollingVaccinatedPeople
FROM Portfolio_Project..Covid_19_deaths dea
JOIN Portfolio_Project..Covid_19_vaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null


SELECT *
FROM PercentPopulationVaccinated