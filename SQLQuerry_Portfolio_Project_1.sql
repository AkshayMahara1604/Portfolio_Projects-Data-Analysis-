 
--Covid_deaths table 

select * 
from Portfolio_Project_1..covid_deaths
where continent is not null
order by total_cases desc


--Death Percentage Table

select location,max(total_cases) as total_cases,population,
max(cast(total_deaths as int)) as total_death,
(max(cast(total_deaths as int))/max(total_cases))*100 as death_percentage
from Portfolio_Project_1..covid_deaths
where continent is not null and population > 100000000
group by location , population
order by death_percentage desc

--Covid Death Data For India 
                                           
select location,date,total_cases,population,total_deaths,(total_deaths/total_cases)*100 as death_percentage 
from Portfolio_Project_1..covid_deaths
where continent is not null and  location like '%india%'
order by date desc



--Max infection count,rate and infection percentage for top countries (by population)

select location,population,(max(cast(total_cases as int)))as max_infection_count,
(max(cast(total_deaths as int))/max(total_cases))*100 as death_percentage ,
(max(cast(total_cases as int))/(population))*100 as infection_percentage 
from Portfolio_Project_1..covid_deaths
where continent is not null and population > 100000000
group by location,population
order by infection_percentage desc



--Mortality rate per 1 million

select location,population,max(cast (total_deaths as int)) as max_death_count,max((total_deaths/population)*100000) as mortality_rate_per_1000000
from Portfolio_Project_1..covid_deaths
where continent is not null
group by location,population
order by max_death_count  desc


--Breakdwon by continent (Mortality rate per 1 milllion)
select continent,max(cast (total_deaths as int)) as max_death_count,max((total_deaths/population)*100000) as mortality_rate_per_1000000
from Portfolio_Project_1..covid_deaths
where continent is not null
group by continent
order by max_death_count  desc




-- Death percentage for people infected over the time 

select date, sum((new_cases)) as total_world_cases , SUM(cast(new_deaths as int)) as total_world_deaths,
(SUM(cast(new_deaths as int))/(sum((new_cases))))*100 as percent_death
from Portfolio_Project_1..covid_deaths
where continent is not null
group by date
order by date 



--Total World Data

select  sum((new_cases)) as total_world_cases , SUM(cast(new_deaths as int)) as total_world_deaths,
(SUM(cast(new_deaths as int))/(sum((new_cases))))*100 as percent_death
from Portfolio_Project_1..covid_deaths
where continent is not null
--group by date
--order by date 

--Joining Vaccination Table and Covid Death Table 

Select dea.continent , dea.location ,dea.date, vac.new_vaccinations
from Portfolio_Project_1..Covid_Deaths dea
join Portfolio_Project_1..Covid_Vaccinations vac
on dea.date =vac.date
and dea.location = vac.location

order by 1,2,3

--Counting Total Vaccination using new vaccination coloumn using partition by function

Select  dea.location ,dea.population,dea.date, vac.new_vaccinations,sum(cast(new_vaccinations as bigint))
over(partition by dea.location order by dea.date) as total_vaccination
from Portfolio_Project_1..Covid_Deaths dea
join Portfolio_Project_1..Covid_Vaccinations vac
on dea.date =vac.date
and dea.location = vac.location
order by location

--Using CTE(Common Table Expressions)

with vaccination(location,population, date,new_vaccinations,total_vaccination)
as 
(
Select  dea.location ,dea.population,dea.date, vac.new_vaccinations,sum(cast(new_vaccinations as bigint))
over(partition by dea.location order by dea.date) as total_vaccination

from Portfolio_Project_1..Covid_Deaths dea
join Portfolio_Project_1..Covid_Vaccinations vac
on dea.date =vac.date
and dea.location = vac.location
where dea.continent is not null
)

select location,population,max(total_vaccination) as total_vaccination

from vaccination

group by location , population
order by total_vaccination desc

--Creating a table 

DROP table if exists  vaccinations
create table  vaccinations(location nvarchar(255) ,population bigint, date datetime,new_vaccinations bigint,total_vaccination bigint)
insert into  vaccinations

Select  dea.location ,dea.population,dea.date, vac.new_vaccinations,sum(cast(new_vaccinations as bigint))
over(partition by dea.location order by dea.date) as total_vaccination
from Portfolio_Project_1..Covid_Deaths dea
join Portfolio_Project_1..Covid_Vaccinations vac
on dea.date =vac.date
and dea.location = vac.location
where dea.continent is not null


select location,population, max(total_vaccination) as total_vaccinations
from vaccinations
group by location, population
order by total_vaccinations desc



--Creating view for data visulizations

Create View Percent_Population_Vaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Portfolio_Project_1..Covid_Deaths dea
Join Portfolio_Project_1..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
