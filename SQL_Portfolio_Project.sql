SELECT *
FROM SQL_PROJECT1..CovidVaccinations
ORDER BY 3,4

SELECT *
FROM SQL_PROJECT1..CovidDeaths

SELECT Location, date, total_cases, new_cases,total_deaths, population
FROM SQL_PROJECT1..CovidDeaths

--TOTAL CASES VS TOTAL DEATHS
SELECT LOCATION,DATE,TOTAL_DEATHS,TOTAL_CASES,(TOTAL_DEATHS/TOTAL_CASES)*100 AS DeathPercentage
FROM SQL_PROJECT1..CovidDeaths
ORDER BY 2

SELECT LOCATION,DATE,TOTAL_DEATHS,TOTAL_CASES,(TOTAL_DEATHS/TOTAL_CASES)*100 AS DeathPercentage
FROM SQL_PROJECT1..CovidDeaths
WHERE LOCATION = 'INDIA'
ORDER BY 2

--Percentage of population getting affected by Covid 
SELECT LOCATION,DATE,TOTAL_CASES,population,(TOTAL_CASES/population)*100 AS CovidPercentage
FROM SQL_PROJECT1..CovidDeaths
ORDER BY 2

--Percentage of population getting affected by Covid in India
SELECT LOCATION,DATE,TOTAL_CASES,population,(TOTAL_CASES/population)*100 AS CovidPercentage
FROM SQL_PROJECT1..CovidDeaths
WHERE LOCATION ='INDIA'
ORDER BY 2
--Highest Number of Cases Recorded
SELECT LOCATION, MAX(TOTAL_CASES) AS HighestInfection,MAX((TOTAL_CASES/POPULATION))*100 AS HighestInfectPercent
FROM SQL_PROJECT1..CovidDeaths
GROUP BY LOCATION
ORDER BY HighestInfectPercent DESC

--Highest Death Count Continent wise
SELECT continent, MAX(CAST(total_deaths AS INT)) AS HighestDeath,MAX((TOTAL_DEATHS/POPULATION))*100 AS HighestDeathPercent
FROM SQL_PROJECT1..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY HighestDeath DESC

--Highest Death Count Country wise
SELECT location, MAX(CAST(total_deaths AS INT)) AS HighestDeath,MAX((TOTAL_DEATHS/POPULATION))*100 AS HighestDeathPercent
FROM SQL_PROJECT1..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY HighestDeath DESC

--Global Numbers
SELECT DATE, SUM(CAST(new_cases AS INT)) AS TotalCases, SUM(CAST(new_deaths AS INT)) AS TotalDeaths
FROM SQL_PROJECT1..CovidDeaths
WHERE continent IS NULL
GROUP BY DATE
ORDER BY 1

--Vaccinations
SELECT dea.DATE, dea.LOCATION, vac.NEW_VACCINATIONS, SUM(CAST(vac.NEW_VACCINATIONS AS int)) OVER (PARTITION BY dea.LOCATION ORDER BY dea.LOCATION) AS VaccinationLocation
FROM SQL_PROJECT1..CovidDeaths dea
Join SQL_PROJECT1..CovidVaccinations vac
ON dea.Location = vac.Location and dea.Date = vac.Date
WHERE dea.continent is not NULL
ORDER BY dea.DATE, dea.location



SELECT dea.DATE, dea.LOCATION, dea.POPULATION ,vac.new_vaccinations, SUM(CAST(vac.NEW_VACCINATIONS AS int)) OVER (PARTITION BY dea.LOCATION ORDER BY dea.LOCATION, dea.DATE) AS VaccinationLocation
FROM SQL_PROJECT1..CovidDeaths dea
Join SQL_PROJECT1..CovidVaccinations vac
ON dea.Location = vac.Location and dea.Date = vac.Date
WHERE dea.continent is not NULL

DROP TABLE IF EXISTS RollingVaxPopulation
CREATE TABLE RollingVaxPopulation
( DATE datetime,
LOCATION nvarchar(255),
POPULATION numeric,
NEW_VACCINATIONS numeric,
RollingVac numeric)

INSERT INTO RollingVaxPopulation
SELECT dea.DATE, dea.LOCATION, dea.POPULATION ,vac.new_vaccinations, SUM(CAST(vac.NEW_VACCINATIONS AS int)) OVER (PARTITION BY dea.LOCATION ORDER BY dea.LOCATION, dea.DATE) AS VaccinationLocation
FROM SQL_PROJECT1..CovidDeaths dea
Join SQL_PROJECT1..CovidVaccinations vac
ON dea.Location = vac.Location and dea.Date = vac.Date
WHERE dea.continent is not NULL

SELECT *, (RollingVac/POPULATION)*100 AS PopulationVaccinated
FROM RollingVaxPopulation

