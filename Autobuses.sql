DROP DATABASE IF EXISTS autobuses;

#Crear base de datos para la línea de autobuses
CREATE DATABASE autobuses;

USE autobuses;

#Crear la tabla donde se ingresarán los operadores (sólo directamente)
CREATE TABLE operadores (
num_operador INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
nombre_operador VARCHAR(20) NOT NULL);

#Crear la tabla donde se ingresarán las terminales (solo directamente)
CREATE TABLE terminales (
num_terminal INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
nombre_terminal VARCHAR(20) NOT NULL);

#Crear la tabla donde se ingresarán las rutas, tomando datos de las tablas anteriores
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

CREATE TABLE boletos (
num_boleto INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
nombre_cliente VARCHAR(50) NOT NULL,
edad_cliente INT NOT NULL,
genero_cliente VARCHAR(1) NOT NULL,
viaje_ida INT NOT NULL,
viaje_regreso INT,
costo_total INT NOT NULL,
estado_compra VARCHAR(10) DEFAULT('ACTIVO'),
metodo_pago VARCHAR(10) NOT NULL,
fecha_compra datetime DEFAULT(NOW()),
fecha_actualizacion datetime DEFAULT(NOW()),
FOREIGN KEY (viaje_ida) REFERENCES rutas(num_ruta),
FOREIGN KEY (viaje_regreso) REFERENCES rutas(num_ruta));

CREATE TABLE usuarios (
num_usuario INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
usuario VARCHAR(15) NOT NULL,
contraseña VARCHAR(12) NOT NULL);

INSERT INTO operadores (nombre_operador) VALUES ('Juan Pérez');
INSERT INTO operadores (nombre_operador) VALUES ('Jose Luis');
INSERT INTO terminales (nombre_terminal) VALUES ('Cuernavaca');
INSERT INTO terminales (nombre_terminal) VALUES ('Cd. México');
INSERT INTO terminales (nombre_terminal) VALUES ('Puebla');
INSERT INTO terminales (nombre_terminal) VALUES ('Xalapa');
INSERT INTO autobuses (asientos_disponibles) VALUES (30);
INSERT INTO autobuses (asientos_disponibles) VALUES (32);
INSERT INTO autobuses (asientos_disponibles) VALUES (30);
INSERT INTO autobuses (asientos_disponibles) VALUES (32);
INSERT INTO autobuses (asientos_disponibles) VALUES (30);
INSERT INTO autobuses (asientos_disponibles) VALUES (32);
INSERT INTO autobuses (asientos_disponibles) VALUES (30);
INSERT INTO autobuses (asientos_disponibles) VALUES (32);
INSERT INTO autobuses (asientos_disponibles) VALUES (30);
INSERT INTO autobuses (asientos_disponibles) VALUES (32);
INSERT INTO rutas (origen,destino,operador,fecha,costo) VALUES (1,2,1,'2021-12-17 4:00:00',200);
INSERT INTO rutas (origen,destino,operador,fecha,costo) VALUES (2,1,1,'2021-12-18 5:00:00',300);
INSERT INTO autobus_ruta (num_autobus,num_ruta) VALUES (1,1);
INSERT INTO autobus_ruta (num_autobus,num_ruta) VALUES (2,2);
#INSERT INTO viajes (viaje_ida,viaje_regreso) VALUES (1,2);
INSERT INTO boletos (nombre_cliente,edad_cliente,genero_cliente,viaje_ida,viaje_regreso,costo_total,estado_compra,metodo_pago)
VALUES ('Erick Didier',21,'H',1,2,500,'ACTIVO','EFECTIVO');
INSERT INTO usuarios (usuario,contraseña) VALUES ('Admin_M','Q)1P3@Za7jwW');
INSERT INTO usuarios (usuario,contraseña) VALUES ('Admin_C','grUmmH0![8n+');
INSERT INTO usuarios (usuario,contraseña) VALUES ('Admin_P','8~mdBOQW(eqI');
INSERT INTO usuarios (usuario,contraseña) VALUES ('Admin_X','iZFGn^dQ5DT(');

DROP FUNCTION IF EXISTS obtener_id;

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

DROP PROCEDURE IF EXISTS registrar_ruta;

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

DROP PROCEDURE IF EXISTS editar_ruta;

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

DROP PROCEDURE IF EXISTS eliminar_ruta;

DELIMITER $$
CREATE PROCEDURE eliminar_ruta(in id INT)
BEGIN
DELETE FROM rutas WHERE num_ruta = id;
END $$
DELIMITER ;

CALL eliminar_ruta(3);

DROP PROCEDURE IF EXISTS asignar_autobus;

DELIMITER $$
CREATE PROCEDURE asignar_autobus(in autobus INT,in ruta INT)
BEGIN
INSERT INTO autobus_ruta (num_autobus,num_ruta) VALUES (autobus,ruta);
END $$
DELIMITER ;

CALL asignar_autobus(1,4);

DROP PROCEDURE IF EXISTS editar_asignacion;

DELIMITER $$
CREATE PROCEDURE editar_asignacion(in autobus INT,in ruta INT,in id INT)
BEGIN
UPDATE autobus_ruta SET num_autobus = autobus, num_ruta = ruta WHERE num_id = id;
END $$
DELIMITER ;

CALL editar_asignacion(2,3,3);

DROP PROCEDURE IF EXISTS eliminar_asignacion;

