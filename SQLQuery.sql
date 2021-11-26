-- DATA EXPLORATION

SELECT * FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY  location, date

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date 


--Looking at Total deaths Vs Total cases 

SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100,2) AS Death_Percentage
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date 

-- Shows likelihood of dying if you catch covid in India

SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100,2) AS Death_Percentage
FROM [Portfolio Project]..CovidDeaths
WHERE location LIKE '%India%' AND continent IS NOT NULL
ORDER BY location, date

--Looking at Total cases Vs Total Population
-- Shows what percent of Populaiton is Covid Positive

SELECT location, date, total_cases, population, (total_cases/population)*100 AS Cases_Percentage
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

SELECT location, MAX(cast(new_deaths as int)) AS TotalDeath_Count, population
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY TotalDeath_Count DESC

-- Breaking it down by continent with highest death count 

SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeath_Count
FROM [Portfolio Project]..CovidDeaths
where continent is not null
GROUP BY continent
ORDER BY TotalDeath_Count DESC


-- GLOBAL NUMBERS 
-- breaking down by the date across the world 
SELECT DATE, SUM(cast(new_cases as int)) AS total_cases , SUM(cast(new_deaths as int)) AS Total_deaths, 
SUM(cast(new_deaths as int))*1.00/SUM(cast(new_cases as int)) *100 AS death_perc
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

-- Overall count
SELECT SUM(cast(new_cases as int)) AS total_cases , SUM(cast(new_deaths as int)) AS Total_deaths, 
SUM(cast(new_deaths as int))*1.00/SUM(cast(new_cases as int)) *100 AS death_perc
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2

--looking at the vaccination data

SELECT * FROM [Portfolio Project]..covidVaccines
ORDER BY  location, date
 
--TOTAL POPULATION VS VACCINATIONS

SELECT death.continent, death.location, death.date, population, vac.total_vaccinations FROM 
[Portfolio Project]..covidDeaths death JOIN
[Portfolio Project]..covidVaccines vac
ON death.location = vac.location
AND death.date = vac.date
where death.continent is not null 
ORDER BY 1,2

-- running total/rolling count of vaccinations
-- USING CTE TO PERFORM OPERATON ON PARTITION BY QUERY 




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


--Creating View tables for Vizualizations 


CREATE VIEW PopVsVacc AS 
SELECT death.continent, death.location, death.date, population, vac.total_vaccinations, 
SUM(CAST( vac.total_vaccinations AS bigint)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS Vaccinations_RollingCount 
FROM 
[Portfolio Project]..covidDeaths death JOIN
[Portfolio Project]..covidVaccines vac
ON death.location = vac.location
AND death.date = vac.date
where death.continent is not null


SELECT * FROM PopVsVacc



