--Потерянное обновление
-- В MS SQL данный сценарий невозможен,
-- потому что даже самый низкий уровень изоляции предотвращает такую ситуацию.
/*Эффект проявляется при одновременном изменении одного блока данных разными транзакциями. Причём одно из изменений может теряться.
Данная формулировка может по-разному интерпретироваться.*/
USE Trains
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRANSACTION
	UPDATE  Рейс_1 SET НомерПоезда = НомерПоезда + 10 WHERE НомерРейса = 123
	WAITFOR DELAY '00:00:10'
	SELECT НомерПоезда FROM  Рейс_1 WHERE НомерРейса = 123
    SELECT * FROM GetLocksInfo
COMMIT TRANSACTION
GO

-- При вычитывании данных в локальную переменную,
-- может произойти потеря обновления (прнименится лишь последнее обновление).
USE Trains
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRANSACTION
	DECLARE @Номер int
	SELECT @Номер = НомерПоезда FROM Рейс_1 WHERE НомерРейса = 123
	WAITFOR DELAY '00:00:10'
	UPDATE Рейс_1 SET НомерПоезда = НомерПоезда + 8 WHERE НомерРейса = 123
    SELECT * FROM GetLocksInfo
COMMIT TRANSACTION
GO
SELECT НомерПоезда FROM  Рейс_1 WHERE НомерРейса = 123
GO


--Грязное чтение.


USE Trains
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRANSACTION
  SELECT НомерПоезда FROM Рейс_1 WHERE НомерРейса = 128
  SELECT * FROM GetLocksInfo
  COMMIT TRANSACTION
GO


-- Неповторяющееся чтение.


USE Trains
GO
BEGIN TRANSACTION
	UPDATE  Рейс_1
    SET НомерПоезда = 15  WHERE НомерРейса = 128
    SELECT * FROM GetLocksInfo
COMMIT TRANSACTION
GO


--Фантомное чтение.


USE Trains
GO

BEGIN TRANSACTION
	 INSERT INTO Рейс_1(НомерРейса, НомерПоезда, Маршрут) 
     VALUES (130, 4443,'A1526HGV')
     SELECT * FROM GetLocksInfo
     SELECT * FROM Рейс_1
COMMIT TRANSACTION
GO
