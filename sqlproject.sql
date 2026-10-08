create database project;
use project;
/*
1. Employee Salary — Second Highest Salary 
You have an employees table: 
emp_id emp_name department salary 
101 Ravi IT 60000 
102 Priya HR 45000 
103 Arun IT 75000 
104 Meena Finance 55000 
105 Karthik IT 70000 
Task: 
Write a SQL query to find the second highest salary from the employees table.*/

create table Employee (emp_id int primary key,emp_name varchar(20),department varchar(20),salary int);
 insert into Employee (emp_id,emp_name,department,salary) values
 (101,'Ravi','IT',6000),
 (102,'Priya','HR',45000),
 (103,'Arun','IT',75000),
 (104,'Meena','Finance',5500),
 (105,'Karthik','IT',75000);
 
 select max(salary) from Employee where salary < (select max(salary) from Employee);
 # or
 select distinct salary from Employee order by salary desc limit 1 offset 1;
 # LIMIT 1: Specifies that you only want to return exactly one row.OFFSET 1: Instructs the database to skip the first row (the highest salary) and start reading data from the second row (the second highest salary)
 /*
 2. Department Average Salary 
Table: employees 
Task: 
Find departments whose average salary is greater than 60,000. 
Expected columns: 
department 
average_salary*/

select * from employee;

update employee set  salary = 60000 where emp_id = 101;
update employee set  salary = 5500 where emp_id = 104;
update employee set  salary = 70000 where emp_id = 105;

select department,avg(salary) as Average_salary from employee group by department 
having avg(salary) > 60000;
 
 /*
  3.Customers With No Orders*/
  create table customers
  (cust_id int,
  cust_name varchar(20));
  
  create table orders
  (order_id int,
  cust_id int,
  amount int);
  insert into customers(cust_id,cust_name)values 
 ( 1,' Ravi'), 
(2, 'Priya'), 
(3, 'Arun'), 
(4, 'Meena');

 insert into orders (order_id ,cust_id ,amount) values
(101, 1, 5000), 
(102 ,2 ,7000 ),
(103, 1, 3000); 

select c.cust_id,c.cust_name from customers c left join orders o on c.cust_id = o.cust_id
where o.cust_id is null;

/*
4. Highest Salary in Each Department
*/
insert into Employee (emp_id,emp_name,department,salary) values
 (106,'divya','HR',65000);
 #using common table expression:
 with HighestSalaryTable as
 (select emp_name,department,salary,
 dense_rank()
 over(partition by department order by salary desc) as Highest_salary from employee
 )
 select emp_name,department,salary from HighestSalaryTable 
 where Highest_salary = 1;
 /*
 5. Employees Earning More Than Department Average*/
 select * from employee;
 #Select emp_name, department, salary from( select  emp_name, department, salary, avg(salary) over(partition by department) as avg_salary from employee)t where salary > avg_salary;
 select emp_name,department,salary from employee E
 where salary >(select avg(salary) from employee
 where department = E.department);
 
 use project;
 /*
 6. Top 2 Highest Paid Employees Per Department 
Table: employees 
Task: 
Find the top 2 highest-paid employees from each department. 
Expected columns: 
department 
emp_name 
salary 
rank 
Requirement: 
Use ROW_NUMBER(), RANK(), or DENSE_RANK(). */

with TopTwoEmployee as
(
select emp_name, department, salary ,dense_rank ()
over (partition by department
order by salary desc )  as HighestSalaryRank from employee )
select emp_name, department, salary, HighestSalaryRank from TopTwoEmployee 
where HighestSalaryRank <= 2 ;

 
 /*
 7. Monthly Sales Analysis 
Table: orders 
Task: 
Calculate the total sales for each month. 
Expected columns: 
month 
total_sales 
 */
 create table orderAnalysis(order_id int primary key,order_Date DATE,customer_id int,  order_amount decimal(10,2));

insert into orderAnalysis(order_id,order_Date,customer_id,order_amount) value(101,'2026-01-10',1,5000);
insert into orderAnalysis(order_id,order_Date,customer_id,order_amount) values(102,'2026-01-15',2,7000);
insert into orderAnalysis(order_id,order_Date,customer_id,order_amount) values(103,'2026-02-05',1,4000),(104,'2026-02-20',3,8000),(105,'2026-03-10',2,6000);
select * from orderAnalysis;

select month(order_Date) as ExtractedMonth ,sum(order_amount)as total_Sales from orderAnalysis 
group by ExtractedMonth order by ExtractedMonth;

