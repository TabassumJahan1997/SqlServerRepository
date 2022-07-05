/*							
			SQL Project Name : Government Funded Old Age Home 
							   Management Database (OHMDB) 
				Trainee Name : SALMA TABASSUM JAHAN   
				  Trainee ID : 1269314       
					Batch ID : ESAD-CS/PNTL-E/51/01 

																															                                                          */
--================================ DDL SCRIPT =======================================--

USE master
GO

DROP DATABASE IF EXISTS OHMDB
GO

                 ------------/* Create database */--------------

CREATE DATABASE OHMDB
ON
(
	name='OHMDB_DataFile',
	filename='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\OHMDB_DataFile.mdf',
	size=100mb,
	maxsize=200mb,
	filegrowth=2mb
)
LOG ON 
(
	name='OHMDB_LogFile',
	filename='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\OHMDB_LogFile.ldf',
	size=50mb,
	maxsize=100mb,
	filegrowth=2%
)
GO

USE OHMDB
GO

CREATE SCHEMA ohms
GO


			 -----------------/* Create Tables */--------------------
 /* 2nd table:tbl_Gender */
 CREATE TABLE ohms.tbl_Gender
 (
	gID INT PRIMARY KEY,
	gName NVARCHAR(10) NOT NULL
 )
 GO

 INSERT INTO ohms.tbl_Gender VALUES
(1, 'Female'),
(2, 'Male')
GO

 /* 4th table:tbl_Religion */
 CREATE TABLE ohms.tbl_Religion
 (
	rID INT IDENTITY PRIMARY KEY,
	rName NVARCHAR(15) NOT NULL
 )
 GO

 INSERT INTO ohms.tbl_Religion VALUES
	('Muslim'),
	('Hindu'),
	('Buddhist'),
	('Christian'),
	('Others')
GO

 /* 3rd table:tbl_MaritalStatus */
 CREATE TABLE ohms.tbl_MaritalStatus
 (
	mID INT PRIMARY KEY,
	mStatus NVARCHAR(10) NOT NULL
 )
 GO

 INSERT INTO ohms.tbl_MaritalStatus VALUES
	(1, 'Married'),
	(2, 'Unmarried')
GO


 /* 5th table:tbl_BloodGroup */
 CREATE TABLE ohms.tbl_BloodGroup
 (
	bgID INT IDENTITY PRIMARY KEY,
	bgName NCHAR(4) NOT NULL
 )
 GO

 INSERT INTO ohms.tbl_BloodGroup VALUES
	('A+'),
	('A-'),
	('B+'),
	('B-'),
	('O+'),
	('O-'),
	('AB+'),
	('AB-')
GO

 /* 7th table:tbl_EmployeeType */
CREATE TABLE ohms.tbl_EmployeeType
(
	typeID INT IDENTITY PRIMARY KEY,
	empType NVARCHAR(15) NOT NULL
)
GO

INSERT INTO ohms.tbl_EmployeeType VALUES
	('Permanent'),
	('Temporary')
GO


/* 8th table:tbl_EmployeeDesignation */
CREATE TABLE ohms.tbl_EmployeeDesignation
(
	dID INT IDENTITY PRIMARY KEY,
	designation NVARCHAR(20) NOT NULL,
	salary MONEY NOT NULL
)
GO

INSERT INTO ohms.tbl_EmployeeDesignation VALUES
	('Doctor',30000),
	('Nurse',15000),
	('Staff',13500),
	('Cook',12000),
	('Gardener',7000),
	('Driver',14000),
	('Cleaner',7000),
	('Security Guard',8000),
	('Building Incharge',10000)
GO

