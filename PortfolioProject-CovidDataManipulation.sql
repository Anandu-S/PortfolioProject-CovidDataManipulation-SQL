select * 
from portfolioproject..CovidDeaths
order by 3,4

select * 
from portfolioproject..CovidVaccinations
order by 3,4


--selecting data that we're gonna use

select location, date, total_cases, new_cases, total_deaths, population
from portfolioproject..CovidDeaths
where location != continent
order by 1,2

--looking at Total Cases v/s Total Deaths

select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from portfolioproject..CovidDeaths
where location != continent
order by 1,2

--looking at Total Cases v/s Total Deaths of a particular nation(INDIA)

select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from portfolioproject..CovidDeaths
where location='india'
order by 1,2

--looking at Total Cases v/s Total Deaths of nations having particular string(say, 'ind') in their name
--the output should have India and Indonesia

select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from portfolioproject..CovidDeaths
where location like '%ind%'
order by 1,2

--looking at Total Cases v/s Population

select location, date, total_cases, new_cases, population, (total_cases/population)*100 as InfectedPopulationPercentage
from portfolioproject..CovidDeaths
where location != continent
order by 1,2

--looking at Total Cases v/s Population of particular nation(India)

select location, date, total_cases, new_cases, population, (total_cases/population)*100 as InfectedPopulationPercentage
from portfolioproject..CovidDeaths
where location != continent and location='india'
order by 1,2

--looking at countries with highest Infection rate compared to Population

select location, population, MAX(total_cases) as HighestInfectedCount, MAX((total_cases/population))*100 as InfectedPopulationPercent
from portfolioproject..CovidDeaths
where location != continent
group by location, population
order by InfectedPopulationPercent desc

--looking at countries with highest Death Count compared to Population

select location, population, MAX(total_deaths) as TotalDeathCount, MAX((total_deaths/population))*100 as DeathPopulationPercent
from portfolioproject..CovidDeaths
where location != continent
group by population,location
order by TotalDeathCount desc

--looking into continental wise data

select continent, MAX(cast(total_deaths as int))as TotalDeathCount
from portfolioproject..CovidDeaths
where location!= continent
group by continent
order by TotalDeathCount desc


--looking at GLOBAL Death Percentage 

select SUM(cast(new_cases as int)) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercent
from portfolioproject..CovidDeaths
where location!= continent
order by 1,2

--looking at Death Percentage on each day globally

select date, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercent
from portfolioproject..CovidDeaths
where location!= continent
group by date
order by 1,2


--Joining Two Tables 

select *  
from portfolioproject..CovidDeaths dea join portfolioproject..CovidVaccinations vac 
on dea.location = vac.location and dea.date = vac.date


--looking at Total Population v/s Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from portfolioproject..CovidDeaths dea join portfolioproject..CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.location != dea.continent
order by 2,3

--looking at Total Population v/s Vaccinations and cummulative rate of vaccine given according to each day

select dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location,dea.date) as cummulativeVaccinations
from portfolioproject..CovidDeaths dea join portfolioproject..CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3
