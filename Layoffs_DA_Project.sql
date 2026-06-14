create database layoff_companies;
use layoff_companies;
select * from layoffs;

-- Check Duplicates :
select * from (select *, row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions)
	as Rownumbers from layoffs)t where Rownumbers>1;
create table layoffs_new as select * from (select *, row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions)
	as Rownumbers from layoffs)t where Rownumbers=1;
select * from layoffs_new;

-- Standardizing Columns :
update layoffs_new set company = trim(company);
select distinct(company) from layoffs_new order by 1;
update layoffs_new set company = 'Crypto' where company like 'Crypto%';
select distinct(location) from layoffs_new order by 1;
update layoffs_new set location = 'Dusseldorf' where location like 'DÃ¼sseldorf';
update layoffs_new set location = 'Florianópolis' where location like 'FlorianÃ³polis';
select distinct(country) from layoffs_new where country like 'United%';
update layoffs_new set country = trim('.' from country) where country like 'United%';
UPDATE layoffs_new SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
alter table layoffs_new modify column `date` Date;
select distinct(industry) from layoffs_new where industry like 'Crypto%';
update layoffs_new set industry = 'Cryptocurr' where industry like 'Crypto%';

-- Removing Nulls and Blanks :
select * from layoffs_new;
update layoffs_new set industry = NULL where trim(industry) like '';
select * from layoffs_new l1
	join layoffs_new l2 on l1.company = l2.company where l1.industry is Null
    and l2.industry is NOT NULL;
update layoffs_new l1 join layoffs_new l2 on l1.company=l2.company
	set l1.industry=l2.industry where l1.industry is NULL and l2.industry is not null;
select count(industry) from layoffs_new where total_laid_off is null and percentage_laid_off is null;
delete from layoffs_new where total_laid_off is null and percentage_laid_off is null;

-- Finalizing columns & rows (TABLE) :
Alter table layoffs_new drop column Rownumbers;
select * from layoffs_new;

-- EDA :
-- Looking at Percentage to see how big these layoffs were
SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM layoffs_new
WHERE  percentage_laid_off IS NOT NULL;

-- Which companies had 1 which is basically 100 percent of they company laid off
SELECT *
FROM layoffs_new
WHERE  percentage_laid_off = 1;
-- these are mostly startups it looks like who all went out of business during this time

-- if we order by funcs_raised_millions we can see how big some of these companies were
SELECT *
FROM layoffs_new
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Companies with the biggest single Layoff
SELECT company, total_laid_off
FROM layoffs_new
ORDER BY 2 DESC
LIMIT 5;

-- Companies with the most Total Layoffs
SELECT company, SUM(total_laid_off)
FROM layoffs_new
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;



-- by location
SELECT location, SUM(total_laid_off)
FROM layoffs_new
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;


SELECT country, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_new
GROUP BY YEAR(date)
ORDER BY 1 ASC;


SELECT industry, SUM(total_laid_off)
FROM layoffs_new
GROUP BY industry
ORDER BY 2 DESC;


SELECT stage, SUM(total_laid_off)
FROM layoffs_new
GROUP BY stage
ORDER BY 2 DESC;


WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_new
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;


-- Rolling Total of Layoffs Per Month
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_new
GROUP BY dates
ORDER BY dates ASC;

-- now use it in a CTE so we can query off of it
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_new
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;