/*
8. Customers With Above-Average Total Orders 
customers 
	customer_id 
	customer_name 
orders 
	order_id 
	customer_id 
	amount 
Task: 
Calculate the total order amount for each customer and return only customers whose total 
spending is greater than the average customer spending.
*/
use project;
select * from customers;
select * from orders;



with AboveAvgCustomers as
(select c.cust_id,c.cust_name ,sum(o.amount) as total_amount from customers c 
join orders O on C.cust_id = O.cust_id 
group by c.cust_id,c.cust_name)
select cust_id,cust_name, total_amount from AboveAvgCustomers 
where total_amount > (select avg(total_amount) from AboveAvgCustomers);

/*
9. Find Consecutive Employee Salaries 
Table: employees 
emp_id emp_name salary 
101 Ravi 50000 
102 Priya 60000 
103 Arun 70000 
104 Meena 80000 
105 Karthik 90000 
Task: 
Find employees whose salary is higher than the previous employee's salary based on emp_id. 
Expected columns: 
emp_id 
emp_name 
salary 
previous_salary 
Hint: Use LAG(). 
*/
with HigherSalary as 
(
select emp_id,emp_name,salary ,
LAG(salary)
over
(
order by emp_id)
as previousSalary
from employee
)
select emp_id,emp_name,salary,previousSalary from HigherSalary where salary > previousSalary  ;

/*
10. Department With Maximum Total Salary 
Table: employees 
emp_id emp_name department salary 
101 Ravi IT 60000 
102 Priya HR 45000 
103 Arun IT 75000 
104 Meena Finance 55000 
105 Karthik IT 70000 
emp_id emp_name department salary 
106 Divya 
HR 
65000 
Task: 
Find the department having the highest total salary expenditure. 
Expected columns: 
department 
total_salary 
Concepts: GROUP BY, SUM(), ORDER BY, LIMIT / subquery. 
*/
select department,sum(salary) as total_salary
from employee
group by department
order by total_salary desc; 

/*
11. Duplicate Customer Records 
Table: customers 
customer_id customer_name 
101 Ravi 
email 
102 Priya 
ravi@gmail.com
103 Arun 
priya@gmail.com
104 Meena 
ravi@gmail.com
meena@gmail.com
Task: 
Find all email addresses that are registered for more than one customer. 
Expected columns: 
email 
customer_count 
Hint: Use GROUP BY and HAVING. 
*/
create table customerEmail (cust_id int , cust_name varchar(20),email varchar(20));
insert into customerEmail (cust_id,cust_name,email) values (101 ,'Ravi','ravi@gmail.com' ),
(102,'priya','priya@gmail.com'),(103,'Arun','ravi@gmail.com'),(104,'Meena', 'meena@gmail.com');
select * from customerEmail;
select email, count(cust_id) as customer_count from customerEmail
group by email having count(*) > 1 ;
drop table customerEmail;

/*
12. Employees Joined in the Same Year 
Table: employees 
emp_id emp_name department joining_date 
101 Ravi IT 2022-05-10 
102 Priya HR 2023-06-15 
103 Arun IT 2022-08-20 
104 Meena Finance 2024-01-10 
105 Karthik IT 2023-03-12 
Task: 
Find the number of employees who joined in each year. 
Expected columns: 
joining_year 
employee_count*/

use project;
create table EmployeeJoining 
(emp_id int primary key,
emp_name varchar(20),
department varchar(20),
joining_date date);

insert into EmployeeJoining(emp_id,emp_name,department,joining_date ) values
(101, 'Ravi' ,'IT', 2022-05-10), 
(102 ,'Priya', 'HR' ,2023-06-15 ),
(103, 'Arun' ,'IT' ,2022-08-20 ),
(104,' Meena',' Finance', 2024-01-10), 
(105, 'Karthik',' IT',2023-03-12);

select * from EmployeeJoining;
select  Year(joining_date) as joining_year,count(emp_id) as employee_count from EmployeeJoining group by joining_year ;

/*13. Products Never Sold*/
create table products (product_id int,product_name varchar(20),price int);
insert into products(product_id,product_name,price)values (1,' Laptop', 60000), 
(2,' Mouse', 1000 ),
(3, 'Keyboard', 2000 ),
(4,' Monitor', 15000);

create table sales (sale_id int,product_id int, quantity int);
insert into sales(sale_id,product_id,quantity) values 
(101, 1, 2), 
(102, 2, 5), 
(103, 1, 1 );

