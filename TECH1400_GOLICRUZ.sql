use TECH1400_A3_DB;

-- Question 1: full name, job title, department, campus and city for every employee
select CONCAT(st.EmployeeFirstName, ' ', st.EmployeeLastName) AS Full_Name,
		ttl.JobTitleName AS Position_Title,
        dp.DepartmentName AS Dept_Name,
        cm.CampusName AS Campus_Name,
        cm.City AS Campus_City
from Campus AS cm
join Departments AS dp ON dp.CampusID = cm.CampusID
join Employees AS st ON st.DepartmentID = dp.DepartmentID
join JobTitle AS ttl ON ttl.jobTitleID = st.JobTitleID
order by cm.City ASC, dp.DepartmentName ASC,
			st.EmployeeLastName ASC, st.EmployeeFirstName ASC;

-- Question 2: employees hired after January 1, 2018, with their job and department
select CONCAT(st.EmployeeFirstName, ' ', st.EmployeeLastName) AS Full_Name,
		st.HireDate AS Hired_ON,
        ttl.JobTitleName AS Position_Title,
        dp.DepartmentName AS Dept_Name,
        st.EmploymentStatus AS Current_Status
from Employees AS st
join Departments AS dp ON dp.DepartmentID = st.DepartmentID
join JobTitle AS ttl ON ttl.JobTitleID = st.JobTitleID
where st.HireDate > '2018-01-01'
order by st.HireDate ASC, st.EmployeeLastName ASC, st.EmployeeFirstName ASC;

-- Question 3: every department with the campus name, city and state it belongs to
select dp.DepartmentName AS Dept_name,
		cm.CampusName AS Campus_Name,
        cm.City AS Campus_City,
        cm.State AS Campus_State
from Campus AS cm
join Departments AS dp ON dp.CampusID = cm.CampusID
order by cm.State ASC, cm.CampusName ASC, dp.DepartmentName ASC;

-- Question 4: headcount per department, largest department first
select dp.DepartmentName AS Dept_Name,
		cm.CampusName AS Campus_Name,
        count(st.EmployeeID) AS Headcount
from Campus AS cm
join Departments AS dp ON dp.CampusID = cm.CampusID
left join Employees AS st ON st.DepartmentID = dp.DepartmentID
group by dp.DepartmentID, dp.DepartmentName, cm.CampusName
order by Headcount DESC, dp.DepartmentName ASC;

-- Question 5: employees in salary classes whose maximum salary is above 90,000
select CONCAT(st.EmployeeFirstName, ' ', st.EmployeeLastName) AS Full_Name,
		sc.SalaryLevel AS Level_Name,
        sc.MinSalary AS Salary_Floor,
        sc.MaxSalary AS Salary_Ceiling
from SalaryClass AS sc
join Employees AS st ON st.SalaryID = sc.SalaryID
where sc.MaxSalary > 90000
order by sc.MaxSalary ASC, st.EmployeeLastName ASC, st.EmployeeFirstName ASC;

-- Question 6: every bonus paid, with the employee, department and campus cuty
select CONCAT(st.EmployeeFirstName, ' ', st.EmployeeLastName) AS Full_Name,
		bn.BonusYear AS Bonus_yr,
        bn.BonusAmount AS Bonus_Amt,
        dp.DepartmentName AS Dept_Name,
        cm.City AS Campus_City
from Employees AS st
join Bonus AS bn ON bn.EmployeeID = st.employeeID
join Departments AS dp ON dp.DepartmentID = st.DepartmentID
join Campus AS cm ON cm.CampusID = dp.CampusID
order by bn.BonusAmount DESC, st.EmployeeLastName ASC,
		st.EmployeeFirstName ASC, bn.BonusYear ASC;
        
-- Question 7: departments whose average bonus is above 5,000
select dp.DepartmentName AS Dept_Name,
		avg(bn.BonusAmount) AS Avg_Bonus
