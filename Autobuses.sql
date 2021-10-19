DROP DATABASE autobuses;

CREATE DATABASE autobuses;

USE autobuses;

CREATE TABLE operadores (
num_operador INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
nombre_operador VARCHAR(20) NOT NULL);

CREATE TABLE terminales (
num_terminal INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
nombre_terminal VARCHAR(20) NOT NULL);

CREATE TABLE rutas (
num_ruta INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
origen INT NOT NULL,
destino INT NOT NULL,
operador INT NOT NULL,
fecha datetime NOT NULL,
costo INT NOT NULL,
FOREIGN KEY (origen) REFERENCES terminales(num_terminal),
FOREIGN KEY (destino) REFERENCES terminales(num_terminal),
FOREIGN KEY (operador) REFERENCES operadores(num_operador));

CREATE TABLE autobuses (
num_autobús INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
asientos_disponibles INT NOT NULL);

CREATE TABLE autobus_ruta (
num_autobus INT NOT NULL,
num_ruta INT NOT NULL,
FOREIGN KEY (num_autobus) REFERENCES autobuses(num_autobús),
FOREIGN KEY (num_ruta) REFERENCES rutas(num_ruta));

CREATE TABLE viajes (
num_viaje INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
viaje_ida INT NOT NULL,
viaje_regreso INT NOT NULL,
FOREIGN KEY (viaje_ida) REFERENCES rutas(num_ruta),
FOREIGN KEY (viaje_regreso) REFERENCES rutas(num_ruta));

CREATE TABLE boletos (
num_boleto INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
num_viaje INT NOT NULL,
costo_total INT NOT NULL,
estado_compra VARCHAR(10) NOT NULL,
método_pago VARCHAR(10) NOT NULL,
fecha_compra datetime DEFAULT(NOW()),
fecha_actualización datetime DEFAULT(NOW()),
FOREIGN KEY (num_viaje) REFERENCES viajes(num_viaje));

INSERT INTO operadores (nombre_operador) VALUES ('Juan Pérez');
INSERT INTO terminales (nombre_terminal) VALUES ('Cuernavaca');
INSERT INTO terminales (nombre_terminal) VALUES ('Cd. México');
INSERT INTO autobuses (asientos_disponibles) VALUES (30);
INSERT INTO autobuses (asientos_disponibles) VALUES (32);
INSERT INTO rutas (origen,destino,operador,fecha,costo) VALUES (1,2,1,'2021-10-08 4:00:00',200);
INSERT INTO rutas (origen,destino,operador,fecha,costo) VALUES (2,1,1,'2021-10-09 5:00:00',300);
INSERT INTO autobus_ruta VALUES (1,1);
INSERT INTO autobus_ruta VALUES (2,2);
INSERT INTO viajes (viaje_ida,viaje_regreso) VALUES (1,2);
INSERT INTO boletos (num_viaje,costo_total,estado_compra,método_pago)
VALUES (1,500,'ACTIVO','EFECTIVO');

SELECT * FROM terminales;
SELECT * FROM operadores;
SELECT * FROM rutas;
SELECT * FROM autobuses;
SELECT * FROM autobus_ruta;
SELECT * FROM viajes;
SELECT * FROM boletos;

CREATE VIEW itinerario AS
SELECT RTO.id,RTO.origen,RTO.destino,o.nombre_operador AS operador,RTO.fecha,RTO.costo FROM
(SELECT RT.id,RT.origen,T.nombre_terminal AS destino,RT.fecha,RT.costo,RT.operador FROM
(SELECT t.nombre_terminal AS origen,r.num_ruta AS id,r.fecha,r.costo,r.destino,r.operador
FROM rutas r INNER JOIN terminales t ON r.origen = t.num_terminal) AS RT
INNER JOIN terminales T ON RT.destino = T.num_terminal) AS RTO
INNER JOIN operadores o ON RTO.operador = o.num_operador;

SELECT * FROM itinerario;
SELECT * FROM terminales WHERE nombre_terminal = 'Cuernavaca';