select p.product_id,p.product_name from products p left join sales s on p.product_id = s.product_id where s.product_id is null;

/*14. Calculate Product Revenue 
Task: 
Calculate the total revenue generated by each product. 
Formula: 
Revenue = price × quantity 
Expected columns: 
product_name 
total_quantity 
total_revenue 
*/
select * from products;
select * from sales;
select p.product_name , sum(s.quantity) as total_quantity,sum(p.price * s.quantity) as total_revenue 
from products p join sales s on p.product_id = s.product_id group by p.product_name;

/*
15.Employee and Manager Details
Table: employees 
emp_id emp_name manager_id 
101 Ravi NULL 
102 Priya 101 
emp_id emp_name manager_id 
103 Arun 101 
104 Meena 102 
105 Karthik 102 
Task: 
Display each employee along with their manager's name. 
Expected columns: 
employee_name 
manager_name 
Hint: Use a self join. 
*/
create table EmployeeManager (emp_id int primary key,emp_name varchar(20),manager_id int);
insert into EmployeeManager(emp_id,emp_name,manager_id)values (101 ,'Ravi', NULL), 
(102 ,'Priya', 101 ),
(103, 'Arun', 101), 
(104,' Meena', 102 ),
(105, 'Karthik', 102);
select *from EmployeeManager;
select e.emp_name,m.emp_name as manager_name from EmployeeManager e left join EmployeeManager m on m.manager_id = e.emp_id ;
/*
16. Find Employees Without Managers 
Table: employees 
emp_id emp_name manager_id 
101 Ravi NULL 
102 Priya 101 
103 Arun 101 
104 Meena 102 
105 Karthik NULL 
Task: 
Find employees who do not have a manager. 
Expected columns: 
emp_id 
emp_name 
*/
select emp_id, emp_name from EmployeeManager where manager_id is NULL;

/*
17. Count Employees Reporting to Each Manager 
Table: employees 
emp_id emp_name manager_id 
101 Ravi NULL 
102 Priya 101 
103 Arun 101 
104 Meena 102 
105 Karthik 102 
Task: 
Find the number of employees reporting directly to each manager. 
Expected columns: 
manager_id 
employee_count 
Hint: Use GROUP BY. */
use project;
select * from employeeManager;
select manager_id , count(emp_id) as employee_count from employeeManager where manager_id is not NULL group by manager_id ;

/*
18. Find Missing Employee IDs 
Table: employees 
emp_id emp_name 
101 Ravi 
102 Priya 
104 Arun 
105 Meena 
Task: 
Find the missing employee ID between the minimum and maximum employee IDs. 
Expected result: 
103 
Hint: Think about LEAD(), LAG(), or a number-generating approach*/
use customerdemo;
insert into employees (emp_id,emp_name,salary)values (107,'Trisha',100000);
select * from employees;
with series as
(
select emp_id , 
lead(emp_id) over(order by emp_id) as NextId 
from employees
)
select (emp_id+1) as EmployeeId  from series where (nextId - emp_id) > 1;
/*
19. Find Employees With Same Salary 
Table: employees 
emp_id emp_name salary 
101employees Ravi 50000 
102 Priya 60000 
103 Arun 50000 
104 Meena 70000 
105 Karthik 60000 
Task: 
Find salaries received by more than one employee. 
Expected columns: 
salary 
employee_count */
use demo;
select * from employee;
insert into employee ()
select * from employee;
select salary, count(empid) as employee_count from employee group by salary having employee_count > 1 ;

#you cannot use aggregate functions like COUNT() inside a WHERE clause.
#The database engine evaluates the WHERE clause row-by-row before it groups any data.
#Because it hasn't grouped the data yet, it is impossible for it to know what the COUNT(empid) is at that stage of execution.
#To filter based on an aggregate function, you must use the HAVING clause placed after the GROUP BY clause.

/*
20. Find Employees With Unique Salaries 
Using the same employees table: 
Task: 
Find employees whose salary is not shared by any other employee. 
Expected columns: 
emp_id 
emp_name 
salary 
Hint: Use GROUP BY with a subquery or window function. 
*/
select  empid,empname,salary from employee where salary in
 (select distinct salary from employee group by salary having count(salary) = 1) ;

/*21. Running Total of Sales 
Task: 
Calculate the running total of sales ordered by sale_date. 
Expected columns: 
sale_date 
amount 
running_total 
Hint: Use SUM() OVER().*/
use project;
create table Runningsales (sale_id int ,sale_date date,amount int);
insert into Runningsales(sale_id,sale_date
,amount) values (101 ,'2026-01-01', 5000), 
(102, '2026-01-05', 3000 ),
(103, '2026-01-10', 7000 ),
(104, '2026-01-15', 4000);

