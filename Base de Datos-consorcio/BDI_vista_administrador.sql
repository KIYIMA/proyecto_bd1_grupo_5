-- Definición:

-- VISTA: es una consulta almacenada con un nombre que se comporta como una tabla virtual. 
-- No almacena datos físicos, sino que se basa en la ejecución de una consulta cada vez que se accede a ella.

-- VISTA INDEXADA: es similar a una vista, pero tiene un índice asociado que almacena físicamente los resultados de la vista. 
-- Los datos se almacenan en la base de datos, lo que mejora el rendimiento de las consultas.




-- NOTA PRINCIPAL 
-- Al crear la base de datos, crearla con el campo "fechaPago" de la tabla "gasto" como campo único para que después al crear el índice para la vista indexada no se generen errores.



-- 2) Crear una vista sobre la tabla administrador que solo muestre los campos apynom, sexo  y fecha de nacimiento.
USE base_consorcio;

CREATE VIEW vistaAdministrador AS
SELECT apeynom, sexo, fechnac
FROM administrador;

GO

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
Insert into vistaAdministrador(apeynom,sexo,fechnac) values ('', 'F', ''); -- Prueba en restricciones faltantes, en la creacion de base_consorcio, no se detalla not null al crear las tablas

SELECT * FROM vistaAdministrador ;



-- 4) Realizar update sobre algunos de los registros creados y volver a verificar el resultado en la tabla.
-- NOTA: Se actualiza el registro normalmente.
-- OBSERVACIÓN: Al actualizar un registro, éste debe tener un campo clave para poder acceder a el y asegurarnos de que es el único con dicho valor en ese campo clave. Tal vez deberíamos agregar a la vista el campo (índice) "idadmin" para solucionar este inconveniente. 
Update vistaAdministrador set fechnac = '19990916' where apeynom = 'AGUIRRE LUCIO';
SELECT * FROM administrador order by apeynom asc;




-- 5) Borrar todos los registros insertados a través de la vista.
-- OBSERVACIÓN: Para eliminar los registros creados con la vista tuve que comparar en los registros de "administrador" el campo "tel" en donde éstos eran nulos, lo cual no es lo correcto ya que, si se había cargardo un registro con "tel" en null que no haya sido con la vista, éste se eliminaria también. Mi solución sería crear un índice en la vista el cual va ser de gran ayuda para realizar esta operación.
DELETE FROM administrador
WHERE tel is NULL;
SELECT * FROM administrador order by apeynom asc;


-- 6) Crear una vista que muestre los datos de las columnas de las siguientes tablas: (Administrador->Apeynom, consorcio->Nombre, gasto->periodo, gasto->fechaPago, tipoGasto->descripcion) .
CREATE VIEW vistaGeneral 
WITH SCHEMABINDING
AS SELECT [dbo].[administrador].apeynom, [dbo].[consorcio].nombre, [dbo].[gasto].periodo, [dbo].[gasto].fechaPago, [dbo].[tipogasto].descripcion
FROM [dbo].[consorcio]
JOIN [dbo].[administrador] ON [dbo].[administrador].idadmin = [dbo].[consorcio].idadmin 
JOIN [dbo].[gasto] ON [dbo].[gasto].idconsorcio = [dbo].[consorcio].idconsorcio
JOIN [dbo].[tipogasto] ON [dbo].[tipogasto].idtipogasto = [dbo].[gasto].idtipogasto;

GO

SELECT * FROM vistaGeneral ;



-- 7) Crear un indice sobre la columna fechaPago sobre la vista  recien creada.
-- Coloco el campo "fechaPago" de la tabla "gasto" como unico ya nesesito que éste sea único para luego crear el índice correspondiente a la vista.
-- NOTA: Tuve que vaciar la base de datos para poder crear el indice ya que habian pagos con la misma fecha y la hora y segundo no estaban cargadas(si estas estaban cargadas todos serian únicos). 
ALTER TABLE [dbo].[gasto]
ADD CONSTRAINT unicoFechaPago UNIQUE (fechaPago);

-- Creo el índice para fechaPago
CREATE UNIQUE CLUSTERED INDEX IX_vistaGeneral_FechaPago
ON [dbo].[vistaGeneral] (fechaPago);
SELECT * FROM vistaGeneral ORDER BY nombre ASC ;

-- CREATE UNIQUE CLUSTERED INDEX: Crea un índice único y agrupado en la tabla vistaGeneral. El índice agrupado ordena físicamente los datos en la tabla según la clave del índice.
-- IX_vistaGeneral_FechaPago: Es el nombre del índice.
-- ON [dbo].[vistaGeneral] (fechaPago): Especifica que el índice se creará en la tabla vistaGeneral y se basará en la columna fechaPago.




------------------------------------------------ Implementacion de backup y restore ---------------------------

-- 1 Verificar el modo de recuperación de la base de datos
use base_consorcio;
SELECT name, recovery_model_desc
FROM sys.databases
WHERE name = 'base_consorcio;';

go

-- 2 cambiamos el modo de recuperacion
USE master -- se usa la instancia de la base Master
ALTER DATABASE base_consorcio
SET RECOVERY FULL; --El recovery se realizara de forma completa, a fin de preservar la totalidad de datos

go

-- 3 Realizamos backup de la base de datos
BACKUP DATABASE base_consorcio
TO DISK = 'C:\backup\consorcio_backup.bak'
WITH FORMAT, INIT;

-- 4 Se insertan 10 nuevos registros
USE base_consorcio;
-- Mostrar todos los registros de la tabla administrador
SELECT * FROM administrador;



