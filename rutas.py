import pymysql

def registrar(origen,destino,operador,fecha,costo,autobus):
    con = obtener_conexion()
    with con.cursor() as cursor:
        cursor.execute("CALL registrar_ruta('{}','{}','{}','{}',{})".format(origen,destino,operador,fecha,costo))
        cursor.execute("SELECT MAX(num_ruta) AS id FROM rutas")
        ID = cursor.fetchall()
        cursor.execute("CALL asignar_autobus({},{})".format(autobus,ID[0][0]))
        cursor.close()
        con.commit()
    con.close()
    estado = 'ok'
    return estado