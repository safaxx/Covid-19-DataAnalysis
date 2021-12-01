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



--TAKING A LOOK AT VACCINATIONS DATA ACROSS THE GLOBE  


SELECT death.continent, death.location, death.date, population, vac.total_vaccinations, vac.people_fully_vaccinated, vac.new_tests, 
vac.total_tests, vac.positive_rate, vac.stringency_index
From
[Portfolio Project]..covidDeaths death JOIN
[Portfolio Project]..covidVaccines vac
ON death.location = vac.location
AND death.date = vac.date
where death.continent is not null 
--ORDER BY 2, 3 

SELECT death.continent, death.location, stringency_index 
from
[Portfolio Project]..covidDeaths death JOIN
[Portfolio Project]..covidVaccines vac
ON death.location = vac.location
AND death.date = vac.date
where death.continent is not null
order by stringency_index desc


-- Total people_fully_vaccinated in location = continents
SELECT location, sum(cast(people_fully_vaccinated as bigint)) AS people_fully_vaccinated
FROM [Portfolio Project]..covidVaccines
WHERE continent IS NULL
and location not in ('World', 'European Union', 'International','High income','Lower middle income','Upper middle income','Low income')
GROUP BY location
ORDER BY people_fully_vaccinated DESC

--Total people_fully_vaccinated in location = country 
SELECT location, sum(cast(people_fully_vaccinated as bigint)) AS people_fully_vaccinated
FROM [Portfolio Project]..covidVaccines
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY people_fully_vaccinated DESC

--Total Tests 
SELECT sum(cast(total_tests as bigint)) as Total_tests, sum(cast(total_vaccinations as bigint)) as Total_Vaccinations
FROM
[Portfolio Project]..covidVaccines
WHERE continent IS NOT NULL

--positive rate by location

SELECT location, positive_rate
from
[Portfolio Project]..covidVaccines
WHERE continent IS NOT NULL


--LOOKING at stringency index at different locations 
SELECT distinct(location),continent, stringency_index FROM [Portfolio Project]..covidVaccines order by stringency_index desc

-- IMPACT ON HEALTHCARE WROKERS 

-- total count  
SELECT SUM([Medical Doctors died]) as MedicalDoctors_DeathCount, 
SUM([Medical Doctors infected]) as MedicalDoctors_Infected, sum([Medical Nurses died]) as MedicalNurses_DeathCount,
sum([Medical Nurses infected]) as MedicalNurses_Infected ,
sum([Other Medical Staff died]) as OtherMedicalStaff_DeathCount,sum([Other Medical Staff infected]) AS OtherMedicalStaff_Infected
FROM [Portfolio Project].[dbo].[HCW]

--breaking down by countries 

SELECT Country,[HCWs (total) died],[HCWs (total) infected]
FROM [Portfolio Project].[dbo].[HCW]
ORDER BY [HCWs (total) died] DESC,[HCWs (total) infected] DESC

-- hcw mortality rate by country
SELECT country, [HCW Mortality per 100,000 ] 
FROM [Portfolio Project].[dbo].[HCW]
ORDER BY [HCW Mortality per 100,000 ] DESC


