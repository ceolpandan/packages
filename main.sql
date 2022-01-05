ALTER PACKAGE pachet_emp_cdp COMPILE PACKAGE;
ALTER PACKAGE pachet_emp_cdp COMPILE BODY;


DECLARE
nume emp_cdp.first_name%type:= 'Dan';
prenume emp_cdp.last_name%type := 'Ceolpan';
email emp_cdp.email%type := 'dc@email.com';
telefon emp_cdp.phone_number%type := '0712312312';
job_id jobs_cdp.job_id%type := pachet_emp_cdp.get_job_id('Programmer');
dept_id dep_cdp.department_id%type := pachet_emp_cdp.get_dept_id('IT');
salary emp_cdp.salary%type := pachet_emp_cdp.get_min_salary_from_dept(job_id, dept_id);
manager_id emp_cdp.employee_id%TYPE := pachet_emp_cdp.get_manager_id('King', 'Steven');
BEGIN
--a - adaug in tabel angajatul cu datele memorate in sectiunea DECLARE:
--pachet_emp_cdp.p_add_emp(nume, prenume, telefon, email, param_job_id => job_id,
--                             param_salary => salary, param_manager_id => manager_id, param_department_id => dept_id);

--b - mut angajatul in departamentul Administration, apoi inapoi in primul departament
--pachet_emp_cdp.muta_angajat(prenume, nume, 'Administration', 'Accounting Manager', 'Jennifer', 'Whalen');
--pachet_emp_cdp.muta_angajat(prenume, nume, 'IT', 'Programmer', 'Steven', 'King');

--c - subalternii lui Whalen
--    dbms_output.put_line(pachet_emp_cdp.get_subalterni('Whalen', 'Jennifer'));

--e - salariu
--pachet_emp_cdp.set_salary(16000, 'Test', 'Altul');

--h
 --pachet_emp_cdp.muta_angajat(prenume, nume, 'IT', 'Programmer', 'Steven', 'King');
pachet_emp_cdp.show_info();

END;
----
--
--BEGIN
--    pachet_emp_cdp.p_add_emp(nume, prenume, telefon, email, param_job_id => job_id,
--                             param_salary => salary, param_manager_id => manager_id, param_department_id => dept_id);
--END;
--/
-------------------Exercitiul 1b
-------------------mut angajatul adaugat la 1a in departamentul Administration
--BEGIN
--        pachet_emp_cdp.muta_angajat(prenume, nume, 'Administration', 'Accounting Manager', 'Jennifer', 'Whalen');
--END;
-------------------Exercitiul 1c
-------------------subalternii lui Steven King
--BEGIN
--    dbms_output.put_line(pachet_emp_cdp.get_subalterni('King', 'Steven'));
--END;
-------------------Exercitiul 1e
-------------------salariul lui ALTUL3
--BEGIN
--    pachet_emp_cdp.set_salary(17000, prenume, nume);
--END;
-------------------Exercitiul 1f
-------------------cursor angajati cu job id ul dat ca parametru
--BEGIN
--FOR i IN pachet_emp_cdp.c_emp('IT_PROG') LOOP
--    dbms_output.put_line(i.first_name || ' ' ||i.last_name);
--END LOOP;
--END;
-------------------Exercitiul 1g
-------------------cursor care intoarce toate joburile(din tabelul jobs)
--BEGIN
--FOR i IN pachet_emp_cdp.c_get_jobs LOOP
--    dbms_output.put_line(i.job_id || ' ' ||i.job_title);
--END LOOP;
--END;
-------------------Exercitiul 1h
-------------------apelez procedura
--BEGIN
--   --pachet_emp_cdp.muta_angajat('Test', 'Altul3', 'IT', 'Programmer', 'Steven', 'King');
--   pachet_emp_cdp.show_info();
--END;
/
SELECT * FROM EMP_CDP;
--SELECT * FROM istoric_joburi;