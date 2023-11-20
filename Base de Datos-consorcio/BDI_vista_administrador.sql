
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


--5 Realizamos backup del log de la base de datos

BACKUP LOG base_consorcio
TO DISK = 'C:\backup\LogBackup.trn'
WITH FORMAT, INIT;


--6 Insertamos 10 registros mas

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



--7 Realizamos backup del log en otra ubicacion

BACKUP LOG base_consorcio
TO DISK = 'C:\backup\logs\LogBackup2.trn'
WITH FORMAT, INIT;

--8 Restauramos el backup de la base de datos

USE master

RESTORE DATABASE base_consorcio
FROM DISK = 'C:\backup\consorcio_backup.bak'
WITH REPLACE, NORECOVERY;

RESTORE LOG base_consorcio
FROM DISK = 'C:\backup\LogBackup.trn'
WITH NORECOVERY;

--9 Segundo log

RESTORE LOG base_consorcio
FROM DISK = 'C:\backup\logs\LogBackup2.trn'
WITH RECOVERY;

USE base_consorcio
SELECT * FROM gasto


-----------implementacion de transacciones --------------
 USE base_consorcio;

-- CREACION DE LAS TRANSACCIONES
BEGIN TRY -- INICIAMOS EL BEGIN TRY PARA LUEGO COLOCAR LA LOGICA DENTRO Y ASEGURARNOS DE QUE SI ALGO FALLA IRA POR EL CATCH
	BEGIN TRAN -- COMENZAMOS LA TRANSACCION
	INSERT INTO administrador(apeynom, viveahi, tel, sexo, fechnac) -- UN INSERT A LA TABLA QUE QUEREMOS
	VALUES ('pablito', 'S', '37942222', 'M', '01/01/1996') -- LOS VALORES A INGRESAR A LA TABLA

	INSERT INTO consorcio(idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin)
	VALUES (999, 1, 1, 'EDIFICIO-111', 'PARAGUAY N 999', 5, 100, 1) -- GENERAMOS UN ERROR INGRESANDO EL ID PROVINCIA 999 QUE NO EXISTE.
	
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',5,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',2,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',3,608.97)

	COMMIT TRAN -- SI TODO FUE EXITOSO FINALIZAMOS LA TRANSACCION
END TRY
BEGIN CATCH -- SI ALGO FALLA VENDRA AQUI
	SELECT ERROR_MESSAGE() -- MOSTRAMOS EL MENSAJE DE ERROR
	ROLLBACK TRAN -- VOLVEMOS HACIA ATRAS PARA MANTENER LA CONSISTENCIA DE LOS DATOS
END CATCH

-----------------------------------------------

--- CASO Transacción Terminada 
 USE base_consorcio;

-- CREACION DE TRANSACCIONES
BEGIN TRY -- INICIAMOS EL BEGIN TRY PARA LUEGO COLOCAR LA LOGICA DENTRO Y ASEGURARNOS DE QUE SI ALGO FALLA IRA POR EL CATCH
	BEGIN TRAN -- COMENZAMOS LA TRANSACCION
	INSERT INTO administrador(apeynom, viveahi, tel, sexo, fechnac) -- UN INSERT A LA TABLA QUE QUEREMOS
	VALUES ('pablito', 'S', '37942222', 'M', '01/01/1996') -- LOS VALORES A INGRESAR A LA TABLA

	INSERT INTO consorcio(idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin)
	VALUES (1, 1, 3, 'EDIFICIO-111', 'PARAGUAY N 999', 5, 100, 1) -- AHORA INGRESAMOS EL CONSORCIO SIN INTENCION DE ERROR.
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',5,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',2,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',3,608.97)

	COMMIT TRAN -- SI TODO FUE EXITOSO FINALIZAMOS LA TRANSACCION
END TRY
BEGIN CATCH -- SI ALGO FALLA VENDRA AQUI
	SELECT ERROR_MESSAGE() -- MOSTRAMOS EL MENSAJE DE ERROR
	ROLLBACK TRAN -- VOLVEMOS HACIA ATRAS PARA MANTENER LA CONSISTENCIA DE LOS DATOS
END CATCH

-- LAS SIGUIENTES CONSULTAS VERIFICAN LOS RESULTADOS DE LAS PRUEBAS SOBRE TRANSACCIONES PLANAS 
-----------------------------------------------
 -- NOS MUESTRA CUAL FUE EL ULTIMO REGISTRO DE ADMINISTRADOR CARGADO
