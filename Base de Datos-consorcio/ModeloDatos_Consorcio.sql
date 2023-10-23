--CREATE DATABASE base_consorcio;
go
-- USE base_consorcio;
go
-------------------
if object_id('gasto') is not null DROP TABLE gasto;
go
---------------------
if object_id('consorcio') is not null DROP TABLE consorcio
go
---------------------
if object_id('localidad') is not null DROP TABLE localidad
go
---------------------
if object_id('provincia') is not null DROP TABLE provincia
go
---------------------
if object_id('zona') is not null DROP TABLE zona
go
---------------------
if object_id('conserje') is not null DROP TABLE conserje
go
---------------------
if object_id('administrador') is not null DROP TABLE administrador
go
---------------------
if object_id('tipogasto') is not null DROP TABLE tipogasto
go
---------------------

Create table provincia (idprovincia int primary key, 
					    descripcion varchar(50),
						km2 int,
						cantdptos int,
						poblacion int,
						nomcabe varchar(50))
go
-------------------

Create table localidad (idprovincia int, 
						idlocalidad int, 
					    descripcion varchar(50),
					    Constraint PK_localidad PRIMARY KEY (idprovincia, idlocalidad),
						Constraint FK_localidad_pcia FOREIGN KEY (idprovincia)  REFERENCES provincia(idprovincia)						 					     					     					     				     					     
						)
go
-------------------

Create table zona		(idzona int identity primary key, 
					    descripcion varchar(50))
go
-------------------

Create table conserje	(idconserje int identity primary key, 
					     apeynom varchar(50),
					     tel varchar(20),
						 fechnac datetime,
					     estciv varchar(1)  NULL default ('S') 
						 CONSTRAINT CK_estadocivil CHECK (estciv IN ('S', 'C','D','O')),
							 	)
go
-------------------

Create table administrador	(idadmin int identity primary key, 
					     apeynom varchar(50),
					     viveahi varchar(1)  NULL default ('N') 
						 CONSTRAINT CK_habitante_viveahi CHECK (viveahi IN ('S', 'N')),
					     tel varchar(20),
					     sexo varchar(1)  NOT NULL 
						 CONSTRAINT CK_sexo CHECK (sexo IN ('F', 'M')),
                         fechnac datetime)

go
-------------------

Create table tipogasto	(idtipogasto int primary key, 
					    descripcion varchar(50))
go
-------------------

Create table consorcio	(idprovincia int,
                         idlocalidad int,
                         idconsorcio int, 
					     nombre varchar(50),
					     direccion varchar(250),					     
					     idzona int,	
						 idconserje int,	
						 idadmin int,	
					     Constraint PK_consorcio PRIMARY KEY (idprovincia, idlocalidad,idconsorcio),
						 Constraint FK_consorcio_pcia FOREIGN KEY (idprovincia,idlocalidad)  REFERENCES localidad(idprovincia,idlocalidad),
						 Constraint FK_consorcio_zona FOREIGN KEY (idzona)  REFERENCES zona(idzona),						 					     					     					     				     					     
						 Constraint FK_consorcio_conserje FOREIGN KEY (idconserje)  REFERENCES conserje(idconserje),
						 Constraint FK_consorcio_admin FOREIGN KEY (idadmin)  REFERENCES administrador(idadmin)						 					     					     					     				     					     						 						 						 					     					     					     				     					     						 
							)
go
-------------------

Create table gasto	(
						idgasto int identity,
						idprovincia int,
                         idlocalidad int,
                         idconsorcio int, 
					     periodo int,
					     fechapago datetime,					     
						 idtipogasto int,
						 importe decimal (8,2),	
					     Constraint PK_gasto PRIMARY KEY (idgasto),
						 Constraint FK_gasto_consorcio FOREIGN KEY (idprovincia,idlocalidad,idconsorcio)  REFERENCES consorcio(idprovincia,idlocalidad,idconsorcio),
						 Constraint FK_gasto_tipo FOREIGN KEY (idtipogasto)  REFERENCES tipogasto(idtipogasto)					     					     						 					     					     
							)
go