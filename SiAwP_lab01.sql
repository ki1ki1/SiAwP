CREATE TABLE REGIONS(
    region_id int NOT NULL,
    region_name varchar(255)
);
ALTER TABLE REGIONS
    ADD PRIMARY KEY(region_id);
  
CREATE TABLE COUNTRIES(
    country_id int NOT NULL,
    country_name varchar(255),
    region_id int NOT NULL
);

ALTER TABLE COUNTRIES
    ADD PRIMARY KEY(country_id)
    ADD FOREIGN KEY (region_id) REFERENCES REGIONS(region_id);

CREATE TABLE LOCATIONS(
    location_id int NOT NULL,
    street_address varchar(255),
    postal_code varchar(10),
    city varchar(255),
    state_province varchar(255),
    country_id int NOT NULL
);

ALTER TABLE LOCATIONS
    ADD PRIMARY KEY(location_id)
    ADD FOREIGN KEY (country_id) REFERENCES COUNTRIES(country_id);

CREATE TABLE JOBS(
    job_id int NOT NULL,
    job_title varchar(255),
    min_salary int,
    max_salary int,
    CHECK ((max_salary - min_salary) >= 2000)
);

ALTER TABLE JOBS
    ADD PRIMARY KEY(job_id);
    
CREATE TABLE EMPLOYEES(
    employee_id int NOT NULL,
    first_name varchar(255),
    last_name varchar(255),
    email varchar(255),
    phone_number number(11),
    hire_date date,
    salary float,
    commission_pct float,
    manager_id int NOT NULL,
    department_id int NOT NULL   
);

ALTER TABLE EMPLOYEES
    ADD job_id int NOT NULL;
    
CREATE TABLE JOB_HISTORY(
    employee_id int NOT NULL,
    start_date date,
    end_date date,
    job_id int NOT NULL,
    department_id int NOT NULL   
);

CREATE TABLE DEPARTMENTS (
    department_id int NOT NULL,
    department_name varchar(255),
    manager_id int NOT NULL,
    location_id int NOT NULL  
);

ALTER TABLE EMPLOYEES
    ADD PRIMARY KEY(employee_id)
      
ALTER TABLE JOB_HISTORY
    ADD FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id)
    ADD FOREIGN KEY (job_id) REFERENCES JOBS(job_id);

ALTER TABLE JOB_HISTORY
    ADD FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id);  
    
ALTER TABLE DEPARTMENTS
    ADD PRIMARY KEY(department_id);
      
ALTER TABLE EMPLOYEES
    ADD FOREIGN KEY (manager_id) REFERENCES EMPLOYEES(employee_id)
    ADD FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id);
    
ALTER TABLE EMPLOYEES
    ADD FOREIGN KEY (job_id) REFERENCES JOBS(job_id);   
    
ALTER TABLE DEPARTMENTS
    ADD FOREIGN KEY (manager_id) REFERENCES EMPLOYEES(employee_id)
    ADD FOREIGN KEY (location_id) REFERENCES LOCATIONS(location_id);
   