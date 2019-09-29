USE master
DROP TABLE IF EXISTS Поезд;
DROP TABLE IF EXISTS Маршрут;
DROP TABLE IF EXISTS Ребенок;
DROP TABLE IF EXISTS Родитель;
DROP SEQUENCE If EXISTS  СountBy;
DROP VIEW IF EXISTS pol;
DROP VIEW IF EXISTS pol1;
IF OBJECT_ID ('pol4', 'view') IS NOT NULL  
DROP VIEW pol4 ; 

GO  


DROP TABLE IF EXISTS  НазваниеПоезда;

--создаем таблицу с автоинкрементным первичным ключем
CREATE TABLE  Поезд
(
    НомерПоезда int IDENTITY(0,1) PRIMARY KEY,
    Вагон int,
    Рейс int 

);
GO
-- Создание представления для одной таблицы lab7
CREATE VIEW pol1
AS
SELECT a.НомерПоезда
FROM [Поезд] as a
GO


--добавление полей с ограничениями
 ALTER TABLE Поезд
 ADD НазваниеВагона  varchar(10) CHECK (НазваниеВагона IN ('Плацкарт','Купе'));
 GO
 ALTER TABLE Поезд
 ADD СуществованиеПоезда varchar(20) DEFAULT 'Существует';
 GO

--Cоздание некластерного индекса с включенными полями lab7
CREATE NONCLUSTERED INDEX INDEX_1 
ON Поезд(НомерПоезда)  
INCLUDE (Вагон, Рейс);
GO  

 
 --Создание таблицы с первичным ключем на основе GUID
 --GUID
 CREATE TABLE dbo.НазваниеПоезда(
     УникальноеIdПоезда  UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID()
 );
 GO
 --Cоздание таблицы на основе послдовательости 
 USE master
 CREATE SEQUENCE СountBy
        START WITH 1
        INCREMENT BY 1;
GO
 CREATE TABLE dbo.Маршрут(
     МаршрутID int PRIMARY KEY 
 );
 
 GO
--Создание индексированного представления lab7
CREATE VIEW pol4
WITH SCHEMABINDING
AS
SELECT m.УникальноеIdПоезда
FROM  dbo.НазваниеПоезда as m
GO
CREATE UNIQUE CLUSTERED INDEX INDEX_pol4  
    ON pol4 (УникальноеIdПоезда);  
GO  

--NO action -параметр по умолчанию
 CREATE TABLE Родитель(
     РодительID int PRIMARY KEY 
 );
 GO
 CREATE TABLE Ребенок(
     IDРебенка int IDENTITY(0,1) PRIMARY KEY,
     РодительID int DEFAULT '1',
     CONSTRAINT FK_Ребенок FOREIGN KEY(РодительID)
     REFERENCES Родитель (РодительID)
     ON DELETE NO ACTION
     ON UPDATE NO ACTION
 );
 GO

INSERT INTO Родитель VALUES(1)
INSERT INTO Родитель VALUES(2)

INSERT INTO Ребенок(РодительID) SELECT РодительID  FROM Родитель;
SELECT * FROM Родитель
SELECT * FROM Ребенок
GO 
--Cоздание представления для связных таблиц lab7

CREATE VIEW pol
AS
SELECT a.[РодительID],b.[IDРебенка]
FROM [Родитель] as a,[Ребенок] as b
WHERE a.[РодительID] = b.[РодительID]
--Чтобы добавить все Родительские id без повторений
UNION 
SELECT a.[РодительID],b.[IDРебенка]
FROM [Родитель] as a,[Ребенок] as b
WHERE a.[РодительID] = b.[РодительID]
GO

USE master




ALTER TABLE Ребенок NOCHECK CONSTRAINT FK_Ребенок
UPDATE  Родитель SET  РодительID = РодительID 
ALTER TABLE Ребенок CHECK CONSTRAINT FK_Ребенок
SELECT * FROM Родитель
SELECT * FROM Ребенок
GO

ALTER TABLE Ребенок NOCHECK CONSTRAINT FK_Ребенок
DELETE FROM Родитель WHERE РодительID = 1
ALTER TABLE Ребенок CHECK CONSTRAINT FK_Ребенок
SELECT * FROM Родитель
SELECT * FROM Ребенок
GO

INSERT INTO Родитель VALUES(1)

--CASCADE
ALTER TABLE Ребенок DROP CONSTRAINT FK_Ребенок
ALTER TABLE Ребенок ADD CONSTRAINT FK_Ребенок FOREIGN KEY ( РодительID)
    REFERENCES Родитель (РодительID)
    ON DELETE CASCADE
    ON UPDATE CASCADE

INSERT INTO Родитель VALUES(3)
INSERT INTO Родитель VALUES(4)

INSERT INTO Ребенок(РодительID) SELECT РодительID  FROM Родитель WHERE РодительID > 2;
SELECT * FROM Родитель
SELECT * FROM Ребенок
GO 

DELETE FROM Родитель WHERE РодительID = 3
SELECT * FROM Родитель
SELECT * FROM Ребенок
GO

UPDATE  Родитель SET  РодительID = РодительID
SELECT * FROM Родитель
SELECT * FROM Ребенок
GO

--SET NULL
ALTER TABLE Ребенок DROP CONSTRAINT FK_Ребенок
ALTER TABLE Ребенок ADD CONSTRAINT FK_Ребенок FOREIGN KEY ( РодительID)
    REFERENCES Родитель (РодительID)
    ON DELETE SET NULL
    ON UPDATE SET NULL

SELECT * FROM Родитель
SELECT * FROM Ребенок

DELETE FROM Родитель WHERE РодительID = 2
SELECT * FROM Родитель
SELECT * FROM Ребенок


UPDATE  Родитель SET  РодительID = РодительID
SELECT * FROM Родитель
SELECT * FROM Ребенок
GO



--SET DEFAULT
ALTER TABLE Ребенок DROP CONSTRAINT FK_Ребенок
ALTER TABLE Ребенок ADD CONSTRAINT FK_Ребенок FOREIGN KEY ( РодительID)
    REFERENCES Родитель (РодительID)
    ON DELETE SET DEFAULT
    ON UPDATE SET DEFAULT
SELECT * FROM Родитель
SELECT * FROM Ребенок

ALTER TABLE Ребенок NOCHECK CONSTRAINT FK_Ребенок
DELETE FROM Родитель WHERE РодительID = 1
ALTER TABLE Ребенок CHECK CONSTRAINT FK_Ребенок
SELECT * FROM Родитель
SELECT * FROM Ребенок

UPDATE  Родитель SET  РодительID = РодительID
SELECT * FROM Родитель
SELECT * FROM Ребенок
GO