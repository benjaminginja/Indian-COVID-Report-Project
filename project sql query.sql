--Portfolio project queries
--Lets create a table for covid19 deaths and import the csv file

CREATE table CovidDeaths (leo_code VARCHAR, continent VARCHAR, location VARCHAR,
						 date VARCHAR, population VARCHAR, total_cases BIGINT, 
						 new_cases INTEGER, total_deaths INTEGER, new_deaths INTEGER,
						 total_deaths_per_million DOUBLE PRECISION, new_deaths_per_million DOUBLE PRECISION,
						 reproduction_rate DOUBLE PRECISION, icu_patients INTEGER, hosp_patients INTEGER,
						 weekly_icu_admissions INTEGER, weekly_hosp_admissions INTEGER)
SELECT * FROM CovidDeaths						 

__create a table for covid9 vaccination and import the csv file

CREATE table CovidVaccinations (iso_code VARCHAR, continent VARCHAR, location VARCHAR,
								date VARCHAR, total_tests BIGINT, new_tests BIGINT, positive_rate DOUBLE PRECISION,
								tests_per_case DOUBLE PRECISION, tests_units VARCHAR, total_vaccinations BIGINT, 
								people_vaccinated BIGINT, people_fully_vaccinated BIGINT, total_boosters BIGINT,
								new_vaccinations BIGINT, stringency_index DOUBLE PRECISION, population_density DOUBLE PRECISION,
								median_age DOUBLE PRECISION, aged_65_older DOUBLE PRECISION, aged_70_older DOUBLE PRECISION,
								gdp_per_capita DOUBLE PRECISION, extreme_poverty DOUBLE PRECISION, cardiovasc_death_rate DOUBLE PRECISION,
								diabetes_prevalence DOUBLE PRECISION, handwashing_facilities DOUBLE PRECISION, life_expentancy DOUBLE PRECISION,
								human_development_index DOUBLE PRECISION, excess_mortality_cumulative DOUBLE PRECISION, excess_mortality DOUBLE PRECISION)
SELECT * FROM CovidVaccinations		

--a.Datewise Likelihood of dying due to covid-Totalcases vs TotalDeath- in India

SELECT date,total_cases,total_deaths 
FROM "coviddeaths" WHERE location like '%India%';

--b.Total % of deaths out of entire population- in India

SELECT (cast(max(total_deaths) AS double precision)/AVG(cast(population as double precision))*100) as percentage
from coviddeaths where location like '%India%';

--NOTE Avoid code below cos it wont convert data type 
ALTER TABLE coviddeaths
ALTER COLUMN population TYPE INTEGER;

----c.Verify b by getting info separately

SELECT max(total_deaths) as total_deaths,avg(cast(population as double precision)) 
AS population FROM "coviddeaths" WHERE location like '%India%';
SELECT * FROM public."coviddeaths" WHERE location like '%India%';
--check
--531564/1417173120 * 100

SELECT * FROM "coviddeaths" WHERE location like '%India%';

--d.Country with highest death as a % of population
SELECT location,(cast(max(total_deaths) as double precision)/avg(cast(population as double precision))*100)
as percentage
FROM "coviddeaths" group by location ORDER BY percentage desc ;

--e.Total % of covid +ve cases- in India
SELECT (cast(max(total_cases) AS double precision)/avg(cast(population as double precision))*100) AS percentage
FROM "coviddeaths" WHERE location LIKE '%India%';

----f.Total % of covid +ve cases- in world
SELECT location,(cast(max(total_cases) as double precision)/avg(cast(population as double precision))*100) 
as percentage FROM "coviddeaths" GROUP by location order by percentage Desc ;

--g.Continentwise +ve cases
SELECT location,max(total_cases) as total_cases FROM coviddeaths 
WHERE continent is null 
GROUP BY location order by total_cases desc;

--h.Continentwise deaths
SELECT location,max(total_deaths) as total_deaths FROM coviddeaths
WHERE continent is null group by location order by total_deaths desc LIMIT 6;

--i.Daily newcases vs hospitalizations vs icu_patients- India
SELECT date,new_cases,hosp_patients,icu_patients,location 
FROM coviddeaths WHERE location LIKE '%India%';

--j. Daily newcases in india
SELECT date,new_cases,location 
FROM coviddeaths WHERE location LIKE '%India%';

--k.countrywise age>65
SELECT coviddeaths.location, covidvaccinations.aged_65_older 
FROM "coviddeaths" JOIN "covidvaccinations" ON "coviddeaths".leo_code = covidvaccinations.iso_code 
AND "coviddeaths".date="covidvaccinations".date;

--k. Find the number of deaths recorded with daily as vaccination was taken.
SELECT excess_mortality AS deaths, total_tests,total_vaccinations, date
FROM covidvaccinations ORDER BY date;

--m. Number of vaccinated people in india
SELECT count(people_fully_vaccinated) AS fully_vaccinated_people
FROM covidvaccinations WHERE location = 'India';

--N. Find the total number of deaths recorded in india 
SELECT count(total_deaths_per_million) AS deaths_recorded_in_india
FROM coviddeaths WHERE continent = 'Asia' AND location LIKE '%India%';


