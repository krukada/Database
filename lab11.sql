drop FUNCTION if exists dbo.AVGSUMTrain;
Drop VIEW IF EXISTS TrainShema;
Drop VIEW IF EXISTS TrainShema_2;
Drop VIEW IF EXISTS PassengerShema;
Drop VIEW IF EXISTS PassengerShema_2;
drop FUNCTION if exists Like2018;
drop FUNCTION if exists MaxMinMoney;
drop TRIGGER if exists InfoPassengerDelete ;
Drop view if EXISTS InfoPassenger;
DROP TRIGGER IF EXISTS InsertNumberTrain;
Drop view if exists WaysRoute;
Drop VIEW IF EXISTS PassengerTicket_1;
Drop VIEW IF EXISTS PassengerTicket_2;
DROP TABLE IF EXISTS Ticket;
DROP TABLE IF EXISTS Passenger;
Drop TABLE if EXISTS Flight;
DROP TABLE IF EXISTS Route;
DROP TABLE IF EXISTS NameTrain;
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

ALTER DATABASE RailwayTransportation
  ADD FILEGROUP TrainsFileGroup;  
GO 

ALTER DATABASE RailwayTransportation   
ADD FILE 
( NAME = TrainsFileGroupFile_1 ,
  FILENAME = '/Users/adelinazagitova/Documents/RailwayTransportation/TrainsFileGroupFile_1.mdf',
  SIZE = 10, 
  MAXSIZE = UNLIMITED,  
  FILEGROWTH = 5 ),
( NAME =  TrainsFileGroupFile_2,
  FILENAME = '/Users/adelinazagitova/Documents/RailwayTransportation/TrainsFileGroupFile_2.ndf',
  SIZE = 10, 
  MAXSIZE = UNLIMITED,  
  FILEGROWTH = 5 )
 TO FILEGROUP TrainsFileGroup 
GO
--Файловая группа по умолчанию
ALTER DATABASE RailwayTransportation   
 MODIFY FILEGROUP TrainsFileGroup  DEFAULT;  
GO  


USE RailwayTransportation
GO

IF OBJECT_ID('NameTrain') IS NOT NULL
  DROP TABLE NameTrain
GO
--таблица данных поездов
CREATE TABLE NameTrain(
    NumberTrain NVARCHAR(128) PRIMARY KEY NOT NULL,
    NumberOfSeats int NULL,
    NamberOfWagons int NULL,
);
--таблица данных пассажира
IF OBJECT_ID('Passenger') IS NOT NULL
  DROP TABLE Passenger
GO
CREATE TABLE Passenger(
    IDPassport NVARCHAR(128) PRIMARY KEY NOT NULL,
    FullName NVARCHAR(255) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Age int NOT NULL,
    CityOfBirth NVARCHAR(128) NULL,
    Phone NVARCHAR(50) NULL
);
--таблица данных маршрутов
IF OBJECT_ID('Route') IS NOT NULL
  DROP TABLE Route
GO
CREATE TABLE Route(
    RouteFlight NVARCHAR(128) PRIMARY KEY NOT NULL,
    DepartureStation NVARCHAR(128) NOT NULL,
    DepartureTime TIME  NULL,
    ArrivalStation NVARCHAR(128) NOT NULL,
    ArrivalTime TIME NOT NULL,
    TravelTime NVARCHAR(128) NULL
);
GO
--таблица рейсов
IF OBJECT_ID('Flight') IS NOT NULL
DROP TABLE Flight
GO

CREATE TABLE Flight(
    NumberFlight int IDENTITY(120,1) PRIMARY KEY NOT NULL,
    DateFlight DATE NULL,/*только дата рейса*/
    RouteFlight NVARCHAR(128) ,
     CONSTRAINT FK_Flight_Route FOREIGN KEY(RouteFlight)
     REFERENCES  Route(RouteFlight)
     ON DELETE CASCADE
	   ON UPDATE CASCADE,
    NumberTrain NVARCHAR(128)  NULL, 
     CONSTRAINT FK_Flight_Train FOREIGN KEY(NumberTrain)
     REFERENCES  NameTrain(NumberTrain)
     ON DELETE SET NULL
     ON UPDATE SET NULL,
);
GO

