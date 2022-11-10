-- Baseline of Overall Employee Satisfaction at Company X

SELECT Age, Department, JobRole, JobSatisfaction, YearsInCurrentRole
FROM `HR_Employee_Attrition.HR_Employee_Data`
ORDER BY Age asc


-- Comparison of Salary between TotalWorkingYears and YearsAtCompany

SELECT Age, Department, JobRole, HourlyRate, MonthlyRate, MonthlyIncome, YearsAtCompany, TotalWorkingYears
FROM `HR_Employee_Attrition.HR_Employee_Data`
ORDER BY MonthlyIncome desc

-- Department with the Highest Total MonthlyIncome

SELECT Department, SUM(MonthlyIncome) as TotalDepartmentPay
FROM `HR_Employee_Attrition.HR_Employee_Data`
GROUP BY Department
ORDER BY TotalDepartmentPay desc

-- MonthlyIncome by Gender, JobRole, and Department (OverTime indicated)

SELECT Department, JobRole, Gender, HourlyRate, MonthlyIncome, OverTime
FROM `HR_Employee_Attrition.HR_Employee_Data`
ORDER BY MonthlyIncome desc

-- Correlation between TrainingTimesLastYear to PerformanceRating and PercentSalaryHike

SELECT Department, JobRole, JobInvolvement, TrainingTimesLastYear, PerformanceRating, PercentSalaryHike,
FROM `HR_Employee_Attrition.HR_Employee_Data`
ORDER BY TrainingTimesLastYear desc

-- Relationship betweek Age, YearsAtCompany, TotalWorkingYears, PercentSalaryHike, and MonthlyIncome

SELECT Age, YearsAtCompany, TotalWorkingYears, PercentSalaryHike, MonthlyIncome
FROM `HR_Employee_Attrition.HR_Employee_Data`
ORDER BY Age desc

-- Breakdown of DistanceFromHome by JobRole and Attrition

SELECT JobRole, DistanceFromHome, Attrition
FROM `HR_Employee_Attrition.HR_Employee_Data`
ORDER BY DistanceFromHome asc

-- Average MonthlyIncome by Education

SELECT Education, AVG(MonthlyIncome) as AverageMonthlyIncome
FROM `HR_Employee_Attrition.HR_Employee_Data`
GROUP BY Education