from Departments AS dp
join Employees AS st ON st.DepartmentID = dp.DepartmentID
join Bonus AS bn ON bn.EmployeeID = st.EmployeeID
group by dp.DepartmentID, dp.DepartmentName
having avg(bn.BonusAmount) > 5000
order by Avg_Bonus DESC;

-- Question 8: lecturers and senior lecturers based in Sydney or Melbourne
select CONCAT(st.EmployeeFirstName, ' ', st.EmployeeLastName) AS Full_Name,
		ttl.JobTitleName AS Position_Title,
        dp.DepartmentName AS Dept_Name,
        cm.City AS Campus_City,
        st.HireDate AS Hired_On
from Employees AS st
join JobTitle AS ttl ON ttl.JobTitleID = st.JobTitleID
join Departments AS dp ON dp.DepartmentID = st.DepartmentID
join Campus AS cm ON cm.CampusID = dp.CampusID
where ttl.JobTitleName IN ('Lecturer', 'Senior Lecturer')
	and (cm.City = 'Sydney' OR cm.City = 'Melbourne')
order by cm.City ASC, st.EmployeeLastName ASC, st.EmployeeFirstName ASC;

-- Question 9: the youngest employee (latest date of birth) in each department
select dp.DepartmentName AS Dept_Name,
		concat(st.EmployeeFirstName, ' ', st.EmployeeLastName) AS Full_Name,
        st.DateOfBirth AS DOB
from Employees AS st
join Departments AS dp ON dp.DepartmentID = st.DepartmentID
where st.DateofBirth = (select MAX(peer.DateOfBirth)
		from Employees AS peer
		where peer.DepartmentID = st.DepartmentID)
order by dp.DepartmentName ASC;

-- Question 10: stored procedure listing the employees at a given campus city
drop procedure if exists Staff_By_City;
DELIMITER // 
create procedure Staff_By_City(IN p_City VARCHAR(50))
begin
	select CONCAT (st.EmployeeFirstName, ' ', st.EmployeeLastName) AS Full_Name,
    dp.DepartmentName AS Dept_Name,
    ttl.JobTitleName AS Position_Title
from Campus AS cm
join Departments AS dp ON dp.CampusID = cm.CampusID
join Employees AS st ON st.DepartmentID = dp.DepartmentID
join JobTitle AS ttl ON ttl.JobTitleID = st.JobTitleID
	where cm.City = p_City
    order by dp.DepartmentName ASC, st.EmployeeLastName ASC,
    st.EmployeeFirstName ASC;
END //
DELIMITER ;

-- Test call for Question 10:
Call Staff_By_City('Perth');

/*
Generative AI Declaration and Collaboration Appendix
Student Name: Anton Louise H. Golicruz 
Student ID: 1893059
AI tool used: ChatGPT

Prompts and Responses:

1. First Set
Prompt: I am working on a MySQL query to retrieve employee details and their total bonuses grouped by department. Can you generate a sample SQL syntax using a standard Inner Joins and Group By clauses?
Response: ChatGPT provided standard syntax using Inner Join across employees, departments, and bonuses tables, utilizing SUM() and Group By clauses to calculate the department level aggregations.

2. Second Set
Prompt: Does standard SQL whitespace or indentation affect query execution in MySQL Workbench?
Response: ChatGPT confirmed that whitespace, tabs, and new lines do not affect SQL execution in MySQL Workbench, as SQL is free format. 

3. Third Set
Prompt: Why am I getting a syntax error on DELIMITER // in MySQL WOrkbench, and how do I properly execute a stored procedure block?
Response: ChatGPT explained that DELIMITER is a client side command in MySQL Workbench used to redefine statement boundaries and advised executing the entire block (from DELIMITER // down to DELIMITER ;) together using Ctrl+Shift+Enter)

Student Statement: I certify that all SQL queries and stored procedures in this submission represent my own original work, which I personally authored, executed, and verified in MySQL Workbench. Generative AI was used strictly as a consultative learning and debugging platform to review sytax accuracy, join logic, and execution workflow.
*/