select sale_date,amount,sum(amount) 
over(
 order by sale_date)as running_total  from Runningsales ;
 
/*22. Compare Current Sale With Previous Sale 
Table: sales 
sale_id sale_date amount 
101 2026-01-01 5000 
102 2026-01-02 7000 
103 2026-01-03 6000 
104 2026-01-04 9000 
Task: 
Display the current sale amount and the previous day's sale amount. 
Expected columns: 
sale_date 
amount 
previous_amount 
Hint: Use LAG().*/

use test;
select * from orders;
select order_date,order_amount, 
LAG(order_amount)
over
(order by order_date) as previous_amount  # order date ->it will order by date
from orders;

/*
23. Calculate Month-over-Month Sales Difference 
Table: monthly_sales 
month total_sales 
January 50000 
February 65000 
March 60000 
April 80000 
Task: 
Calculate the difference between the current month's sales and previous month's sales. 
Expected columns: 
month 
total_sales 
previous_sales 
sales_difference 
*/
use project;
create table monthly_sales 
(monthname varchar(20),
total_sales int);

alter table monthly_sales rename column month to monthname; # renaming the column name 

insert into monthly_sales(monthname,total_sales) values ('January', 50000), 
('February', 65000), 
('March', 60000), 
('April', 80000 );

with sales as
(
select monthname,total_sales ,
LAG(total_sales)
over
(order by MONTH(str_to_date(monthname,'%M'))) as previous_Sales  #Convert month name to a date format internally so it sorts chronologically
from monthly_sales    
)
select monthname,total_sales,previous_Sales,(previous_Sales - total_sales) as sales_difference from sales ;

/*24. Find First Order of Each Customer 
Table: orders 
order_id customer_id order_date amount 
101 1 2026-01-10 5000 
102 1 2026-02-15 7000 
103 2 2026-01-20 3000 
104 2 2026-03-10 6000 
Task: 
Find the first order placed by each customer. 
Expected columns: 
customer_id 
order_id 
order_date 
amount 
Hint: Use ROW_NUMBER() or MIN().*/
use test;
select * from orders;
insert into orders (customer_id,order_id,order_date,order_amount) values(102,90,'2026-03-01',20000.0),
(103,17,'2026-03-01',20000.0),(103,20,'2026-03-01',20000.0),(104,23,'2026-03-01',20000.0);

with FirstOrder as
(
select customer_id,order_id,order_date,order_amount ,
row_number() 
over(partition by customer_id order by order_date asc,order_id asc) as first_order
from orders 
)
select customer_id,order_id,order_date,order_amount,first_order from FirstOrder where first_order = 1;


/*25. Find Latest Order of Each Customer
Task: 
Find the most recent order of every customer. 
Expected columns: 
customer_id 
order_id 
order_date 
amount 
Hint: Use ROW_NUMBER() with ORDER BY order_date DESC.*/

with Latest_Order as
(
select customer_id,order_id,order_date,order_amount ,
row_number() 
over(partition by customer_id order by order_date desc,order_id desc) as recent_order
from orders 
)
select customer_id,order_id,order_date,order_amount from Latest_Order where recent_order = 1;

/*26. Customers With Multiple Orders 
Table: orders 
order_id customer_id amount 
101 1 5000 
102 1 7000 
103 2 3000 
104 3 6000 
105 3 4000 
Task: 
Find customers who have placed more than one order. 
Expected columns: 
customer_id 
order_count*/
select customer_id, count(order_id) as order_count from orders group by customer_id having count(order_id) > 1;

/*27. Find the Third Highest Distinct Salary
Task: 
Find the third highest distinct salary. 
Expected result: 
70000 
Requirement: 
Duplicate salary values should be counted only once.*/
select * from employee;
with High_Salary_cte as
(
select emp_id,salary ,
dense_rank()
over
(order by salary desc) as HighSalary
from employee )
select salary from  High_Salary_cte where HighSalary = 3;


/*28. Find Products Above Average Price
product_id product_name price 
1 Laptop 60000 
2 Mouse 1000 
3 Monitor 15000 
4 Keyboard 3000 
Task: 
Find products whose price is greater than the average product price. 
Expected columns: 
product_id 
product_name 
price 
Hint: Use a subquery containing AVG().
*/
use project;
select * from products;
select product_id,product_name,price from products where price > (select avg(price) from products );

