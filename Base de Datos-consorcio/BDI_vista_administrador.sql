
-- NOTA PRINCIPAL 
-- Al crear la base de datos, crearla con el campo "fechaPago" de la tabla "gasto" como campo único para que después al crear el índice para la vista indexada no se generen errores.



-- 2) Crear una vista sobre la tabla administrador que solo muestre los campos apynom, sexo  y fecha de nacimiento.
USE base_consorcio;

CREATE VIEW vistaAdministrador AS
SELECT apeynom, sexo, fechnac
FROM administrador;

SELECT * FROM vistaAdministrador;




-- 3) Realizar insert de un lote de datos sobre la vista recien creada. Verificar el resultado en la tabla administrador.
-- NOTA: Al realizar el insert a la vista, se agragan los campos insertados con normalidad y, los campos cuyos valores no se especificaron (ya que la vista solo trabaja con ciertos campos y no con todos) se cargan los valores que se asignan por defecto a la hora de crear un registro.
-- OBSERBACIÓN: Al cargar un registro sin especificar una "fechnac" este se crea sin inconvenientes. Tal vez se debería agregar una restricción para que éste campo sea cargado con una fecha válida obligatoriamente (NOT NULL). Y al insertarse un nuevo registro, este debe tener mas de uno o dos caracteres en su campo "apeynom", ya que es un dato que cualquier persona tiene.
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('BASUALDO DELMIRA', 'F', '19801009')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('SEGOVIA ALEJANDRO H.', 'M', '19740602')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('ROMERO ELEUTERIO', 'M', '19720819')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('NAHMIAS DE K. NIDIA', 'F', '19711128')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('CORREA DE M. MARIA G.', 'F', '19900116')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('NAHMIAS JOSE', 'M', '19740902')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('NAHMIAS DE R. REBECA J.', 'F', '19890307')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('LOVATO CERENTTINI ISABEL', 'F', '19731015')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('GOMEZ MATIAS GABRIEL', 'M', '19740320')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('CORREA HUGO E.', 'M', '19930811')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('MACHUCA CEFERINA', 'F', '19910916')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('CARDOZO MAXIMA', 'F', '19881107')
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('', 'F', ''); -- Prueba en restricciones faltantes.

select * from vistaAdministrador ;



-- 4) Realizar update sobre algunos de los registros creados y volver a verificar el resultado en la tabla.
-- NOTA: Se actualiza el registro normalmente.
-- OBSERVACIÓN: Al actualizar un registro, éste debe tener un campo clave para poder acceder a el y asegurarnos de que es el único con dicho valor en ese campo clave. Tal vez deberíamos agregar a la vista el campo (índice) "idadmin" para solucionar este inconveniente. 
Update vistaAdministrador set fechnac = '19990916' where apeynom = 'CARDOZO PRUEBA';
select * from administrador order by idadmin desc;




-- 5) Borrar todos los registros insertados a través de la vista.
-- OBSERVACIÓN: Para eliminar los registros creados con la vista tuve que comparar en los registros de "administrador" el campo "tel" en donde éstos eran nulos, lo cual no es lo correcto ya que, si se había cargardo un registro con "tel" en null que no haya sido con la vista, éste se eliminaria también. Mi solución sería crear un índice en la vista el cual va ser de gran ayuda para realizar esta operación.
DELETE FROM administrador
WHERE tel is NULL;


-- 6) Crear una vista que muestre los datos de las columnas de las siguientes tablas: (Administrador->Apeynom, consorcio->Nombre, gasto->periodo, gasto->fechaPago, tipoGasto->descripcion) .
CREATE VIEW vistaGeneral 
WITH SCHEMABINDING
AS SELECT [dbo].[administrador].apeynom, [dbo].[consorcio].nombre, [dbo].[gasto].periodo, [dbo].[gasto].fechaPago, [dbo].[tipogasto].descripcion
FROM [dbo].[consorcio]
JOIN [dbo].[administrador] ON [dbo].[administrador].idadmin = [dbo].[consorcio].idadmin 
JOIN [dbo].[gasto] ON [dbo].[gasto].idconsorcio = [dbo].[consorcio].idconsorcio
JOIN [dbo].[tipogasto] ON [dbo].[tipogasto].idtipogasto = [dbo].[gasto].idtipogasto;

