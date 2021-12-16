from flask import Flask
from flask import render_template
from flask import request
from flask import make_response
from flask import session
from flask import flash
from flask import g
from flask import url_for
from flask import redirect
from flask import jsonify
from flask import send_file

from config import DevelopmentConfig

from models import db
from models import Parking_lot
from models import Records
from models import User

from flask_wtf import CSRFProtect

from helper import date_format

import random
from datetime import datetime, timedelta

from conexion import obtener_conexion

import pdfkit
from jinja2 import Environment, FileSystemLoader

app = Flask(__name__)
app.config.from_object(DevelopmentConfig)
csrf = CSRFProtect()

@app.errorhandler(404)
def page_not_found(e):
	return render_template('404.html'), 404

@app.before_request
def before_request():
	if 'username' not in session and request.endpoint in ['comment']:
		return redirect(url_for('login'))
	elif 'username' in session and request.endpoint in ['login', 'create']:
		return redirect(url_for('rutas'))

@app.after_request
def after_request(response):
	return response

@app.route('/', methods = ['GET', 'POST'])
def index():
	title = "Compra de Boletos"
	con = obtener_conexion()
	origen_bd = []
	destino_bd = []
	with con.cursor() as cursor:
		cursor.execute("SELECT * FROM terminales")
		origen_bd = cursor.fetchall()
		cursor.execute("SELECT * FROM terminales WHERE nombre_terminal != '{}'".format("Cuernavaca"))
		destino_bd = cursor.fetchall()
	con.close()
	return render_template('index.html', title = title, origen = origen_bd, destino = destino_bd)

@app.route('/informes', methods = ['GET','POST'])
@app.route('/informes/<filtro>', methods = ['POST'])
def informes(filtro=''):
	rutas = []
	con = obtener_conexion()
	if filtro == 'fecha':
		with con.cursor() as cursor:
			cursor.execute("SELECT * FROM itinerario ORDER BY fecha")
			rutas = cursor.fetchall()
		con.close()
	if filtro == 'origen':
		with con.cursor() as cursor:
			cursor.execute("SELECT * FROM itinerario ORDER BY origen")
			rutas = cursor.fetchall()
		con.close()
	if filtro == 'destino':
		with con.cursor() as cursor:
			cursor.execute("SELECT * FROM itinerario ORDER BY destino")
			rutas = cursor.fetchall()
		con.close()
	if filtro == 'autobus':
		with con.cursor() as cursor:
			cursor.execute("SELECT * FROM itinerario ORDER BY autobus")
			rutas = cursor.fetchall()
		con.close()
	if filtro == 'operador':
		with con.cursor() as cursor:
			cursor.execute("SELECT * FROM itinerario ORDER BY operador")
			rutas = cursor.fetchall()
		con.close()
	return render_template('informes.html',rutas=rutas)

@app.route('/rutas', methods = ['GET','POST'])
@app.route('/rutas/<operacion>', methods = ['POST'])
def rutas(operacion=''):
	origen = request.form.get('origen')
	destino = request.form.get('destino')
	operador = request.form.get('operador')
	fecha = request.form.get('fecha')
	costo = request.form.get('costo')
	autobus = request.form.get('num_autobus')
	con = obtener_conexion()
	if operacion == 'registrar':
		with con.cursor() as cursor:
			cursor.execute("CALL registrar_ruta('{}','{}','{}','{}',{})".format(origen,destino,operador,fecha,costo))
			cursor.execute("SELECT MAX(num_ruta) AS id FROM rutas")
			ID = cursor.fetchall()
			cursor.execute("CALL asignar_autobus({},{})".format(autobus,ID[0][0]))
			cursor.close()
			con.commit()
		con.close()
	return render_template('rutas.html',operacion=operacion)

@app.route('/destino/<origen>')
def destino(origen):
	con = obtener_conexion()
	destinos = []
	with con.cursor() as cursor:
		cursor.execute("SELECT * FROM terminales WHERE nombre_terminal != '{}'".format(origen))
		destinos = cursor.fetchall()
	con.close()
	destArray = []
	for destino in destinos:
		destObj = {}
		destObj['id'] = destino[0]
		destObj['name'] = destino[1]
		destArray.append(destObj)
	return jsonify({'Destinos': destArray})

