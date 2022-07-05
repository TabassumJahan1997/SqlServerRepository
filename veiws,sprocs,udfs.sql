
/* Create the OHMDB database and tables first and then execute this script. */

USE OHMDB
GO


-----------------/* Create View */-----------------------
/* A view that shows Resident details by joining  different tables */

CREATE VIEW ohms.vResidentDetails
WITH ENCRYPTION,SCHEMABINDING
AS
	SELECT  r.[Resident ID],
			r.[Entry Date],
			r.FName AS FirstName,
			r.LName AS LastName,
			r.Age,
			g.gName AS gender,
			r.[Date Of Birth],
			rn.rName AS Religion,
			bg.bgName AS BloodGroup,
			ms.mStatus AS MaritalStatus,
			r.[No.Of Children],
			r.[Permanent Address],
			r.[Room No.],
			r.[Building No.]

	FROM	ohms.tbl_Resident r
	
	JOIN    ohms.tbl_Gender g ON r.Gender = g.gID
	LEFT JOIN	ohms.tbl_Religion rn ON r.Religion = rn. rID
	LEFT JOIN	ohms.tbl_BloodGroup bg ON r.[Blood Group] = bg.bgID
	LEFT JOIN	ohms.tbl_MaritalStatus ms ON r.[Marital Status] = ms.mID
GO

--test VIEW ohms.vResidentDetails 

SELECT	[Resident ID],
		[Entry Date],
		FirstName,
		LastName,
		Age,
		gender,
		[Date Of Birth],
		Religion,
		BloodGroup,
		MaritalStatus,
		[No.Of Children],
		[Permanent Address],
		[Room No.],
		[Building No.]
FROM ohms.vResidentDetails
GO

/* A view that shows category wise total expenses in 2022  */
CREATE VIEW vYearlyTotalExpenses
AS
SELECT	
		[Year],
		SUM([Food Expense]) AS 'Total Food Cost',
		SUM([Transportation Expense]) AS 'Total Transportation Cost',
		SUM([Medication Cost]) AS 'Total Medication Cost',
		SUM([Utility Cost]) AS 'Total Utility Cost',
		SUM([Miscellaneous]) AS 'Total Miscellaneous Cost'
FROM 
		ohms.tbl_MonthlyExpenseRecord
WHERE 
		[Year] = 2022
GROUP BY 
		[Year]
GO

-- test VIEW vYearlyTotalExpenses 

SELECT * FROM vYearlyTotalExpenses
GO


/* A view that INSERTS data into the base table .*/
CREATE VIEW vInsertMonthlyExpenseRecord
AS
	SELECT  
			[Month],
			[Year],
			[Food Expense],
			[Transportation Expense],
			[Medication Cost],
			[Utility Cost],
			[Miscellaneous]
	FROM 
			[ohms].[tbl_MonthlyExpenseRecord]
GO

--test VIEW vInsertMonthlyExpenseRecord 

 INSERT INTO  vInsertMonthlyExpenseRecord 
	
([Month],[Year],[Food Expense],[Transportation Expense],[Medication Cost],[Utility Cost],[Miscellaneous]) 
	
	VALUES
			(11,2021,450000,7500,150000,40000,5000),
			(12,2021,500000,7500,150000,40000,3000),
			(10,2021,450000,10000,150000,40000,2000)
			
	GO

       -------/* Create Stored Procedure (Insert, Delete, Update) */------
                        /* A procedure(without parameter) 
	             that will show Employee Details from tbl_Employee 
			            whose Employee type is Permanent */

CREATE PROC ohms.sp_EmployeeDetails
WITH ENCRYPTION
AS
	SELECT  
			e.[Employee ID],
			e.[FName],
			e.[LName],
			et.empType,
			ed.designation,
			ed.salary,
			g.gName,
			r.rName,
			bg.bgName,
			e.Age,
			e.[Joining Date],
			e.[Contact No.]

	FROM ohms.tbl_Employees e
	JOIN ohms.tbl_EmployeeType et ON e.[Employee Type] = et.typeID
	LEFT JOIN ohms.tbl_EmployeeDesignation ed ON e.Designation = ed.dID
	LEFT JOIN ohms.tbl_Gender g ON e.Gender = g.gID
	LEFT JOIN ohms.tbl_Religion r ON e.Religion = r.rID
	LEFT JOIN ohms.tbl_BloodGroup bg ON e.[Blood Group] = bg.bgID

	WHERE et.empType = 'Permanent'