--создание таблицы билетов
IF OBJECT_ID('Ticket') IS NOT NULL
  DROP TABLE Ticket
GO
CREATE TABLE Ticket(
    NumberTicket NVARCHAR(128) PRIMARY KEY  NOT NULL,
    NumberFlight INT NOT NULL,
     CONSTRAINT FK_Ticket_NumberFlight FOREIGN KEY(NumberFlight)
     REFERENCES  Flight(NumberFlight)
     ON DELETE CASCADE
	   ON UPDATE CASCADE,
    IDPassport NVARCHAR(128) NULL,
     CONSTRAINT FK_Ticket_IdPassport FOREIGN KEY(IDPassport)
     REFERENCES  Passenger(IDPassport)
     ON DELETE SET NULL
     ON UPDATE SET NULL,
    FullName NVARCHAR(255)  NULL,
    PriceTicket SMALLMONEY NULL,
    PassengerSeat int NULL

);

GO
--заполнение таблиц
INSERT INTO NameTrain(NumberTrain,NumberOfSeats,NamberOfWagons) VALUES
  (N'AA33241',124,16),
  (N'BA89031',NULL,NULL),
  (N'AS88926',166,18),
  (N'SS27489',90,12),
  (N'EE09827',NULL,18),
  (N'FF78392',124,16),
  (N'BA45672',198,20),
  (N'KK09876',124,20),
  (N'KL90817',166,18),
  (N'SA09876',198,20);

INSERT INTO Passenger(IDPassport,FullName,DateOfBirth,Age,CityOfBirth,Phone) VALUES
  (N'4587 12345',N'Крук Артем Александрович','1994-07-24',24,N'Moscow',NULL),
  (N'4545 26748',N'Бидайшеева Алина Эмировна','2001-09-01',17,NULL,NULL),
  (N'1342 98874',N'Загитова Зульфия','2003-01-01',15,NULL,NULL),
  (N'1245 23984',N'Шишигина Агата','1998-11-12',20,N'Якутск',NULL),
  (N'3542 17723',N'Шань Инь Ань','1988-11-12',30,N'Магадан',N'7382916452'),
  (N'3902 23478',N'Загитова Эмилия Ильвировна','2004-07-12',24,N'Уфа',N'7382947920'),
  (N'US73234',N'Джи-Джи Хадид','1994-12-14',24,N'NewYork','+27227253'),
  (N'1234 78893',N'Загитова Ильвир','2000-05-06',18,NULL,N'789126364'),
  (N'AS6739',N'Элис Грей','1965-11-09',53,N'Торонто','+374724245'),
  (N'230SS-345',N'Сурен Магикян','1988-09-09',30,NULL,NULL),
  (N'90817 3456',N'Рассал Магомедов','1994-08-12',24,N'Moscow','23874829734'),
  (N'92817 2347',N'Рассал Магомедов','1994-09-09',24,N'Moscow','23874829734');

INSERT INTO Route(RouteFlight,DepartureStation,DepartureTime,ArrivalStation,ArrivalTime,TravelTime) VALUES
  (N'121A',N'Тбилиси','23:00:00.123',N'Москва','15:30:00.123', N'16 часов 30 минут'),
  (N'130B',N'Тбилиси','00:30:00.123',N'Москва','22:30:00.123',N'44 часа'),
  (N'122A',N'Москва','16:00:00.123',N'Уфа','23:40:00.123',N'33 часа 40 минут'),
  (N'123B',N'Сочи','17:30:00.123',N'Санкт-Петербург','14:40:00.123',N'21 час 10 минут'),
  (N'177F',N'Самара','19:00:00.123',N'Уфа','06:00:00.123',N'11 часов'),
  (N'155D',N'Якутск','01:30:00.123',N'Москва','01:30:00.123',N'72 часа'),  
  (N'112A',N'Чебоксары','01:30:00.123',N'Сочи','11:30:00.123',N'34 часа'),
  (N'155V',N'Москва','12:00:00.123',N'Уфа','12:30:00.123',N'24 часа 30 минут'),
  (N'199G',N'Казань','10:00:00.123',N'Сибай','22:00:00.123',N'10 часов'),
  (N'122C',N'Чебоксары','23:00:00.123',N'Сочи','10:00:00.123',N'11 часов'),
  (N'132D',N'Иркутск','23:30:00.123',N'Якутск','06:00:00.123',N' 6 часов 30 минут');