/* 6th table:tbl_Employees */
CREATE TABLE ohms.tbl_Employees  
	(
		[Employee ID] INT IDENTITY(1001,1) PRIMARY KEY,
		[FName] NVARCHAR(20) NOT NULL,
		[LName] NVARCHAR(20) NOT NULL,
		[Employee Type] INT NOT NULL REFERENCES ohms.tbl_EmployeeType(typeID) ,
		Designation INT NOT NULL REFERENCES ohms.tbl_EmployeeDesignation(dID) ,
		[Date Of Birth] DATE NOT NULL,
		NID NVARCHAR(10) NOT NULL,   
		Gender INT REFERENCES ohms.tbl_Gender(gID),
		Religion INT NOT NULL REFERENCES ohms.tbl_Religion(rID),
		[Blood Group] INT NOT NULL REFERENCES ohms.tbl_BloodGroup(bgID),
		[Marital Status] INT NOT NULL REFERENCES ohms.tbl_MaritalStatus(mID),
		[Joining Date] DATE NOT NULL,
		[Contact No.] NVARCHAR(15) NOT NULL,
		[Present Address] NVARCHAR(100) NOT NULL,
		[Permanent Address] NVARCHAR(100) NOT NULL,
		Age AS DATEDIFF(YEAR,[Date Of Birth],GETDATE())
	)
GO

INSERT INTO ohms.tbl_Employees VALUES
	('Mahbub',' Alam', 1, 1,'03/03/1988', '6005536485', 2,1,1,1,'03/02/2022','01547258965','Gazipur','Feni'),
	('Shahnaz ','Ara', 1, 1,   '03/03/1985', '6005585258', 1,1,2,1,'03/27/2021','01558693254','Gazipur','Barisal'),
	('Sanzida ','Alam', 1, 2,  '12/03/1990', '6001485247',1,1,3,2,'09/27/2021','01754823695','Gazipur','Khulna'),
	('Zinat ','Parvin', 1, 2,  '09/04/1982', '6005536485', 1,1,4,1,'05/05/2022','01824569357','Gazipur','Shirajgonj'),
	('Kaniz',' Fatema', 1, 2, '11/10/1985', '6001475896', 1,1,5,1,'01/19/2021','01632584257','Gazipur','Pabna'),
	('Alamgir',' Sharkar', 1, 2,   '02/03/1989', '6002548698', 2,1,6,2,'05/02/2020','01548726958','Gazipur','Feni'),
	('Anwar',' Islam', 1, 2,   '08/05/1989', '6005536485', 2,1,7,2,'10/13/2022','01932587412','Gazipur','Natore'),
	('Ismail ','Hossain', 1, 4,  '04/23/1980', '6002584692', 2,1,8,1,'05/02/2021','01847596325','Gazipur','Barisal'),
	('Habib',' Chowdhuri',2,4, '05/15/1981', '6075842361', 2,1,7,1,'11/01/2020','01721458692','Gazipur','Sylhet'),
	('Fahmida ','Akter',2,4,  '06/18/1983', '6005842365', 1,1,1,1,'02/22/2020','01547258412','Gazipur','Pabna'),
	('Mahbuba',' Khandokar', 1, 4,  '03/03/1979', '6006521478', 1,1,1,1,'07/06/2020','01875478548','Gazipur','Chottogram'),
	('Shajib ','Khan', 1, 7,   '10/05/1982', '6005536485', 2,1,2,1,'11/18/2022','01525488965','Gazipur','Kumilla'),
	('Shaheen',' Bosu', 1, 7,   '03/21/1985', '6005536584', 2,2,3,1,'10/05/2020','01785475258','Gazipur','Gaibandha'),
	('Farzana ','Islam',2,7,  '06/03/1985', '6005536965', 1,1,5,1,'09/02/2021','01694582142','Gazipur','Narayanganj'),
	('Keya ','Sultana',2,7, '07/05/1988', '6005533258', 1,1,6,2,'01/16/2022','01512548965','Gazipur','Faridpur'),
	('Shahidul',' Islam', 1, 5,   '09/07/1981', '6005856485', 2,1,5,1,'10/12/2021','01875255547','Gazipur','Bogra'),
	('Adav',' Protik',2,5,  '10/09/1981', '6005584265', 2,2,1,1,'04/09/2021','01847545785','Gazipur','Tangail'),
	('Ajaj ','Khan', 1, 3, '03/03/1988', '6005584756', 
	  2, 1,3,2,'10/02/2021','01521584565','Gazipur','Potuakhali'),
	('Faiza ','Tabassum', 1, 3,  '11/20/1987', '6005842569', 1,1,3,1,'03/01/2022','01541895865','Gazipur','Jamalpur'),
	('Motaleb',' Hossain',1, 3, '04/12/1990', '6005587521', 2,1,5,2,'03/01/2022','01535848965','Gazipur','Shatkhira'),
	('Shahidul',' Alam', 1, 6,  '09/03/1989', '6014587521', 2,1,7,2,'11/07/2022','01547258965','Gazipur','Chapainobabgonj'),
	('Rashid ','Uddin', 1, 8,  '09/23/1985', '6018521469', 2,1,1,1,'01/17/2019','01936548258','Gazipur','Kumilla'),
	('Mehedi ','Sharkar', 1, 9,   '06/13/1988', '6005214875',2,1,2,1,'09/19/2021','01542587412','Gazipur','Barisal'),
	('Habib ','Uddin', 1, 9,   '08/13/1988', '6005432875',2,1,2,1,'08/21/2021','01547584412','Gazipur','Barisal')
