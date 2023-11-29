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