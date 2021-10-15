#Crear base de datos para la clínica dental
CREATE DATABASE clinica;
USE clinica;

#Crear tablas necesarias
CREATE TABLE usuarios (nombre VARCHAR(50) PRIMARY KEY NOT NULL, contraseña VARCHAR(20) NOT NULL);
CREATE TABLE doctores (nombre_doctor VARCHAR(30) PRIMARY KEY NOT NULL, nombre_asistente VARCHAR(30) NOT NULL);
CREATE TABLE agenda (folio VARCHAR(10) PRIMARY KEY NOT NULL, nombre_paciente VARCHAR(30), tel_paciente VARCHAR(11),
fecha DATE,
hora TIME, 
consultorio VARCHAR(20),
servicio VARCHAR(20)
);
CREATE TABLE servicios (nombre VARCHAR(20) PRIMARY KEY NOT NULL, costo INTEGER(4), duración VARCHAR(2));

INSERT INTO usuarios VALUES ('Juan Pérez','Juan1');
INSERT INTO doctores VALUES ('Juan Pérez','Patricia González');
INSERT INTO agenda VALUES ('ANSF0921','Erick Didier',7771234567,'2021-09-25',03-00-00,'Dental Care','Limpieza Completa');
INSERT INTO servicios VALUES ('Limpieza Completa',500,30);