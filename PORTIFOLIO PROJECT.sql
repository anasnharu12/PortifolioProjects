
--select *
--from PortifolioProject..CovidVaccination
--order by 3 , 4
--select the  data that we are going to be using 

select location, date, total_cases , new_cases , total_deaths , population 
from PortifolioProject..CovidDeaths
order by 1,2

--Looking for TotalCases vs Total Deaths
--shows Death percentage in Morocco 
select location, date, total_cases  , total_deaths , (total_deaths / total_cases )*100  AS DeathPercentage
from PortifolioProject..CovidDeaths 
WHERE location Like '%rocco%' AND total_cases  IS NOT NULL AND total_deaths IS NOT NULL
order by 1,2

--looking at Total cases VS population
--Shows the percentage of people in each country  poupulation got covid 

select location, date, total_cases  , population , (total_cases / population )*100  AS infectedPeoplePercentage
from PortifolioProject..CovidDeaths 
WHERE  total_cases  IS NOT NULL AND population IS NOT NULL

order by 1,2

--looking at country with the hightest infection rate Per Population 

select location,  max(total_cases) AS Hightest_totalCases  , population , MAX((total_cases / population ))*100 AS hightest_infection_percentage
from PortifolioProject..CovidDeaths 
WHERE  total_cases  IS NOT NULL AND population IS NOT NULL
group by location , population  
order by hightest_infection_percentage desc

--showing counties with the hightest Death Count per Population 
select location,  max(cast((total_deaths)as int )) AS Hightest_totalDeaths   
from PortifolioProject..CovidDeaths 
group by location 
order by Hightest_totalDeaths  desc

--Now Lets Be Showing This Per Continent 
select continent,  max(cast((total_deaths)as int )) AS Hightest_totalDeaths  , max ((total_deaths / population ))*100 AS hightest_deaths_percentage
from PortifolioProject..CovidDeaths
where continent is not null 
group by continent 
order by Hightest_totalDeaths  desc

--GLOBAL NUMBERS 
select date, sum(new_cases) as total_cases , sum(cast(new_deaths as int )) as  total_deaths , sum(cast(new_deaths as int ))/sum(new_cases)*100 AS deaths_percentage
from PortifolioProject..CovidDeaths
where continent is not null 
group by date 
order by 1 , 2





ALTER TABLE PortifolioProject..CovidVaccination
ALTER COLUMN new_vaccinations INT






--Looking at  Total Population  vs vaccinations

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations ) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortifolioProject..CovidDeaths dea
Join PortifolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3



--USE CTE  CASE 

WITH PopvsVac( continent , location  , date , population , new_vaccination , RollingPeopleVaccinated)
AS
(
Select   dea.continent, dea.location,  dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortifolioProject..CovidDeaths dea
Join PortifolioProject..CovidVaccination   vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
select * , (RollingPeopleVaccinated/population)*100	
from PopvsVac


--TEMP TABLE 
DROP table if exists  #PercentPopulationVaccinated 
CREATE TABLE #PercentPopulationVaccinated 
( continent nvarchar(255) , location nvarchar(255) , date datetime ,population numeric , new_vaccination numeric ,RollingPeopleVaccinated numeric )

INSERT INTO #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortifolioProject..CovidDeaths dea
Join PortifolioProject..CovidVaccination   vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
select * , (RollingPeopleVaccinated/population)*100	
from #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated2  AS
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortifolioProject..CovidDeaths dea
Join PortifolioProject..CovidVaccination   vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--ORDER BY 2 ,3

select * 
from PercentPopulationVaccinated2