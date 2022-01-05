CREATE OR REPLACE PACKAGE pachet_emp_cdp IS
    PROCEDURE set_salary(
        new_salary emp_cdp.salary%TYPE,
        param_nume emp_cdp.last_name%TYPE,
        param_prenume emp_cdp.first_name%TYPE);
    PROCEDURE muta_angajat (
        param_nume              emp_cdp.last_name%TYPE,
        param_prenume           emp_cdp.first_name%TYPE,
        param_department_name   dep_cdp.department_name%TYPE,
        param_job_title         jobs_cdp.job_title%TYPE,
        param_manager_fn        emp_cdp.first_name%TYPE,
        param_manager_ln        emp_cdp.last_name%TYPE);
    PROCEDURE job_history(
        employee_id emp_cdp.employee_id%TYPE,
        previous_job_id emp_cdp.job_id%TYPE,
        actual_job_id emp_cdp.job_id% type);
    PROCEDURE p_add_emp (
        param_nume             emp_cdp.first_name%TYPE,
        param_prenume          emp_cdp.last_name%TYPE,
        param_telefon          emp_cdp.phone_number%TYPE,
        param_email            emp_cdp.email%TYPE,
        param_hire_date        emp_cdp.hire_date%TYPE := sysdate,
        param_job_id           emp_cdp.job_id%TYPE,
        param_salary           emp_cdp.salary%TYPE := 0,
        param_commission_pct   emp_cdp.commission_pct%TYPE := 0,
        param_manager_id       emp_cdp.manager_id%TYPE,
        param_department_id    dep_cdp.department_id%TYPE);
    FUNCTION get_min_salary_from_dept (
        param_job_id    emp_cdp.job_id%TYPE,
        param_dept_id   dep_cdp.department_id%TYPE) RETURN NUMBER;
    FUNCTION get_manager_id (
        param_prenume   emp_cdp.last_name%TYPE,
        param_nume      emp_cdp.first_name%TYPE) RETURN emp_cdp.employee_id%TYPE;
    FUNCTION get_dept_id (param_nume_dept dep_cdp.department_name%TYPE) RETURN dep_cdp.department_id%TYPE;
    FUNCTION get_job_id (
        param_nume_job jobs_cdp.job_title%TYPE) RETURN jobs_cdp.job_id%TYPE; 
    FUNCTION get_subalterni(
        param_nume emp_cdp.last_name%TYPE,
        param_prenume emp_cdp.first_name%TYPE) RETURN NUMBER;

