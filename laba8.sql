USE master
DROP TABLE IF EXISTS Flight;
DROP FUNCTION IF EXISTS dbo.GetTrainFromDB;
DROP PROCEDURE IF EXISTS dbo.SortTrain ;
DROP FUNCTION IF EXISTS dbo.Function1;
DROP PROCEDURE IF EXISTS dbo.SortTrain2 ;
USE master
CREATE TABLE Flight(
    IdFlight int ,
    IdTrain  int,
    Route    int,
);
GO
INSERT INTO Flight(IdFlight,IdTrain,Route)
 VALUES (123,18,55),
        (124,15,66),
        (141,15,88);
GO
SELECT * FROM Flight
GO
IF OBJECT_ID ( 'dbo.FlightCursor', 'P' ) IS NOT NULL  
    DROP PROCEDURE dbo.FlightCursor;  
GO  
--1 

CREATE PROCEDURE dbo.FlightCursor 
    @FliCursor CURSOR VARYING OUTPUT  
AS   
    SET @FliCursor = CURSOR  
    FORWARD_ONLY STATIC FOR  
      SELECT IdFlight,Route 
      FROM Flight
      WHERE IdTrain = '15';  
    OPEN @FliCursor;  
    
GO  

DECLARE @MyCursor CURSOR
DECLARE @IdFlight INT, @Route int
EXEC dbo.FlightCursor @FliCursor = @MyCursor OUTPUT; 
FETCH   FROM @MyCursor INTO @Route,@Idflight 
WHILE (@@FETCH_STATUS = 0)  
BEGIN; 
    SELECT @Route as Route, @IdFlight as IdFlight
     FETCH NEXT FROM @MyCursor INTO @Route,@IdFlight
  
END; 
CLOSE @MyCursor;  
DEALLOCATE @MyCursor;  
GO  


--2
CREATE FUNCTION dbo.Function1(@Route3 int)
RETURNS INT
  AS
BEGIN 
     RETURN @Route3
END;
GO


CREATE FUNCTION dbo.GetTrainFromDB (@IdTrains int)
RETURNS TABLE
AS 
RETURN
 (
    SELECT IdFlight,Route 
      FROM Flight 
      WHERE IdTrain = @IdTrains);
 GO

IF OBJECT_ID ( 'dbo.SortTrain', 'P' ) IS NOT NULL  
    DROP PROCEDURE dbo.SortTrain;  
GO 

CREATE PROCEDURE dbo.SortTrain      
     @SortTrains CURSOR VARYING OUTPUT  
AS   
    SET @SortTrains = CURSOR  
    FORWARD_ONLY STATIC FOR    
    SELECT dbo.Function1(Route)
    FROM Flight
    OPEN @SortTrains; 
GO  
DECLARE @MyCursor1 CURSOR
DECLARE  @Route1 INT
EXEC dbo.SortTrain @SortTrains = @MyCursor1 OUTPUT; 
FETCH NEXT FROM @MyCursor1 INTO @Route1
WHILE (@@FETCH_STATUS = 0)  
BEGIN
    SELECT @Route1 as Route
     FETCH NEXT FROM @MyCursor1 INTO @Route1
END; 
CLOSE @MyCursor1;  
DEALLOCATE @MyCursor1;  
GO  
--3
IF OBJECT_ID ( 'dbo.ExecProcedure', 'P' ) IS NOT NULL  
    DROP PROCEDURE dbo.ExecProcedure;  
GO 
CREATE PROCEDURE  dbo.ExecProcedure
AS
DECLARE @MyCursor2 CURSOR
DECLARE @Route2 INT
EXEC dbo.SortTrain @SortTrains = @MyCursor2 OUTPUT; 
FETCH NEXT FROM @MyCursor2 INTO @Route2
WHILE (@@FETCH_STATUS = 0)  
BEGIN  
    SELECT @Route2 as Route
     FETCH NEXT FROM @MyCursor2 INTO @Route2
     
END; 
CLOSE @MyCursor2;  
DEALLOCATE @MyCursor2;  
GO  
EXECUTE dbo.ExecProcedure
GO
--4
IF OBJECT_ID ( 'dbo.FlightCursor2', 'P' ) IS NOT NULL  
    DROP PROCEDURE dbo.FlightCursor2;  
GO  

CREATE PROCEDURE dbo.SortTrain2      
     @SortTrains2 CURSOR VARYING OUTPUT  
AS   
    SET @SortTrains2 = CURSOR
    --Указывает, что курсор может просматриваться только от первой строки к последней
    --создает временную копию данных для использования курсором
    FORWARD_ONLY STATIC FOR    
    SELECT * FROM dbo.GetTrainFromDB('18')
    --заполняет результирующий набор
    OPEN @SortTrains2; 
GO  
-- использует синтаксис ISO для задания параметров работы курсора.
DECLARE @MyCursor3 CURSOR
DECLARE @IdFlight3 INT, @Route3 INT
EXEC dbo.SortTrain2 @SortTrains2 = @MyCursor3 OUTPUT; 
--возвращает из него строку
FETCH NEXT FROM @MyCursor3 INTO @Route3,@Idflight3
WHILE (@@FETCH_STATUS = 0)  
BEGIN;  
     SELECT @Route3 as Route, @IdFlight3 as IdFlight
     FETCH NEXT FROM @MyCursor3 INTO @Route3,@IdFlight3
    
END; 
--снимает блокировку курсоров для строк
CLOSE @MyCursor3; 
-- Удаляет ссылку курсора, чтобы освободить данные захваченные курсором
DEALLOCATE @MyCursor3;  
GO 