GO

--test Stored Procedure ohms.sp_EmployeeDetails

EXEC ohms.sp_EmployeeDetails
GO

					    /* A procedure(with parameter) 
					that will INSERT data into tbl_Resident  */

CREATE PROC ohms.sp_ResidentInsert @entrydate DATE,
								   @fname NVARCHAR(40),
								   @lname NVARCHAR(40),
								   @gender INT,
								   @dob DATE,
								   @religion INT,
								   @bloodgroup INT,
								   @maritalstatus INT,
								   @children INT,
								   @permanentaddress NVARCHAR(20),
								   @room INT,
								   @building INT
AS
BEGIN
	INSERT INTO ohms.tbl_Resident
	([Entry Date],[FName],[LName],[Gender],[Date Of Birth],[Religion],[Blood Group],[Marital Status],[No.Of Children],[Permanent Address],[Room No.],[Building No.])
	VALUES(@entrydate,@fname,@lname,@gender,@dob,@religion,@bloodgroup,@maritalstatus,@children, @permanentaddress,@room,@building)
END
GO

--test Stored Procedure ohms.sp_ResidentInsert 

	EXEC ohms.sp_ResidentInsert @entrydate = '2021-07-13',
								@fname = 'Monika',
								@lname = 'Roy',
								@gender = 1,
								@dob = '1947-10-11',
								@religion = 2,
								@bloodgroup = 5,
								@maritalstatus = 1,
								@children = 3,
								@permanentaddress = 'Sylhet',
								@room = 601,
								@building = 60011
	EXEC ohms.sp_ResidentInsert @entrydate = '2020-05-12',
								@fname = 'Rahim ',
								@lname = 'Haydar',
								@gender = 2,
								@dob = '1945-09-10',
								@religion = 1,
								@bloodgroup = 8,
								@maritalstatus = 1,
								@children = 2,
								@permanentaddress = 'Narayanganj',
								@room = 711,
								@building = 70011
	GO

	SELECT * FROM ohms.tbl_Resident
	GO

					    /* A procedure(with parameter) 
					that will DELETE data from tbl_Resident  */

CREATE PROC ohms.sp_DeleteResident @id INT
AS
	DELETE FROM ohms.tbl_Resident
	WHERE [Resident ID] = @id
GO

--test Stored Procedure ohms.sp_DeleteResident 
	EXEC ohms.sp_DeleteResident 117
	GO

						/* A procedure(with parameter) 
		   that will show gender wise resident details from tbl_Resident  */

CREATE PROC ohms.sp_GenderWiseDetails @gender INT
AS 
	SELECT  r.[Resident ID],
			r.[Entry Date],
			r.FName AS FirstName,
			r.LName AS LastName,
			r.Age,
			g.gName AS gender,
			r.[Date Of Birth],
			rn.rName AS Religion,
			bg.bgName AS BloodGroup,
			ms.mStatus AS MaritalStatus,
			r.[No.Of Children],
			r.[Permanent Address],
			r.[Room No.],
			r.[Building No.]

	FROM	ohms.tbl_Resident r
	
	INNER JOIN  ohms.tbl_Gender g ON r.Gender = g.gID
	LEFT JOIN	ohms.tbl_Religion rn ON r.Religion = rn. rID
	LEFT JOIN	ohms.tbl_BloodGroup bg ON r.[Blood Group] = bg.bgID
	LEFT JOIN	ohms.tbl_MaritalStatus ms ON r.[Marital Status] = ms.mID

	WHERE   Gender = @gender

GO

--  test Stored Procedure ohms.sp_GenderWiseDetails 

	EXEC ohms.sp_GenderWiseDetails 1
	GO

					/* A procedure(with OUTPUT parameter) 
					      that will return an output  */

CREATE PROC ohms.sp_ReturnFurnitureRoomID @Fid NCHAR(5), @name NVARCHAR(15)
AS 
	DECLARE 
		@roomID INT,
		@buildingNo INT
	SELECT  
		@roomID = RoomID 
	FROM  
		ohms.tbl_Furniture
	WHERE 
		@Fid = FurnitureID AND 
		@name = [Name]
	RETURN 
		@roomID 
