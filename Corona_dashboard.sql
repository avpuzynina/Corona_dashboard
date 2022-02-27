-- 1.
-- Global numbers
select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Death_Percentage
from PortfolioProjectSQL.dbo.Covid_Deaths
Where continent is not null
order by 1,2


-- 2.
select location, SUM(cast(new_deaths as int)) as Total_Death_Count
from PortfolioProjectSQL.dbo.Covid_Deaths
where continent is null
and location not in ('World', 'European Union', 'International', 'Upper middle income', 'High income', 'Lower middle income', 'Low income')
group by location
order by Total_Death_Count desc


-- 3.
select location, population, MAX(total_cases) as Highest_Infection_Count, MAX(total_cases/population)*100 as Percent_Population_Infected
from PortfolioProjectSQL.dbo.Covid_Deaths
group by location, population
order by Percent_Population_Infected desc


-- 4.
select location, population, date, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/population))*100 as PercentePopulationInfected
from PortfolioProjectSQL.dbo.Covid_Deaths
group by location, population, date
order by PercentePopulationInfected desc