GO


/* 13th table:tbl_Transport */
CREATE TABLE ohms.tbl_Transport  
	(
		TransportID NCHAR(5) NOT NULL CHECK(TransportID LIKE 'T[0-9][0-9][0-9][0-9]') 
		PRIMARY KEY ,
		[Type] NVARCHAR(15) NOT NULL,
		DriverID INT NOT NULL REFERENCES ohms.tbl_Employees([Employee ID])
	)
GO

INSERT INTO ohms.tbl_Transport VALUES
		('T0001','Ambulance',1021),
		('T0002','Ambulance',1021),
		('T0003','Ambulance',1021)
GO


/* 12th table:tbl_Buildings */
CREATE TABLE ohms.tbl_Buildings  
	(
		[Building No.] INT IDENTITY(50011,10000) PRIMARY KEY,
		[Building Name] NVARCHAR(15) NOT NULL,
		[Assigned for] INT REFERENCES ohms.tbl_Gender(gID),
		[Total No. of Rooms] INT NOT NULL,
		[Building Incharge] INT NOT NULL REFERENCES ohms.tbl_Employees([Employee ID])
	)
GO

INSERT INTO ohms.tbl_Buildings VALUES
	('Mayakunjo',   1,15,1004),
	('Dipshikha',   1,10,1005),
	('Chayaniketon',2,15,1018),
	('Kolpotoru',   2,10,1019)
GO

/* 10th table:tbl_RoomDetails */
CREATE TABLE ohms.tbl_RoomDetails  
	(
		RoomID INT  PRIMARY KEY,
		[Building No.] INT NOT NULL REFERENCES ohms.tbl_Buildings([Building No.])
	)
GO

INSERT INTO ohms.tbl_RoomDetails VALUES
	(501,50011), (502,50011), (503,50011), (504,50011), (505,50011), (506,50011),
	(507,50011), (508,50011), (509,50011), (510,50011), (511,50011), (512,50011),
	(513,50011), (514,50011), (515,50011), (601,60011), (602,60011), (603,60011),
	(604,60011), (605,60011), (606,60011), (607,60011), (608,60011), (609,60011),
	(610,60011), (701,70011), (702,70011), (703,70011), (704,70011), (705,70011),
    (706,70011), (707,70011), (708,70011), (709,70011), (710,70011), (711,70011),
    (712,70011), (713,70011), (714,70011), (715,70011), (801,80011), (802,80011),
    (803,80011), (804,80011), (805,80011), (806,80011), (807,80011), (808,80011),
	(809,80011), (810,80011)
GO

/* 11th table:tbl_Furniture */
CREATE TABLE ohms.tbl_Furniture 
	(
		FurnitureID NCHAR(5) NOT NULL CHECK(FurnitureID LIKE 'F[0-9][0-9][0-9][0-9]') ,
		[Name] NVARCHAR(15) NOT NULL,
		RoomID INT NOT NULL REFERENCES ohms.tbl_RoomDetails(RoomID),
		[Building No.] INT NOT NULL REFERENCES ohms.tbl_Buildings([Building No.]),
	)
GO