GO

--  test Stored Procedure ohms.sp_ReturnFurnitureRoomID 
	DECLARE @roomID INT
	EXEC @roomID = ohms.sp_ReturnFurnitureRoomID 'F0015','Locker-5'
	PRINT 'Room Number: '+STR(@roomID)
	GO

			/* A procedure that will INSERT data with DEFAULT VALUE 
		and show the total balance in [ohms].[tbl_MonthlyExpenseRecord]*/

CREATE PROC ohms.sp_MonthlyExpenseInsertWithReturn 
			
			@month INT,
			@year INT,
			@fexpense MONEY,
			@texpense MONEY = 15000,
			@mexpense MONEY,
			@uexpense MONEY = 40000,
			@misexpense MONEY
			
AS
	DECLARE @totalMonthlyExpense MONEY

	INSERT INTO [ohms].[tbl_MonthlyExpenseRecord]

		  ([Month],[Year],[Food Expense],[Transportation Expense],[Medication Cost],[Utility Cost],[Miscellaneous])
			  
	VALUES(@month,  @year, @fexpense,@texpense,@mexpense,@uexpense,@misexpense)

	SELECT @totalMonthlyExpense =(@fexpense+@texpense+@mexpense+
								  @uexpense+@misexpense) 

	FROM [ohms].[tbl_MonthlyExpenseRecord]
	RETURN @totalMonthlyExpense
GO

--  test Stored Procedure ohms.sp_MonthlyExpenseInsertWithReturn  

	DECLARE @totalMonthlyExpense MONEY
	EXEC @totalMonthlyExpense = ohms.sp_MonthlyExpenseInsertWithReturn			
						
						@month = 2,
						@year = 2021,
						@fexpense = 450000,
						@texpense = DEFAULT,
						@mexpense = 150000,
						@uexpense = DEFAULT,
						@misexpense = 5000

	PRINT 'Total Monthly Expense: '+STR(@totalMonthlyExpense)
	GO

	DECLARE @totalMonthlyExpense MONEY
	EXEC @totalMonthlyExpense = ohms.sp_MonthlyExpenseInsertWithReturn 

						@month = 3,
						@year = 2021,
						@fexpense = 450000,
						@texpense = DEFAULT,
						@mexpense = 150000,
						@uexpense = DEFAULT,
						@misexpense = 5000
	
	PRINT 'Total Monthly Expense: '+STR(@totalMonthlyExpense)
	GO

                  /* A procedure to apply procedural constraint
		        into tbl_RoomDetails which will restrict inserting 
				              invalid building No.*/

CREATE PROC ohms.sp_InsertRoomDetailsbuildingID  @roomno INT,
											     @buildingno INT
AS

	IF @buildingno IN (SELECT [Building No.] FROM ohms.tbl_Buildings)
	BEGIN
		INSERT INTO ohms.tbl_RoomDetails([RoomID] ,[Building No.])
		VALUES(@roomno,@buildingno)
	END
	ELSE
		RAISERROR('Invalid Entry!!!!',10,1)
GO

--  test Stored Procedure ohms.sp_MonthlyExpenseInsertWithReturn 

	EXEC ohms.sp_InsertRoomDetailsbuildingID 713,90011
	GO

				/* A procedure to UPDATE employee details
				            from tbl_Employee*/

CREATE PROC ohms.sp_EmployeeDesignationUpdate 

				@dID INT,
				@designation NVARCHAR(20),
				@salary MONEY,
				@statementType NVARCHAR(20)

AS
BEGIN
	IF @statementType = 'Update'
		BEGIN
		UPDATE [ohms].[tbl_EmployeeDesignation]
		SET 
			[Designation] = @designation,
			[salary] = @salary
		WHERE
			@dID= dID
	END
END
GO	

--  test Stored Procedure ohms.sp_EmployeeDesignationUpdate  

	EXEC ohms.sp_EmployeeDesignationUpdate 

			@dID = 5,
			@designation = 'Gardener',
			@salary = 8000,
			@statementType = 'Update'

	GO

				----------------/* Create UDF */----------------------		
					 /* Scalar valued function for counting 
					   number of furnitures in a building*/

