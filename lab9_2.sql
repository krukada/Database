DROP TABLE IF EXISTS Пассажир_1;
DROP TABLE IF EXISTS Рейс_1;
DROP  VIEW IF EXISTS lol;
if OBJECT_ID(N'FK_Пассажир',N'F') IS NOT NULL 
ALTER TABLE Пассажир DROP CONSTRAINT FK_Пассажир 
go 
 USE master;
CREATE TABLE  Рейс_1(
     НомерРейса  int PRIMARY KEY NOT NULL,
     НомерПоезда int NOT NULL,
     Маршрут   NVARCHAR(50) NULL,
 );
 CREATE TABLE Пассажир_1(
     НомерРейса int NOT NULL,
     IdПассажира int PRIMARY KEY  IDENTITY(1, 1),
     ФИО NVARCHAR(250) NOT NULL,
     CONSTRAINT FK_Пассажир FOREIGN KEY(НомерРейса)
     REFERENCES Рейс_1 (НомерРейса)
 );
 INSERT INTO Рейс_1(НомерРейса, НомерПоезда, Маршрут) VALUES (123, 3333,'A1526V')
 INSERT INTO Рейс_1(НомерРейса, НомерПоезда, Маршрут) VALUES (124, 3324,'B1626V')
 INSERT INTO Рейс_1(НомерРейса, НомерПоезда, Маршрут) VALUES (125, 3283,'C1526V')
 INSERT INTO Рейс_1(НомерРейса, НомерПоезда, Маршрут) VALUES (126, 3093,'D1726V')
 INSERT INTO Рейс_1(НомерРейса, НомерПоезда, Маршрут) VALUES (127, 3883,'F1926V')
 INSERT INTO Рейс_1(НомерРейса, НомерПоезда, Маршрут) VALUES (128, 3123,'H1226V')

 INSERT INTO Пассажир_1(НомерРейса, ФИО) VALUES (125, N'Федор Птушкин')
 INSERT INTO Пассажир_1(НомерРейса, ФИО) VALUES (126, N'Рик')
 INSERT INTO Пассажир_1(НомерРейса, ФИО) VALUES (127, N'Морти')
 INSERT INTO Пассажир_1(НомерРейса, ФИО) VALUES (127, N'Лера Москаленко')
 INSERT INTO Пассажир_1(НомерРейса, ФИО) VALUES (123, N'Алина Бидайшейка')
 INSERT INTO Пассажир_1(НомерРейса, ФИО) VALUES (123, N'Артем Крук')
 INSERT INTO Пассажир_1(НомерРейса, ФИО) VALUES (128, N'Артем Крук')
SELECT * FROM Рейс_1
SELECT * FROM Пассажир_1
Go
CREATE VIEW lol
AS
SELECT k.ФИО,p.НомерРейса,p.НомерПоезда
FROM Пассажир_1 as k,Рейс_1 as p
WHERE p.НомерРейса = k.НомерРейса
GO
SELECT * FROM dbo.lol;
GO

IF OBJECT_ID(N'LolTrrigerDelete',N'TR') IS NOT NULL 
DROP TRIGGER LolTrrigerDelete 
GO 

create TRIGGER LolTrrigerDelete ON lol
   INSTEAD OF DELETE
   AS
        BEGIN
        --Удалять пассажира мы можем по любым его характеристикам,также можно удалить весь рейс, если его отменили (или UPDATE, если заменили)
            DELETE FROM Пассажир_1 WHERE EXISTS (SELECT * FROM deleted WHERE (deleted.ФИО = Пассажир_1.ФИО)) 
              PRINT (N'удалили пассажира');
        -- Удаляем пустые рейсы из таблицы рейсов, которые не используются 
            DELETE FROM  Рейс_1 WHERE ((SELECT COUNT(*) FROM Пассажир_1 WHERE Рейс_1.НомерРейса = Пассажир_1.НомерРейса) = 0 )
       END;
     GO

/*DELETE FROM dbo.lol WHERE   НомерРейса = 123
SELECT * FROM dbo.lol;
GO
DELETE FROM dbo.lol WHERE   ФИО = N'Мудрый мудак'
Go
SELECT * FROM dbo.lol;
GO
DELETE FROM dbo.lol WHERE   НомерРейса = 127
SELECT * FROM dbo.lol;
GO*/
DELETE FROM dbo.lol WHERE   НомерПоезда = 3883
SELECT * FROM dbo.lol;
GO
DELETE FROM dbo.lol WHERE   ФИО = N'Рик'
Go
SELECT * FROM Рейс_1
SELECT * FROM Пассажир_1
Go