/*
29. Find the Most Expensive Product in Each Category Task: 
Find the most expensive product in each category. 
Expected columns: 
category 
product_name 
price 
Hint: Use ROW_NUMBER(), RANK(), or a subquery. */
use demo;
select * from product;
with expensiveProduct as 
(
select category,product_name,price,row_number()
over(partition by category order by price desc ) as expensivePrice 
from product
)
select category,product_name,price from expensiveProduct where expensivePrice = 1 ;

/*30. Find Departments With More Than 3 Employees 
Task: 
Find departments that have more than 3 employees. 
Expected columns: 
department 
employee_count 
Hint: Use GROUP BY and HAVING.*/
use project;
select * from employee;

select department,count(emp_id) as employee_count from employee group by department having count(emp_id) > 3;

/*31. Employees Above Their Manager's Salary 
Table: employees 
emp_id emp_name salary manager_id 
101 Ravi 60000 NULL 
102 Priya 70000 101 
103 Arun 50000 101 
104 Meena 80000 102 
105 Karthik 65000 102 
Task: 
Find employees whose salary is greater than their manager's salary. 
Expected columns: 
emp_id 
emp_name 
employee_salary 
manager_salary 
Hint: Use a self join.
*/
create table managerSalary 
(emp_id int primary key,emp_name varchar(20),salary int,manager_id int );
insert into managerSalary(emp_id,emp_name,salary,manager_id) values (101,'Trisha',60000,null),(102,'Dinesh',70000,101),
(103,'arun',50000,101),(104,'radha',80000,102),(105,'geetha',65000,102);

select * from managerSalary;
select e.emp_id,e.emp_name,e.salary as employee_salary ,m.salary as	 manager_salary 
from managerSalary e left join managerSalary m on e.manager_id = m.emp_id  where e.salary > m.salary;

/*32. Department Salary Difference 
Table: employees 
emp_id emp_name department salary 
101 Ravi IT 60000 
102 Priya IT 80000 
103 Arun HR 50000 
104 Meena HR 70000 
105 Karthik Finance 55000 
Task: 
For each department, find the difference between the highest salary and lowest salary. 
Expected columns: 
department 
max_salary 
min_salary 
salary_difference 
Hint: Use MAX() and MIN().*/
use project;
select * from employee;
select department,max(salary) as max_salary ,min(salary)as min_salary,
(max(salary)-min(salary))as salary_difference from employee group by department ;

/*33. Customers Who Purchased Every Product
Task: 
Find customers who have purchased every available product. 
Expected columns: 
customer_id 
customer_name
*/
use project;
select * from customers;
select * from products;
create table sale (cust_id int,product_id int);
insert into sale(cust_id,product_id) values 
(1 ,101), 
(1 ,102), 
(1 ,103), 
(2 ,101), 
(2 ,102), 
(3, 101);
select * from sale;
insert into sale(cust_id,product_id) values (1,104);
select c.cust_id,c.cust_name from customers c join sale s on c.cust_id = s.cust_id  group by
c.cust_id,c.cust_name having count(distinct(product_id))= (select count(*) from products);

/*
34. Find the Longest Employee Tenure 
Table: employees 
emp_id emp_name joining_date 
101 Ravi 2018-05-10 
102 Priya 2020-03-15 
103 Arun 2016-08-20 
104 Meena 2022-01-10 
Task: 
Find the employee who has been working for the longest period. 
Expected columns: 
emp_id 
emp_name 
joining_date 
Hint: Use date difference and sorting.
*/
select * from employeejoining;
select emp_id ,emp_name,joining_date from employeejoining where joining_date in (select min(joining_date) from employeejoining);

/*35. Orders With Above-Average Order Amount 
Table: orders 
order_id customer_id amount 
101 1 5000 
102 2 12000 
103 3 7000 
104 1 15000 
105 4 4000 
Task: 
Find all orders where the order amount is greater than the overall average order amount. 
Expected columns:
order_id 
customer_id 
amount 
Hint: Use a scalar subquery with AVG().*/
use project;
select order_id ,cust_id ,amount from orders where amount > (select avg(amount) from orders ) ;

/*36. Category With the Most Products 
Table: products 
product_id product_name category 
101 Laptop 
102 Mouse 
Electronics 
Electronics 
103 Keyboard 
104 Chair 
Electronics 
Furniture 
105 Table 
106 Pen 
Furniture 
Stationery 
Task: 
Find the category that contains the maximum number of products. 
Expected columns: 
category 
product_count 
Hint: Use GROUP BY, COUNT(), and a subquery.*/
use demo;
select * from product;