@app.route('/itinerario/<tipo_v>', methods = ['GET','POST'])
@app.route('/itinerario/<tipo_v>/<orig>/<dest>/<fecha_r>/<id_ri>', methods = ['GET','POST'])
def itinerario(tipo_v,orig='',dest='',fecha_r='',id_ri=0):
	print(tipo_v)
	tipo_viaje = request.form.get('viaje')
	num_pasajeros = request.form.get('pasajeros')
	origen = request.form.get('origen')
	destino = request.form.get('destino')
	fecha_ida = request.form.get('ida')
	fecha_regreso = request.form.get('regreso')
	print(fecha_ida)
	print(fecha_regreso)
	con = obtener_conexion()
	horarios_i = []
	horarios_r = []
	if tipo_v == 'sencillo':
		with con.cursor() as cursor:
			cursor.execute("SELECT * FROM itinerario WHERE origen = '{}' AND destino = '{}' AND fecha = '{}'".format(origen,destino,fecha_ida))
			horarios_i = cursor.fetchall()
		con.close()
		for horario_i in horarios_i:
			hora_i = str(horario_i[7])
			hora_i = ':'.join(str(hora_i).split(':')[:2])
			print(hora_i)
			fecha_i = str(horario_i[6])
			print(fecha_i)
			print(horarios_i)
		return render_template('itinerario.html',horarios_i=horarios_i,fecha_i=fecha_i,hora_i=hora_i,tipo_v=tipo_v)
	elif tipo_v == 'redondo':
		with con.cursor() as cursor:
			cursor.execute("SELECT * FROM itinerario WHERE origen = '{}' AND destino = '{}' AND fecha = '{}'".format(origen,destino,fecha_ida))
			horarios_i = cursor.fetchall()
		con.close()
		for horario_i in horarios_i:
			hora_i = str(horario_i[7])
			hora_i = ':'.join(str(hora_i).split(':')[:2])
			print(hora_i)
			fecha_i = str(horario_i[6])
			print(fecha_i)
		print(horarios_i)
		return render_template('itinerario.html',tipo_v='redondo',origen=origen,destino=destino,fecha_regreso=fecha_regreso,horarios_i=horarios_i,fecha_i=fecha_i,hora_i = hora_i)
	elif tipo_v == 'redondo1' and request.method == 'GET':
		print(fecha_regreso)
		with con.cursor() as cursor:
			cursor.execute("SELECT * FROM itinerario WHERE origen = '{}' AND destino = '{}' AND fecha = '{}'".format(dest,orig,fecha_r))
			horarios_r = cursor.fetchall()
		con.close()
		for horario_r in horarios_r:
			hora_r = str(horario_r[7])
			hora_r = ':'.join(str(hora_r).split(':')[:2])
			print(hora_r)
			fecha_r = str(horario_r[6])
			print(fecha_r)
		print(horarios_r)
		return render_template('itinerario.html',id_ri=id_ri, tipo_v = 'redondo1', horarios_r = horarios_r, fecha_r = fecha_r, hora_r = hora_r)

@app.route('/datos/<tipo_v>/<int:id_ri>', methods = ['GET','POST'])
@app.route('/datos/<tipo_v>/<int:id_ri>/<int:id_rr>', methods = ['GET','POST'])
@app.route('/datos/<tipo_v>/<int:id_ri>/<int:id_rr>/<int:datos_e>', methods = ['GET','POST'])
def datos(tipo_v,id_ri,id_rr=0,datos_e=0):
	print(datos_e)
	print(id_ri)
	print(id_rr)
	if request.method == 'POST':
		print(datos_e)
		print(tipo_v)
		if datos_e == 1 and tipo_v == 'sencillo':
			nombre = request.form.get('nombre')
			edad = request.form.get('edad')
			genero = request.form.get('genero')
			return redirect(url_for('comprar',id_ri=id_ri,tipo_v=tipo_v,nombre=nombre,edad=edad,genero=genero))
			#return render_template('itinerario.html',nombre=nombre,edad=edad,genero=genero,tipo_v=tipo_v)
		elif datos_e == 1 and tipo_v == 'redondo1':
			nombre = request.form.get('nombre')
			edad = request.form.get('edad')
			genero = request.form.get('genero')
			return redirect(url_for('comprar',id_ri=id_ri,id_rr=id_rr,nombre=nombre,edad=edad,genero=genero,tipo_v='redondo1'))
	elif request.method == 'GET':
		if datos_e == 0:
			return render_template('datos_cliente.html', tipo_v = tipo_v,id_rr=id_rr, id_ri = id_ri)

