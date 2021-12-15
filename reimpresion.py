def reimpresion(num)
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