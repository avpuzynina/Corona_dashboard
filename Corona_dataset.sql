
-- Ќужно использовать другой датасет и придумать запросы к ним дл€ pet-project
-- Select Data wagtb using
select *
from PortfolioProjectSQL.dbo.Covid_Deaths
where continent is not null
order by 3, 4


--select *
--from PortfolioProjectSQL.dbo.Covid_Vaccinations
--order by 3, 4

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProjectSQL.dbo.Covid_Deaths
where continent is not null
order by 1,2


--Total Cases vs Total Deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProjectSQL.dbo.Covid_Deaths
where location like '%Russia%'
and continent is not null
order by 1,2

--Total Cases vs Population
select location, date,  population, total_cases, (total_cases/population)*100 as PercentePopulationInfected
from PortfolioProjectSQL.dbo.Covid_Deaths
where continent is not null
--where location like '%Russia%'
order by 1,2

-- —траны с высоким уровнем инфецировани€ относительно населени€ c процентами
select location, population, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/population))*100 as Percente_Population_Infected
from PortfolioProjectSQL.dbo.Covid_Deaths
where continent is not null
group by location, population
order by Percente_Population_Infected desc

-- —траны с высоким уровнем смертности
select location, MAX(cast(total_deaths as int)) as Total_Death_Count
from PortfolioProjectSQL.dbo.Covid_Deaths
where continent is not null
group by location
order by Total_Death_Count desc

--  онтиненты с высоким уровнем смертности 
select continent, MAX(cast(total_deaths as int)) as Total_Death_Count
from PortfolioProjectSQL.dbo.Covid_Deaths
where continent is not null
group by continent
order by Total_Death_Count desc

-- Global numbers
select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Death_Percentage
from PortfolioProjectSQL.dbo.Covid_Deaths
--where location like '%Russia%'
Where continent is not null
--group by date
order by 1,2

-- total population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(ISNULL(convert(float, vac.new_vaccinations), 0)) OVER (Partition by dea.location order by dea.date) as Rolling_People_Vaccinated
--(Rolling_People_Vaccinated/population)*100 as Percent_
from PortfolioProjectSQL.dbo.Covid_Deaths dea
join PortfolioProjectSQL.dbo.Covid_Vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3



-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(ISNULL(convert(float, vac.new_vaccinations), 0)) OVER (Partition by dea.location order by dea.date) as Rolling_People_Vaccinated
--(Rolling_People_Vaccinated/population)*100 as Percent_
from PortfolioProjectSQL.dbo.Covid_Deaths dea
join PortfolioProjectSQL.dbo.Covid_Vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



--Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date nvarchar(255),
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(ISNULL(convert(float, vac.new_vaccinations), 0)) OVER (Partition by dea.location order by dea.date) as Rolling_People_Vaccinated
--(Rolling_People_Vaccinated/population)*100 as Percent_
from PortfolioProjectSQL.dbo.Covid_Deaths dea
join PortfolioProjectSQL.dbo.Covid_Vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(ISNULL(convert(float, vac.new_vaccinations), 0)) OVER (Partition by dea.location order by dea.date) as Rolling_People_Vaccinated
--(Rolling_People_Vaccinated/population)*100 as Percent_
from PortfolioProjectSQL.dbo.Covid_Deaths dea
join PortfolioProjectSQL.dbo.Covid_Vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3


Select *
From PercentPopulationVaccinated