-- 5 Realizar backup del log de la base de datos
BACKUP LOG base_consorcio TO DISK = 'C:\backup\LogBackup.trn' WITH FORMAT, INIT;
SELECT * FROM administrador;

--6 Realizamos backup del log en otra ubicacion

BACKUP LOG base_consorcio
TO DISK = 'C:\backup\logs\LogBackup2.trn'
WITH FORMAT, INIT;

--7 Insertar 10 registros en la tabla administrador
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Nombre1 Apellido1', 'S', '123456789', 'M', '1990-01-01');
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Nombre2 Apellido2', 'N', '987654321', 'F', '1985-05-15');
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Nombre3 Apellido3', 'S', '555555555', 'M', '1992-08-20');
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Nombre4 Apellido4', 'N', '111111111', 'F', '1980-03-10');
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Nombre5 Apellido5', 'S', '999999999', 'M', '1988-12-05');
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Nombre6 Apellido6', 'N', '777777777', 'F', '1995-06-25');
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Nombre7 Apellido7', 'S', '444444444', 'M', '1987-11-15');
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Nombre8 Apellido8', 'N', '666666666', 'F', '1998-09-30');
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Nombre9 Apellido9', 'S', '222222222', 'M', '1983-04-18');
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Nombre10 Apellido10', 'N', '333333333', 'F', '1997-07-22');
SELECT * FROM administrador ORDER BY idadmin DESC; 


--8 Restauramos el backup de la base de datos

USE master


RESTORE DATABASE base_consorcio
FROM DISK = 'C:\backup\consorcio_backup.bak'
WITH REPLACE, NORECOVERY;

RESTORE LOG base_consorcioS
FROM DISK = 'C:\backup\LogBackup.trn'
WITH NORECOVERY;

--9 Segundo log

RESTORE LOG base_consorcio
FROM DISK = 'C:\backup\logs\LogBackup2.trn'
WITH RECOVERY;

USE base_consorcio
SELECT * FROM administrador ORDER BY idadmin DESC; 


------------------------------------------implementacion de transacciones ----------------------------------
 -- Crear un índice columnar no agrupado en la tabla administrador
CREATE NONCLUSTERED COLUMNSTORE INDEX Indice_Administrador
ON administrador (idadmin, apeynom, viveahi, tel, sexo, fechnac);

-- Transacción con posible error
USE base_consorcio;

BEGIN TRY
    BEGIN TRAN;

    -- Insertar un nuevo registro en la tabla administrador
    INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac)
    VALUES ('pablito', 'S', '37942222', 'M', '01/01/1996');

    -- Intentar insertar un consorcio con un idprovincia inexistente (999)
    INSERT INTO consorcio (idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin)
    VALUES (1, 2, 999, 'EDIFICIO-111', 'PARAGUAY N 999', 5, 100, 1);

    -- Otros inserts en la tabla administrador (puedes agregar más según tus necesidades)
    INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac)
    VALUES ('otro nombre', 'N', '123456789', 'F', '02/02/1980');

    COMMIT TRAN;
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE();
    ROLLBACK TRAN;
END CATCH;

-- Consulta para verificar el resultado de las transacciones
-- Muestra el último registro de administrador cargado
SELECT TOP 10 * FROM administrador ORDER BY idadmin DESC; 


------------------------------------------- Procedimientos y Funciones Almacenadas --------------------------------------
USE base_consorcio

GO

-- CREATE PROCEDURE InsertarAdministrador
CREATE PROCEDURE InsertarAdministrador
(
    @apeynom varchar(50),
    @viveahi varchar(1),
    @tel varchar(20),
    @sexo varchar(1),
    @fechnac datetime
)
AS
BEGIN
    INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac)
    VALUES (@apeynom, @viveahi, @tel, @sexo, @fechnac);
END
GO

-- CREATE PROCEDURE ModificarAdministrador
CREATE PROCEDURE ModificarAdministrador
(
    @idadmin int,
    @apeynom varchar(50),
    @viveahi varchar(1),
    @tel varchar(20),
    @sexo varchar(1),
    @fechnac datetime
)
AS
BEGIN
    UPDATE administrador
    SET apeynom = @apeynom,
        viveahi = @viveahi,
        tel = @tel,
        sexo = @sexo,
        fechnac = @fechnac
    WHERE idadmin = @idadmin;
END
GO

-- DROP PROCEDURE IF EXISTS BorrarAdministrador;
-- CREATE PROCEDURE BorrarAdministrador
IF OBJECT_ID('BorrarAdministrador', 'P') IS NOT NULL
    DROP PROCEDURE BorrarAdministrador;
GO

CREATE PROCEDURE BorrarAdministrador
(
    @idadmin int
)
AS
BEGIN
    DELETE FROM administrador
    WHERE idadmin = @idadmin;
END
GO



---------------------------------------------------------------------------------------------------

-- Lote de Pruebas --
-- Insersecion de nuevo administrador usando el procedimiento
EXEC InsertarAdministrador 'Paquito Perez', 'S', '3704567423', 'M', '1997-02-14';
select * from administrador where (apeynom like 'Paquito Perez'); --verificacion

-- Modificar datos de un administrador utilizando el procedimiento almacenado correspondiente:
EXEC ModificarAdministrador 185, 'Juan Perez', 'N', '22334455', 'M', '1997-02-14';
SELECT * FROM administrador ORDER BY idadmin DESC; -- Verificación

-- Eliminacion de datos de un administrador utilizando el procedimiento almacenado correspondiente:
EXEC BorrarAdministrador 185;
SELECT * FROM administrador ORDER BY idadmin DESC; -- Verificación
