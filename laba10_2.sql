
--Потерянное обновление
-- В MS SQL данный сценарий невозможен, потому что даже самый низкий уровень изоляции предотвращает такую ситуацию.
USE Trains
GO
BEGIN TRANSACTION
	UPDATE  Рейс_1 SET НомерПоезда = НомерПоезда * 2 WHERE НомерРейса = 123
	WAITFOR DELAY '00:00:10'
	SELECT НомерПоезда FROM  Рейс_1 WHERE НомерРейса = 123  
COMMIT TRANSACTION
GO

-- При вычитывании данных в локальную переменную, может произойти потеря обновления (прнименится лишь последнее обновление).
USE Trains
GO
BEGIN TRANSACTION
	DECLARE @Номер int
	SELECT @Номер = НомерПоезда FROM Рейс_1 WHERE НомерРейса = 123
	WAITFOR DELAY '00:00:10'
	UPDATE Рейс_1 SET НомерПоезда = НомерПоезда * 2 WHERE НомерРейса = 123
COMMIT TRANSACTION
GO
SELECT НомерПоезда FROM Рейс_1 WHERE НомерРейса = 123
GO


--Грязное чтение.


USE Trains
GO
BEGIN TRANSACTION
	UPDATE Рейс_1 SET НомерПоезда = НомерПоезда * 2 
	WAITFOR DELAY '00:00:10';
ROLLBACK;
GO
SELECT НомерПоезда FROM Рейс_1 WHERE НомерРейса = 128
GO


-- Неповторяющееся чтение.


USE Trains
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
--SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
	SELECT * FROM Рейс_1 WHERE НомерРейса = 128
	WAITFOR DELAY '00:00:10'
	SELECT * FROM Рейс_1 WHERE НомерРейса = 128
COMMIT TRANSACTION
GO


--Фантомное чтение.


USE Trains
GO
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
--SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRANSACTION
	SELECT * FROM Рейс_1
	WAITFOR DELAY '00:00:10'  
	SELECT * FROM Рейс_1
COMMIT TRANSACTION
GO