SELECT TOP 1 * FROM administrador ORDER BY idadmin DESC; 

 -- MUESTRA LOS DATOS DEL CONSORCIO CON LA DIRECCION EN CUESTION (EXITE O NO)
SELECT * FROM consorcio WHERE direccion = 'PARAGUAY N 999';

-- MUESTRA LOS ULTIMOS 3 REGISTROS DE GASTOS CARGADOS
SELECT TOP 3 * FROM gasto ORDER BY idgasto DESC; 
-----------------------------------------------


-----------------------------------------------
--- CASO Transacción Anidada fallida
-- USE base_consorcio;

-- CREACION DE TRANSACCIONES
BEGIN TRY -- INICIAMOS EL BEGIN TRY PARA LUEGO COLOCAR LA LOGICA DENTRO Y ASEGURARNOS DE QUE SI ALGO FALLA IRA POR EL CATCH
	BEGIN TRAN -- COMENZAMOS LA TRANSACCION
	INSERT INTO administrador(apeynom, viveahi, tel, sexo, fechnac) -- UN INSERT A LA TABLA QUE QUEREMOS
	VALUES ('pablito clavounclavito', 'S', '37942222', 'M', '01/01/1996') -- LOS VALORES A INGRESAR A LA TABLA

	INSERT INTO consorcio(idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin)
	VALUES (1, 1, 3, 'EDIFICIO-111', 'PARAGUAY N 999', 5, 100, 1) -- GENERAMOS UN ERROR INGRESANDO EL ID PROVINCIA 999 QUE NO EXISTE.

	-------------------------
	BEGIN TRAN -- COMENZAMOS UNA TRANSACCION ANIDADA
		UPDATE consorcio SET nombre = 'EDIFICIO-222'; -- ACTUALIZAMOS EL REGISTRO DE CONSORCIO QUE CARGAMOS ANTES
		INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) 
			VALUES (1,1,1,6,'20130616',20,608.97) -- INSERT A LA TABLA GASTO, DEBE DAR UN ERROR POR TIPO DE GASTO
	COMMIT TRAN -- FINALIZAMOS UNA TRANSACCION ANIDADA
	------------------------

	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',5,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',2,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',3,608.97)

	COMMIT TRAN -- SI TODO FUE EXITOSO FINALIZAMOS LA TRANSACCION
END TRY
BEGIN CATCH -- SI ALGO FALLA VENDRA AQUI
	SELECT ERROR_MESSAGE() -- MOSTRAMOS EL MENSAJE DE ERROR
	ROLLBACK TRAN -- VOLVEMOS HACIA ATRAS PARA MANTENER LA CONSISTENCIA DE LOS DATOS
END CATCH




-----------------------------------------------
--- CASO Transacción Anidada 
-- USE base_consorcio;

