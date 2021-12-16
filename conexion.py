import pymysql


def obtener_conexion():
    return pymysql.connect(host='autobuses.ckrwy8ggtlgg.us-east-1.rds.amazonaws.com', user='admin', password='Erdidier137980#', db='autobuses')