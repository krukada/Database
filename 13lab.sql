drop view if exists DB_2.View_13lab;
drop view if exists DB_1.View_13lab;
drop table if exists List_DB1;
drop table if exists List_DB2;
USE master
GO
DROP DATABASE if exists  DB_1;
DROP DATABASE if exists DB_2;
GO

IF DB_ID(N'DB_1') IS NOT NULL
  DROP DATABASE DB_1;
--создание базы данных 
CREATE DATABASE DB_1
 ON PRIMARY
 ( NAME = DB_1_dat,
    FILENAME = '/Users/adelinazagitova/Documents/DB_1/DB_1_dat.mdf',
    SIZE = 10, 
    MAXSIZE = UNLIMITED,  
    FILEGROWTH = 5 )
 LOG ON  
 ( NAME = DB_1_log,  
    FILENAME = '/Users/adelinazagitova/Documents/DB_1/RailwayDB_1_log.ldf',  
    SIZE = 5MB,  
    MAXSIZE = 150MB,  
    FILEGROWTH = 5MB )   
GO

USE DB_1
GO
IF DB_ID(N'List_DB1') IS NOT NULL
  DROP Table List_DB1;

CREATE TABLE List_DB1 (
     ID INTEGER PRIMARY KEY CHECK (ID >= 1 and ID < 1000),
     NumberList INTEGER,
     GroupList nvarchar(255) NOT NULL

     );
GO

Insert into List_DB1(ID,NumberList,GroupList) VALUES
 (1,22,'B'),
 (2,12,'A'),
 (3,222,'B'),
 (4,211232,'Q'),
 (5,21212,'Y'),
 (6,2222,'B'),
 (7,22,'A'),
 (8,22,'U'),
 (9,2432,'M'),
 (10,222,'O'),
 (11,2232,'P');



GO
USE master
IF DB_ID(N'DB_2') IS NOT NULL
  DROP DATABASE DB_2;
--создание базы данных 
CREATE DATABASE DB_2
 ON PRIMARY
 ( NAME = DB_2_dat,
    FILENAME = '/Users/adelinazagitova/Documents/DB_2/DB_2_dat.mdf',
    SIZE = 10, 
    MAXSIZE = UNLIMITED,  
    FILEGROWTH = 5 )
 LOG ON  
 ( NAME = DB_2_log,  
    FILENAME = '/Users/adelinazagitova/Documents/DB_2/RailwayDB_2_log.ldf',  
    SIZE = 5MB,  
    MAXSIZE = 150MB,  
    FILEGROWTH = 5MB )   
GO

USE DB_2
GO
IF DB_ID(N'List_DB2') IS NOT NULL
  DROP Table List_DB2;

CREATE TABLE List_DB2 (
     ID INTEGER PRIMARY KEY CHECK (ID >= 1000 and ID <= 2000),
     NumberList INTEGER,
     GroupList nvarchar(255) NOT NULL
     );
GO

Insert into List_DB2(ID,NumberList,GroupList) VALUES
 (1000,22,'B'),
 (1001,12,'B'),
 (1003,222,'B'),
 (1004,211232,'B'),
 (1005,21212,'B'),
 (1006,2222,'B'),
 (1007,22,'B'),
 (1008,22,'B'),
 (1009,2432,'B'),
 (1010,222,'B'),
 (1011,2232,'B');

--Cелекционное представление
Use DB_1
GO

CREATE VIEW View_13lab AS
  SELECT * FROM DB_1.dbo.List_DB1
  UNION ALL
  SELECT * FROM DB_2.dbo.List_DB2
GO

select * from View_13lab

insert into View_13lab(ID,NumberList,GroupList) VALUES
(44,4545,'D');
select * from View_13lab
/*sp_linkedservers*/
select*from DB_1.dbo.List_DB1

insert into View_13lab(ID,NumberList,GroupList) VALUES
(1044,4545,'D');
select*from DB_1.dbo.List_DB1
select*from DB_2.dbo.List_DB2

delete View_13lab where ID = 8 or ID = 1044
select * from View_13lab
select*from DB_1.dbo.List_DB1
select*from DB_2.dbo.List_DB2

update  View_13lab set GroupList = 'fff' where ID = 9 or NumberList = 22
select * from View_13lab
select*from DB_1.dbo.List_DB1
select*from DB_2.dbo.List_DB2

Use DB_2
GO

CREATE VIEW View_13lab AS
  SELECT * FROM DB_2.dbo.List_DB2
  UNION ALL
  SELECT * FROM DB_1.dbo.List_DB1
GO

select * from View_13lab

insert into View_13lab(ID,NumberList,GroupList) VALUES
(1999,666,'HHHH');

select * from View_13lab
/*sp_linkedservers*/
select*from DB_2.dbo.List_DB2


delete View_13lab where ID = 1011 or ID = 44
select * from View_13lab
select*from DB_1.dbo.List_DB1
select*from DB_2.dbo.List_DB2

update  View_13lab set GroupList = 'ADELINA' where ID = 9 or NumberList = 22
select * from View_13lab
select*from DB_1.dbo.List_DB1
select*from DB_2.dbo.List_DB2