INSERT INTO Flight(DateFlight,RouteFlight,NumberTrain) VALUES
  ('2018-12-16',(SELECT RouteFlight FROM Route where RouteFlight = N'121A' ),(SELECT NumberTrain From NameTrain where NumberTrain = N'AA33241')),
  /* Один и тот же маршрут,но с разными поездами и разными датами */
  ('2018-12-17',(SELECT RouteFlight FROM Route where RouteFlight = N'121A' ),(SELECT NumberTrain From NameTrain where NumberTrain = N'KK09876')),
  ('2018-12-18',(SELECT RouteFlight FROM Route where RouteFlight = N'130B'),(SELECT NumberTrain From NameTrain where NumberTrain = N'SA09876')),
  /* поезд выехал из тбилиси и прибыл в москву, значит он может поехать далее по маршруту от москвы*/
  ('2018-12-22',(SELECT RouteFlight FROM Route where RouteFlight = N'122A' ),(SELECT NumberTrain From NameTrain where NumberTrain = N'KK09876')),
  ('2018-12-21',(SELECT RouteFlight FROM Route where RouteFlight = N'155V' ),(SELECT NumberTrain From NameTrain where NumberTrain = N'SA09876')),
  ('2018-12-18',(SELECT RouteFlight FROM Route where RouteFlight = N'155V' ),(SELECT NumberTrain From NameTrain where NumberTrain = N'AA33241')),
  ('2018-12-19',(SELECT RouteFlight FROM Route where RouteFlight = N'132D' ),(SELECT NumberTrain From NameTrain where NumberTrain = N'KL90817')),
  ('2018-12-19',(SELECT RouteFlight FROM Route where RouteFlight = N'155D' ),(SELECT NumberTrain From NameTrain where NumberTrain = N'KL90817')),
  ('2018-12-18',(SELECT RouteFlight FROM Route where RouteFlight = N'123B' ),(SELECT NumberTrain From NameTrain where NumberTrain = N'BA45672')),
  ('2018-12-19',(SELECT RouteFlight FROM Route where RouteFlight = N'112A' ),(SELECT NumberTrain From NameTrain where NumberTrain = N'AA33241')),
  ('2018-12-20',(SELECT RouteFlight FROM Route where RouteFlight = N'199G' ),(SELECT NumberTrain From NameTrain where NumberTrain = N'SS27489'));



INSERT INTO Ticket(NumberTicket,NumberFlight,IDPassport,FullName,PriceTicket,PassengerSeat) VALUES
  (N'AA12300987',(select NumberFlight from Flight where NumberFlight = 120),(select IDPassport from Passenger where IDPassport = N'4587 12345'),(select FullName from Passenger where IDPassport = N'4587 12345'),'2007.20',15),
  (N'AA12400987',(select NumberFlight from Flight where NumberFlight = 120),(select IDPassport from Passenger where IDPassport = N'4545 26748'),(select FullName from Passenger where IDPassport = N'4545 26748'),'2507.20',16),
  (N'SD89000987',(select NumberFlight from Flight where NumberFlight = 123),(select IDPassport from Passenger where IDPassport = N'3902 23478'),(select FullName from Passenger where IDPassport = N'3902 23478'),'4500.90',24),
  (N'SD21500987',(select NumberFlight from Flight where NumberFlight = 127),(select IDPassport from Passenger where IDPassport = N'1342 98874'),(select FullName from Passenger where IDPassport = N'1342 98874'),'9000.89',88),
  (N'JJ12300987',(select NumberFlight from Flight where NumberFlight = 121),(select IDPassport from Passenger where IDPassport = N'230SS-345'),(select FullName from Passenger where IDPassport = N'230SS-345'),'2007.20',10),
  (N'RT23300987',(select NumberFlight from Flight where NumberFlight = 122),(select IDPassport from Passenger where IDPassport = N'90817 3456'),(select FullName from Passenger where IDPassport = N'90817 3456'),'3333.20',4),
  (N'QW12300987',(select NumberFlight from Flight where NumberFlight = 123),(select IDPassport from Passenger where IDPassport = N'4587 12345'),(select FullName from Passenger where IDPassport = N'4587 12345'),'2029.20',19),
  (N'KK45300987',(select NumberFlight from Flight where NumberFlight = 124),(select IDPassport from Passenger where IDPassport = N'92817 2347'),(select FullName from Passenger where IDPassport = N'92817 2347'),'3000.20',33);


