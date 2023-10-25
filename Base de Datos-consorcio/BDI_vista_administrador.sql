-- 2) Crear una vista sobre la tabla administrador que solo muestre los campos apynom, sexo  y fecha de nacimiento.

USE base_consorcio;

CREATE VIEW vistaAdministrador AS
SELECT apeynom, sexo, fechnac
FROM administrador;

SELECT * FROM vistaAdministrador;

-- 3) Realizar insert de un lote de datos sobre la vista recien creada. Verificar el resultado en la tabla administrador.

--lote de datos para la vista "vistaAdministrador"

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