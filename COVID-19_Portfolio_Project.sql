SELECT *
FROM Portfolio_Project..Covid_19_deaths
WHERE continent is not null
ORDER BY 3,4

--SELECT *
--FROM Portfolio_Project..Covid_19_vaccinations
--ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio_Project..Covid_19_deaths
ORDER BY 1,2


-- Total Cases versus the Total Deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM Portfolio_Project..Covid_19_deaths
WHERE location like '%states%'
ORDER BY 1,2


-- Total Cases vs Population

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


-- Countries with Highest Death Count per Population by Continent

SELECT continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM Portfolio_Project..Covid_19_deaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc


-- Global Numbers

SELECT date, sum(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM Portfolio_Project..Covid_19_deaths
-- WHERE location like '%states%'
WHERE continent is not null
GROUP BY date
ORDER BY 1,2


-- Total Cases and Deaths

SELECT sum(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM Portfolio_Project..Covid_19_deaths
-- WHERE location like '%states%'
WHERE continent is not null
ORDER BY 1,2



-- Total Population vs New Vaccinations per Day

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.date) as RollingVaccinatedPeople
, 
FROM Portfolio_Project..Covid_19_deaths dea
JOIN Portfolio_Project..Covid_19_vaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3



-- USING CTE

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




-- TEMP TABLE

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