SELECT * FROM NameTrain
SELECT * FROM Passenger
SELECT * FROM Route
SELECT * FROM Flight
SELECT * FROM Ticket
GO

-- cоздание представления c помощью JOIN ON,выводит для каждого рейса все их билеты 
CREATE VIEW PassengerTicket_1 AS
  SELECT b.NumberFlight as Flight,NumberTicket as Ticket
  FROM Flight as a JOIN Ticket as b 
   ON b.NumberFlight = a.NumberFlight
GO

SELECT * FROM dbo.PassengerTicket_1
GO
--создание представления для рейсов, для проверки ,у которых нет проданных билетов LEFT JOIN

CREATE VIEW PassengerTicket_2 AS
  SELECT a.NumberFlight as Flight,NumberTicket as Ticket
  FROM Flight as a LEFT JOIN Ticket as b 
   ON a.NumberFlight = b.NumberFlight
GO
SELECT * FROM dbo.PassengerTicket_2
GO

IF OBJECT_ID ( 'dbo.PassengersUnder18', 'P' ) IS NOT NULL  
    DROP PROCEDURE dbo.PassengersUnder18;  
GO   
--процедура для вычесления не достигших 18 лет пассажиров, сортировка по возрастанию - ORDER BY ASC
CREATE PROCEDURE dbo.PassengersUnder18
    @Passenger CURSOR VARYING OUTPUT  
AS   
    SET @Passenger = CURSOR  
    FORWARD_ONLY STATIC FOR  
      SELECT IDPassport,FullName,DateOfBirth,Age,CityOfBirth,Phone
      FROM Passenger
      WHERE (Age <= 18) ORDER BY Age ASC;
    OPEN @Passenger;  
    
GO  

DECLARE @Cursor CURSOR
DECLARE @IDPassport NVARCHAR(128),@FullName NVARCHAR(255),@DateOfBirth DATE,@Age int,@CityOfBirth NVARCHAR(128),@Phone NVARCHAR(50)
EXEC dbo.PassengersUnder18 @Passenger = @Cursor OUTPUT; 
FETCH NEXT FROM @Cursor INTO @IDPassport,@FullName,@DateOfBirth,@Age,@CityOfBirth,@Phone
WHILE (@@FETCH_STATUS = 0)  
BEGIN; 
    SELECT @IDPassport as IDPassport,@FullName as FullName,@DateOfBirth as DateOfBirth,@Age as Age,@CityOfBirth as CityOfBirth,@Phone as Phone
     FETCH NEXT FROM @Cursor INTO @IDPassport,@FullName,@DateOfBirth,@Age,@CityOfBirth,@Phone
  
END; 
CLOSE @Cursor;  
DEALLOCATE @Cursor;  
GO
--представления для путей(город отправления-город прибытия), по которым осуществляется отправление в данной базе данных (DISTINCT)
CREATE VIEW WaysRoute  AS
   SELECT DISTINCT  a.DepartureStation AS Departure, a.ArrivalStation as Arrival
   FROM Route as a
GO
SELECT * FROM dbo.WaysRoute
GO

-- выборка поездов в функции по тем, которые есть в рейсах и у тех, у которых мест от 120 до 125(IN , BETWEEN)
IF OBJECT_ID ( 'dbo.NamberTrain', 'P' ) IS NOT NULL  
    DROP FUNCTION dbo.NamberTrain;  
GO

