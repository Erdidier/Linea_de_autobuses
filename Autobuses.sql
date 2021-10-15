CREATE DATABASE estacionamiento;

USE estacionamiento;

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
num_ruta INT NOT NULL,
asientos_disponibles INT NOT NULL,
FOREIGN KEY (num_ruta) REFERENCES rutas(num_ruta));

CREATE TABLE boletos (
num_boleto INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
num_ruta INT NOT NULL,
fecha_ida datetime NOT NULL,
fecha_vuelta datetime,
costo_total INT NOT NULL,
estado_compra VARCHAR(10) NOT NULL,
método_pago VARCHAR(10) NOT NULL,
fecha_compra datetime DEFAULT(NOW()),
fecha_actualización datetime DEFAULT(NOW()),
FOREIGN KEY (num_ruta) REFERENCES rutas(num_ruta));