CREATE FUNCTION ohms.fnCountNumberOfFurniture (@buildingID INT)
RETURNS INT
AS
BEGIN
	DECLARE @totalFurnituresInBuilding INT
	SELECT @totalFurnituresInBuilding = COUNT(FurnitureID) FROM ohms.tbl_Furniture
	RETURN @totalFurnituresInBuilding
END
GO

--  test UDF ohms.fnCountNumberOfFurniture 
	SELECT ohms.fnCountNumberOfFurniture (70011) AS 'NumberOFtotalFurniture'
	GO


				 /* A Scalar valued function for calculating 
					 yearly food cost in the Old Age Home*/

CREATE FUNCTION ohms.fnCalculateYearlyFoodCost (@year INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @YearlyFoodCost MONEY 
	SELECT @YearlyFoodCost = SUM([Food Expense]) 
	FROM [ohms].[tbl_MonthlyExpenseRecord]
	WHERE @year = [Year]
	RETURN @YearlyFoodCost 
END
GO

--  test UDF ohms.fnCalculateYearlyFoodCost 
	
	SELECT ohms.fnCalculateYearlyFoodCost (2022) AS	'Yearly Food Cost' 
	GO

				/* An Inline Table-valued Function for calculating 
			      Total Yearly Expense  summary in the Old Age Home */

CREATE FUNCTION ohms.fnCalculateYearlyExpenseSummary (@year INT)
RETURNS TABLE
AS
RETURN
(
	SELECT  
			[Year],
			SUM([Food Expense]) AS 'Total Food cost',
			SUM([Transportation Expense]) AS 'Total transportation cost',
			SUM([Medication Cost]) AS 'Total Medication cost',
			SUM([Utility Cost]) AS 'Total Utility Cost',
			SUM([Miscellaneous]) AS 'Total Miscellaneous cost'
			
	FROM  
			[ohms].[tbl_MonthlyExpenseRecord]
	WHERE
			@year = [Year]
	GROUP BY 
			[Year]
)
GO

--  test UDF ohms.fnCalculateYearlyExpenseSummary 

	SELECT * FROM ohms.fnCalculateYearlyExpenseSummary(2022) 
	GO

			/* A MultiStatement Table-valued Function for presenting
			      Employee Details according to their designation */

CREATE FUNCTION ohms.fnDesignationWiseEmployeeDetails (@designation INT)
RETURNS @DesignationWiseEmployeeDetails TABLE 
(
	EmployeeID INT,
	[Name] NVARCHAR(20),
	Age INT,
	EmployeeType NVARCHAR(20),
	Designation NVARCHAR(20),
	Gender NVARCHAR(10),
	Salary MONEY,
	[Joining Date] DATE ,
	[Yearly Total Salary] MONEY,
	Religion NVARCHAR(15),
	[Blood Group] NCHAR(4),
	[Working Day] INT,
	[Contact No.] NVARCHAR(15)
)
AS
BEGIN
		INSERT INTO	
			@DesignationWiseEmployeeDetails
		SELECT  
			e.[Employee ID],
			e.[FName]+e.[LName] ,
			e.Age,
			et.empType,
			ed.designation,
			g.gName,
			ed.salary,
			e.[Joining Date],
			ed.salary*12, 
			r.rName,
			bg.bgName,
			DATEDIFF(DAY,e.[Joining Date],GETDATE()),
			e.[Contact No.]

		FROM ohms.tbl_Employees e
		JOIN ohms.tbl_EmployeeType et ON e.[Employee Type] = et.typeID
		LEFT JOIN ohms.tbl_EmployeeDesignation ed ON e.Designation = ed.dID
		LEFT JOIN ohms.tbl_Gender g ON e.Gender = g.gID
		LEFT JOIN ohms.tbl_Religion r ON e.Religion = r.rID
		LEFT JOIN ohms.tbl_BloodGroup bg ON e.[Blood Group] = bg.bgID

		WHERE @designation = ed.dID 
		RETURN	
END
GO

--  test UDF ohms.fnDesignationWiseEmployeeDetails 

	SELECT * FROM ohms.fnDesignationWiseEmployeeDetails (3)
	GO