CREATE FUNCTION dbo.NamberTrain()
RETURNS TABLE
AS 
RETURN
 (
    SELECT p.NumberTrain, p.NumberOfSeats, p.NamberOfWagons
      FROM  dbo.NameTrain as p
      WHERE p.NumberTrain in (select NumberTrain
 from Flight) and p.NumberOfSeats between 120 and 125);
 GO

select * from dbo.NamberTrain()
GO
--тригер на вставку NameTrain (NumberTrain,NumberOfSeats,NamberOfWagons) с использованием COUNT

create TRIGGER InsertNumberTrain on NameTrain
  AFTER INSERT
  AS
     BEGIN 
   
     INSERT INTO NameTrain (NumberTrain,NumberOfSeats,NamberOfWagons)
		(SELECT  NumberTrain,NumberOfSeats,NamberOfWagons FROM inserted WHERE ((SELECT COUNT(*) FROM NameTrain WHERE NameTrain.NumberTrain = inserted.NumberTrain ) = 0))
     PRINT N'Добавлен новый поезд';
      END;
GO
/*INSERT INTO NameTrain(NumberTrain,NumberOfSeats,NamberOfWagons) VALUES 
   (N'FF12344',133,NULL),
   (N'AA33241',124,16);*/
Go
INSERT INTO NameTrain(NumberTrain,NumberOfSeats,NamberOfWagons) VALUES 
  (N'FF12344',133,NULL);

Go
select * from NameTrain
GO
-- Представление для данных пассажиров, с использованием  EXISTS

IF OBJECT_ID ( 'dbo.InfoPassenger', 'P' ) IS NOT NULL  
    DROP FUNCTION dbo.InfoPassenger;  
GO
CREATE VIEW  dbo.InfoPassenger 
WITH SCHEMABINDING
AS
   select p.IDPassport as Passport, p.FullName as Name,a.NumberTicket as Ticket,a.NumberFlight as Flight, a.PassengerSeat as Seat
   From dbo.Passenger as p,dbo.Ticket as a
   WHERE exists(select NumberFlight from dbo.Flight as d where a.NumberFlight = d.NumberFlight ) 
   and p.IDPassport = a.IDPassport 
GO

--запрос с помощью  ORDER BY DESC -по убыванию
select * from dbo.InfoPassenger order by Flight DESC
GO
IF OBJECT_ID ( 'dbo.InfoPassengerDelete', 'P' ) IS NOT NULL  
    DROP TRIGGER dbo.InfoPassengerDelete;  
GO

create TRIGGER InfoPassengerDelete on dbo.InfoPassenger
 INSTEAD OF DELETE
   AS
      BEGIN
       DELETE FROM Passenger WHERE EXISTS (SELECT * FROM deleted WHERE (deleted.Name = Passenger.FullName))
     print(N'Удалили пассажира')
     END;
  Go
Delete  from dbo.InfoPassenger where Flight = 120
GO
select * from dbo.InfoPassenger order by Flight DESC
GO

-- MIN and MAX функции и GROUP BY
IF OBJECT_ID ( 'dbo.MaxMinMoney', 'P' ) IS NOT NULL  
    DROP FUNCTION dbo.MaxMinMoney;  
GO
CREATE FUNCTION dbo.MaxMinMoney()
RETURNS TABLE
AS 
RETURN
 (
    SELECT NumberFlight as Flight, MIN(PriceTicket) as MinPrice,MAX(PriceTicket) as MaxPrise
      FROM  Ticket 
      group by NumberFlight);
 GO
select * from dbo.MaxMinMoney()
GO

--Like 2018 находим рейсы 
CREATE FUNCTION dbo.Like2018()
RETURNS TABLE
AS 
RETURN
 (
    SELECT d.NumberFlight as Flight,d.RouteFlight as Route
      FROM  Flight as d
      where  d.DateFlight like '%2018%');
  
 GO

select * from dbo.Like2018()
GO
--NULL
SELECT * FROM NameTrain where NumberOfSeats is NULL and NamberOfWagons is NULL
GO
UPDATE NameTrain SET NumberOfSeats = 10  where NumberOfSeats is NULL
GO

