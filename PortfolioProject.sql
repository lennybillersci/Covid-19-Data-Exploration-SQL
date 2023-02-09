SELECT *
FROM CovidDeaths
Where continent is not null
Order by 1,2

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE location like '%states%'
Order by 1,2

SELECT Location, date, total_cases, population, (total_deaths/population)*100 as DeathsPerPopulation
FROM CovidDeaths
WHERE location like 'Jamaica'
Order by 1,2

SELECT Location, MAX(total_cases) as TotalCases
from CovidDeaths
--WHERE location like 'Jamaica'
GROUP BY Location
order by TotalCases desc

SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
Where continent is not null
--WHERE location like 'Jamaica'
GROUP BY Location
order by TotalDeathCount desc

SELECT Continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
Where continent is not null
--WHERE location like 'Jamaica'
GROUP BY continent
order by TotalDeathCount desc

SELECT date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(New_deaths)/SUM(New_cases)*100 as DeathPercentage
FROM CovidDeaths
Where continent is not null
group by date
Order by 1,2

WITH PopvsVac (Continent, location, Date, population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac

CREATE TABLE #PercentPopulationVaccinated
(
Continent NVARCHAR(255),
Location NVARCHAR(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated

CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

SELECT * 
FROM PercentPopulationVaccinated