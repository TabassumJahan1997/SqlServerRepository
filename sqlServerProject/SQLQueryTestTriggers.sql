
/* Test Triggers */
--  test FOR TRIGGER trPreventUnexpectedTableChange to prevent UPDATE or DELETE 

	DELETE FROM [ohms].[tbl_Buildings]
	WHERE [Building No.] = 70011
	GO

--test the FOR INSERT trigger trStock
	
	INSERT INTO tbl_stock(productId,quantity) VALUES(1,40)
	INSERT INTO tbl_stock(productId,quantity) VALUES(2,20)
	INSERT INTO tbl_stock(productId,quantity) VALUES(3,30)
	INSERT INTO tbl_stock(productId,quantity) VALUES(4,50)
	GO

-- test FOR DELETE trigger tr_DeleteResidentCopy 
	
	DELETE [ohms].[tbl_Resident]
	WHERE [Resident ID] = 118
	GO

--test the INSTEAD OF INSERT trigger trMonthlyExpenseInsert
	
	INSERT INTO ohms.vMonthlyExpenseRecord VALUES
	(1,2021,450000,7500,150000,40000,5000),
	(2,2021,450000,7500,150000,40000,3000)
	GO