INSERT INTO ohms.tbl_Furniture VALUES
	('F0001','Bed-1',501,50011),
	('F0002','Bed-2',502,50011),
	('F0003','Bed-3',503,50011),
	('F0004','Bed-4',504,50011),
	('F0005','Bed-5',505,50011),
	('F0006','Bed-6',506,50011),
	('F0007','Bed-7',507,50011),
	('F0008','Bed-8',508,50011),
	('F0009','Bed-9',509,50011),
	
	('F0011','Locker-1',501,50011),
	('F0012','Locker-2',502,50011),
	('F0013','Locker-3',503,50011),
	('F0014','Locker-4',504,50011),
	('F0015','Locker-5',505,50011),
	('F0016','Locker-6',506,50011),
	('F0017','Locker-7',507,50011),
	('F0018','Locker-8',508,50011),
	('F0019','Locker-9',509,50011),
	
	('F0021','Bed-11',701,70011),
	('F0022','Bed-12',701,70011),
	('F0023','Bed-13',703,70011),
	('F0024','Bed-14',704,70011),
	('F0025','Bed-15',705,70011),
	('F0026','Bed-16',706,70011),
	('F0027','Bed-17',707,70011),
	('F0028','Bed-18',708,70011),
	('F0029','Bed-19',709,70011),
	
	('F0031','Locker-11',701,70011),
	('F0032','Locker-12',702,70011),
	('F0033','Locker-13',703,70011),
	('F0034','Locker-14',704,70011),
	('F0035','Locker-15',705,70011),
	('F0036','Locker-16',706,70011),
	('F0037','Locker-17',707,70011),
	('F0038','Locker-18',708,70011),
	('F0039','Locker-19',709,70011)
	
GO



 /* 1st table:tbl_Resident */

CREATE TABLE ohms.tbl_Resident 
	(
		[Resident ID] INT IDENTITY(101,1) PRIMARY KEY,  
		[Entry Date] DATE NOT NULL,
		[FName] NVARCHAR(40) NOT NULL, 
		[LName] NVARCHAR(40) NOT NULL,
		Gender INT REFERENCES ohms.tbl_Gender(gID),
		[Date Of Birth] DATE NOT NULL ,
		Religion INT NOT NULL REFERENCES ohms.tbl_Religion(rID),
		[Blood Group] INT NOT NULL REFERENCES ohms.tbl_BloodGroup(bgID),
		[Marital Status] INT NOT NULL REFERENCES ohms.tbl_MaritalStatus(mID),
		[No.Of Children] INT NOT NULL DEFAULT 0,  
		[Permanent Address] NVARCHAR(20),
		[Room No.] INT NOT NULL REFERENCES ohms.tbl_RoomDetails(RoomID),   	
		[Building No.] INT NOT NULL REFERENCES ohms.tbl_Buildings([Building No.]),
		Age AS DATEDIFF(YEAR,[Date Of Birth],GETDATE())
	)
GO

INSERT INTO ohms.tbl_Resident VALUES
		('03/01/2015','Jamir','Mollah',2,'05/07/1950',1,1,1,3,'Barisal',701,70011),
		('04/12/2016','Jahir',' Mollah',2,'07/09/1950',1,3,1,2,'Barisal',702,70011),
		('04/21/2021','Karim','Khan',2,'12/07/1952',1,2,1,7,'Barisal',703,70011),
		('01/13/2020','Fazlul',' Karim',2,'05/07/1953',1,4,1,4,'Khulna',704,70011),
		('11/15/2015', 'Shariful','Islam', 2, '04/13/1957', 1,5, 1, 5,'Rajshahi',705,70011),
		('12/28/2015','Narayan','Mondol',2,'03/02/1950',2,6,1,3,'Pabna',706,70011),
		('09/23/2020','Farid','Karim', 2, '11/23/1951', 1, 7,1,3,'Tangail',707,70011),
		('07/07/2021','Kashem','Khan',2,'10/07/1949',1,3,1,2,'Shirajgonj',708,70011),
		('08/05/2018','Abdul','Karim',2,'05/17/1948',1,5,1,4,'Mymensing',709,70011),
		('06/12/2016','Jashim','Haque', 2, '09/25/1948', 1, 8,1,3,'Shatkhira',710,70011),
		('05/11/2017','Firoja','Khatun',1,'12/07/1950',1,2,1,3,'Khulna',501,50011),
		('06/12/2017','Shahnaz','Begum',1,'11/05/1948',1,1,1,2,'Bagerhat',502,50011),
		('11/23/2018','Shamima','Khanam',1,'05/21/1948',1,7,2,0,'Narayanganj',503,50011),
		('03/15/2018','Khadiza','Parvin', 1, '06/25/1950', 1,3, 1, 3, 'Jamalpur', 504, 50011),
		('09/19/2019','Mila',' Nag',1,'09/20/1951',2,4,1,5,'Faridpur',505,50011),
		('07/30/2021','Shirin',' Khan',1,'07/17/1949',1,3,1,1,'Kushtia',506,50011),
		('10/27/2020','Rahela ','Parvin', 1, '08/13/1952',1,1, 1,2,'Pirojpur',507,50011),
		('08/13/2017','Belly ','Firoz', 1, '06/19/1948', 1, 7,1, 3,'Noakhali',508,50011),
		('09/11/2019','Fatima',' Islam',1,'05/22/1949',1,1,1,0,'Bhola',509,50011),
		('11/10/2018','Shahida ','Begum',1,'03/23/1947',1,5,1,3,'Kumilla',510,50011)