--
IF OBJECT_ID ( 'dbo.PassengerShema', 'P' ) IS NOT NULL  
    DROP VIEW dbo.PassengerShema;  
GO
--UNION исключение повторяющих записей
CREATE VIEW dbo.PassengerShema
WITH SCHEMABINDING
AS
  SELECT p.NumberFlight as Flight,d.FullName as Ticket
  FROM dbo.Ticket as p,dbo.Passenger as d
  where d.FullName = p.FullName
  UNION
SELECT p.NumberFlight as Flight,d.FullName as Ticket
  FROM dbo.Ticket as p,dbo.Passenger as d
  where d.FullName = p.FullName
GO
SELECT * FROM dbo.PassengerShema
GO
-- UNION ALL  не исключая повторения
IF OBJECT_ID ( 'dbo.PassengerShema_2', 'P' ) IS NOT NULL  
    DROP VIEW dbo.PassengerShema_2;  
GO

CREATE VIEW dbo.PassengerShema_2
WITH SCHEMABINDING
AS
 SELECT p.NumberFlight as Flight,d.FullName as Ticket
  FROM dbo.Ticket as p,dbo.Passenger as d
  where d.FullName = p.FullName
  UNION ALL
 SELECT p.NumberFlight as Flight,d.FullName as Ticket
  FROM dbo.Ticket as p,dbo.Passenger as d
  where d.FullName = p.FullName
GO

SELECT * FROM dbo.PassengerShema_2
GO

IF OBJECT_ID ( 'dbo.TrainShema', 'P' ) IS NOT NULL  
    DROP VIEW dbo.TrainShema;  
GO
--EXCEPT B Исключение результатов
CREATE VIEW dbo.TrainShema
WITH SCHEMABINDING
AS
  SELECT f.NumberTrain as Train, a.NumberFlight as Flight
  FROM dbo.NameTrain as f,dbo.Flight as a
  where f.NumberTrain = a.NumberTrain
  EXCEPT
 SELECT f.NumberTrain as Train, a.NumberFlight as Flight
  FROM dbo.NameTrain as f,dbo.Flight as a
  where f.NumberTrain = a.NumberTrain and a.NumberFlight = 124
GO
SELECT * FROM dbo.TrainShema
GO


IF OBJECT_ID ( 'dbo.TrainShema_2', 'P' ) IS NOT NULL  
    DROP VIEW dbo.TrainShema_2;  
GO
--Получение пересечения результаток выборок INTERSECT
CREATE VIEW dbo.TrainShema_2
WITH SCHEMABINDING
AS
  SELECT f.NumberTrain as Train, a.NumberFlight as Flight
  FROM dbo.NameTrain as f,dbo.Flight as a
  where f.NumberTrain = a.NumberTrain
  INTERSECT
 SELECT f.NumberTrain as Train, a.NumberFlight as Flight
  FROM dbo.NameTrain as f,dbo.Flight as a
  where f.NumberTrain = a.NumberTrain 
GO
SELECT * FROM TrainShema_2
GO
IF OBJECT_ID ( 'dbo.AVGSUMTrain', 'P' ) IS NOT NULL  
    DROP FUNCTION dbo.AVGSUMTrain; 
GO
-- AVG and SUM 
CREATE FUNCTION dbo.AVGSUMTrain()
RETURNS TABLE
AS 
RETURN
 (
    SELECT 
    AVG(d.NamberOfWagons) as AvgWagons,
    SUM(d.NamberOfWagons) as SumWagonsTrain,
    MIN(d.NamberOfWagons) as MINWagons,
    MAX(d.NamberOfWagons) as MAXWagons
      FROM  NameTrain as d
 );
  
 GO

select * from dbo.AVGSUMTrain()
GO
--вложенные запросы
SELECT a.NumberFlight as Flight,NumberTicket as Ticket
FROM Flight as a FULL OUTER JOIN Ticket as b 
 ON a.NumberFlight = b.NumberFlight 
 GO
 
SELECT NumberFlight as Flight, MAX(PriceTicket) as MinPrice
      FROM  Ticket 
      group by NumberFlight
      HAVING max(PriceTicket) > '2007.5000'


 