DELIMITER $$
CREATE PROCEDURE eliminar_asignacion(in id INT)
BEGIN
DELETE FROM autobus_ruta WHERE num_id = id;
END $$
DELIMITER ;

CALL eliminar_asignacion(3);

DROP PROCEDURE IF EXISTS comprar_boletos;

DELIMITER $$
CREATE PROCEDURE comprar_boletos(in nombre VARCHAR(50),in edad INT,in genero VARCHAR(1),in ida INT, in regreso INT,in costo_i INT,in costo_r INT,in pago VARCHAR(10))
BEGIN
DECLARE total INT;
SET total = costo_i + costo_r;
INSERT INTO boletos (nombre_cliente,edad_cliente,genero_cliente,viaje_ida,viaje_regreso,costo_total,metodo_pago)
VALUES (nombre,edad,genero,ida,regreso,total,pago);
END $$
DELIMITER ;

CALL comprar_boletos('Erick Didier',21,'H',1,2,200,300,'EFECTIVO');
CALL comprar_boletos('Erick Didier',21,'H',1,NULL,200,0,'EFECTIVO');

DROP PROCEDURE IF EXISTS cancelar_boleto;

DELIMITER $$
CREATE PROCEDURE cancelar_boleto(in id INT,out estado VARCHAR(10))
BEGIN
DECLARE anticipacion TIME;
DECLARE fecha DATETIME;
SET fecha = (SELECT fecha_i from consulta_boletos cb WHERE cb.id = id);
IF fecha > NOW() THEN
SET anticipacion = (SELECT TIMEDIFF(fecha,NOW()));
IF anticipacion >= 3 THEN
UPDATE boletos SET estado_compra = 'CANCELADO',fecha_actualizacion = now() WHERE num_boleto = id;
ELSE
SET estado = 'MENOR';
END IF;
ELSE
SET estado = 'PASADO';
END IF;
END $$
DELIMITER ;

CALL cancelar_boleto(2,@estado);
SELECT @estado;

SELECT * FROM terminales;
SELECT * FROM operadores;
SELECT * FROM rutas;
SELECT * FROM autobuses;
SELECT * FROM autobus_ruta;
#SELECT * FROM viajes;
SELECT * FROM boletos;
SELECT * FROM usuarios;

DROP VIEW IF EXISTS itinerario;

CREATE VIEW itinerario AS
SELECT AR.id,AR.origen,AR.destino,AR.operador,AR.autobus,a.asientos_disponibles AS asientos,DATE(AR.fecha) AS fecha,TIME(AR.fecha) AS hora,AR.costo FROM
(SELECT RTO.id,RTO.origen,RTO.destino,RTO.operador,ar.num_autobus AS autobus,RTO.fecha,RTO.costo FROM
(SELECT RT2.id,RT2.origen,RT2.destino,o.nombre_operador AS operador,RT2.fecha,RT2.costo FROM
(SELECT RT.id,RT.origen,T.nombre_terminal AS destino,RT.fecha,RT.costo,RT.operador FROM
(SELECT t.nombre_terminal AS origen,r.num_ruta AS id,r.fecha,r.costo,r.destino,r.operador
FROM rutas r INNER JOIN terminales t ON r.origen = t.num_terminal) AS RT
INNER JOIN terminales T ON RT.destino = T.num_terminal) AS RT2
INNER JOIN operadores o ON RT2.operador = o.num_operador) AS RTO
INNER JOIN autobus_ruta ar ON RTO.id = ar.num_ruta) AS AR
INNER JOIN autobuses a ON AR.autobus = a.num_autobus;

DROP VIEW IF EXISTS consulta_boletos;

CREATE VIEW consulta_boletos AS
SELECT DISTINCTROW vi.id,vi.nombre,vi.edad,vi.genero,vi.viaje_ida,vi.operador_i,vi.fecha_i,vi.hora_i,vi.costo_i,
IF(vi.viaje_regreso IS NULL,'-',CONCAT(i.origen,'-',i.destino)) AS viaje_regreso,IF(vi.viaje_regreso IS NULL,'-',i.operador) AS operador_r,IF(vi.viaje_regreso IS NULL,'-',i.fecha) AS fecha_r,IF(vi.viaje_regreso IS NULL,'-',i.hora) AS hora_r,IF(vi.viaje_regreso IS NULL,'-',i.costo) AS costo_r,vi.costo_total,vi.estado_compra,vi.metodo_pago,vi.fecha_compra,vi.fecha_actualizacion FROM
(SELECT b.num_boleto AS id,b.nombre_cliente AS nombre,b.edad_cliente AS edad,b.genero_cliente AS genero,CONCAT(i.origen,'-',i.destino) AS viaje_ida,i.operador AS operador_i,i.fecha AS fecha_i,i.hora AS hora_i,i.costo AS costo_i,b.viaje_regreso,b.costo_total,b.estado_compra,b.metodo_pago,b.fecha_compra,b.fecha_actualizacion
FROM boletos b INNER JOIN itinerario i ON b.viaje_ida = i.id) AS vi
INNER JOIN itinerario i ON (vi.viaje_regreso = i.id OR (vi.viaje_regreso IS NULL)) ORDER BY vi.id;

SELECT * FROM itinerario;
SELECT * FROM itinerario ORDER BY fecha;
SELECT * FROM consulta_boletos;
SELECT * FROM terminales WHERE nombre_terminal != 'Cuernavaca';
SELECT * FROM itinerario WHERE origen = 'Cuernavaca' AND destino = 'Cd. México' AND fecha = '2021-10-08';