GO

/* 14th table:tbl_MedicalRecord */
CREATE TABLE ohms.tbl_MedicalRecord 
	(
		[Medical EntryID] INT IDENTITY PRIMARY KEY,
		[Resident ID] INT NOT NULL REFERENCES ohms.tbl_Resident([Resident ID]),
		[Health Issue] NVARCHAR(255) NOT NULL,
		[Referred Hospital] NVARCHAR(100) NOT NULL DEFAULT 'N/A',
		[Entry Date] DATE NOT NULL,
		[Release Date] DATE NOT NULL,
		CHECK([Release Date] > [Entry Date])
	)
GO

INSERT INTO ohms.tbl_MedicalRecord VALUES
	(112,'Heart Problem',    'General Hospital', '12/23/2017','12/27/2017'),
	(107,'Digestion Problem','National Hospital','01/23/2021','01/25/2021'),
	(102,'Kidney Desease',   'City Hospital',    '05/19/2017','05/25/2017')
GO

/* 15th table : tbl_FoodMedicationRecord */
CREATE TABLE ohms.tbl_FoodMedicationRecord 
	(
		[Date] DATE ,
		ResidentID INT REFERENCES ohms.tbl_Resident([Resident ID]),
		[Have Breakfast] BIT  ,
		[Have Midsnack1] BIT,
		[Have Lunch] BIT,
		[Have Midsnack2] BIT,
		[Have Supper] BIT,
		[Have Medication] BIT
	)
GO

INSERT INTO ohms.tbl_FoodMedicationRecord VALUES
	
	('05/30/2022' ,101,  1, 1, 1, 0, 1, 1),
	('05/30/2022' ,102,  1, 0, 1, 1, 1, 1),
	('05/30/2022' ,103,  1, 1, 1, 0, 1, 1),
	('05/30/2022' ,104,  1, 0, 1, 1, 1, 1),
	('05/30/2022' ,105,  1, 1, 1, 1, 1, 1),
	 		   						    
	('05/30/2022' ,111,  1, 1, 1, 0, 1, 1),
	('05/30/2022' ,112,  1, 1, 1, 1, 1, 1),
	('05/30/2022' ,113,  1, 0, 1, 1, 1, 1),
	('05/30/2022' ,114,  1, 1, 1, 0, 1, 1),
	('05/30/2022' ,115,  1, 1, 1, 1, 1, 1)
GO

/* 9th table: tbl_Visitors */
CREATE TABLE ohms.tbl_Visitors
	(
		VisitorID INT IDENTITY(10001,1) PRIMARY KEY ,
		[FName] NVARCHAR(20) NOT NULL,
		[LName] NVARCHAR(20) NOT NULL,
		Gender INT REFERENCES ohms.tbl_Gender(gID),
		[Address] NVARCHAR(100) NOT NULL,
		[Resident ID] INT REFERENCES ohms.tbl_Resident([Resident ID]),
		[Contact No.] NVARCHAR(15) NOT NULL,
		Relationship NVARCHAR(20) NOT NULL DEFAULT 'No Relation',
		[Visiting Date] DATE NOT NULL DEFAULT GETDATE(),
		[TimeIn] TIME NOT NULL,
		[TimeOut] TIME NOT NULL,
		CHECK([TimeIn]<[TimeOut])
	)
