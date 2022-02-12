CREATE DATABASE BAC_LATAM_SALARIES
USE BAC_LATAM_SALARIES

---------------------------------------------------------------------------------RESPUESTA SEGÚN PREGUNTA
CREATE TABLE [dbo].[employees](
	[department_name] [varchar](100) NOT NULL,
	[employee_id] [decimal](18,0) UNIQUE NOT NULL,
	[employee_name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_employees] PRIMARY KEY CLUSTERED (
	[employee_id] ASC,
	[employee_name] ASC
)) ON [PRIMARY]


INSERT INTO [employees](department_name,employee_id,employee_name)
SELECT 'Sales',123,'Jhon Doe'
UNION ALL
SELECT 'Sales',211,'Jane Smith'
UNION ALL
SELECT 'HR',556,'Billy Bob'
UNION ALL
SELECT 'Sales',711,'Robert Hayek'
UNION ALL
SELECT 'Marketing',235,'Edward Jorgson'
UNION ALL
SELECT 'Marketing',236,'Christine Packard'

SELECT * FROM [employees]

CREATE TABLE [dbo].[salaries](
	[salary] [money] NOT NULL,
	[employee_id] [decimal](18,0) NOT NULL,
	[employee_name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_salaries] PRIMARY KEY CLUSTERED (
	[employee_id] ASC,
	[employee_name] ASC
)) ON [PRIMARY]

ALTER TABLE [dbo].[salaries]  WITH CHECK ADD  CONSTRAINT [FK_salaries_employees] FOREIGN KEY([employee_id],[employee_name])
REFERENCES [dbo].[employees] ([employee_id],[employee_name])

SELECT * 
FROM [salaries]

INSERT INTO [salaries](salary,employee_id,employee_name)
SELECT 500,123,'Jhon Doe'
UNION ALL
SELECT 600,211,'Jane Smith'
UNION ALL
SELECT 1000,556,'Billy Bob'
UNION ALL
SELECT 400,711,'Robert Hayek'
UNION ALL
SELECT 1200,235,'Edward Jorgson'
UNION ALL
SELECT 200,236,'Christine Packard'

SELECT EMP.department_name,AVG(salary) AS average
FROM salaries AS SAL
INNER JOIN employees EMP
	ON SAL.employee_id = EMP.employee_id
	AND SAL.employee_name = EMP.employee_name
WHERE 1 = 1
GROUP BY EMP.department_name
HAVING AVG(salary) < 500
ORDER BY average DESC
---------------------------------------------------------------------------------RESPUESTA SEGÚN PREGUNTA

---------------------------------------------------------------------------------RESPUESTA CON TABLAS NORMALIZADAS
CREATE TABLE [dbo].[departments](
	[department_id] [integer] IDENTITY(1,1) NOT NULL,
	[department_name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_departments] PRIMARY KEY CLUSTERED (
	[department_id] ASC
)) ON [PRIMARY]

INSERT INTO [departments](department_name)
SELECT 'Sales'
UNION ALL
SELECT 'HR'
UNION ALL
SELECT 'Marketing'

CREATE TABLE [dbo].[employees_2](
	[department_id] [integer] NOT NULL,
	[employee_id] [decimal](18,0) UNIQUE NOT NULL,
	[employee_name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_employees_2] PRIMARY KEY CLUSTERED (
	[employee_id] ASC
)) ON [PRIMARY]

ALTER TABLE [dbo].[employees_2]  WITH CHECK ADD  CONSTRAINT [FK_employees_2_departments] FOREIGN KEY ([department_id])
REFERENCES [dbo].[departments] ([department_id])

INSERT INTO employees_2(department_id,employee_id,employee_name)
SELECT 1,123,'John Doe'
UNION ALL
SELECT 1,211,'Jane Smith'
UNION ALL
SELECT 2,556,'Billy Bob'
UNION ALL
SELECT 1,711,'Robert Hayek'
UNION ALL
SELECT 3,235,'Edward Jorgson'
UNION ALL
SELECT 3,236,'Christine Packard'

CREATE TABLE [dbo].[salaries_2](
	[salary] [money] NOT NULL,
	[employee_id] [decimal](18,0) NOT NULL,
 CONSTRAINT [PK_salaries_2] PRIMARY KEY CLUSTERED (
	[employee_id] ASC,
	[salary] ASC
)) ON [PRIMARY]

ALTER TABLE [dbo].[salaries_2]  WITH CHECK ADD  CONSTRAINT [FK_salaries_2_employees_2] FOREIGN KEY ([employee_id])
REFERENCES [dbo].[employees_2] ([employee_id])

INSERT INTO salaries_2(salary,employee_id)
SELECT 500,123
UNION ALL
SELECT 600,211
UNION ALL
SELECT 1000,556
UNION ALL
SELECT 400,711
UNION ALL
SELECT 1200,235
UNION ALL
SELECT 200,236

SELECT DEP.department_id,DEP.department_name,AVG(SAL.salary) AS average
FROM salaries_2 AS SAL
INNER JOIN employees_2 AS EMP
	ON SAL.employee_id = EMP.employee_id
INNER JOIN departments AS DEP
	ON EMP.department_id = DEP.department_id
WHERE 1 = 1
GROUP BY DEP.department_id,DEP.department_name
HAVING AVG(salary) < 500
ORDER BY average DESC
---------------------------------------------------------------------------------RESPUESTA CON TABLAS NORMALIZADAS