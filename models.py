from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class User(db.Model):
	__tablename__ = 'usuarios'
	id = db.Column(db.Integer, primary_key = True)
	username = db.Column(db.String(50), unique = True)
	password = db.Column(db.String(12))

	def __init__(self, username, password):
		self.username = username
		self.password = password

class Parking_lot(db.Model):
	__tablename__ = 'estacionamientos'
	id = db.Column(db.Integer, primary_key = True)
	nombre = db.Column(db.String(50), unique = True)
	c_p = db.Column(db.String(5))
	teléfono = db.Column(db.String(10))
	capacidad = db.Column(db.Integer)

	def __init__(self, nombre, c_p, teléfono, capacidad):
		self.nombre = nombre
		self.c_p = c_p
		self.teléfono = teléfono
		self.capacidad = capacidad

class Records(db.Model):
	__tablename__ = 'registros'
	id = db.Column(db.Integer, primary_key = True)
	codigo_llegada = db.Column(db.String(5))
	fecha_llegada = db.Column(db.DateTime)
	fecha_salida = db.Column(db.DateTime)
	total_pago = db.Column(db.Integer)

	def __init__(self, codigo_llegada, fecha_llegada, fecha_salida, total_pago):
		self.codigo_llegada = codigo_llegada
		self.fecha_llegada = fecha_llegada
		self.fecha_salida = fecha_salida
		self.total_pago = total_pago