
                       /* SQL queries from OHMDB database */

-- [Create the OHMDB database first and then execute this script. ]

USE OHMDB
GO

--1. CASE
SELECT  e.[Employee ID],et.[empType],ed.designation,ed.salary,e.Age,
		
		CASE
			WHEN  ed.salary > 20000
				THEN  'High paid'
			WHEN  ed.salary <= 20000 AND ed.salary > 10000
				THEN  'Medium paid'
			WHEN  ed.salary <=10000
				THEN  'Low paid'
		END	AS [Salary Status]	
		
FROM    ohms.tbl_Employees e

INNER JOIN [ohms].[tbl_EmployeeDesignation] ed ON e.Designation = ed.dID
LEFT JOIN  [ohms].[tbl_EmployeeType] et ON e.[Employee Type] = et.typeID

WHERE et.[typeID] = 1
GO

select * from ohms.tbl_Employees
select * from ohms.tbl_EmployeeType

--2. CTE [Two CTEs on tbl_Resident, tbl_Buildings and tbl_MedicalRecord and a query that uses them ]

WITH residentInfo1  AS
(
	SELECT	r.[Resident ID],
			r.FName+r.LName AS [Name],
			r.LName ,
			r.Age,
			g.gName AS Gender,
			b.[Building Name]
			
	FROM ohms.tbl_Resident r 
	JOIN [ohms].[tbl_Gender] g ON r.Gender = g.gID
	JOIN ohms.tbl_Buildings b ON r.Gender = b.[Assigned for]

	WHERE r.Age BETWEEN 70 AND 80
),
	 residentInfo2  AS
(
	SELECT	r.[Resident ID],
			mr.[Entry Date] AS [Medical Entry Date],
			mr.[Health Issue],
			mr.[Release Date],
			DATEDIFF(DAY,mr.[Entry Date],mr.[Release Date]) AS 'Staying total Day'

	FROM ohms.tbl_Resident r 
	JOIN ohms.tbl_MedicalRecord mr ON r.[Resident ID] = mr.[Resident ID]
)
	SELECT  ri1.[Name], 
			ri1.Age,
			ri1.Gender,
			ri1.[Building Name],
			ri2.[Medical Entry Date],
			ri2.[Health Issue],
			ri2.[Medical Entry Date],
			ri2.[Release Date],
			ri2.[Staying total Day]

	FROM residentInfo1  ri1 
	JOIN residentInfo2  ri2 ON ri1.[Resident ID] = ri2.[Resident ID]

GO
	
--3. SELECT INTO statement [creates a new table tbl_ResidentCopy As a copy of tbl_Resident]

SELECT  
		[Resident ID],
		[Entry Date],
		[FName]+' '+[LName] AS [Name],
		[Gender],
		[Date Of Birth],
		[Religion],
		[Blood Group],
		[Marital Status],
		[No.Of Children],
		[Permanent Address],
		[Room No.],
		[Building No.],
		[Age]
INTO 
		ohms.tbl_ResidentCopy  
FROM 
		ohms.tbl_Resident
GO

--4.EXCEPT
SELECT [Permanent Address] FROM ohms.tbl_Resident
EXCEPT
SELECT [Address] FROM ohms.tbl_Visitors
GO

--5.UNION
SELECT [Permanent Address] FROM ohms.tbl_Resident
UNION 
SELECT [Address] FROM ohms.tbl_Visitors
GO

--6.INTERSECT
SELECT [Permanent Address] FROM ohms.tbl_Resident
INTERSECT 
SELECT [Address] FROM ohms.tbl_Visitors
GO