select * from vistaGeneral ;



-- 7) Crear un indice sobre la columna fechaPago sobre la vista  recien creada.
-- Coloco el campo "fechaPago" de la tabla "gasto" como unico ya nesesito que éste sea único para luego crear el índice correspondiente a la vista.
-- NOTA: Tuve que vaciar la base de datos para poder crear el indice ya que habian pagos con la misma fecha y la hora y segundo no estaban cargadas(si estas estaban cargadas todos serian únicos). 
ALTER TABLE [dbo].[gasto]
ADD CONSTRAINT unicoFechaPago UNIQUE (fechaPago);

-- Creo el índice para fechaPago
CREATE UNIQUE CLUSTERED INDEX IX_vistaGeneral_FechaPago
ON [dbo].[vistaGeneral] (fechaPago);
select * from vistaGeneral order by nombre asc ;

-- 8) Las concluciones fui poniendo en cada punto.


-- Implementacion de backup y restore

-- 1 Verificar el modo de recuperación de la base de datos
use base_consorcio;
SELECT name, recovery_model_desc
FROM sys.databases
WHERE name = 'base_consorcio;';

go

-- 2 cambiamos el modo de recuperacion
USE master -- se utiliza el contexto de la base de datos master
ALTER DATABASE base_consorcio
SET RECOVERY FULL;

go

-- 3 Realizamos backup de la base de datos
BACKUP DATABASE base_consorcio
TO DISK = 'C:\backup\consorcio_backup.bak'
WITH FORMAT, INIT;

-- 4 Se insertan 10 nuevos registros
USE base_consorcio;
select * from gasto;
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) VALUES (1, 1, 1, 5, GETDATE(), 5, 1200);
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) VALUES (2, 3, 1, 6, GETDATE(), 2, 1500);
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) VALUES (3, 2, 4, 7, GETDATE(), 8, 800);
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) VALUES (1, 4, 2, 5, GETDATE(), 6, 2000);
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) VALUES (2, 1, 3, 6, GETDATE(), 1, 1000);
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) VALUES (3, 3, 1, 7, GETDATE(), 4, 1200);
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) VALUES (1, 2, 2, 5, GETDATE(), 7, 900);
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) VALUES (2, 4, 4, 6, GETDATE(), 3, 1800);
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) VALUES (3, 1, 3, 7, GETDATE(), 5, 1100);
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) VALUES (1, 3, 1, 5, GETDATE(), 9, 1300);


-- 4 Realizamos backup del log de la base de datos

BACKUP LOG base_consorcio
TO DISK = 'C:\backup\LogBackup.trn'
WITH FORMAT, INIT;


-- Insertamos 10 registros mas

select * from gasto

INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) VALUES (1, 1, 1, 5, GETDATE(), 5, 1200);
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) VALUES (2, 2, 2, 6, GETDATE(), 6, 1300);
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) VALUES (3, 3, 3, 7, GETDATE(), 7, 1400);
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) VALUES (4, 4, 4, 8, GETDATE(), 8, 1500);
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) VALUES (5, 5, 5, 9, GETDATE(), 9, 1600);
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) VALUES (6, 6, 6, 10, GETDATE(), 10, 1700);
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) VALUES (7, 7, 7, 11, GETDATE(), 11, 1800);
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) VALUES (8, 8, 8, 12, GETDATE(), 12, 1900);
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) VALUES (9, 9, 9, 13, GETDATE(), 13, 2000);
INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) VALUES (10, 10, 10, 14, GETDATE(), 14, 2100);



--5 Realizamos backup del log en otra ubicacion

BACKUP LOG base_consorcio
TO DISK = 'C:\backup\logs\LogBackup2.trn'
WITH FORMAT, INIT;

--6 Restauramos el backup de la base de datos

USE master

RESTORE DATABASE base_consorcio
FROM DISK = 'C:\backup\consorcio_backup.bak'
WITH REPLACE, NORECOVERY;

RESTORE LOG base_consorcio
FROM DISK = 'C:\backup\LogBackup.trn'
WITH NORECOVERY;

-- Segundo log

RESTORE LOG base_consorcio
FROM DISK = 'C:\backup\logs\LogBackup2.trn'
WITH RECOVERY;

USE base_consorcio
SELECT * FROM gasto


