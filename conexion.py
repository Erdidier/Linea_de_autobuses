import pymysql


def obtener_conexion():
    return pymysql.connect(host='localhost', user='root', password='Erdidier137980', db='autobuses')