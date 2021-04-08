-----creer des databases ayant des noms des jours 
CREATE DATABASE "LUNDI"
CREATE DATABASE "MARDI"
CREATE DATABASE "MERCREDI"
CREATE DATABASE "JEUDI"
CREATE DATABASE "VENDREDI"
CREATE DATABASE "SAMEDI"
CREATE DATABASE "DIMANCHE"
DECLARE @name VARCHAR(50) -- nom du database 
DECLARE @path VARCHAR(256) -- stockage 
DECLARE @fileName VARCHAR(256) -- nom du fichier BACKUP
DECLARE @fileDate VARCHAR(20) -- utilisee dans le nom du fichier
DECLARE @day VARCHAR(50)= CONVERT(varchar ,DATENAME (dw,GETDATE()) ,112)--- le nom du jour //d'aujourd'hui
DECLARE @now_time time(2) = convert (time,SYSDATETIME())---temps actuel 
 while @now_time='23:00'
 BEGIN 
-- direction vers fichier du BACKUP 
SET @path = 'C:\Backup\'  
-- LA FORME DU NOM DU FICHIER 
SELECT @fileDate = CONVERT(date,GETDATE()) 
DECLARE db_cursor CURSOR READ_ONLY FOR  --read only pour ne pas supprimer ce qui etait enregistré auparavant
SELECT name 
FROM master.sys.databases 
WHERE name NOT IN ('master','model','msdb','tempdb')  -- exclude these databases
AND state = 0 -- database est en ligne
AND is_in_standby = 0 -- la base de données n'est pas en lecture seule pour l'envoi de journaux
AND name = UPPER(@day) -----stocker les informations dans la base de donnee de meme nom
 OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @name   
 
WHILE @@FETCH_STATUS = 0 --Renvoie l'état de la dernière instruction FETCH effectuée sur le curseur,elle renvoie 0 si tout s'est bien passé
BEGIN   
   SET @fileName = @path + @name + '_' + @fileDate + '.BAK'  
   BACKUP DATABASE @name TO DISK = @fileName  
 
   FETCH NEXT FROM db_cursor INTO @name   
END   

 
CLOSE db_cursor   
DEALLOCATE db_cursor
END 
