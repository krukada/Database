use master
go
drop DATABASE if exists RailwayTransportation;
USE master
GO
IF DB_ID(N'RailwayTransportation') IS NOT NULL
  DROP DATABASE RailwayTransportation;
--создание базы данных
CREATE DATABASE RailwayTransportation
ON PRIMARY
( NAME = RailwayTransportation_dat,
    FILENAME = '/Users/adelinazagitova/Documents/RailwayTransportation/RailwayTransportationdat.mdf',
    SIZE = 10, 
    MAXSIZE = UNLIMITED,  
    FILEGROWTH = 5 )
LOG ON  
( NAME = RailwayTransportation_log,  
    FILENAME = '/Users/adelinazagitova/Documents/RailwayTransportation/RailwayTransportationlog.ldf',  
    SIZE = 5MB,  
    MAXSIZE = 150MB,  
    FILEGROWTH = 5MB )   
GO
USE RailwayTransportation
GO

IF OBJECT_ID('NameTrain') IS NOT NULL
  DROP TABLE NameTrain
GO
--таблица данных поездов
CREATE TABLE NameTrain(
    NumberTrain int PRIMARY KEY NOT NULL,
    NumberOfSeats int NULL,
);
INSERT INTO NameTrain(NumberTrain,NumberOfSeats) VALUES
 (1,11),
 (3,256),
 (2,88),
 (7,19);
SELECT * FROM NameTrain
go

SELECT
    'data source=' + @@servername +
    ';initial catalog=' + db_name() +
    CASE type_desc
        WHEN 'WINDOWS_LOGIN' 
            THEN ';trusted_connection=true'
        ELSE
            ';user id=' + suser_name()
    END
FROM sys.server_principals WHERE name = suser_name()