ALTER PACKAGE pachet_emp_cdp COMPILE PACKAGE;
ALTER PACKAGE pachet_emp_cdp COMPILE BODY;


DECLARE
-------------------Exercitiul 1a
-------------------adaug un angajat nou cu datele respective folosind functiile din pachet

nume emp_cdp.first_name%type:= 'Altul3';
prenume emp_cdp.last_name%type := 'Test';
email emp_cdp.email%type := 'm@m.com';
telefon emp_cdp.phone_number%type := '060066';
job_id jobs_cdp.job_id%type := pachet_emp_cdp.get_job_id('Programmer');
dept_id dep_cdp.department_id%type := pachet_emp_cdp.get_dept_id('IT');
salary emp_cdp.salary%type := pachet_emp_cdp.get_min_salary_from_dept(job_id, dept_id);
manager_id emp_cdp.employee_id%TYPE := pachet_emp_cdp.get_manager_id('King', 'Steven');
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
BEGIN
    dbms_output.put_line(pachet_emp_cdp.get_subalterni('King', 'Steven'));
END;

