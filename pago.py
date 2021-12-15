def pago():
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