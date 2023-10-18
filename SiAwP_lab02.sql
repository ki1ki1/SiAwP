ALTER TABLE LOCATIONS DROP CONSTRAINT SYS_C00128039;
DROP TABLE COUNTRIES;
ALTER TABLE DEPARTMENTS DROP CONSTRAINT SYS_C00128360;
ALTER TABLE DEPARTMENTS DROP CONSTRAINT SYS_C00128361;
ALTER TABLE JOB_HISTORY DROP CONSTRAINT SYS_C00128331;
ALTER TABLE JOB_HISTORY DROP CONSTRAINT SYS_C00128332;
ALTER TABLE JOB_HISTORY DROP CONSTRAINT SYS_C00128364;
ALTER TABLE EMPLOYEES DROP CONSTRAINT SYS_C00128349;
ALTER TABLE EMPLOYEES DROP CONSTRAINT SYS_C00128350;
ALTER TABLE EMPLOYEES DROP CONSTRAINT SYS_C00128363;
DROP TABLE DEPARTMENTS;
DROP TABLE EMPLOYEES;
DROP TABLE JOB_HISTORY;
DROP TABLE JOBS;
DROP TABLE LOCATIONS;
DROP TABLE REGIONS;

CREATE TABLE COUNTRIES AS SELECT * FROM HR.COUNTRIES;
CREATE TABLE DEPARTMENTS AS SELECT * FROM HR.DEPARTMENTS;
CREATE TABLE EMPLOYEES AS SELECT * FROM HR.EMPLOYEES;
CREATE TABLE JOB_GRADES AS SELECT * FROM HR.JOB_GRADES;
CREATE TABLE JOB_HISTORY AS SELECT * FROM HR.JOB_HISTORY;
CREATE TABLE JOBS AS SELECT * FROM HR.JOBS;
CREATE TABLE LOCATIONS AS SELECT * FROM HR.LOCATIONS;
CREATE TABLE REGIONS AS SELECT * FROM HR.REGIONS;

ALTER TABLE REGIONS
    ADD PRIMARY KEY(region_id);
ALTER TABLE COUNTRIES
    ADD PRIMARY KEY(country_id)
    ADD FOREIGN KEY (region_id) REFERENCES REGIONS(region_id);
ALTER TABLE LOCATIONS
    ADD PRIMARY KEY(location_id)
    ADD FOREIGN KEY (country_id) REFERENCES COUNTRIES(country_id);
ALTER TABLE JOBS
    ADD PRIMARY KEY(job_id);
ALTER TABLE EMPLOYEES
    ADD PRIMARY KEY(employee_id);
ALTER TABLE JOB_GRADES
    ADD PRIMARY KEY(grade);
ALTER TABLE JOB_HISTORY
    ADD FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id)
    ADD FOREIGN KEY (job_id) REFERENCES JOBS(job_id);
ALTER TABLE DEPARTMENTS
    ADD PRIMARY KEY(department_id);
ALTER TABLE JOB_HISTORY
    ADD FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id);  
ALTER TABLE EMPLOYEES
    ADD FOREIGN KEY (manager_id) REFERENCES EMPLOYEES(employee_id)
    ADD FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id);
ALTER TABLE EMPLOYEES
    ADD FOREIGN KEY (job_id) REFERENCES JOBS(job_id);  
ALTER TABLE DEPARTMENTS
    ADD FOREIGN KEY (manager_id) REFERENCES EMPLOYEES(employee_id)
    ADD FOREIGN KEY (location_id) REFERENCES LOCATIONS(location_id);
   
SELECT last_name || ', ' || TO_CHAR(salary, 'FM9999.99') AS wynagrodzenie
FROM EMPLOYEES
WHERE department_id IN (20, 50)
AND salary BETWEEN 2000 AND 7000
ORDER BY last_name;

SELECT e1.hire_date, e1.last_name, e1.salary
FROM EMPLOYEES e1
JOIN EMPLOYEES e2 ON e1.manager_id = e2.employee_id
WHERE e1.manager_id IS NOT NULL
AND EXTRACT(YEAR FROM e2.hire_date) = 2005
ORDER BY e1.salary;

SELECT CONCAT(first_name, CONCAT(' ',last_Name)) AS name, salary, phone_number
FROM EMPLOYEES
WHERE SUBSTR(last_name, 3, 1) = 'e'
AND SUBSTR(first_name, 1, 2) = 'Wi'
ORDER BY name DESC, salary ASC;

SELECT first_name, last_name, ROUND(MONTHS_BETWEEN(CURRENT_DATE, hire_date)) AS months_worked,
CASE
    WHEN ROUND(MONTHS_BETWEEN(CURRENT_DATE, hire_date)) < 150 THEN 0.1 * salary
    WHEN ROUND(MONTHS_BETWEEN(CURRENT_DATE, hire_date)) < 200 THEN 0.2 * salary
    ELSE 0.3 * salary END
    AS bonus_amount
FROM EMPLOYEES
ORDER BY months_worked;

SELECT d.department_name, SUM(e.salary) AS Suma_Zarobków, ROUND(AVG(e.salary)) AS Œrednia_Zarobków
FROM DEPARTMENTS d
JOIN EMPLOYEES e ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING MIN(e.salary) > 5000;

SELECT e.last_name, e.department_id, d.department_name, e.job_id 
FROM EMPLOYEES e
JOIN DEPARTMENTS d ON e.department_id = d.department_id
JOIN LOCATIONS l ON d.location_id = l.location_id
WHERE l.city = 'Toronto';

SELECT DISTINCT e1.first_name, e1.last_name, e2.first_name AS wspó³pracownik_imiê, e2.last_name AS wspó³pracownik_nazwisko
FROM EMPLOYEES e1
JOIN DEPARTMENTS d ON e1.department_id = d.department_id
JOIN EMPLOYEES e2 ON d.department_id = e2.department_id
WHERE e1.first_name = 'Jennifer';

SELECT d.department_name
FROM DEPARTMENTS d
LEFT JOIN EMPLOYEES e ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;

SELECT e.first_name, e.last_name, e.job_id, d.department_name, e.salary, jg.grade
FROM EMPLOYEES e
JOIN DEPARTMENTS d ON e.department_id = d.department_id
LEFT JOIN JOB_GRADES jg ON e.salary BETWEEN jg.min_salary AND jg.max_salary;

SELECT first_name, last_name, salary
FROM EMPLOYEES
WHERE salary > (SELECT AVG(salary) FROM EMPLOYEES)
ORDER BY salary DESC;

SELECT e.employee_id, e.first_name, e.last_name
FROM EMPLOYEES e
WHERE e.department_id IN (SELECT d.department_id
  FROM DEPARTMENTS d
  WHERE EXISTS (
    SELECT 1
    FROM EMPLOYEES
    WHERE department_id = d.department_id
      AND last_name LIKE '%u%'
  )
);