select category,count(product_id) as product_count from product group by category order by product_count desc limit 1;

/*37. Employees With No Salary Change 
Task: 
Find employees whose salary has not changed between the recorded salary periods. 
Expected columns: 
emp_id 
salary 
Hint: Compare the minimum and maximum salary for each employee.
*/
use project;
create table employee_salary_history(emp_id int,salary_date DATE,salary int);
insert into employee_salary_history(emp_id,salary_date,salary)values
(101,2025-01-01, 50000), 
(101, 2025-06-01, 50000), 
(102 ,2025-01-01, 60000),
(102, 2025-06-01, 70000), 
(103 ,2025-01-01, 55000),
(103, 2025-06-01, 55000);

select emp_id,min(salary) as salary from employee_salary_history group by emp_id 
having min(salary) = max(salary) ;

/*38. Detect Consecutive Login Days 
Table: user_logins 
user_id login_date 
101 2026-01-01 
101 2026-01-02 
101 2026-01-03 
102 2026-01-01 
102 2026-01-03 
103 2026-01-05 
103 2026-01-06 
Task: 
Find users who logged in on at least 3 consecutive days. 
Expected columns: 
user_id 
Hint: Use date functions with ROW_NUMBER() or LAG(). */
create table user_logins(user_id int,login_date DATE);
insert into user_logins(user_id,login_date) values
 (101, '2026-01-01'), 
(101, '2026-01-02' ),
(101, '2026-01-03') ,
(102, '2026-01-01' ),
(102, '2026-01-03') ,
(103, '2026-01-05' ),
(103, '2026-01-06' );

with consecutiveCTE as
(
select user_id ,row_number()
over(partition by user_id )as consecutiveDays from user_logins 
)
select user_id, consecutiveDays from consecutiveCTE where consecutiveDays >=3 ;

/*39. Find the Second Order of Each Customer
Task: 
Find the second order placed by each customer. 
Expected columns: 
customer_id 
order_id 
order_date 
amount 
Hint: Use ROW_NUMBER() and filter for 2
*/
use project;
select * from orderanalysis;
with OrderCTE as 
(
select customer_id,order_id,order_date,order_amount,
row_number() over(partition by customer_id order by customer_id) as secondorder from orderanalysis 
)
select customer_id,order_id,order_date,order_amount from OrderCTE where secondorder = 2;

/*40. Calculate Percentage Contribution of Each Department 
Table: employees 
emp_id emp_name department salary 
101 Ravi IT 60000 
102 Priya IT 80000 
103 Arun HR 50000 
104 Meena HR 70000 
105 Karthik Finance 40000 
Task: 
Calculate each department's total salary and its percentage contribution to the company's 
total salary. 
Expected columns: 
department 
department_salary 
total_company_salary
percentage_contribution 
Hint: Use a window function such as: 
SUM(salary) OVER () 
*/
use project;
select * from employee;

select 
 department,
 sum(salary) as department_salary,
 sum(sum(salary)) over() as total_company_salary,
 (sum(salary)*100.0) / sum(sum(salary)) over() as percentage_contribution from employee group by department;

/*41. Department Hierarchy — Recursive CTE
Task: 
Display the complete employee hierarchy, starting from the top-level manager. 
*/
use project;
select * from employeemanager;
with recursive employeehierarchy as
(
select *,1 as level from employeemanager
where manager_id is null
union all
select e.emp_id,e.emp_name,e.manager_id,level+1 from employeemanager e join employeehierarchy eh on
 eh.emp_id = e.manager_id
)
select * from employeehierarchy;

/*42. Find Employees Whose Salary Increased Continuously

Task: 
Find employees whose salary increased at every recorded salary change.
Expected columns: 
emp_id 
Requirement: 
Do not simply compare the first and last salary. Every intermediate salary must also increase. 
Hint: Use: 
LAG() 
and compare the current salary with the previous salary.
*/
select * from employee_salary_history;
insert into employee_salary_history (emp_id,salary_date,salary) values (102,'2025-08-01',80000),(103,'2025-07-09',4000);

select emp_id ,salary, LAG(salary)
over(partition by emp_id order by salary_date) as previous_salary from employee_salary_history;

with employeesalary as
(
select emp_id ,salary, LAG(salary)
over(partition by emp_id order by salary_date) as previous_salary from employee_salary_history
)
select distinct emp_id from employeesalary 
where  emp_id not in 
(select emp_id from employeesalary where salary <= previous_salary and previous_salary is not null);

