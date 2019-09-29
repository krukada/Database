DROP TRIGGER IF EXISTS ChildTriggerUpdate;
DROP TRIGGER IF EXISTS ChildTriggerDelete;
DROP TRIGGER IF EXISTS ChildTriggerInsert;
DROP TRIGGER IF EXISTS PolTrrigerDelete;
DROP TRIGGER IF EXISTS PolTrrigerInsert;
DROP TRIGGER IF EXISTS PolTrrigerUpdate;
 
 USE master
 GO
 DROP TABLE IF EXISTS Ребенок;
 DROP TABLE IF EXISTS Родитель;
 DROP VIEW IF EXISTS pol;
 CREATE TABLE Родитель(
     РодительID int PRIMARY KEY ,
     MINРебенокID int
 );
 GO

 CREATE TABLE Ребенок(
     IDРебенка int  PRIMARY KEY,
     РодительID int DEFAULT '1',
     CONSTRAINT FK_Ребенок FOREIGN KEY(РодительID)
     REFERENCES Родитель (РодительID)
     ON DELETE NO ACTION
     ON UPDATE NO ACTION
 );
INSERT INTO Родитель(РодительID,MINРебенокID) VALUES(1,0)
INSERT INTO Родитель(РодительID,MINРебенокID) VALUES(2,1)
INSERT INTO Родитель(РодительID,MINРебенокID) VALUES(3,2)
INSERT INTO Родитель(РодительID,MINРебенокID) VALUES(4,3)

INSERT INTO Ребенок(IDРебенка,РодительID) SELECT  MINРебенокID,РодительID  FROM Родитель;
SELECT * FROM Родитель
SELECT * FROM Ребенок
GO 
--AFTER UPDATE указывает, что триггер срабатывает после выполнения оператора UPDATE,только в таблицах
CREATE TRIGGER ChildTriggerUpdate on Ребенок
 AFTER UPDATE
 AS
 --Обновление родительского столбца
 IF UPDATE(РодительID)
 PRINT (' Parent column is updated');
 --Обновления дочернего столбца
 IF UPDATE(IDРебенка)
 PRINT ('Child column is updated');
GO

UPDATE  Ребенок SET РодительID = РодительID + 1 WHERE РодительID < 2;
GO

--BEFORE DELETE указывает, что триггер срабатывает до выполнения оператора DELETE.

CREATE TRIGGER ChildTriggerDelete on Ребенок
 AFTER DELETE
 AS
 PRINT ('Child is deleted');
GO

DELETE FROM Ребенок WHERE IDРебенка = 4;
DELETE FROM Ребенок WHERE IDРебенка = 16;
GO


create TRIGGER ChildTriggerInsert on Ребенок
  AFTER INSERT
  AS
  
     BEGIN 
      IF EXISTS(SELECT IDРебенка FROM inserted WHERE IDРебенка = 3)
      BEGIN
      --серьезности от 20 до 25 считаются неустранимыми.
      --Вы получите синтаксическую ошибку 11-20
      --для предупреждения 0-10
-- 10- важность(0,18), 1-код состояния
        RAISERROR (' Fail',10,1)
        ROLLBACK TRANSACTION;
     END;
     ELSE 
     PRINT 'Child is inserted';
     END;
GO

 

--проверки
DELETE FROM Ребенок WHERE IDРебенка = 3;
GO



INSERT INTO Ребенок(IDРебенка,РодительID) VALUES (5, 3);
GO
INSERT INTO Ребенок(IDРебенка,РодительID) VALUES (3, 3);
GO

      


DELETE FROM Ребенок WHERE IDРебенка = 2;
GO
INSERT INTO Ребенок(IDРебенка,РодительID) VALUES (2, 2);
GO

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

--2
--результаты изменений, внесенных триггером INSTEAD OF, никак не отражаются на таблице/таблицах, на основе которых создано VIEW.
CREATE TRIGGER PolTrrigerDelete ON pol
   INSTEAD OF DELETE
   AS
     DECLARE @РодительID int,@IDРебенка int;
     SELECT @РодительID = РодительID ,@IDРебенка = IDРебенка FROM deleted;

    IF EXISTS (SELECT * FROM Родитель WHERE РодительID = @РодительID) 
    AND EXISTS (SELECT * FROM Ребенок WHERE IDРебенка = @IDРебенка)
    BEGIN
       IF EXISTS (SELECT * FROM Ребенок WHERE IDРебенка = @IDРебенка AND РодительID = @РодительID)
				DELETE FROM Ребенок WHERE IDРебенка = @IDРебенка AND РодительID = @РодительID
			ELSE  
            --Отношения с дочерними элементами удалены
            DELETE FROM Родитель WHERE РодительID = @IDРебенка
			PRINT 'Relation with child is deleted';
            END;
        ELSE
         PRINT 'Relation does not exist'
GO

CREATE TRIGGER PolUpdateTrig ON pol
	INSTEAD OF UPDATE
	AS

		RAISERROR ('Updating is not allowed', 10, 2);
GO
 
CREATE TRIGGER PolTrrigerInsert ON pol
   INSTEAD OF INSERT
   AS
   DECLARE @ParentID int, @ChildID int;
		SELECT @ParentID = РодительID, @ChildID = IDРебенка FROM inserted;
		--Отношение уже вставлено до этого
		IF EXISTS ( SELECT * FROM Родитель WHERE РодительID  = @ParentID )
         AND EXISTS ( SELECT * FROM  Ребенок WHERE  IDРебенка = @ChildID AND РодительID = @ParentID)
			PRINT 'Relation has been already inserted before';

		ELSE 
        -- Судествует уже отношение с тем же ребенком
        IF EXISTS ( SELECT * FROM Родитель WHERE РодительId = @ParentID ) 
        AND EXISTS ( SELECT * FROM Ребенок WHERE IDРебенка = @ChildID)
			PRINT 'There is another relation with same child';

		ELSE 
        --Взаимодействие с новым родителем вставлено
        IF EXISTS ( SELECT * FROM Ребенок WHERE IDРебенка = @ChildID )
		BEGIN
			INSERT INTO Родитель(РодительID) VALUES (@ParentID);
			UPDATE Ребенок SET РодительID = @ParentID;
			PRINT 'Relation with new parent is inserted';
		END

		ELSE
        --Новые связь ребенок, родитель вставлена
         IF EXISTS ( SELECT * FROM Родитель WHERE РодительId = @ParentID )
		BEGIN
			INSERT INTO Ребенок(IDРебенка, РодительID) VALUES (@ChildID, @ParentID);
			PRINT 'Relation with new child is inserted';
		END;

		ELSE 
        --связь с новыми родителями и дочерними элементами вставлена
        BEGIN
			INSERT INTO Родитель(РодительID) VALUES (@ParentID);
			INSERT INTO Ребенок(IDРебенка, РодительID) VALUES (@ChildID, @ParentID);
			PRINT 'Relation with new parent and child is inserted';
		END;
GO

SELECT * FROM dbo.pol;
GO
DELETE FROM dbo.pol WHERE РодительID = 2 AND IDРебенка = 1
GO
SELECT * FROM dbo.pol;
GO

INSERT INTO dbo.pol( РодительID, IDРебенка) VALUES (7, 2)
GO
INSERT INTO dbo.pol( РодительID, IDРебенка) VALUES (6, 6)
GO



SELECT * FROM dbo.pol;
GO

UPDATE dbo.pol SET IDРебенка = IDРебенка - 1 WHERE РодительID = 7;
GO

SELECT * FROM dbo.pol;
GO