-- CREACION DE TRANSACCIONES
BEGIN TRY -- INICIAMOS EL BEGIN TRY PARA LUEGO COLOCAR LA LOGICA DENTRO Y ASEGURARNOS DE QUE SI ALGO FALLA IRA POR EL CATCH
	BEGIN TRAN -- COMENZAMOS LA TRANSACCION
	INSERT INTO administrador(apeynom, viveahi, tel, sexo, fechnac) -- UN INSERT A LA TABLA QUE QUEREMOS
	VALUES ('pablito clavounclavito', 'S', '37942222', 'M', '01/01/1996') -- LOS VALORES A INGRESAR A LA TABLA

	INSERT INTO consorcio(idprovincia, idlocalidad, idconsorcio, nombre, direccion, idzona, idconserje, idadmin)
	VALUES (1, 1, 3, 'EDIFICIO-111', 'PARAGUAY N 999', 5, 100, 1) -- GENERAMOS UN ERROR INGRESANDO EL ID PROVINCIA 999 QUE NO EXISTE.

	-------------------------
	BEGIN TRAN -- COMENZAMOS UNA TRANSACCION ANIDADA
		UPDATE consorcio SET nombre = 'EDIFICIO-222'; -- ACTUALIZAMOS EL REGISTRO DE CONSORCIO QUE CARGAMOS ANTES
		INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe) 
			VALUES (1,1,1,6,'20130616',5,608.97) -- INSERT A LA TABLA GASTO, DEBE DAR UN ERROR POR TIPO DE GASTO
	COMMIT TRAN -- FINALIZAMOS UNA TRANSACCION ANIDADA
	------------------------

	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',5,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',2,608.97)
	INSERT INTO gasto(idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
	VALUES (1,1,1,6,'20130616',3,608.97)

	COMMIT TRAN -- SI TODO FUE EXITOSO FINALIZAMOS LA TRANSACCION
END TRY
BEGIN CATCH -- SI ALGO FALLA VENDRA AQUI
	SELECT ERROR_MESSAGE() -- MOSTRAMOS EL MENSAJE DE ERROR
	ROLLBACK TRAN -- VOLVEMOS HACIA ATRAS PARA MANTENER LA CONSISTENCIA DE LOS DATOS
END CATCH

-----------------------------------------------
-----------------------------------------------
-- LAS SIGUIENTES CONSULTAS VERIFICAN LOS RESULTADOS DE LAS PRUEBAS SOBRE TRANSACCIONES ANIDADAS 
-----------------------------------------------
 -- NOS MUESTAR CUAL FUE EL ULTIMO REGISTRO DE ADMINISTRADOR CARGADO
SELECT TOP 1 * FROM administrador ORDER BY idadmin DESC; 

 -- MUESTRA LOS DATOS DEL CONSORCIO CON LA DIRECCION EN CUESTION (EXITE O NO)
SELECT * FROM consorcio WHERE direccion = 'PARAGUAY N 999';

-- MUESTAR LOS ULTIMOS 3 REGISTROS DE GASTOS CARGADOS
SELECT TOP 4 * FROM gasto ORDER BY idgasto DESC; 
-----------------------------------------------




-------------------------------------------- Indices Columnares en SQL Server ---------------------------------
USE base_consorcio;

Create table gastonew (
	idgasto int identity not null,
	idprovincia int not null,
    idlocalidad int not null,
    idconsorcio int not null, 
	periodo int not null,
	fechapago datetime not null,					     
	idtipogasto int not null,
	importe decimal (8,2) not null,	
	Constraint PK_gastonew PRIMARY KEY (idgasto),
	Constraint FK_gastonew_consorcio FOREIGN KEY (idprovincia,idlocalidad,idconsorcio)  REFERENCES consorcio(idprovincia,idlocalidad,idconsorcio),
	Constraint FK_gastonew_tipo FOREIGN KEY (idtipogasto)  REFERENCES tipogasto(idtipogasto)					     					     						 					     					     
)

GO
-- Variables para controlar el bucle de inserciónnn
DECLARE @RowCount INT = 0;
DECLARE @TotalRows INT = 100000; -- Número total de registros a insertar

-- Inicio del bucle de inserción
WHILE @RowCount < @TotalRows
BEGIN
    -- Generar datos aleatorios
    DECLARE @idprovincia INT;
    DECLARE @idlocalidad INT;
    DECLARE @idconsorcio INT;
    
    -- valores aleatorios para idprovincia, idlocalidad e idconsorcio de la tabla "consorcio"
    SELECT TOP 1 @idprovincia = idprovincia, @idlocalidad = idlocalidad, @idconsorcio = idconsorcio
    FROM consorcio
    ORDER BY NEWID();							--genera valores entre 1 y 24
    
								-- aleatorio entre 1 y 9
    DECLARE @periodo INT = FLOOR(RAND() * 9) + 1;; 
								-- Fecha en los últimos 365 días
    DECLARE @fechapago DATETIME = DATEADD(DAY, -CAST((RAND() * 365) AS INT), GETDATE()); 
								--genera valores entre 1 y 5
    DECLARE @idtipogasto INT = FLOOR(RAND() * 5) + 1;
								--genera valores entre 1 y 10
    
								-- Importe aleatorio
    DECLARE @importe DECIMAL(8, 2) = CAST(RAND() * 1000 AS DECIMAL(8, 2)); 

    -- Insertar el registro aleatorio en la tabla GASTONEW
    INSERT INTO gastonew (idprovincia, idlocalidad, idconsorcio,periodo, fechapago, idtipogasto, importe)
    VALUES (@idprovincia, @idlocalidad,@idconsorcio ,@periodo, @fechapago, @idtipogasto, @importe);

    -- Incrementar el contador
    SET @RowCount = @RowCount + 1;
END
GO



--Es importante mencionar que solo puede haber un índice agrupado por cada tabla, porque las filas de datos solo pueden estar almacenadas de una forma.
--Cuando se establece una restricción de clave primaria (PRIMARY KEY) en una tabla, se crea automáticamente un índice agrupado (clustered) si no se especifica uno.
--Entonces para nuestra investigación se utilizara un índice no agrupado
--crea un indice agrupado
--CREATE NONCLUSTERED COLUMNSTORE INDEX NombreDelIndice
--ON NombreDeLaTabla;

go
--El siguiente comando crea un indice no agrupado en la tabla gastonew, en las columnas especificadas
--CREATE NONCLUSTERED COLUMNSTORE INDEX NombreDelIndice
--ON NombreDeLaTabla (nombreColumna1, nombreColumna2,.....);
CREATE NONCLUSTERED COLUMNSTORE INDEX Indice_NoAgrupado
ON gastonew (idgasto, idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe);

--CONSULTAS SOBRE LAS TABLAS GASTO Y GASTONEW PARA HACER UN ANALISIS DEL RENDIMIENTO

--Las siguientes consultas sobre la tabla gasto y gastonew: 
--Selecciona la fecha de pago y la suma total de los importes para cada fecha única.
--Agrupa los resultados por fecha de pago.
--Ordena los resultados por fecha de pago.
go
SELECT fechapago, SUM(importe) as TotalVentas
FROM gasto
GROUP BY fechapago
ORDER BY fechapago;


SELECT fechapago, SUM(importe) as TotalVentas
FROM gastonew
GROUP BY fechapago
ORDER BY fechapago;


--Esta consulta suma los gastos (importe) de cada tipo de gasto (idtipogasto) en el período 3 (periodo = 3) de la tabla gasto. Cada tipo de gasto tendrá una suma total.
SELECT idtipogasto, SUM(importe) as TotalGastos
FROM gasto
WHERE periodo = 3
GROUP BY idtipogasto;

SELECT idtipogasto, SUM(importe) as TotalGastos
FROM gastonew
WHERE periodo = 3
GROUP BY idtipogasto;



--------------------------------- Optimizacion de consulta a traves de indices ------------------

--PRIMER EJECUCION DE CONSULTA 
--Permite ver detalle de los tiempos de ejecucionde la consulta
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
go
--Consulta: Gastos del periodo 8 

SELECT g.idgasto, g.periodo, g.fechapago, t.descripcion
FROM gasto g
INNER JOIN tipogasto t ON g.idtipogasto = t.idtipogasto
WHERE g.periodo = 8 ;
go


--SEGUNDA EJECUCION DE CONSULTA ----------------------------------------------------------------------------

--SqlServer toma la PK de gasto como indice CLUSTERED, asique para crear el solicitado en periodo debemos primero eliminar el actual
ALTER TABLE gasto
DROP CONSTRAINT PK_gasto;
go

--Transformamos la PK en un indice NONCLUSTERED
ALTER TABLE gasto
ADD CONSTRAINT PK_gasto PRIMARY KEY NONCLUSTERED (idGasto);
go

--Creamos un nuevo indice CLUSTERED en periodo
CREATE CLUSTERED INDEX IX_gasto_periodo
ON gasto (periodo);
go
--Permite ver detalle de los tiempos de ejecucionde la consulta
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
go
--Consulta: Gastos del periodo 8 

SELECT g.idgasto, g.periodo, g.fechapago, t.descripcion
FROM gasto g
INNER JOIN tipogasto t ON g.idtipogasto = t.idtipogasto
WHERE g.periodo = 8 ;
go


--TERCER EJECUCION DE CONSULTA------------------------------------------------------------------
-- Elimina el Indice agrupado anterior
DROP INDEX IX_gasto_periodo ON gasto;
go

-- Crea un nuevo Indice agrupado en periodo, fechapago e idtipogasto
CREATE CLUSTERED INDEX IX_Gasto_Periodo_FechaPago_idTipoGasto
ON gasto (periodo, fechapago, idtipogasto);
go

--Permite ver detalle de los tiempos de ejecucionde la consulta
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
go
--Consulta: Gastos del periodo 8 

SELECT g.idgasto, g.periodo, g.fechapago, t.descripcion
FROM gasto g
INNER JOIN tipogasto t ON g.idtipogasto = t.idtipogasto
WHERE g.periodo = 8 ;
go


--------------------------------------------- Triggers ------------------------------------------

--crear registro de actividad, para ello es necesario una tabla llamada auditoria, esta tendra como funcion registrar
--operaciones que afecten al contenido de la base de datos, proporcionando así un
--registro de actividad
USE base_consorcio
go

CREATE TABLE auditoria (
    id_auditoria int identity primary key,
    tabla_afectada varchar(100),  
	columna_afectada varchar(100), 
    accion varchar(10),           
    fecha_hora datetime,          
    usuario varchar(50),        
    valor_anterior varchar(max),  
    valor_actual varchar(max),     
);

--- CREAR LOS TRIGGERS CON LOS SCRIPTS "conserjeTriggerUpdate" "conserjeTriggerDelete" "conserjeTriggerInsert" dentro de la carpeta triggers de la tabla conserje (click derecho---> insertar trigger)

---Probamos los triggers agregando registros
INSERT INTO conserje (apeynom, tel, fechnac, estciv)
VALUES ('Juan Pérez', '5554567', '1985-03-15', 'S');

INSERT INTO conserje (apeynom, tel, fechnac, estciv)
VALUES ('María González', '5876543', '1990-08-22', 'C');

INSERT INTO conserje (apeynom, tel, fechnac, estciv)
VALUES ('Carlos Rodríguez', '5555555', '1982-12-10', 'D');

--probamos modicficando
UPDATE conserje
SET tel = '55512222'
WHERE idconserje = 1;
UPDATE conserje
SET estciv = 'O'
WHERE idconserje = 2;

---probamos eliminando
DELETE FROM conserje
WHERE idconserje = 3;


---------------------------------------- Manejo de permisos a nivel de usuarios de base de datos ---------------------------------

USE base_consorcio;

/*
Creamos usuarios de prubea
*/

CREATE LOGIN UsuarioAnalista WITH PASSWORD = 'ContrasenaAnalista';
CREATE LOGIN UsuarioDisenador WITH PASSWORD = 'ContrasenaDisenador';


CREATE USER UsuarioAnalista FOR LOGIN UsuarioAnalista;
CREATE USER UsuarioDisenador FOR LOGIN UsuarioDisenador;


/*

Creamos dos roles
*/

CREATE ROLE Analistas;
CREATE ROLE Disenadores;


/*
Le damos permisos  a los roles
*/

GRANT SELECT TO Analistas;


GRANT CREATE TABLE TO Disenadores;
GRANT ALTER ON SCHEMA::dbo TO Disenadores;

/*
Le asignamos a cada role los usuarios
*/

ALTER ROLE Analistas ADD MEMBER UsuarioAnalista;
ALTER ROLE Disenadores ADD MEMBER UsuarioDisenador;

/*
Crear usuario solo vista
*/
CREATE SCHEMA ViewSchema AUTHORIZATION dbo;
GO
-- Crear una nueva vista en este esquema
-- Crear vistas para cada tabla
CREATE VIEW ViewSchema.ProvinciaView AS SELECT * FROM provincia;
GO
CREATE VIEW ViewSchema.LocalidadView AS SELECT * FROM localidad;
GO
CREATE VIEW ViewSchema.ZonaView AS SELECT * FROM zona;
GO
CREATE VIEW ViewSchema.ConsorcioView AS SELECT * FROM consorcio;
GO
CREATE VIEW ViewSchema.GastoView AS SELECT * FROM gasto;
GO
CREATE VIEW ViewSchema.ConserjeView AS SELECT * FROM conserje;
GO
CREATE VIEW ViewSchema.AdministradorView AS SELECT * FROM administrador;
GO
CREATE VIEW ViewSchema.TipoGastoView AS SELECT * FROM tipogasto;
GO
-- Crear un nuevo rol de base de datos
CREATE ROLE db_viewreader;

-- Otorgar permisos SELECT a todos los objetos en el esquema ViewSchema al nuevo rol de base de datos
GRANT SELECT ON SCHEMA::ViewSchema TO db_viewreader;


-- Crear un nuevo usuario
CREATE USER usuarioVista WITHOUT LOGIN;

-- Agregar el nuevo usuario al rol de base de datos
ALTER ROLE db_viewreader ADD MEMBER usuarioVista;


