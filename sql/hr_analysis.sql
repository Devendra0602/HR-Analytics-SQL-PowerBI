-- =========================================
-- HR Analytics Project
-- Tool: SQL Server
-- Dataset: IBM HR Analytics
-- =========================================

CREATE DATABASE HR_Analytics;
USE HR_Analytics;

-- =========================================
-- Employee Table
-- =========================================
CREATE TABLE HR_Employees (
    Age INT,
    Attrition VARCHAR(10),
    BusinessTravel VARCHAR(50),
    DailyRate INT,
    Department VARCHAR(50),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(50),
    EmployeeCount INT,
    EmployeeNumber INT,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(10),
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(50),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(20),
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    Over18 VARCHAR(5),
    OverTime VARCHAR(5),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);

-- =========================================
-- Basic Data Checks
-- =========================================
SELECT COUNT(*) AS TotalRows 
FROM HR_Employees;

SELECT TOP 5 * 
FROM HR_Employees;

-- =========================================
-- Key HR Metrics
-- =========================================
SELECT COUNT(*) AS Total_Employees
FROM HR_Employees;

SELECT COUNT(*) AS Attrition_Count
FROM HR_Employees
WHERE Attrition = 'Yes';

-- =========================================
-- Gender Distribution
-- =========================================
SELECT 
    Gender,
    COUNT(*) AS Employee_Count
FROM HR_Employees
GROUP BY Gender;

-- =========================================
-- Salary Analysis
-- =========================================
SELECT AVG(MonthlyIncome) AS Avg_Monthly_Income
FROM HR_Employees;

SELECT 
    JobRole,
    AVG(MonthlyIncome) AS Avg_Monthly_Income
FROM HR_Employees
GROUP BY JobRole
ORDER BY Avg_Monthly_Income DESC;

-- =========================================
-- Base View for Power BI
-- Adds Age Groups and Attrition Flag
-- =========================================
CREATE VIEW vw_HR_Base AS
SELECT *,
       CASE 
           WHEN Age < 25 THEN 'Under 25'
           WHEN Age < 35 THEN '25-34'
           WHEN Age < 45 THEN '35-44'
           WHEN Age < 55 THEN '45-54'
           ELSE '55+'
       END AS Age_Group,
       CASE 
           WHEN Attrition = 'Yes' THEN 1 ELSE 0 
       END AS Attrition_Flag
FROM HR_Employees;

-- =========================================
-- KPI Calculation Using Base View
-- =========================================
SELECT 
    COUNT(*) AS Total_Employees,
    SUM(Attrition_Flag) AS Attrition_Count,
    (SUM(Attrition_Flag) * 100.0 / COUNT(*)) AS Attrition_Rate
FROM vw_HR_Base;

-- =========================================
-- Department-wise Attrition
-- =========================================
SELECT 
    Department,
    COUNT(*) AS Total_Employees,
    SUM(Attrition_Flag) AS Attrition_Count
FROM vw_HR_Base
GROUP BY Department;

-- =========================================
-- Age Group-wise Attrition
-- =========================================
SELECT 
    Age_Group,
    COUNT(*) AS Total_Employees,
    SUM(Attrition_Flag) AS Attrition_Count
FROM vw_HR_Base
GROUP BY Age_Group
ORDER BY Age_Group;

-- =========================================
-- Views Used Directly in Power BI
-- =========================================
CREATE VIEW vw_HR_KPIs AS
SELECT 
    COUNT(*) AS Total_Employees,
    SUM(Attrition_Flag) AS Attrition_Count,
    CAST(SUM(Attrition_Flag) * 1.0 / COUNT(*) AS DECIMAL(6,4)) AS Attrition_Rate,
    CAST(AVG(MonthlyIncome) AS INT) AS Avg_Monthly_Income
FROM vw_HR_Base;

CREATE VIEW vw_Attrition_By_Department AS
SELECT 
    Department,
    COUNT(*) AS Total_Employees,
    SUM(Attrition_Flag) AS Attrition_Count
FROM vw_HR_Base
GROUP BY Department;

CREATE VIEW vw_AgeGroup_Attrition AS
SELECT 
    Age_Group,
    COUNT(*) AS Total_Employees,
    SUM(Attrition_Flag) AS Attrition_Count
FROM vw_HR_Base
GROUP BY Age_Group;

-- =========================================
-- View Validation
-- =========================================
SELECT * FROM vw_HR_KPIs;
SELECT * FROM vw_Attrition_By_Department;
SELECT * FROM vw_AgeGroup_Attrition;