@app.route('/logout')
def logout():
	if 'username' in session:
		session.pop('username')
	return redirect(url_for('login'))

@app.route('/login', methods = ['GET', 'POST'])
def login():
	if request.method == 'POST':
		con = obtener_conexion()
		username = request.form.get('usuario')
		password = request.form.get('contraseña')
		with con.cursor() as cursor:
			cursor.execute("SELECT usuario,contraseña FROM usuarios WHERE usuario = '{}'".format(username))
			user = cursor.fetchall()
		#user = User.query.filter_by(username = username).first()
		if user != () and user[0][1] == password:
			success_message = 'Bienvenido {}'.format(username)
			flash(success_message)
			session['username'] = username
			return redirect(url_for('informes'))
		else:
			error_message = 'Usuario o contraseña no válidos!'
			flash(error_message)
	return render_template('login.html')

@app.route('/registros')
def registros():
	registros = Records.query.all()
	for registro in registros:
		print(registro.codigo_llegada)
	return render_template('reviews.html', registros = registros)

@app.route('/create', methods = ['GET', 'POST'])
def create():
	estacionamiento = forms.Registrar(request.form)
	if request.method == 'POST':
		parking = Parking_lot(estacionamiento.nombre.data,
			estacionamiento.c_p.data,
			estacionamiento.teléfono.data,
			estacionamiento.capacidad.data)
		db.session.add(parking)
		db.session.commit()
		success_message = 'Estacionamiento registrado en la base de datos'
		flash(success_message)
	return redirect(url_for('index'))

@app.route('/edit/<int:id>')
def get_contact(id):
	data = Parking_lot.query.filter_by(id = id).first()
	return render_template('edit.html', estacionamiento = data)

@app.route('/update/<int:id>', methods = ['POST'])
def update_contact(id):
	if request.method == 'POST':
		nombre = request.form['nombre']
		c_p = request.form['c_p']
		teléfono = request.form['teléfono']
		capacidad = request.form['capacidad']
		update = Parking_lot.query.filter_by(id = id).update(dict(nombre = nombre, c_p = c_p, teléfono = teléfono, capacidad = capacidad))
		db.session.commit()
		flash('Información actualizada con éxito')
		return redirect(url_for('index'))

@app.route('/delete/<int:id>')
def delete_contact(id):
	update = Parking_lot.query.filter_by(id = id).delete()
	db.session.commit()
	flash('Estacionamiento eliminado satisfactoriamente')
	return redirect(url_for('index'))

@app.route('/pv', methods = ['GET', 'POST'])
def pv():
	return render_template('pv.html')

@app.route('/reimpresion', methods = ['GET', 'POST'])
def salida():
	if request.method == 'POST':
		num = request.form.get('numero')
		correo = request.form.get('correo')
		con = obtener_conexion()
		boleto = []
		with con.cursor() as cursor:
			cursor.execute("SELECT * FROM consulta_boletos WHERE id = {}".format(num))
			boleto = cursor.fetchall()
		print(boleto)
		print(len(boleto))
		if len(boleto) != 0:
			env = Environment(loader=FileSystemLoader("templates"))
			template = env.get_template("boleto_redondo.html")
			if boleto[0][9] == '-':
				b = {
					'numero' : boleto[0][0],
					'nombre' : boleto[0][1],
					'edad' : boleto[0][2],
					'genero' : boleto[0][3],
					'fecha_i' : boleto[0][6],
					'hora_i' : boleto[0][7],
					'ruta_i' : boleto[0][4],
					'operador_i' : boleto[0][5],
					'origen_i' : boleto[0][4].split('-')[0],
					'destino_i' : boleto[0][4].split('-')[1],
					'costo_i' : '$'+str(boleto[0][8])+'.00 MXN',
					'costo_r' : '$0.00 MXN',
					'total' : '$'+str(boleto[0][14])+'.00 MXN',
					'tipo' : 'sencillo'
				}
			else:
				b = {
					'numero' : boleto[0][0],
					'nombre' : boleto[0][1],
					'edad' : boleto[0][2],
					'genero' : boleto[0][3],
					'fecha_i' : boleto[0][6],
					'hora_i' : boleto[0][7],
					'ruta_i' : boleto[0][4],
					'operador_i' : boleto[0][5],
					'origen_i' : boleto[0][4].split('-')[0],
					'destino_i' : boleto[0][4].split('-')[1],
					'costo_i' : '$'+str(boleto[0][8])+'.00 MXN',
					'fecha_r' : boleto[0][11],
					'hora_r' : boleto[0][12],
					'operador_r' : boleto[0][10],
					'ruta_r' : boleto[0][9],
					'origen_r' : boleto[0][9].split('-')[0],
					'destino_r' : boleto[0][9].split('-')[1],
					'costo_r' : '$'+str(boleto[0][13])+'.00 MXN',
					'total' : '$'+str(boleto[0][14])+'.00 MXN',
					'tipo' : 'redondo'
				}
			options = {
				'page-size' : 'Letter',
				'encoding' : 'UTF-8'
			}
			print(b)
			html = template.render(b)
			config = pdfkit.configuration(wkhtmltopdf='C:\\Program Files\\wkhtmltopdf\\bin\\wkhtmltopdf.exe')
			pdfkit.from_string(html, 'boleto.pdf',options=options,configuration=config)
			pdf = "boleto.pdf"
			flash('Boleto descargado y enviado con éxito')
			return send_file(pdf,as_attachment=True)
			#return render_template('Calcular.html', salida = salida, código = código, total = total)
		else:
			flash('El número de boleto ingresado no se encuentra registrado')
		con.close()
	return render_template('reimpresion.html')

