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
num_autobus INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
asientos_disponibles INT NOT NULL);

CREATE TABLE autobus_ruta (
num_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
num_autobus INT NOT NULL,
num_ruta INT NOT NULL,
FOREIGN KEY (num_autobus) REFERENCES autobuses(num_autobus),
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
metodo_pago VARCHAR(10) NOT NULL,
fecha_compra datetime DEFAULT(NOW()),
fecha_actualizacion datetime DEFAULT(NOW()),
FOREIGN KEY (num_viaje) REFERENCES viajes(num_viaje));

INSERT INTO operadores (nombre_operador) VALUES ('Juan Pérez');
INSERT INTO terminales (nombre_terminal) VALUES ('Cuernavaca');
INSERT INTO terminales (nombre_terminal) VALUES ('Cd. México');
INSERT INTO autobuses (asientos_disponibles) VALUES (30);
INSERT INTO autobuses (asientos_disponibles) VALUES (32);
INSERT INTO rutas (origen,destino,operador,fecha,costo) VALUES (1,2,1,'2021-10-08 4:00:00',200);
INSERT INTO rutas (origen,destino,operador,fecha,costo) VALUES (2,1,1,'2021-10-09 5:00:00',300);
INSERT INTO autobus_ruta (num_autobus,num_ruta) VALUES (1,1);
INSERT INTO autobus_ruta (num_autobus,num_ruta) VALUES (2,2);
INSERT INTO viajes (viaje_ida,viaje_regreso) VALUES (1,2);
INSERT INTO boletos (num_viaje,costo_total,estado_compra,metodo_pago)
VALUES (1,500,'ACTIVO','EFECTIVO');

DROP FUNCTION obtener_id;

DELIMITER $$
CREATE FUNCTION obtener_id(num_tabla INT,valor VARCHAR(20)) RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
DECLARE resultado INT;
IF num_tabla = 1 THEN
SET resultado = (SELECT num_terminal FROM terminales WHERE nombre_terminal = valor);
ELSEIF num_tabla = 2 THEN
SET resultado = (SELECT num_operador FROM operadores WHERE nombre_operador = valor);
ELSE
SET resultado = 0;
END IF;
RETURN resultado;
END $$
DELIMITER ;

SELECT obtener_id(1,'Cuernavaca');
SELECT obtener_id(1,'Cd. México');
SELECT obtener_id(2,'Juan Pérez');
SELECT obtener_id(3,'Juan Pérez');

DROP PROCEDURE registrar_ruta;

DELIMITER $$
CREATE PROCEDURE registrar_ruta(in t_origen VARCHAR(20),in t_destino VARCHAR(20),in n_operador VARCHAR(20),in fecha DATETIME,in costo INT)
BEGIN
DECLARE Origen INT;
DECLARE Destino INT;
DECLARE Operador INT;
SET Origen = obtener_id(1,t_origen);
SET Destino = obtener_id(1,t_destino);
SET Operador = obtener_id(2,n_operador);
INSERT INTO rutas (origen,destino,operador,fecha,costo) VALUES (Origen,Destino,Operador,fecha,costo);
END $$
DELIMITER ;

CALL registrar_ruta('Cd. México','Cuernavaca','Juan Pérez','2021-10-09 05:00:00',300);

DROP PROCEDURE editar_ruta;

DELIMITER $$
CREATE PROCEDURE editar_ruta(in id INT,in t_origen VARCHAR(20),in t_destino VARCHAR(20),in n_operador VARCHAR(20),in fecha DATETIME,in costo INT)
BEGIN
DECLARE Origen INT;
DECLARE Destino INT;
DECLARE Operador INT;
SET Origen = obtener_id(1,t_origen);
SET Destino = obtener_id(1,t_destino);
SET Operador = obtener_id(2,n_operador);
UPDATE rutas SET origen = Origen, destino = Destino, operador = Operador, fecha = fecha, costo = costo WHERE num_ruta = id;
END $$
DELIMITER ;

CALL editar_ruta(3,'Cd. México','Cuernavaca','Juan Pérez','2021-10-10 05:00:00',300);

DROP PROCEDURE eliminar_ruta;

DELIMITER $$
CREATE PROCEDURE eliminar_ruta(in id INT)
BEGIN
DELETE FROM rutas WHERE num_ruta = id;
END $$
DELIMITER ;

CALL eliminar_ruta(3);

DROP PROCEDURE asignar_autobus;

DELIMITER $$
CREATE PROCEDURE asignar_autobus(in autobus INT,in ruta INT)
BEGIN
INSERT INTO autobus_ruta (num_autobus,num_ruta) VALUES (autobus,ruta);
END $$
DELIMITER ;

CALL asignar_autobus(1,3);

DROP PROCEDURE editar_asignacion;

DELIMITER $$
CREATE PROCEDURE editar_asignacion(in autobus INT,in ruta INT,in id INT)
BEGIN
UPDATE autobus_ruta SET num_autobus = autobus, num_ruta = ruta WHERE num_id = id;
END $$
DELIMITER ;

CALL editar_asignacion(2,3,3);

SELECT * FROM terminales;
SELECT * FROM operadores;
SELECT * FROM rutas;
SELECT * FROM autobuses;
SELECT * FROM autobus_ruta;
SELECT * FROM viajes;
SELECT * FROM boletos;

DROP VIEW itinerario;

CREATE VIEW itinerario AS
SELECT AR.id,AR.origen,AR.destino,AR.operador,AR.autobus,a.asientos_disponibles AS asientos,AR.fecha,AR.costo FROM
(SELECT RTO.id,RTO.origen,RTO.destino,RTO.operador,ar.num_autobus AS autobus,RTO.fecha,RTO.costo FROM
(SELECT RT2.id,RT2.origen,RT2.destino,o.nombre_operador AS operador,RT2.fecha,RT2.costo FROM
(SELECT RT.id,RT.origen,T.nombre_terminal AS destino,RT.fecha,RT.costo,RT.operador FROM
(SELECT t.nombre_terminal AS origen,r.num_ruta AS id,r.fecha,r.costo,r.destino,r.operador
FROM rutas r INNER JOIN terminales t ON r.origen = t.num_terminal) AS RT
INNER JOIN terminales T ON RT.destino = T.num_terminal) AS RT2
INNER JOIN operadores o ON RT2.operador = o.num_operador) AS RTO
INNER JOIN autobus_ruta ar ON RTO.id = ar.num_ruta) AS AR
INNER JOIN autobuses a ON AR.autobus = a.num_autobus;

DROP VIEW consulta_boletos;

CREATE VIEW consulta_boletos AS
SELECT b.num_boleto AS id,v.viaje_ida AS ida,v.viaje_regreso AS regreso,b.costo_total,b.estado_compra,b.metodo_pago,b.fecha_compra,b.fecha_actualizacion
FROM boletos b INNER JOIN viajes v ON b.num_viaje = v.num_viaje;

SELECT * FROM itinerario;
SELECT * FROM consulta_boletos;
SELECT * FROM boletos b INNER JOIN viajes v;
SELECT * FROM terminales WHERE nombre_terminal = 'Cuernavaca';