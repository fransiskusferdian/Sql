-- SImple Exploratory Data Analysis (EDA) with SQL on real COVID 19 Data from  https://ourworldindata.org/covid-deaths

select * 
from covid_eda..CovidDeaths
order by 3,4

-- Select data that we are going to use
select location, date, total_cases, new_cases, population 
from covid_eda..CovidDeaths
order by 1,2 

--Calculate Total cases vs total deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from covid_eda..CovidDeaths
where location like '%indonesia%'
order by 1,2


--Total case vs population
select location, date, population, total_cases, (total_cases/population)*100 as case_percentage
from covid_eda..CovidDeaths
where location like '%indonesia%'
order by 1,2

--Country with highest case rate
select location, population, MAX(total_cases) as highest_infection_count, MAX((total_cases/population))*100 as case_percentage
from covid_eda..CovidDeaths
group by population, location
order by case_percentage desc

--Country with highest death count
select location, MAX(cast(total_deaths as int)) as total_death_count
from covid_eda..CovidDeaths
where continent is not NULL
group by location
order by total_death_count desc

--Breaking down by continent
select continent, MAX(cast(total_deaths as int)) as total_death_count
from covid_eda..CovidDeaths
where continent is not NULL
group by continent
order by total_death_count desc

--Global Number
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_Cases)*100 as death_percentage
From covid_eda..CovidDeaths
where continent is not null 
order by 1,2
 

 --Total population vs vaccination
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as rolling_count_vaccinated
--, (RollingPeopleVaccinated/population)*100
From covid_eda..CovidDeaths dea
Join covid_eda..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


