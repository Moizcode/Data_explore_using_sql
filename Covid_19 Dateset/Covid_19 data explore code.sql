Select *
From practice..CovidDeaths
order by 3,4

Select *
From practice..CovidVaccinations
order by 3,4

-- we update total_cases_per_million to total_cases ,after applying this we have to Rename it to total_cases and change its data type to int
Update practice..CovidDeaths set total_cases_per_million = ((total_cases_per_million*population) / 1000000) 


-- select data that we are going to use
Select Location,date,total_cases,total_deaths,population
From practice..CovidDeaths
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying by covid in different country
Select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
From practice..CovidDeaths
where location = 'India'
order by 1,2

-- Looking at Total Cases vs Population
-- Looking what percentage of population got covid
Select Location,date,new_cases,population,(new_cases/population)*100 as Infectionpercentage
From practice..CovidDeaths
where location = 'India'
order by 1,2

-- Looking at Countries with highest infection rate compared to Country
Select Location,max(total_cases) as Total_case,population,max((total_cases/population))*100 as Infectionpercentage
From practice..CovidDeaths
Group by Location,population
order by 4 Desc

-- Looking Highest Death Count in Country
Select Location,max(cast(Total_deaths as int)) as TotalDeathCount -- we cast Totat_deaths in int bcoz its data type is Varchar
From practice..CovidDeaths
where continent is not null  -- we do this because when location is continent(like asia) then in continent column is null and for now we not want continent as location
Group by Location
order by 2 Desc

-- let's explore with continent
Select continent,max(cast(Total_deaths as int)) as TotalDeathCount
From practice..CovidDeaths
where continent is not null  
Group by continent
order by 2 Desc
-- same code below but use Location column for getting accurate result
Select location,max(cast(Total_deaths as int)) as TotalDeathCount
From practice..CovidDeaths
where continent is null  -- when continent is null means we use location which is not inside any location like asia(location)
Group by location
order by 2 Desc

-- Global number
Select date,sum(new_cases) as Total_new_cases,sum(cast(new_deaths as int)) as Total_Deaths , (sum(Cast(new_deaths as int))/sum(new_cases))*100 as Deathspercentage
From practice..CovidDeaths 
where continent is not null
Group by date
order by 1


-- CovidVaccinations
Select * 
From practice..CovidVaccinations


-- Join two table
 -- we put 0 where null value is present so that we can cast and do sum
update practice..CovidVaccinations Set new_vaccinations = 0 where new_vaccinations is null
update practice..CovidDeaths Set new_deaths = 0 where new_deaths is null

-- looking at Total population, cases, deaths and vaccinations
Select vac.location,max(population),sum(new_cases),sum(new_deaths),sum(Cast(new_vaccinations as int))
From practice..CovidDeaths dea
Join practice..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
Group by vac.location

 Select dea.location,vac.date,population,new_vaccinations, 
  sum(new_vaccinations) over (partition by dea.location order by dea.location,vac.date) as RollingpeopleVaccinated
From practice..CovidDeaths dea
Join practice..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 order by 1,2

 -- creating view to store data for later visualization
 create view percentpopulationVaccinated as
  Select dea.location,vac.date,population,new_vaccinations, 
   sum(new_vaccinations) over (partition by dea.location order by dea.location,vac.date) as RollingpeopleVaccinated
  From practice..CovidDeaths dea
  Join practice..CovidVaccinations vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null

