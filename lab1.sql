USE master;
GO

IF DB_ID(N'Trains') IS NOT NULL
DROP DATABASE Trains;

DROP TABLE IF EXISTS Flight;
DROP TABLE IF EXISTS Билет;
DROP TABLE IF EXISTS Билет2;
--создание базы данных Trains

CREATE DATABASE Trains
ON PRIMARY
( NAME = Trains_dat,
    FILENAME = '/Users/adelinazagitova/Documents/Train/Trainsdat.mdf',
    SIZE = 10, 
    MAXSIZE = UNLIMITED,  
    FILEGROWTH = 5 )
LOG ON  
( NAME = Trains_log,  
    FILENAME = '/Users/adelinazagitova/Documents/Train/Trainslog.ldf',  
    SIZE = 5MB,  
    MAXSIZE = 150MB,  
    FILEGROWTH = 5MB )   
GO

IF OBJECT_ID('Flight') IS NOT NULL
DROP TABLE Flight
GO

-- Создание таблицы 

USE Trains;
CREATE TABLE Билет2
(
   Номер    [VARCHAR](50)        NOT NULL, 
   Рейс     [VARCHAR](50)        NOT NULL,
);
GO
CREATE TABLE Flight
(
   FlightNumber   [VARCHAR](50)        NOT NULL PRIMARY KEY,
   Route          [VARCHAR](50)        NOT NULL,
   TrainNamber    [VARCHAR](50)         NULL,
   FlighTime      [DATETIME]            NULL,
);
GO
--создание файла
ALTER DATABASE Trains
ADD FILE
( NAME = SecondaryData,
  FILENAME = '/Users/adelinazagitova/Documents/Train/SecondaryDate.ndf');
GO
--создание файловой группы
ALTER DATABASE Trains  
ADD FILEGROUP MyFileGroup;  
GO  
ALTER DATABASE Trains   
ADD FILE 
( NAME = MyFile1,
  FILENAME = '/Users/adelinazagitova/Documents/Train/myfile1.mdf'),
( NAME = MyFile2,
  FILENAME = '/Users/adelinazagitova/Documents/Train/myfile2.ndf')
TO FILEGROUP MyFileGroup; 
GO
--Файловая группа по умолчанию

ALTER DATABASE Trains   
MODIFY FILEGROUP MyFileGroup DEFAULT;  
GO  


--Создание таблицы
CREATE TABLE Билет
(
   Номер    [VARCHAR](50)        NOT NULL, 
   Рейс     [VARCHAR](50)        NOT NULL,
)
on 
GO

--Удаление файлов в файловой группе
--Файловая группа станет PRIMARY,чтобы удалить

ALTER DATABASE Trains   
MODIFY FILEGROUP [PRIMARY] DEFAULT;  
GO 

ALTER DATABASE Trains  
REMOVE FILE MyFile1 ; 

ALTER DATABASE Trains
REMOVE FILE MyFile2;  
GO  

insert into Билет2(Номер,Рейс)
select [Номер],[Рейс] 
from Билет ;

DROP TABLE Билет
--Удаление самой файловой группы
ALTER DATABASE Trains 
REMOVE FILEGROUP MyFileGroup ;  
GO  
--Создание схемы
USE Trains;
GO
CREATE SCHEMA MySchema
GO
--переместить в схему таблицу
ALTER SCHEMA MySchema TRANSFER OBJECT::Flight;
GO
--удалить схему
DROP TABLE  IF EXISTS Trains.MySchema.Flight;
DROP SCHEMA MySchema;



  