-- 1.
DECLARE
  numer_max NUMBER;
  nowy_numer_departamentu NUMBER;
  nowa_nazwa_departamentu departments.department_name%TYPE := 'EDUCATION';
  nowy_location_id NUMBER := 3000;
BEGIN
  SELECT MAX(department_id) INTO numer_max FROM departments;

  nowy_numer_departamentu := numer_max + 10;
  INSERT INTO departments(department_id, department_name, location_id)
  VALUES (nowy_numer_departamentu, nowa_nazwa_departamentu, nowy_location_id);
  
  COMMIT;

  DBMS_OUTPUT.PUT_LINE('Dodano nowy departament o numerze: ' || nowy_numer_departamentu);
END;
/

-- 2. 
DECLARE
  numer_max NUMBER;
  nowy_numer_departamentu NUMBER;
  nowy_location_id NUMBER := 3000;
BEGIN
  SELECT MAX(department_id) INTO numer_max FROM departments;
  nowy_numer_departamentu := numer_max + 10;
  UPDATE departments
  SET location_id = nowy_location_id
  WHERE department_id = nowy_numer_departamentu;

  COMMIT;

  DBMS_OUTPUT.PUT_LINE('Zmieniono location_id dla departamentu o numerze: ' || nowy_numer_departamentu);
END;
/

-- 3. 
CREATE TABLE nowa (
    pole VARCHAR2(10)
);

DECLARE
    v_liczba NUMBER;
BEGIN
    FOR i IN 1..10 LOOP
        IF i NOT IN (4, 6) THEN
            v_liczba := i;
            INSERT INTO nowa (pole) VALUES (TO_CHAR(v_liczba));
        END IF;
    END LOOP;
END;
/

-- 4.
DECLARE
  kraj_rec countries%ROWTYPE;
BEGIN
  SELECT * INTO kraj_rec
  FROM countries
  WHERE country_id = 'CA';

  DBMS_OUTPUT.PUT_LINE('Kraj: ' || kraj_rec.country_name || ', Region ID: ' || kraj_rec.region_id);
END;
/

-- 5. 
DECLARE
    TYPE departamenty_tab_typ IS TABLE OF departments.department_name%TYPE INDEX BY BINARY_INTEGER;
    v_departments departamenty_tab_typ;
BEGIN
    FOR i IN 1..10 LOOP
        v_departments(i * 10) := NULL;
        SELECT department_name INTO v_departments(i * 10)
        FROM departments
        WHERE department_id = i * 10;
    END LOOP;
    FOR i IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE('Numer departamentu: ' || i * 10 || ', Nazwa departamentu: ' || v_departments(i * 10));
    END LOOP;
END;
/

-- 6. 
DECLARE
  TYPE departamenty_tab_typ IS TABLE OF departments%ROWTYPE INDEX BY BINARY_INTEGER;
  departamenty_tab departamenty_tab_typ;
BEGIN
  FOR i IN 1..10 LOOP
    SELECT * INTO departamenty_tab(i)
    FROM departments
    WHERE department_id = i * 10;
  END LOOP;

  FOR i IN departamenty_tab.FIRST..departamenty_tab.LAST LOOP
    DBMS_OUTPUT.PUT_LINE('Departament ' || i || ': ' || departamenty_tab(i).department_name || ', Location ID: ' || departamenty_tab(i).location_id);
  END LOOP;
END;
/

-- 7.
DECLARE
  CURSOR wynagrodzenie_cur IS
    SELECT last_name, salary
    FROM employees
    WHERE department_id = 50;
  
  v_last_name employees.last_name%TYPE;
  v_salary employees.salary%TYPE;
BEGIN
  FOR emp IN wynagrodzenie_cur LOOP
    v_last_name := emp.last_name;
    v_salary := emp.salary;

    IF v_salary > 3100 THEN
      DBMS_OUTPUT.PUT_LINE(v_last_name || ': nie dawaæ podwy¿ki');
    ELSE
      DBMS_OUTPUT.PUT_LINE(v_last_name || ': daæ podwy¿kê');
    END IF;
  END LOOP;
END;
/

-- 8. 
DECLARE
  CURSOR zarobki_cur (p_min_salary NUMBER, p_max_salary NUMBER, p_part_of_name VARCHAR2) IS
    SELECT first_name, last_name, salary
    FROM employees
    WHERE salary BETWEEN p_min_salary AND p_max_salary
      AND (first_name LIKE '%' || p_part_of_name || '%' OR last_name LIKE '%' || p_part_of_name || '%');

  v_first_name employees.first_name%TYPE;
  v_last_name employees.last_name%TYPE;
  v_salary employees.salary%TYPE;
