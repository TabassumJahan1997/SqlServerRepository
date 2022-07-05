 
 /* This is a part of DDL script. So executing this script may cause
    some changes in table sturctures in database.*/

USE OHMDB
GO
 
 
                 -----------------/* Alter Table */-----------------------
                                /* Add New Column */

ALTER TABLE [ohms].[tbl_Buildings]
ADD Area FLOAT NULL
GO

                                  /* Delete Column */

ALTER TABLE [ohms].[tbl_Buildings]
DROP COLUMN Area
GO

                             /* Modify Column Data Type */

ALTER TABLE ohms.tbl_ResidentLeaveRecord
ALTER COLUMN [Leaving Date] DATETIME NOT NULL
GO

					------------/* Create Clustered Index */------------

DROP INDEX IF EXISTS IX_furnitureID
ON ohms.tbl_Furniture
GO

CREATE CLUSTERED INDEX IX_furnitureID
ON ohms.tbl_Furniture
(
	FurnitureID
)
GO

             ------------/* Create Non-Clustered Index */-------------

DROP INDEX IF EXISTS IX_FundEntryDate
ON ohms.tbl_FoodMedicationRecord
GO

CREATE NONCLUSTERED INDEX IX_Date
ON ohms.tbl_FoodMedicationRecord 
(
	[Date]
)
GO

                    -----------/* Create Sequence */-------------

CREATE SEQUENCE testSequence1
	AS INT
	START WITH 1
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 100000
	CYCLE CACHE 10
GO