@app.route('/comprar/<tipo_v>/<nombre>/<int:edad>/<genero>/<int:id_ri>', methods = ['GET', 'POST'])
@app.route('/comprar/<tipo_v>/<nombre>/<int:edad>/<genero>/<int:id_ri>/<int:id_rr>', methods = ['GET', 'POST'])
def comprar(id_ri,tipo_v,nombre,edad,genero,id_rr=None):
	if request.method == 'GET':
		pago = 'EFECTIVO'
		if id_rr == None and tipo_v == 'sencillo':
			con = obtener_conexion()
			with con.cursor() as cursor:
				cursor.execute("SELECT id FROM itinerario WHERE id = '{}'".format(id_ri))
				ida = cursor.fetchall()
				cursor.execute("SELECT costo FROM itinerario WHERE id = '{}'".format(id_ri))
				costo_ida = cursor.fetchall()
				cursor.execute("CALL comprar_boletos('{}',{},'{}',{},NULL,{},0,'{}')".format(nombre,edad,genero,ida[0][0],costo_ida[0][0],pago))
				cursor.close()
				con.commit()
			con.close()
			print(ida[0][0])
		elif id_rr != None and tipo_v == 'redondo1':
			con = obtener_conexion()
			with con.cursor() as cursor:
				cursor.execute("SELECT id FROM itinerario WHERE id = '{}'".format(id_ri))
				ida = cursor.fetchall()
				cursor.execute("SELECT costo FROM itinerario WHERE id = '{}'".format(id_ri))
				costo_ida = cursor.fetchall()
				cursor.execute("SELECT id FROM itinerario WHERE id = '{}'".format(id_rr))
				regreso = cursor.fetchall()
				cursor.execute("SELECT costo FROM itinerario WHERE id = '{}'".format(id_rr))
				costo_regreso = cursor.fetchall()
				cursor.execute("CALL comprar_boletos('{}',{},'{}',{},{},{},{},'{}')".format(nombre,edad,genero,ida[0][0],regreso[0][0],costo_ida[0][0],costo_regreso[0][0],pago))
				cursor.close()
				con.commit()
			con.close()
			print(ida[0][0])
			print(regreso)
			#return render_template('itinerario.html')
		flash('Boleto Comprado Exitosamente')
		return redirect(url_for('index'))
	#return render_template('Calcular.html', salida = salida, código = código, total = total)

@app.route('/reviews/', methods = ['GET'])
@app.route('/reviews/<int:page>', methods = ['GET'])
def reviews(page = 1):
	per_page = 3
	comments = Comment.query.join(User).add_columns(User.username, Comment.text, Comment.created_date).paginate(page,per_page,False)
	return render_template('reviews.html', comments = comments, date_format = date_format)

if __name__ == '__main__':
	csrf.init_app(app)
	app.run(host="0.0.0.0", port = 80)	