--7.MERGE
MERGE ohms.tbl_ResidentCopy   rc  --target        --[ohms].[tbl_ResidentBackup]     
USING ohms.tbl_Resident r  --source				  --has been created as a copy of 
ON r.[Resident ID] = rc.[Resident ID]			  --[ohms].[tbl_Resident] table .
	
	WHEN MATCHED THEN
		UPDATE SET
			rc.[Entry Date]	       = r.[Entry Date], 
			rc.[Name]              = r.[FName]+' '+r.[LName] ,						
			rc.[Gender]	           = r.[Gender],
			rc.[Date Of Birth]     = r.[Date Of Birth],
			rc.[Religion]          = r.[Religion],
			rc.[Blood Group]       = r.[Blood Group],
			rc.[Marital Status]    = r.[Marital Status],
			rc.[No.Of Children]	   = r.[No.Of Children],
			rc.[Permanent Address] = r.[Permanent Address],
			rc.[Room No.]          = r.[Room No.],
			rc.[Building No.]      = r.[Building No.],
			rc.[Age]               = r.[Age]

	WHEN NOT MATCHED BY TARGET THEN
		INSERT 
			(
				[Entry Date],[Name],[Gender],[Date Of Birth],[Religion],[Blood Group],[Marital Status],[No.Of Children],[Permanent Address],[Room No.],[Building No.],[Age]
			)
		VALUES
			(
				r.[Entry Date],r.[FName]+' '+r.[LName],r.[Gender],r.[Date Of Birth],r.[Religion],r.[Blood Group],r.[Marital Status],r.[No.Of Children],r.[Permanent Address],r.[Room No.],r.[Building No.],r.[Age]
			)

	--WHEN NOT MATCHED BY SOURCE THEN 
	--	DELETE
;

--8. Use of AGGREGATE FUNCTIONS [A query that find out the total number of muslim employees using COUNT function]
                              
SELECT 
	COUNT([Employee ID]) AS 'Total Muslim Employees'
FROM 
	ohms.tbl_Employees
WHERE
	Religion = 1
GO

select * from ohms.tbl_Religion

           --[ A simple query to find out residents whose blood group is A+ ]
SELECT  
	r.[Resident ID],
	r.[FName]+' '+r.[LName] AS 'Name',
	bg.[bgName] AS 'Blood Group',
	g.gName AS 'Gender',
	Age
FROM 
	ohms.tbl_Resident r 
INNER JOIN 
	[ohms].[tbl_BloodGroup] bg ON r.[Blood Group] = bg.bgID
INNER JOIN 
	[ohms].[tbl_Gender] g ON r.Gender = g.gID
WHERE 
	[Blood Group] = 1
ORDER BY 
	[Resident ID]
GO

--[A query that find out the month and year wise total  expense using SUM function] 
					      
SELECT 
	[Year],
	[Month],
	SUM([Food Expense]) AS 'Total Food Expense',
	SUM([Transportation Expense]) AS 'Total Transportation Cost',
	SUM([Medication Cost]) AS 'Total Medication Cost',
	SUM([Utility Cost]) AS 'Total Utility Cost',
	SUM([Miscellaneous]) AS 'Total Miscellaneous Cost'
FROM 
	[ohms].[tbl_MonthlyExpenseRecord]
WHERE 
	[Year] = 2022 AND
	[Month] = 4
GROUP BY 
	[Year],
	[Month]
GO

--[A query that find out the Average yearly expense using AVG function]
					       
SELECT 
	AVG([Food Expense]) AS 'Average Food Cost'
FROM 
	[ohms].[tbl_MonthlyExpenseRecord]
GO

                      /* A query that uses MIN and MAX function*/

SELECT	
	MAX(Age) AS 'Maximum Age of Employees',
	MIN(Age) AS 'Minimum Age of Employees'
FROM 
	ohms.tbl_Employees
GO

--9. IN and NOT IN
                /* A query that uses IN and NOT IN operator */

SELECT	
		e.[Employee ID],
		e.[FName],
		e.[LName],
		e.Age,
		g.gName AS Gender,
		ed.designation AS Designation,
		ed.salary,
		e.[Joining Date],
		e.[Present Address],
		e.[Permanent Address]

FROM 
		ohms.tbl_Employees  e
INNER JOIN
		[ohms].[tbl_Gender] g ON e.Gender = g.gID
INNER JOIN 
		[ohms].[tbl_EmployeeDesignation] ed ON e.Designation = ed.dID

WHERE	
		[Permanent Address] IN (SELECT [Permanent Address] 
								FROM ohms.tbl_Resident) AND 
	    [Permanent Address] NOT IN (SELECT [Permanent Address] 
									FROM ohms.tbl_Visitors)
GO