/*43. Top 3 Customers by Revenue in Each Year 
Task: 
Calculate each customer's yearly revenue and return the top 3 customers for each year. 
Expected columns: 
year 
customer_id 
total_revenue 
rank 
Hint: First aggregate then denseran
*/
use demo;
select * from orders;

with customerrank as
(
select year(order_date) as year ,
customer_id ,
sum(order_amount) over(partition by year(order_date)) as total_revenue,
row_number() over(partition by year(order_date) order by year(order_date)) as ranking
 from orders 
 )
 select year,customer_id,total_revenue,ranking from customerrank where ranking <= 3 ;
 
 use project;
create table orderRank(order_id int primary key, customer_id int, order_date DATE, amount int);
insert into orderRank(order_id ,customer_id ,order_date ,amount) values 
(101 ,1 ,'2025-01-10', 5000 ),
(102, 2, '2025-02-15', 8000), 
(103, 1 ,'2025-03-10', 7000), 
(104 ,3, '2025-04-20', 10000), 
(105 ,2, '2026-01-15', 12000), 
(106 ,1 ,'2026-02-10', 15000); 

select * from orderRank;

with customerrank as
(
select year(order_date) as year ,
customer_id ,
sum(amount) as total_revenue
from orderRank
group by year(order_date) ,customer_id 
 ) ,
topcustomers as
 (
 select year,customer_id,total_revenue, dense_rank()
 over (partition by year order by total_revenue desc) as ranking from customerrank
 )
 select year,customer_id,total_revenue, ranking as 'rank' from topcustomers where ranking <=3 order by year desc,ranking asc;
 
 /*44. Find Missing Dates in Daily Sales
 Task: 
Find all dates where no sales record exists between the minimum and maximum sale dates.*/
 use project;
	create table daily_sales(sale_date DATE,total_sales int);
    insert into daily_sales(sale_date,total_sales) values 
('2026-01-01' ,5000),
('2026-01-02' ,7000), 
('2026-01-04',6000), 
('2026-01-06',9000);

select * from  daily_sales;
with recursive missing_date as
(
# select cast('2026-01-01' as DATE) as consecutive_date 
select min(sale_date) as consecutive_date ,
max(sale_date) as max_date from daily_Sales
union all
 select date_add(consecutive_date,interval 1 day) , max_date
 from missing_date
 where consecutive_date < max_date
) 
 select consecutive_date from missing_date where consecutive_date not in (select sale_date from daily_sales);
 
 
/*45. Find the Longest Consecutive Login Streak
Task: 
For each user, find their longest consecutive login streak. 
Expected columns: 
user_id 
longest_streak 
For example: 
101   3 
102   2 
Hint: This is a classic Gaps and Islands problem. 
Consider: 
ROW_NUMBER() 
combined with date arithmetic.
*/
use demo;
create table user_logins(user_id int,login_date DATE);
insert into user_logins(user_id,login_date) values (101 ,'2026-01-01'), 
(101,' 2026-01-02' ),
(101, '2026-01-03' ),
(101,' 2026-01-06' ),
(102,' 2026-01-01' ),
(102,' 2026-01-02' ),
(102, '2026-01-05');

 select * from user_logins;

 with rankedLogin as
 (
 select user_id, login_date,
 row_number() over(partition by user_id order by login_date asc) as rn 
 from user_logins  
 ),
 island as
 (
 select user_id,login_date ,
 date_sub(login_date ,interval rn DAY) as streak_id from rankedLogin
 ),
 streakcount as 
 (
 select user_id,streak_id,count(*) as streak_length from island group by streak_id , user_id
 )
select user_id,max(streak_length) as LongestStreak from streakcount group by user_id order by user_id;

/*
46. Customers Who Bought the Same Products 
Task: 
Find pairs of customers who purchased exactly the same set of products. 
Expected columns: 
customer_1 
customer_2 
Expected example: 
101   102 
Hint: Compare customers using: 
COUNT(DISTINCT product_id) 
and set-based aggregation.
*/
use project;
create table salesProduct (customer_id int,product_id int);
insert into salesProduct(customer_id,product_id)values 
(101 ,1), 
(101, 2), 
(101 ,3), 
(102 ,1), 
(102 ,2), 
(102, 3), 
(103 ,1), 
(103 ,2);
select * from salesProduct;
	with sales as
    (
    select customer_id,
    group_concat(distinct product_id order by product_id asc) as productList ,
    count(distinct product_id) as product_count
    from salesProduct group by customer_id 
    )

    select c1.customer_id , c2.customer_id from sales c1 join sales c2  on c1.customer_id < c2.customer_id # c1.customer_id < c2.customer_id: This prevents identical duplicates like (101, 101)
    and c1.product_count = c2.product_count and c1.productList = c2.productList;

