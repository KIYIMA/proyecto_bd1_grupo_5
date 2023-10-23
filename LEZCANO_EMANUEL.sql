-- version:  Microsoft SQL Server 2022 (RTM) - 16.0.1000.6 (X64)   Oct  8 2022 05:58:25   Copyright (C) 2022 Microsoft Corporation  Enterprise Evaluation Edition (64-bit) on Windows 10 Pro 10.0 <X64> (Build 19045: ) 

CREATE DATABASE clinicaveterinaria;

USE clinicaveterinaria;

CREATE TABLE especialidad
(
  id INT PRIMARY KEY IDENTITY(1,1),
  nombre VARCHAR(100) NOT NULL
);

CREATE TABLE veterinario
(
  id INT PRIMARY KEY IDENTITY(1,1),
  nombre VARCHAR(100) NOT NULL,
  nro_licencia INT NOT NULL UNIQUE,
  especialidad VARCHAR(100) ,
  horario_atencion VARCHAR(100) NOT NULL,
  especialidad_id INT ,
  FOREIGN KEY (especialidad_id) REFERENCES especialidad(id)
);

CREATE TABLE dueno
(
  id INT PRIMARY KEY IDENTITY(1,1),
  dni NUMERIC(8,0) UNIQUE NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  direccion VARCHAR(100) NOT NULL,
  telefono INT NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL
);


CREATE TABLE especie
(
  id INT PRIMARY KEY IDENTITY(1,1),
  nombre VARCHAR(100) NOT NULL
);

CREATE TABLE mascota
(
  id INT PRIMARY KEY IDENTITY(1,1),
  nombre VARCHAR(100) NOT NULL,
  raza VARCHAR(100) NOT NULL,
  peso  DECIMAL(3,2) NOT NULL,
  fecha_nacimento DATE NOT NULL,
  
  especie_id INT NOT NULL,
  dueno_id INT NOT NULL,

  FOREIGN KEY (especie_id) REFERENCES especie(id),
  FOREIGN KEY (dueno_id) REFERENCES dueno(id)
);

CREATE TABLE tratamiento
(
  id INT PRIMARY KEY IDENTITY(1,1),
  nombre VARCHAR(100) NOT NULL,
  duracion VARCHAR(200) NOT NULL,
  dosis VARCHAR(200) NOT NULL
);

CREATE TABLE cita_medica
(
  id INT PRIMARY KEY IDENTITY(1,1),
  fecha DATE DEFAULT GETDATE() NOT NULL,
  hora DATE NOT NULL,
  motivo VARCHAR(255) NOT NULL,
  
  veterinario_id INT NOT NULL,
  mascota_id INT NOT NULL,
  tratamiento_id INT,

  FOREIGN KEY (veterinario_id) REFERENCES veterinario(id),
  FOREIGN KEY (mascota_id) REFERENCES mascota(id),
  FOREIGN KEY (tratamiento_id) REFERENCES tratamiento(id)
);

-- Insertar especialidades
INSERT INTO especialidad (nombre) VALUES
('Especialidad 1'),
('Especialidad 2'),
('Especialidad 3');

-- Insertar veterinarios
INSERT INTO veterinario (nombre, nro_licencia, especialidad, horario_atencion, especialidad_id) VALUES
('Veterinario 1', 12345, 'Especialidad 1', 'Horario 1', 1),
('Veterinario 2', 67890, 'Especialidad 2', 'Horario 2', 2),
('Veterinario 3', 54321, 'Especialidad 1', 'Horario 3', 1);

-- Insertar dueños
INSERT INTO dueno (dni, nombre, direccion, telefono, email) VALUES
(12345678, 'Dueño 1', 'Dirección 1', 111111111, 'dueno1@example.com'),
(87654321, 'Dueño 2', 'Dirección 2', 222222222, 'dueno2@example.com'),
(11112222, 'Dueño 3', 'Dirección 3', 333333333, 'dueno3@example.com');

-- Insertar especies
INSERT INTO especie (nombre) VALUES
('Especie 1'),
('Especie 2'),
('Especie 3');

-- Insertar mascotas
INSERT INTO mascota (nombre, raza, peso, fecha_nacimento, especie_id, dueno_id) VALUES
('Mascota 1', 'Raza 1', 5.5, '2020-01-10', 1, 1),
('Mascota 2', 'Raza 2', 7.0, '2019-05-15', 2, 2),
('Mascota 3', 'Raza 3', 4.2, '2021-03-20', 3, 3);

-- Insertar tratamientos
INSERT INTO tratamiento (nombre, duracion, dosis) VALUES
('Tratamiento 1', '10 días', '2 veces al día'),
('Tratamiento 2', '15 días', '3 veces al día'),
('Tratamiento 3', '7 días', '1 vez al día');

-- Insertar citas médicas
INSERT INTO cita_medica (fecha, hora, motivo, veterinario_id, mascota_id, tratamiento_id) VALUES
('2023-10-10', '10:00', 'Motivo 1', 1, 1, 1),
('2023-10-11', '14:30', 'Motivo 2', 2, 2, 2),
('2023-10-12', '16:15', 'Motivo 3', 3, 3, NULL);



-- Intentar insertar un dueño con DNI inválido
INSERT INTO dueno (dni, nombre, direccion, telefono, email)
VALUES (1234567890, 'Dueño Inválido', 'Dirección Inválida', 555555555, 'invalido@example.com');

-- Insertar un veterinario sin especificar la especialidad
INSERT INTO veterinario (nombre, nro_licencia, horario_atencion, especialidad_id)
VALUES ('Veterinario sin Especialidad', 99999, 'Horario', NULL);

-- Intentar insertar una mascota sin especificar el dueño
INSERT INTO mascota (nombre, raza, peso, fecha_nacimento, especie_id, dueno_id)
VALUES ('Mascota sin Dueño', 'Raza', 4.5, '2022-01-01', 1, NULL);



-- MODIFICACION EN FECHA DE CITA_MEDICA

ALTER TABLE cita_medica
ADD ano INT,
    mes INT,
    dia INT;


UPDATE cita_medica
SET ano = YEAR(fecha),
    mes = MONTH(fecha),
    dia = DAY(fecha);


ALTER TABLE cita_medica
DROP COLUMN fecha;