-- TOP,PERCENT and WITH TIES operator
                       /* A query that uses TOP clause ,PERCENT 
					             and WITH TIES clause */

SELECT TOP 5 PERCENT WITH TIES
		e.[Employee ID],
		e.[FName],
		e.[LName],
		e.[Age],
		et.empType AS  [Employee Type],
		ed.designation AS  [Designation],
		ed.salary AS [Salary],
		e.[Date Of Birth],
		g.gName AS [Gender],
		e.[Joining Date],
		e.[Contact No.]

FROM 
		ohms.tbl_Employees  e
INNER JOIN
		[ohms].[tbl_Gender] g ON e.Gender = g.gID
INNER JOIN 
		[ohms].[tbl_EmployeeDesignation] ed ON e.Designation = ed.dID
INNER JOIN 
		[ohms].[tbl_EmployeeType] et ON e.[Employee Type] = et.typeID
		
ORDER BY 
		ed.salary DESC
GO

--10.FETCH and OFFSET clause

SELECT 
		e.[Employee ID],
		e.[FName],
		e.[LName],
		e.[Age],
		et.empType AS  [Employee Type],
		ed.designation AS  [Designation],
		ed.salary AS [Salary],
		e.[Date Of Birth],
		g.gName AS [Gender],
		e.[Joining Date],
		e.[Contact No.]

FROM 
		ohms.tbl_Employees  e
INNER JOIN
		[ohms].[tbl_Gender] g ON e.Gender = g.gID
INNER JOIN 
		[ohms].[tbl_EmployeeDesignation] ed ON e.Designation = ed.dID
INNER JOIN 
		[ohms].[tbl_EmployeeType] et ON e.[Employee Type] = et.typeID
ORDER BY 
		ed.salary DESC

		OFFSET 5 ROWS
		FETCH NEXT 5 ROWS ONLY
GO

--11. GROUP BY and HAVING clause

SELECT 
		[Year] AS 'Year',
		[Month] AS 'Month',
		SUM([Medication Cost]) AS 'Total Medication Cost'
FROM 
		 [ohms].[tbl_MonthlyExpenseRecord]
GROUP BY 
		[Year],[Month]
HAVING 
		[Month] = 4
GO

--12. PARTITION BY and ORDER BY clause

SELECT	
		[Month],
		[Year],
		SUM([Food Expense]) OVER(PARTITION BY [Month] ORDER BY [Month]) AS 'Total Food Cost',
		AVG([Food Expense]) OVER(PARTITION BY [Month] ORDER BY [Month]) AS 'Average Food Cost'
FROM 
		[ohms].[tbl_MonthlyExpenseRecord]
GROUP BY 
		[Month],
		[Year],
		[Food Expense]
GO

--13. DISTINCT clause

SELECT DISTINCT 
	[Permanent Address] AS 'District'
FROM 
	[ohms].[tbl_Employees]
GO

--14. ALL,SOME, ANY keyword

SELECT	ALL
		e.[Employee ID],
		e.[FName],
		e.[LName],
		e.[Age],
		ed.designation AS [Designation],
		ed.salary AS [Salary],
		g.gName AS [Gender],
		e.[Joining Date]
FROM 
		ohms.tbl_Employees  e
INNER JOIN
		[ohms].[tbl_Gender] g ON e.Gender = g.gID
INNER JOIN 
		[ohms].[tbl_EmployeeDesignation] ed ON e.Designation = ed.dID
WHERE 
		[Present Address] = ANY (SELECT [Address] 
								 FROM ohms.tbl_Visitors) OR
		[Permanent Address] = SOME (SELECT [Permanent Address] 
								 FROM [ohms].[tbl_Resident])
GO

--15. EXISTS operator
SELECT	
		[Employee ID],
		[FName],
		[LName],
		[Age],
		[Joining Date]
FROM 
		[ohms].[tbl_Employees]
WHERE NOT EXISTS 
		(SELECT * FROM ohms.tbl_Resident
		WHERE ohms.tbl_Resident.Age < [ohms].[tbl_Employees].Age)
GO

--16. GROUPING SETS
SELECT  
	[Permanent Address] AS 'Resident District',
	[Religion],
	COUNT([Resident ID]) AS 'Number of Residents' 