IF OBJECT_ID(N'LolUpdateTrig ',N'TR') IS NOT NULL 
DROP TRIGGER LolUpdateTrig 
GO 

CREATE TRIGGER LolUpdateTrig ON lol
	INSTEAD OF UPDATE
	AS
    BEGIN
    --Можно изменять имена пассажиров, вносить поправки
      UPDATE  Пассажир_1 SET ФИО = (SELECT ФИО from inserted) WHERE ФИО IN (SELECT ФИО FROM deleted) 
       and НомерРейса IN (SELECT НомерРейса FROM deleted)
       PRINT N'Данные о пассажирах изменены!'
    --Менять только данные ОДНОГО человека , связанные с рейсом, если изменить поезд
    --Нельзя менять данные рейса для пассажира, для этого его нужно удалить, и потом создать заново для другого рейса
     UPDATE Рейс_1 set  НомерПоезда = (SELECT НомерПоезда from inserted) WHERE НомерПоезда IN (SELECT  НомерПоезда FROM deleted)
      and НомерРейса IN (SELECT НомерРейса FROM deleted)
    End;
GO

UPDATE dbo.lol SET ФИО = N'Федор Птушкин' WHERE  ФИО = N'Федор Птушкович'
GO
SELECT * FROM dbo.lol;
GO
UPDATE dbo.lol SET ФИО = N'Артем Александрочив Крук' WHERE  ФИО = N'Артем Крук' and НомерРейса = 128
GO
SELECT * FROM dbo.lol;
GO
UPDATE dbo.lol SET ФИО = N'Иван Птушкевич' WHERE  НомерРейса = 125 
SELECT * FROM dbo.lol;
GO
--Выдаст ошибку так как нельзя обновлять сразу две строки в Пассажирах
/*UPDATE dbo.lol SET ФИО = N'Иван Птушкевич' WHERE  НомерРейса = 123 
SELECT * FROM dbo.lol;
GO*/
UPDATE dbo.lol SET НомерПоезда = 4433 WHERE   НомерРейса = 125 
GO
SELECT * FROM dbo.lol;
GO
--Для данного представления нельзя менять для пассажиров поезда,
-- если только для одного единственного пассажира, а чтобы сделать для всех нужно обновить таблицу с Рейсами
UPDATE dbo.Рейс_1 SET НомерПоезда = 5533 WHERE   НомерРейса = 123
GO
SELECT * FROM dbo.lol;
GO



CREATE TRIGGER lolTrrigerInsert ON lol
   INSTEAD OF INSERT
   AS
BEGIN
	/* Можно вставить пассажира, но только с тем рейсом,который уже существует.
    Также можно вставить рейс только вместе поездом, ибо так рейс считается несущественным */
    INSERT INTO Пассажир_1 (ФИО,НомерРейса)
		(SELECT  ФИО,НомерРейса FROM inserted WHERE (EXISTS(SELECT * FROM Рейс_1
			WHERE  (inserted.НомерРейса = Рейс_1.НомерРейса))))
	INSERT INTO Рейс_1 (НомерПоезда,НомерРейса)
		(SELECT   НомерПоезда,НомерРейса FROM inserted 
		WHERE (NOT EXISTS(SELECT * FROM Рейс_1
			WHERE  (inserted.НомерРейса = Рейс_1.НомерРейса))))

END
GO




INSERT INTO dbo.lol(НомерПоезда, НомерРейса) VALUES (1267,133)
GO
SELECT * FROM dbo.lol;
GO
SELECT * FROM Рейс_1
SELECT * FROM Пассажир_1
Go

INSERT INTO dbo.lol(ФИО,НомерРейса) VALUES (N'Федор Птушкин',123)
GO
SELECT * FROM dbo.lol;
GO
SELECT * FROM Рейс_1
SELECT * FROM Пассажир_1
Go

INSERT INTO dbo.lol(ФИО,НомерРейса) VALUES (N'Игорь Вишняков',133)
GO
SELECT * FROM dbo.lol;
GO
SELECT * FROM Рейс_1
SELECT * FROM Пассажир_1
Go

