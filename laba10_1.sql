 USE master

IF DB_ID(N'Trains') IS NOT NULL
DROP DATABASE Trains;

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
USE Trains
 CREATE TABLE  Рейс_1(
     НомерРейса  int PRIMARY KEY NOT NULL,
     НомерПоезда int NOT NULL,
     Маршрут   NVARCHAR(50) NULL,
 );
 INSERT INTO Рейс_1(НомерРейса, НомерПоезда, Маршрут) VALUES (123, 3333,'A1526V')
 INSERT INTO Рейс_1(НомерРейса, НомерПоезда, Маршрут) VALUES (124, 3324,'B1626V')
 INSERT INTO Рейс_1(НомерРейса, НомерПоезда, Маршрут) VALUES (125, 3283,'C1526V')
 INSERT INTO Рейс_1(НомерРейса, НомерПоезда, Маршрут) VALUES (126, 3093,'D1726V')
 INSERT INTO Рейс_1(НомерРейса, НомерПоезда, Маршрут) VALUES (127, 3883,'F1926V')
 INSERT INTO Рейс_1(НомерРейса, НомерПоезда, Маршрут) VALUES (128, 3123,'H1226V')
SELECT * FROM Рейс_1
GO
USE Trains 
GO
/*Возвращает сведения об активных в данный момент 
в SQL Server 2017 ресурсах диспетчера блокировок.
 Каждая строка представляет текущий активный запрос диспетчеру
  блокировок о блокировке, которая была получена или находится в 
  ожидании получения.*/
 /* Получение подробной информации о блокировках. */
CREATE VIEW GetLocksInfo AS
SELECT 
--nvarchar(60)= resourse_type
    CASE train.resource_type
    --Идентификатор объекта.Идентификатор сущности в базе данных, с которой связан ресурс = resource_associated_entity_id
		WHEN N'OBJECT' THEN OBJECT_NAME(train.resource_associated_entity_id)
    --Представляет строку в указателе
		WHEN N'KEY'THEN (SELECT OBJECT_NAME(object_id) FROM sys.partitions WHERE hobt_id = train.resource_associated_entity_id)
    --Представляет отдельную страницу в файле данных.
		WHEN N'PAGE' THEN (SELECT OBJECT_NAME(object_id) FROM sys.partitions WHERE hobt_id = train.resource_associated_entity_id)
    --Представляет кучу или сбалансированное дерево. Это основные структуры путей доступа.
		WHEN N'HOBT' THEN (SELECT OBJECT_NAME(object_id) FROM sys.partitions WHERE hobt_id = train.resource_associated_entity_id)
    --Представляет физическую строку в куче
		WHEN N'RID' THEN (SELECT OBJECT_NAME(object_id) FROM sys.partitions WHERE hobt_id = train.resource_associated_entity_id)
		ELSE N'Unknown'
    END AS objectName,
    CASE train.resource_type
		WHEN N'KEY' THEN (SELECT indexes.name 
							FROM sys.partitions JOIN sys.indexes 
								ON partitions.object_id = indexes.object_id AND partitions.index_id = indexes.index_id
							WHERE partitions.hobt_id = train.resource_associated_entity_id)
		ELSE N'Unknown'
    END AS IndexName,
    train.resource_type,
	DB_NAME(train.resource_database_id) AS database_name,
	train.resource_description,
	train.resource_associated_entity_id,
	train.request_mode
FROM sys.dm_tran_locks AS train
	WHERE train.resource_database_id = DB_ID(N'Trains')
GO