/*47. Running Percentage of Total Sales
Table: sales 
sale_date amount 
2026-01-01 5000 
2026-01-02 10000 
2026-01-03 15000 
2026-01-04 20000 
Task: 
Calculate the running sales amount and the running percentage of total sales. 
Expected columns: 
sale_date 
amount 
running_total 
running_percentage*/

create database customerdemo;
use customerdemo;
create table sales (sale_date DATE,amount int);
insert into sales(sale_date,amount) values 
('2026-01-01' ,5000), 
('2026-01-02' ,10000 ),
('2026-01-03' ,15000 ),
('2026-01-04' ,20000 );
select * from sales;

with totalsales as 
(
select date_format(sale_date,'%b-%d')  as sale_date ,
 amount ,
 sum(amount) over() as totalamount,
 sum(amount) over(order by sale_date) as running_total 
 from sales
 )

 select sale_date,amount,running_total,concat(round(sum(running_total)*100.0 / totalamount),'%') as running_percentage 
 from totalsales group by sale_date,amount,running_total;
 
 SELECT
    date_format(sale_date,'%b-%d')  as sale_date,
    amount,
    SUM(amount) OVER ( ORDER BY sale_date) AS running_total,
    ROUND(SUM(amount) OVER (ORDER BY sale_date)* 100.0/ SUM(amount) OVER (),2) AS running_percentage
FROM sales
ORDER BY sale_date;

 /*48. Find Customers With Increasing Monthly Spending 
Table: customer_monthly_sales 
customer_id month amount 
101 January 5000 
101 February 7000 
101 March 9000 
102 January 8000 
102 February 6000 
102 March 10000 
Task: 
Find customers whose spending increased every month. 
Expected result: 
customer_id 
101 
Customer 102 should not be returned because: 
8000 → 6000 → 10000 
is not continuously increasing. 
Hint: Use LAG() and verify every current amount is greater than the previous amount.*/
create table customer_monthly_sales(customer_id int,month varchar(20),amount int);

 insert into customer_monthly_sales(customer_id,month,amount)values
 (101 ,'January', 5000), 
(101 ,'February' ,7000 ),
(101,' March', 9000), 
(102, 'January', 8000 ),
(102,' February', 6000 ),
(102,' March', 10000);

select * from customer_monthly_sales;
use customerdemo;
with salaryIncrease as
(
select customer_id ,month,amount,LAG(amount) 
over(partition by customer_id order by month(str_to_date(month,'%m')) asc) as previous_amount 
from customer_monthly_sales
)

select customer_id from salaryIncrease group by customer_id having sum(case when amount <= previous_amount then 1 else 0 end) = 0
and count(*) > 1;

/*49. Find the Median Salary
Task: 
Find the median salary of all employees. 
Expected result: 
60000
*/
use customerdemo;
create table employees(emp_id int,emp_name varchar(20),salary int);
insert into employees(emp_id,emp_name,salary)values 
(101 ,'Ravi', 40000), 
(102 ,'Priya', 50000),
(103 ,'Arun', 60000), 
(104,' Meena', 70000), 
(105 ,'Karthik' ,80000);


select * from employees;
with median as
(select salary,row_number()
over(order by salary) as rn,
count(*) over() as totalcount from employees
)
select cast(avg(salary)as signed)  as average_Salary from median 
where rn between (totalcount/2.0) and (totalcount/2.0) + 1 ;


/*50. Identify Customers With a Complete Purchase Sequence
Task: 
Find customers who placed at least 3 orders, and display the first order date, last order date, and 
number of days between them. 
Expected columns: 
customer_id 
customer_name 
order_count 
first_order_date 
last_order_date 
days_between_orders
*/
use project;
select * from orderanalysis;
select * from customers;

select c.cust_id,c.cust_name, count(o.order_id) as order_count, min(o.order_Date) as first_order_date,
max(o.order_Date) as last_order_date, datediff(max(o.order_Date) ,min(o.order_Date) )as days_between_orders 
from customers c join orderanalysis o on c.cust_id = o.customer_id 
group by c.cust_id,c.cust_name having count(o.customer_id) >= 2;