BEGIN
  -- a.
  DBMS_OUTPUT.PUT_LINE('Pracownicy z zarobkami 1000-5000 i czêœci¹ imienia A:');
  FOR emp IN zarobki_cur(1000, 5000, 'a') LOOP
    v_first_name := emp.first_name;
    v_last_name := emp.last_name;
    v_salary := emp.salary;
    DBMS_OUTPUT.PUT_LINE(v_first_name || ' ' || v_last_name || ': ' || v_salary);
  END LOOP;

  -- b.
  DBMS_OUTPUT.PUT_LINE('Pracownicy z zarobkami 5000-20000 i czêœci¹ imienia U:');
  FOR emp IN zarobki_cur(5000, 20000, 'u') LOOP
    v_first_name := emp.first_name;
    v_last_name := emp.last_name;
    v_salary := emp.salary;
    DBMS_OUTPUT.PUT_LINE(v_first_name || ' ' || v_last_name || ': ' || v_salary);
  END LOOP;
END;
/

-- 9.
-- a.
CREATE OR REPLACE PROCEDURE dodaj_job (
  p_job_id jobs.job_id%TYPE,
  p_job_title jobs.job_title%TYPE
) IS
BEGIN
  INSERT INTO jobs(job_id, job_title)
  VALUES (p_job_id, p_job_title);
  
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Dodano now¹ pozycjê do tabeli Jobs: ' || p_job_id || ' - ' || p_job_title);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('B³¹d: ' || SQLERRM);
END;
/

-- b.
CREATE OR REPLACE PROCEDURE modyfikuj_job_title (
  p_job_id jobs.job_id%TYPE,
  p_new_title jobs.job_title%TYPE
) IS
BEGIN
  UPDATE jobs
  SET job_title = p_new_title
  WHERE job_id = p_job_id;

  IF SQL%NOTFOUND THEN
    RAISE_APPLICATION_ERROR(-20001, 'No Jobs updated');
  END IF;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Zaktualizowano pozycjê w tabeli Jobs: ' || p_job_id || ' - ' || p_new_title);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('B³¹d: ' || SQLERRM);
END;
/

-- c. 
CREATE OR REPLACE PROCEDURE usun_job (
  p_job_id jobs.job_id%TYPE
) IS
BEGIN
  DELETE FROM jobs
  WHERE job_id = p_job_id;

  IF SQL%NOTFOUND THEN
    RAISE_APPLICATION_ERROR(-20002, 'No Jobs deleted');
  END IF;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Usuniêto pozycjê z tabeli Jobs: ' || p_job_id);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('B³¹d: ' || SQLERRM);
END;
/

-- d.
CREATE OR REPLACE PROCEDURE wyciagnij_zarobki (
  p_employee_id employees.employee_id%TYPE,
  o_last_name OUT employees.last_name%TYPE,
  o_salary OUT employees.salary%TYPE
) IS
BEGIN
  SELECT last_name, salary
  INTO o_last_name, o_salary
  FROM employees
  WHERE employee_id = p_employee_id;
  
  DBMS_OUTPUT.PUT_LINE('Pracownik ' || o_last_name || ': ' || o_salary);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Nie znaleziono pracownika o ID: ' || p_employee_id);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('B³¹d: ' || SQLERRM);
END;
/

-- e. 
CREATE SEQUENCE employees_seq
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

CREATE OR REPLACE PROCEDURE dodaj_pracownika (
  p_first_name employees.first_name%TYPE DEFAULT 'John',
  p_last_name employees.last_name%TYPE DEFAULT 'Doe',
  p_salary employees.salary%TYPE DEFAULT 1000
) IS
BEGIN
  IF p_salary > 20000 THEN
    RAISE_APPLICATION_ERROR(-20003, 'Wynagrodzenie nie mo¿e przekroczyæ 20000');
  END IF;

  INSERT INTO employees(employee_id, first_name, last_name, salary)
  VALUES (employees_seq.NEXTVAL, p_first_name, p_last_name, p_salary);

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Dodano nowego pracownika: ' || p_first_name || ' ' || p_last_name || ', Zarobki: ' || p_salary);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('B³¹d: ' || SQLERRM);
END;
/
