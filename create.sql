--DROP TABLE jobs_cdp;
--CREATE TABLE jobs_cdp as SELECT * FROM jobs;
--
--DROP TABLE dep_cdp;
--CREATE TABLE dep_cdp as SELECT * FROM departments;
--
--DROP TABLE emp_cdp;
--CREATE TABLE emp_cdp as SELECT * FROM employees;

--DROP SEQUENCE emp_seq;
--CREATE SEQUENCE emp_seq
--START WITH 206
--INCREMENT BY 1
--NOCACHE NOCYCLE;

--CREATE SEQUENCE istoric_seq
--START WITH 1
--INCREMENT BY 1
--NOCACHE NOCYCLE;
--DROP TABLE istoric_joburi;
--CREATE TABLE istoric_joburi (
--      job_history_id NUMBER(6) NOT NULL,
--      emp_id  NUMBER(6) NOT NULL,
--      previous_job_id  VARCHAR2(25),
--      actual_job_id  VARCHAR2(25)
--);

--select * from jobs_cdp;
--select * from dep_cdp;
select * from emp_cdp;
--select * from istoric_joburi;