END pachet_emp_cdp;
/
CREATE OR REPLACE PACKAGE BODY pachet_emp_cdp AS
    PROCEDURE set_salary(
        new_salary emp_cdp.salary%TYPE,
        param_nume emp_cdp.last_name%TYPE,
        param_prenume emp_cdp.first_name%TYPE) IS
            min_salary_for_job emp_cdp.salary%TYPE;
            max_salary_for_job emp_cdp.salary%TYPE;
            current_job_id emp_cdp.job_id%TYPE;
            emp_id emp_cdp.employee_id%TYPE;
            CURSOR C IS
                SELECT employee_id FROM emp_cdp WHERE first_name = param_prenume and last_name = param_nume;

        BEGIN
        SELECT job_id INTO current_job_id FROM emp_cdp WHERE first_name = param_prenume and last_name = param_nume;
        SELECT min_salary INTO min_salary_for_job FROM jobs_cdp WHERE job_id = current_job_id;
        SELECT max_salary INTO max_salary_for_job FROM jobs_cdp WHERE job_id = current_job_id;
        IF new_salary > min_salary_for_job AND new_salary <= max_salary_for_job THEN
            UPDATE emp_cdp SET
                salary = new_salary
            WHERE first_name = param_prenume and last_name = param_nume;
            dbms_output.put_line('Salariul a fost actualizat!');
        ELSE
            dbms_output.put_line('Angajatul ' || param_nume || ' ' || param_prenume|| ' nu poate primi salariul de ' || new_salary);
        END IF;
        EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('Nu am gasit angajatul ' || param_nume || ' ' || param_prenume);
        WHEN too_many_rows THEN
            dbms_output.put_line('Exista mai multi angajati cu numele respectiv: ');
            OPEN c;
            LOOP
                FETCH c INTO emp_id;
                EXIT WHEN c%NOTFOUND;
                dbms_output.put_line(emp_id);
            END LOOP;
            CLOSE c;
    END set_salary;
    
    FUNCTION get_subalterni(
        param_nume emp_cdp.last_name%TYPE,
        param_prenume emp_cdp.first_name%TYPE) RETURN NUMBER IS
            num_of_sub NUMBER:= 0;
            emp_id emp_cdp.employee_id%TYPE;
        BEGIN
        SELECT employee_id INTO emp_id FROM emp_cdp WHERE first_name = param_prenume AND last_name = param_nume;
        SELECT count(*) INTO num_of_sub FROM emp_cdp WHERE manager_id = emp_id;
        RETURN num_of_sub;
        EXCEPTION
            WHEN no_data_found THEN
                dbms_output.put_line('Niciun angajat nu este subordonat angajatului cu codul ' || emp_id);
            WHEN too_many_rows THEN
                dbms_output.put_line('Am gasit mai multe inregistrari cu numele ' || param_nume ||' ' || param_prenume);

    END get_subalterni;
    PROCEDURE job_history(
        employee_id emp_cdp.employee_id%TYPE,
        previous_job_id emp_cdp.job_id%TYPE,
        actual_job_id emp_cdp.job_id% type) IS
        BEGIN
        INSERT INTO istoric_joburi VALUES (
            istoric_seq.NEXTVAL,
            employee_id,
            previous_job_id,
            actual_job_id);
    END job_history;
    
    PROCEDURE muta_angajat(
        param_nume              emp_cdp.last_name%TYPE,
        param_prenume           emp_cdp.first_name%TYPE,
        param_department_name   dep_cdp.department_name%TYPE,
        param_job_title         jobs_cdp.job_title%TYPE,
        param_manager_fn        emp_cdp.first_name%TYPE,
        param_manager_ln        emp_cdp.last_name%TYPE) IS
--
        dep_id           dept_cdp.department_id%TYPE := pachet_emp_cdp.get_dept_id(param_department_name);
        old_job_id       jobs_cdp.job_id%TYPE;
        new_job_id       jobs_cdp.job_id%TYPE := pachet_emp_cdp.get_job_id(param_job_title);
        new_manager_id   emp_cdp.employee_id%TYPE := pachet_emp_cdp.get_manager_id(param_manager_ln, param_manager_fn); 
        old_salary       emp_cdp.salary%TYPE;
        new_salary       emp_cdp.salary%TYPE;
        new_min_salary   emp_cdp.salary%TYPE;
        emp_id      emp_cdp.employee_id%TYPE;
        min_comission emp_cdp.commission_pct%TYPE;
--        
        BEGIN
        SELECT employee_id INTO emp_id FROM emp_cdp WHERE first_name = param_prenume AND last_name = param_nume;
        SELECT job_id INTO old_job_id FROM emp_cdp WHERE employee_id = emp_id;
        SELECT salary INTO old_salary FROM emp_cdp WHERE first_name = param_prenume AND last_name = param_nume;
        SELECT min_salary INTO new_min_salary FROM jobs_cdp WHERE job_id = new_job_id; 
        IF old_salary < new_min_salary THEN
            new_salary := new_min_salary;
        ELSE
            new_salary := old_salary;
        END IF;
        
        dbms_output.put_line(old_salary || ' ' || new_salary);
        
        UPDATE emp_cdp SET 
            department_id = dep_id,
            salary = new_salary,
            manager_id = new_manager_id,
            job_id = new_job_id,
            hire_date = SYSDATE
        WHERE employee_id = emp_id;
        
        pachet_emp_cdp.job_history(emp_id, old_job_id, new_job_id);