FROM 
	ohms.tbl_Resident
WHERE 
	[Permanent Address] IN ('Barisal','Rajshahi')
GROUP BY GROUPING SETS
	([Permanent Address],[Religion],([Permanent Address],[Religion]),())
ORDER BY 
	[Permanent Address] DESC
GO

--17. CUBE
SELECT	
		COALESCE(e.[Permanent Address],'District Wise') AS EmpDistrict,
		COALESCE(g.gName,'gender wise'),
		COALESCE(CAST(ed.salary AS VARCHAR),'Salary wise'),
		COUNT(e.[Employee ID]) AS 'Number of Employees'
FROM 
		ohms.tbl_Employees  e
INNER JOIN
		[ohms].[tbl_Gender] g ON e.Gender = g.gID
INNER JOIN 
		[ohms].[tbl_EmployeeDesignation] ed ON e.Designation = ed.dID
WHERE 
		ed.salary > 10000 AND
		[Permanent Address] IN ('Feni','Barisal','Sylhet')
GROUP BY CUBE
		(e.[Permanent Address],g.gName,ed.salary)
ORDER BY 
		COUNT(e.[Employee ID]) DESC
GO

--18. ROLLUP
SELECT	
		COALESCE(e.[Permanent Address],'District Wise') AS EmpDistrict,
		COALESCE(g.gName,'gender wise'),
		COUNT(e.[Employee ID]) AS 'Number of Employees'
FROM
		ohms.tbl_Employees e
INNER JOIN 
		[ohms].[tbl_Gender] g ON e.Gender = g.gID
WHERE 
		e.[Permanent Address] IN ('Feni','Barisal','Sylhet')
GROUP BY CUBE
		(e.[Permanent Address],g.gName)
ORDER BY 
		COUNT(e.[Employee ID]) DESC
GO

--19. LEFT OUTER JOIN 
SELECT  
		rd.[Building No.],
		rd.RoomID,
		f.FurnitureID,
		f.[Name],
		b.[Building Name],
		g.gName AS Gender

FROM ohms.tbl_RoomDetails rd 
LEFT OUTER JOIN ohms.tbl_Furniture f ON rd.RoomID = f.RoomID
LEFT OUTER JOIN ohms.tbl_Buildings b ON f.[Building No.] = b.[Building No.]
LEFT OUTER JOIN ohms.tbl_Gender g ON b.[Assigned for] = g.gID

WHERE rd.RoomID BETWEEN 501 AND 509
GO

--20. RIGHT OUTER JOIN
SELECT  
		rd.[Building No.],
		rd.RoomID,
		f.FurnitureID,
		f.[Name],
		g.gName AS 'Assigned For',
		b.[Building Name]
		
FROM ohms.tbl_Furniture f
RIGHT OUTER JOIN ohms.tbl_RoomDetails rd ON rd.RoomID = f.RoomID
RIGHT OUTER JOIN ohms.tbl_Buildings b ON f.[Building No.] = b.[Building No.]
RIGHT OUTER JOIN ohms.tbl_Gender g ON g.gID = b.[Assigned for]

WHERE b.[Building No.] IN (50011,70011) AND
	  rd.RoomID BETWEEN 701 AND 709
GO

--21. FULL OUTER JOIN
SELECT  
		fmr.[Date],
		r.[Resident ID],
		r.[FName]+' '+r.LName AS 'Name',
		fmr.[Have Breakfast],
		fmr.[Have Midsnack1],
		fmr.[Have Lunch],
		fmr.[Have Midsnack2],
		fmr.[Have Supper],
		fmr.[Have Medication]
FROM 
		ohms.tbl_Resident r 

FULL OUTER JOIN [ohms].[tbl_FoodMedicationRecord] fmr
ON r.[Resident ID] = fmr.ResidentID
WHERE  fmr.[Date] = '2022-05-30'
GO

--22. CROSS JOIN
SELECT  
		f.FurnitureID,
		f.[Name],
		b.[Building Name],
		b.[Assigned for]
FROM 
		ohms.tbl_Furniture f
CROSS JOIN 
		ohms.tbl_Buildings b  
GO

