--Looking at Total deaths Vs Total cases 

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as Death_percentage
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

--
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date

-- Countries with the Highest Infedction Rate compared to Populaiton

SELECT location, MAX(total_cases) AS HighestInfection_Count, population, MAX((total_cases/population)*100) AS InfectedPopualiton_Percentage
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY InfectedPopualiton_Percentage DESC

--Countries with Highest Death Count 

SELECT location, sum(cast(new_deaths as int)) AS TotalDeath_Count
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NULL
and location not in ('World', 'European Union', 'International','High income','Lower middle income','Upper middle income','Low income')
GROUP BY location
ORDER BY TotalDeath_Count DESC


-- Breaking it down by continent with highest death count 

SELECT continent, MAX(cast(new_deaths as int)) AS TotalDeath_Count
FROM [Portfolio Project]..CovidDeaths
where continent is NOT  null
--and location not in ('World', 'European Union', 'International','High income','Lower middle income','Upper middle income','Low income')
GROUP BY continent
ORDER BY TotalDeath_Count DESC


--SELECT location, population, MAX(total_cases) AS HighestInfection_Count, MAX((total_cases/population)*100) AS InfectedPopualiton_Percentage
--FROM [Portfolio Project]..CovidDeaths
--WHERE continent IS NOT NULL
--GROUP BY location, population
--ORDER BY InfectedPopualiton_Percentage DESC


SELECT location,population, date, MAX(total_cases) AS HighestInfection_Count,  MAX((total_cases/population)*100) AS InfectedPopualiton_Percentage
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population, date
ORDER BY InfectedPopualiton_Percentage DESC




WITH PopVsVacc (continent, location, date, population, total_vaccinations, Vaccinations_RollingCount)
AS
(SELECT death.continent, death.location, death.date, population, vac.total_vaccinations, 
SUM(CAST( vac.total_vaccinations AS bigint)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS Vaccinations_RollingCount FROM 
[Portfolio Project]..covidDeaths death JOIN
[Portfolio Project]..covidVaccines vac
ON death.location = vac.location
AND death.date = vac.date
where death.continent is not null 
--ORDER BY 2, 3 
)

SELECT * , (Vaccinations_RollingCount/population) AS PeopleVaccinated 
FROM PopVsVacc