-- Create Warehouse
CREATE WAREHOUSE my_wh
WAREHOUSE_SIZE = 'SMALL'
AUTO_SUSPEND = 60
AUTO_RESUME = TRUE;

USE WAREHOUSE my_wh;

-- Create Database
CREATE DATABASE IF NOT EXISTS hospital_db;

USE DATABASE hospital_db;

-- Create Schema
CREATE SCHEMA IF NOT EXISTS hospital_schema;

USE SCHEMA hospital_schema;


-- Data Exploration

--count number of rows in patient
select count(patient_id) as total_records from patient;

-- data sample
select * from patient limit 10;

-- Checking Null Values
Select COUNT_IF(patient_admission_date IS NULL)
from patient;

SELECT
    COUNT(*) AS Total_rows,
    COUNT_IF(patient_admission_date IS NULL) AS date_nulls,
    COUNT_IF(patient_admission_time IS NULL) AS time_nulls,
    COUNT_IF(patient_age IS NULL) AS age_nulls,
    COUNT_IF(patient_gender IS NULL) AS gender_nulls,
    COUNT_IF(patient_race IS NULL) AS race_nulls,
    COUNT_IF(department_referral IS NULL) AS department_nulls,
    COUNT_IF(patient_admission_flag IS NULL) AS admission_flag_nulls,
    COUNT_IF(patient_waittime IS NULL) AS waittime_nulls,
    COUNT_IF(patient_satisfaction_score IS NULL) AS satisfaction_nulls,
    COUNT_IF(visit_type IS NULL) AS visit_nulls,
    COUNT_IF(doctor_id IS NULL) AS doctor_nulls
FROM patient_cleaned;

---- Date Range---
Select MiN(patient_admission_date) as min_date, Max(patient_admission_date) as max_date
from patient;

-- Checking distribution of patients per dept
Select department_referral,
count(*) as patient_count
from patient
group by department_referral
order by patient_count desc;

-- patient gender distribution

Select patient_gender,
count(*) as patient_count
from patient_cleaned
group by patient_gender
order by patient_count desc;

-- doctors data exploration
select * from doctor;

-- doctors per department
select department, count(*) as doctor_count
from doctor
group by department
order by doctor_count desc;

-- Data Cleaning

-- 1. Convert admission date into DATE type
--2. Change Null values in Department column to "Unknown"
--3. Change ambiguous values in Gender column to "Unknown"

CREATE OR REPLACE TABLE
patient_cleaned AS
SELECT * REPLACE(

    -- Fixing date column
    TO_DATE(patient_admission_date, 'DD-MM-YYYY') AS patient_admission_date,

    -- Fix department nulls
    COALESCE(department_referral, 'Unknown') AS department_referral,

    -- Fix gender column
    IFF(LOWER(patient_gender) = 'femaleemale', 'Unknown', patient_gender) as patient_gender
)
FROM patient;


---- Business Transactions -------------------

--Q1 How has patient volume changed over time? Calculate  monthly patient encounter counts to identify trends and growth patterns.

SELECT
EXTRACT(MONTH FROM patient_admission_date) AS month,
EXTRACT(YEAR FROM patient_admission_date) AS year,
COUNT(*) AS patient_count
FROM patient_cleaned
GROUP BY year,month
ORDER BY year, month;

SELECT 
EXTRACT(YEAR from patient_admission_date) as year,
count(*) as patient_count
from patient_cleaned
group by year
order by year desc;

--Q2 How does patient volume vary by visit type (Emergency vs Walk-in vs Scheduled)?
SELECT
visit_type,
COUNT(*) AS patient_count
FROM patient_cleaned
GROUP BY visit_type
ORDER BY patient_count DESC;

--Q3. What is the average wait time across the hospital, and how does it vary by department?
SELECT
ROUND(AVG(patient_waittime),2) AS avg_wait_time
FROM patient_cleaned;

SELECT
department_referral,
ROUND(AVG(patient_waittime),2) AS avg_wait_time
FROM patient_cleaned
group by department_referral
order by avg_wait_time desc;


-- Q4. What % of patients wait more than 30 mins?
SELECT
COUNT_IF(patient_waittime > 30) * 100.0/ COUNT(*) as percent_patients
FROM patient_cleaned;

--% of patients = number of patients who wait more than 30 mins/ total patients

--Q5. What are the peak hours for patient arrivals?
SELECT
EXTRACT(HOUR from patient_admission_time) as hour_of_day,
COUNT(*) as patient_count
FROM patient_cleaned
GROUP BY hour_of_day
ORDER BY hour_of_day;

--Q6. Which department & hour of the day combinations experience the highest wait times?
SELECT
department_referral,
EXTRACT(HOUR from patient_admission_time) as hour_of_day,
ROUND(AVG(patient_waittime),2) AS avg_wait_time
FROM patient_cleaned
group by department_referral, hour_of_day
order by avg_wait_time desc;

--Q7. How does patient satisfaction vary by department?
SELECT
department_referral,
ROUND(AVG(patient_satisfaction_score),2) AS avg_satisfaction
FROM patient_cleaned
WHERE patient_satisfaction_score IS NOT NULL
GROUP BY department_referral
ORDER BY avg_satisfaction DESC;

--Q8. How do admission rates differ across departments?
SELECT 
department_referral,
ROUND(100.0 * COUNT_IF(patient_admission_flag = 'Admission')/COUNT(*),2) as admission_rate
from patient_cleaned
group by department_referral
order by admission_rate desc;

--Q9. Is there a relationship between wait time duration and likelihood of patient admission?
SELECT
CASE WHEN patient_waittime >=30 THEN 'Long Wait'
    WHEN patient_waittime >= 15 THEN 'Medium Wait'
    ELSE 'Short Wait' END AS wait_time_category,
COUNT_IF(patient_admission_flag = 'Admission') AS admissions
FROM patient_cleaned
GROUP BY wait_time_category
ORDER BY admissions DESC;

--Q10. How do different doctor shifts compare in terms of patient load and wait time?
SELECT
d.shift_type,
COUNT(p.patient_id) as total_patients,
ROUND(AVG(p.patient_waittime),2) as avg_wait_time
FROM patient_cleaned p
JOIN doctor d ON p.doctor_id = d.doctor_id
GROUP BY d.shift_type
ORDER BY avg_wait_time DESC;