GO

INSERT INTO ohms.tbl_Visitors VALUES
('Firoz',' Ali',2,'Barisal',107,'01724589654','Neighbour','09/12/2021','10:00:00','12:00:00'),
('Shahadat',' Kabir',2,'Khulna',111,'01775842695','Brother','09/12/2021','11:00:00','13:50:00'),
('Lila ','Rani',1,'Faridpur',115,'01812547859','Sister','05/09/2020','11:00:00','14:00:00'),
('Shaymol',' Chokroborti', 2,'Faridpur', 115, '01512845874', 'Brother', '11/15/2021', '08:00:00', '09:00:00'),
('Abul ','Mollah',2,'Rajshahi',105,'01985475821','Neighbour','08/12/2019','08:00:00','09:30:00'),
('Shihab',' Uddin',2,'Bhola',119,'01654821578','Neighbour','10/27/2020','10:00:00','11:30:00'),
('Abbas',' Khan',2,'Kumilla',120,'01728475215','Neighbour','12/17/2020','11:00:00','12:00:00')
GO

/* 16th table : tbl_ResidentLeaveRecord */
CREATE TABLE ohms.tbl_ResidentLeaveRecord 
	(
		lID UNIQUEIDENTIFIER PRIMARY KEY,
		[Resident ID] INT NOT NULL REFERENCES ohms.tbl_Resident([Resident ID]),
		[Leaving Date] DATE NOT NULL,
		[Reason] NVARCHAR(100) DEFAULT 'N/A' ,
		[Description] NVARCHAR(255) DEFAULT 'N/A'
	)
GO

INSERT INTO ohms.tbl_ResidentLeaveRecord(lID,[Resident ID],[Leaving Date],[Reason]) VALUES
				(NEWID(),119,'10/26/2021','Recieved by a relative'),
				(NEWID(),120,'08/07/2020','Recieved by brother')
				
GO

/* 17th table : tbl_MonthlyExpenseRecord */
CREATE TABLE ohms.tbl_MonthlyExpenseRecord
(
	[Month] INT NOT NULL,
	[Year] INT NOT NULL,
	[Food Expense] MONEY NOT NULL,
	[Transportation Expense] MONEY NOT NULL,
	[Medication Cost] MONEY NOT NULL,
	[Utility Cost] MONEY NOT NULL,
	[Miscellaneous] MONEY NOT NULL
)
GO

INSERT INTO ohms.tbl_MonthlyExpenseRecord VALUES
		(1,2022,450000,7500,150000,40000,5000),
		(2,2022,450000,7500,150000,40000,3000),
		(3,2022,450000,10000,150000,40000,2000),
		(4,2022,500000,7500,150000,40000,3000),
		(5,2022,500000,7500,170000,50000,5000)
GO

/* test table data */
SELECT * FROM ohms.tbl_Resident
SELECT * FROM ohms.tbl_Gender
SELECT * FROM ohms.tbl_MaritalStatus
SELECT * FROM ohms.tbl_BloodGroup
SELECT * FROM ohms.tbl_MonthlyExpenseRecord
SELECT * FROM ohms.tbl_ResidentLeaveRecord
SELECT * FROM ohms.tbl_Religion
SELECT * FROM ohms.tbl_Employees
SELECT * FROM  ohms.tbl_EmployeeType
SELECT * FROM ohms.tbl_EmployeeDesignation
SELECT * FROM ohms.tbl_Visitors
SELECT * FROM ohms.tbl_RoomDetails
SELECT * FROM ohms.tbl_Furniture
SELECT * FROM ohms.tbl_Buildings
SELECT * FROM ohms.tbl_Transport
SELECT * FROM ohms.tbl_FoodMedicationRecord
SELECT * FROM ohms.tbl_MedicalRecord
GO