--23. CAST,CONVER and TRY_CONVERT
SELECT	
		CAST( [Month] AS VARCHAR) AS [Month],
		CAST([Year] AS VARCHAR) AS 'Year',
		CONVERT(VARCHAR,[Transportation Expense],1) AS 'Transportation Cost',
		CONVERT(FLOAT,[Medication Cost],1) AS 'Medication Cost',
		TRY_CONVERT(VARCHAR,[Miscellaneous],107) AS 'Miscellaneous Expenses'

FROM 
		[ohms].[tbl_MonthlyExpenseRecord]
GO

--24. BUILT IN FUNCTIONS
SELECT	
	[FName]+' '+LName  AS 'Full Name',
	LEFT([FName]+' '+LName,CHARINDEX(' ',[FName]+' '+LName)-1) AS 'First Name' ,
	RIGHT([FName]+' '+LName,LEN([FName]+' '+LName)-CHARINDEX(' ',[FName]+' '+LName)) AS 'Last Name',
	STR(Age) AS Age,
	YEAR([Joining Date]) AS 'Joining Year',
	DATENAME(MONTH,[Joining Date])AS 'Joining Month',
	DATENAME(DAY,[Joining Date]) AS 'Joining Date',
	DATENAME(WEEKDAY,[Joining Date]) AS 'Joining Day'
FROM 
	ohms.tbl_Employees 
GO

--25. RANKING FUNCTIONS
SELECT 
		e.[Employee ID],
		e.[FName],
		e.[LName],
		ed.designation AS [Designation],
		ed.salary AS [Salary],
		ROW_NUMBER() OVER (ORDER BY ed.salary) AS 'Row Number',
		RANK() OVER (ORDER BY ed.salary) AS 'Rank',
		DENSE_RANK() OVER (ORDER BY ed.salary) AS 'Dense Rank',
		NTILE(3) OVER (ORDER BY ed.salary) AS 'Ntile'
FROM 
		ohms.tbl_Employees e 
INNER JOIN 
		[ohms].[tbl_EmployeeDesignation] ed ON e.Designation = ed.dID
GO

--26. TRY CATCH
BEGIN TRY
		INSERT INTO [ohms].[tbl_Transport]([TransportID],[Type],[DriverID])
		VALUES('T000005','Ambulance',1021)
END TRY
BEGIN CATCH
		RAISERROR('Invalid Entry !!',10,1)
END CATCH
GO

--27. IF....ELSE
DECLARE @age INT
		SET @age = 45
	IF @age >= 60
	BEGIN
		PRINT 'Eligible for staying in Old Home.'
	END
	ELSE 
	BEGIN
		PRINT 'Age must be 60 or above to stay in Old Home.'
		RAISERROR('Invalid Age',10,1)
	END
	GO

--28. WHILE LOOP
DECLARE @number INT
	SET @number = 20
		WHILE @number <= 100
			BEGIN
				PRINT 'Current Number is: '+STR(@number)
				
				IF @number = 70
				BREAK
		
				SET @number = @number + 1

			END
	GO

--29. GOTO
DECLARE @time TIME
	SET @time = '10:00:00'

	IF @time BETWEEN '09:00:00' AND '13:00:00'
	GOTO Batch1

	IF @time BETWEEN '13:00:00' AND '19:00:00'
	GOTO Batch2

	Batch1: 
			PRINT 'Morning Batch'
			PRINT 'Time: 9 AM to 1 PM'
			PRINT 'Duration : 4 hours'
			RETURN
	Batch2:
			PRINT 'Evening Batch'
			PRINT 'Time: 1PM to 7 PM'
			PRINT 'Duration : 4 hours'
			RETURN
	GO

--30. WAITFOR
SELECT GETDATE()  AS 'Current Time'
	WAITFOR DELAY '00:00:02'
	SELECT GETDATE()  AS 'Current Time'
	GO

--31. Correlated subquery
SELECT  [Resident ID],
			Gender,
			Age
			
	FROM [ohms].[tbl_Resident] AS res1
	WHERE Age < (SELECT MAX(Age) FROM [ohms].[tbl_Resident] AS res2 
					WHERE res2.[Age] > res1.[Age] )

	ORDER BY [Resident ID],Age
	GO

	
