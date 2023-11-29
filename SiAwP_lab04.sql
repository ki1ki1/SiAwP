-- Paczka operacji na pracownikach
CREATE OR REPLACE PACKAGE employee_operations IS
  FUNCTION retrieve_job_title(p_job_id IN jobs.job_id%TYPE) RETURN jobs.job_title%TYPE;
  FUNCTION calculate_annual_salary(p_employee_id IN employees.employee_id%TYPE) RETURN NUMBER;
  FUNCTION get_area_code(p_phone IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION format_name(p_string IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION pesel_to_birthdate(p_pesel IN CHAR) RETURN DATE;
  FUNCTION count_employees_departments(p_country_name IN VARCHAR2) RETURN VARCHAR2;
END employee_operations;
/

CREATE OR REPLACE PACKAGE BODY employee_operations IS
  -- Funkcja 1:
  FUNCTION retrieve_job_title(p_job_id IN jobs.job_id%TYPE) RETURN jobs.job_title%TYPE IS
    v_job_title jobs.job_title%TYPE;
  BEGIN
    SELECT job_title INTO v_job_title FROM jobs WHERE job_id = p_job_id;
    RETURN v_job_title;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'Praca o podanym identyfikatorze nie istnieje');
  END retrieve_job_title;

  -- Funkcja 2:
  FUNCTION calculate_annual_salary(p_employee_id IN employees.employee_id%TYPE) RETURN NUMBER IS
    v_annual_salary NUMBER;
    v_commission_pct employees.commission_pct%TYPE;
  BEGIN
    SELECT salary, NVL(commission_pct, 0) INTO v_annual_salary, v_commission_pct 
    FROM employees WHERE employee_id = p_employee_id;
    v_annual_salary := v_annual_salary * (12 + v_commission_pct);
    RETURN v_annual_salary;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20002, 'Pracownik o podanym identyfikatorze nie istnieje');
  END calculate_annual_salary;

  -- Funkcja 3:
  FUNCTION get_area_code(p_phone IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN SUBSTR(p_phone, 1, INSTR(p_phone, ')') - 1);
  END get_area_code;

  -- Funkcja 4:
  FUNCTION format_name(p_string IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN INITCAP(p_string);
  END format_name;

  -- Funkcja 5:
  FUNCTION pesel_to_birthdate(p_pesel IN CHAR) RETURN DATE IS
    v_birth_date DATE;
  BEGIN
    v_birth_date := TO_DATE(SUBSTR(p_pesel, 1, 6), 'YYMMDD');
    RETURN v_birth_date;
  END pesel_to_birthdate;

  -- Funkcja 6:
  FUNCTION count_employees_departments(p_country_name IN VARCHAR2) RETURN VARCHAR2 IS
    v_employee_count NUMBER;
    v_department_count NUMBER;
  BEGIN
    SELECT COUNT(*)
    INTO v_employee_count
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
    WHERE c.country_name = p_country_name;

    SELECT COUNT(*)
    INTO v_department_count
    FROM departments d
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
    WHERE c.country_name = p_country_name;

    RETURN 'Pracownicy: ' || TO_CHAR(v_employee_count) || ' Dzia³y: ' || TO_CHAR(v_department_count);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20005, 'Kraj o podanej nazwie nie istnieje');
  END count_employees_departments;

END employee_operations;
/
-- Wyzwalacz 1:
CREATE OR REPLACE TRIGGER archive_department
AFTER DELETE ON departments
FOR EACH ROW
DECLARE
  v_manager_name VARCHAR2(100);
BEGIN
  SELECT first_name || ' ' || last_name INTO v_manager_name
  FROM employees
  WHERE employee_id = :OLD.manager_id;

  INSERT INTO archiwum_departamentow (id, nazwa, data_zamkniecia, ostatni_manager)
  VALUES (:OLD.department_id, :OLD.department_name, SYSDATE, v_manager_name);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    INSERT INTO archiwum_departamentow (id, nazwa, data_zamkniecia, ostatni_manager)
    VALUES (:OLD.department_id, :OLD.department_name, SYSDATE, NULL);
END;
/
-- Wyzwalacz 2:
CREATE OR REPLACE TRIGGER validate_employee_salary
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
DECLARE
  v_salary NUMBER;
BEGIN
  v_salary := :NEW.salary;
  IF v_salary < 2000 OR v_salary > 26000 THEN
    INSERT INTO zlodziej (id, user_name, czas_zmiany) VALUES (:NEW.employee_id, USER, SYSTIMESTAMP);
    RAISE_APPLICATION_ERROR(-20012, 'Wynagrodzenie poza dozwolonym zakresem');
  END IF;
END;
/
-- Wyzwalacz 3:
CREATE OR REPLACE TRIGGER employees_auto_increment
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
  IF :NEW.employee_id IS NULL THEN
    SELECT employees_seq.NEXTVAL INTO :NEW.employee_id FROM DUAL;
  END IF;
END;
/
-- Wyzwalacz 4:
CREATE OR REPLACE TRIGGER forbid_job_grades_modification
BEFORE INSERT OR UPDATE OR DELETE ON job_grades
BEGIN
  RAISE_APPLICATION_ERROR(-20013, 'Operacja niedozwolona na JOB_GRADES');
END;
/
-- Wyzwalacz 5:
CREATE OR REPLACE TRIGGER preserve_salary_bounds
BEFORE UPDATE OF max_salary, min_salary ON jobs
FOR EACH ROW
BEGIN
  :NEW.max_salary := :OLD.max_salary;
  :NEW.min_salary := :OLD.min_salary;
END;
/
-- Paczka ogólna operacji na pracownikach
CREATE OR REPLACE PACKAGE all_operations IS
  FUNCTION retrieve_job_title(p_job_id jobs.job_id%TYPE) RETURN jobs.job_title%TYPE;
  FUNCTION calculate_annual_salary(p_employee_id employees.employee_id%TYPE) RETURN NUMBER;
  
  FUNCTION get_area_code(p_phone VARCHAR2) RETURN VARCHAR2;
  
  FUNCTION format_name(p_string VARCHAR2) RETURN VARCHAR2;
  
  FUNCTION pesel_to_birthdate(p_pesel CHAR) RETURN DATE;
  
  FUNCTION count_employees_departments(p_country_name VARCHAR2) RETURN VARCHAR2;
END all_operations;
/

CREATE OR REPLACE PACKAGE BODY all_operations IS
  FUNCTION retrieve_job_title(p_job_id jobs.job_id%TYPE) RETURN jobs.job_title%TYPE IS
    v_job_title jobs.job_title%TYPE;
  BEGIN
    SELECT job_title INTO v_job_title FROM jobs WHERE job_id = p_job_id;
    RETURN v_job_title;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'Praca o podanym identyfikatorze nie istnieje');
  END retrieve_job_title;

  FUNCTION calculate_annual_salary(p_employee_id employees.employee_id%TYPE) RETURN NUMBER IS
    v_annual_salary NUMBER;
    v_commission_pct employees.commission_pct%TYPE;
  BEGIN
    SELECT salary, NVL(commission_pct, 0) INTO v_annual_salary, v_commission_pct 
    FROM employees WHERE employee_id = p_employee_id;
    v_annual_salary := v_annual_salary * (12 + v_commission_pct);
    RETURN v_annual_salary;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20002, 'Pracownik o podanym identyfikatorze nie istnieje');
  END calculate_annual_salary;

  FUNCTION get_area_code(p_phone VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN SUBSTR(p_phone, 1, INSTR(p_phone, ')') - 1);
  END get_area_code;

  FUNCTION format_name(p_string VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN INITCAP(p_string);
  END format_name;

  FUNCTION pesel_to_birthdate(p_pesel CHAR) RETURN DATE IS
    v_birth_date DATE;
  BEGIN
    v_birth_date := TO_DATE(SUBSTR(p_pesel, 1, 6), 'YYMMDD');
    RETURN v_birth_date;
  END pesel_to_birthdate;

  FUNCTION count_employees_departments(p_country_name VARCHAR2) RETURN VARCHAR2 IS
    v_employee_count NUMBER;
    v_department_count NUMBER;
  BEGIN
    SELECT COUNT(*)
    INTO v_employee_count
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
    WHERE c.country_name = p_country_name;

    SELECT COUNT(*)
    INTO v_department_count
    FROM departments d
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
    WHERE c.country_name = p_country_name;

    RETURN 'Pracownicy: ' || TO_CHAR(v_employee_count) || ' Dzia³y: ' || TO_CHAR(v_department_count);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20005, 'Kraj o podanej nazwie nie istnieje');
  END count_employees_departments;

END all_operations;
/
-- Paczka obs³uguj¹ca tabelê REGIONS
CREATE OR REPLACE PACKAGE regions_operations IS
  PROCEDURE create_region(p_region_id IN REGIONS.REGION_ID%TYPE, p_region_name IN REGIONS.REGION_NAME%TYPE);
  PROCEDURE update_region(p_region_id IN REGIONS.REGION_ID%TYPE, p_region_name IN REGIONS.REGION_NAME%TYPE);
  PROCEDURE delete_region(p_region_id IN REGIONS.REGION_ID%TYPE);
  FUNCTION read_region(p_region_id IN REGIONS.REGION_ID%TYPE DEFAULT NULL, p_region_name IN REGIONS.REGION_NAME%TYPE DEFAULT NULL) RETURN SYS_REFCURSOR;
END regions_operations;
/
CREATE OR REPLACE PACKAGE BODY regions_operations IS
  PROCEDURE create_region(p_region_id IN REGIONS.REGION_ID%TYPE, p_region_name IN REGIONS.REGION_NAME%TYPE) IS
  BEGIN
    INSERT INTO REGIONS (REGION_ID, REGION_NAME) VALUES (p_region_id, p_region_name);
  END create_region;

  PROCEDURE update_region(p_region_id IN REGIONS.REGION_ID%TYPE, p_region_name IN REGIONS.REGION_NAME%TYPE) IS
  BEGIN
    UPDATE REGIONS SET REGION_NAME = p_region_name WHERE REGION_ID = p_region_id;
  END update_region;

  PROCEDURE delete_region(p_region_id IN REGIONS.REGION_ID%TYPE) IS
  BEGIN
    DELETE FROM REGIONS WHERE REGION_ID = p_region_id;
  END delete_region;

  FUNCTION read_region(p_region_id IN REGIONS.REGION_ID%TYPE DEFAULT NULL, p_region_name IN REGIONS.REGION_NAME%TYPE DEFAULT NULL) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR 
      SELECT * 
      FROM REGIONS 
      WHERE (p_region_id IS NULL OR REGION_ID = p_region_id) 
      AND (p_region_name IS NULL OR REGION_NAME LIKE p_region_name || '%');
    RETURN v_cursor;
  END read_region;

END regions_operations;
/