

           --------/* CREATING TRIGGER (FOR TRIGGER, INSTEAD OF TRIGGER) */--------

/* Create the OHMDB database and tables first and then execute this script. */
/* Executing this script may cause some changes in data. */

USE OHMDB
GO

	                      -------/* FOR Trigger */--------
							
							/*   Create a FOR TRIGGER 
							to  Prevent update or delete */


CREATE TRIGGER trPreventUnexpectedTableChange
ON [ohms].[tbl_Buildings]
FOR UPDATE,DELETE
AS
BEGIN
		PRINT'Warning!!!No update or delete is possible.'
		PRINT'You don''t have permission to update or delete this table.'
		ROLLBACK TRANSACTION
END
GO



						  /* Create a FOR INSERT trigger */

--creating two tables to create FOR INSERT trigger.
--these two tables are not a part of OHMDB relational database.

CREATE TABLE tbl_products
(
	productId INT PRIMARY KEY,
	productName VARCHAR(20),
	price MONEY,
	stock INT
)
CREATE TABLE tbl_stock
(
	stockid INT IDENTITY PRIMARY KEY,
	stockIndate DATETIME DEFAULT GETDATE(),
	productId INT REFERENCES tbl_products(productId),
	quantity INT
)
GO

--inserting data
INSERT INTO tbl_products VALUES
(1,'Mouse',500,0),
(2,'Keyboard',550,0),
(3,'Monitor',10000,0),
(4,'Router',2500,0),
(5,'Sound Box', 1200,0)
GO

--Create a FOR INSERT trigger
CREATE TRIGGER trStock
ON tbl_stock
FOR INSERT
AS
BEGIN
	DECLARE @pid INT, 
		    @quantity INT 

	SELECT @pid=productId,@quantity=quantity FROM inserted

	UPDATE tbl_products SET stock=stock+@quantity
	WHERE productId=@pid
END
GO



				  /* A FOR DELETE TRIGGER to delete data from a table */

CREATE TRIGGER tr_DeleteResidentCopy
ON [ohms].[tbl_Resident]
FOR DELETE
AS
	BEGIN
			DECLARE @Rid INT
			SELECT @Rid= [Resident ID]
			FROM deleted

			DELETE [ohms].[tbl_ResidentCopy]
			
			WHERE [Resident ID]=@Rid
	END
GO


						------/* INSTEAD OF TRIGGER */------
				/*  Create an INSTEAD OF(INSERT) TRIGGER on a VIEW */

--Create a view
CREATE VIEW ohms.vMonthlyExpenseRecord
AS 
	SELECT * FROM [ohms].[tbl_MonthlyExpenseRecord]
GO

--TRIGGER
CREATE TRIGGER trMonthlyExpenseInsert
ON ohms.vMonthlyExpenseRecord
INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO 
		[ohms].[tbl_MonthlyExpenseRecord] ([Month],[Year],[Food Expense],[Transportation Expense],[Medication Cost],[Utility Cost],[Miscellaneous])
	SELECT
			[Month],[Year],[Food Expense],[Transportation Expense],[Medication Cost],[Utility Cost],[Miscellaneous]
	FROM 
			inserted
END
GO


			
			
			/* Create INSTEAD OF DELETE TRIGGER on  [ohms].[tbl_Resident] */

CREATE TRIGGER trResidentCopyDelete
ON [ohms].[tbl_Resident]
INSTEAD OF DELETE 
AS
BEGIN
		DELETE FROM [ohms].[tbl_ResidentCopy]
		WHERE [Resident ID] IN (SELECT [Resident ID]  FROM deleted)
END
GO