--        
        EXCEPTION
            WHEN no_data_found THEN
                dbms_output.put_line('NOT_FOUND ' || param_nume || ' ' || param_prenume);
            WHEN too_many_rows THEN
                dbms_output.put_line('QUERY RETURNED MORE THAN ONE ROW ' || param_nume || ' ' || param_prenume);

    END muta_angajat;

    FUNCTION get_job_id (
        param_nume_job jobs_cdp.job_title%TYPE
    ) RETURN jobs_cdp.job_id%TYPE IS
        r_job_id jobs_cdp.job_id%TYPE;
    BEGIN
        SELECT job_id INTO r_job_id FROM jobs_cdp WHERE job_title = param_nume_job;
        RETURN r_job_id;
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('Nu exista joburi cu numele ' || param_nume_job);
        WHEN OTHERS THEN
            dbms_output.put_line('Alta eroare!');
    END get_job_id;

    FUNCTION get_dept_id (
        param_nume_dept dep_cdp.department_name%TYPE
    ) RETURN dep_cdp.department_id%TYPE IS
        r_dept_id dep_cdp.department_id%TYPE;
    BEGIN
        SELECT department_id INTO r_dept_id FROM dep_cdp WHERE department_name = param_nume_dept;
        RETURN r_dept_id;
    EXCEPTION
        WHEN no_data_found THEN
            dbms_output.put_line('Nu exista departamentul cu numele ' || param_nume_dept);
        WHEN OTHERS THEN
            dbms_output.put_line('EROARE GET_DEPT_ID ');
    END get_dept_id;

    FUNCTION get_manager_id (
        param_prenume   emp_cdp.last_name%TYPE,
        param_nume      emp_cdp.first_name%TYPE
    ) RETURN emp_cdp.employee_id%TYPE IS
        r_mang_id emp_cdp.employee_id%TYPE;
    BEGIN
        SELECT employee_id INTO r_mang_id FROM emp_cdp WHERE first_name = param_nume AND last_name = param_prenume;
        RETURN r_mang_id;
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('EROARE GET_MANAGER_ID');
    END get_manager_id;

    FUNCTION get_min_salary_from_dept (
        param_job_id    emp_cdp.job_id%TYPE,
        param_dept_id   dep_cdp.department_id%TYPE
    ) RETURN NUMBER IS
        r_salary emp_cdp.salary%TYPE;
    BEGIN
        SELECT MIN(salary) INTO r_salary FROM emp_cdp WHERE department_id = param_dept_id AND job_id = param_job_id;
        RETURN r_salary;
        EXCEPTION 
            WHEN OTHERS THEN
                dbms_output.put_line('EROARE GET_SALARY');
    END get_min_salary_from_dept;

    PROCEDURE p_add_emp (
        param_nume             emp_cdp.first_name%TYPE,
        param_prenume          emp_cdp.last_name%TYPE,
        param_telefon          emp_cdp.phone_number%TYPE,
        param_email            emp_cdp.email%TYPE,
        param_hire_date        emp_cdp.hire_date%TYPE := sysdate,
        param_job_id           emp_cdp.job_id%TYPE,
        param_salary           emp_cdp.salary%TYPE := 0,
        param_commission_pct   emp_cdp.commission_pct%TYPE := 0,
        param_manager_id       emp_cdp.manager_id%TYPE,
        param_department_id    dep_cdp.department_id%TYPE
    ) AS
    BEGIN
        INSERT INTO emp_cdp VALUES (
            emp_seq.NEXTVAL,
            param_nume,
            param_prenume,
            param_email,
            param_telefon,
            param_hire_date,
            param_job_id,
            param_salary,
            param_commission_pct,
            param_manager_id,
            param_department_id);

        dbms_output.put_line('Angajatul '
                             || param_nume
                             || ' '
                             || param_prenume
                             || ' a fost adaugat.');

    END p_add_emp;

END pachet_emp_cdp;