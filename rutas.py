import pymysql

class DataBase:
    def __init__(self):
        self.connection = pymysql.connect(
            host='localhost',
            user='root',
            password='Erdidier137980',
            db='autobuses'
        )

        self.cursor = self.connection.cursor()

    def seleccionar_origen(self, terminal):
        sql = 'SELECT * FROM terminales WHERE nombre_terminal = "{}"'.format(terminal)

        try:
            self.cursor.execute(sql)
            origen = int(self.cursor.fetchone()[0])
            return origen

        except Exception as e:
            raise

    def seleccionar_destino(self, terminal):
        sql = 'SELECT * FROM terminales WHERE nombre_terminal = "{}"'.format(terminal)

        try:
            self.cursor.execute(sql)
            destino = int(self.cursor.fetchone()[0])
            return destino

        except Exception as e:
            raise

    def seleccionar_operador(self, operador):
        sql = 'SELECT * FROM operadores WHERE nombre_operador = "{}"'.format(operador)

        try:
            self.cursor.execute(sql)
            operador = int(self.cursor.fetchone()[0])
            return operador

        except Exception as e:
            raise

    def registrar(self, t_origen, t_destino, n_operador, fecha, costo):
        origen = int(self.seleccionar_origen(t_origen))
        destino = int(self.seleccionar_destino(t_destino))
        operador = int(self.seleccionar_operador(n_operador))
        #fecha = '2021-10-08 4:00:00'
        #costo = 200
        sql = 'INSERT INTO rutas (origen,destino,operador,fecha,costo) VALUES ({},{},{},"{}",{});'.format(origen,destino,operador,fecha,costo)

        try:
            self.cursor.execute(sql)
            self.connection.commit()

        except Exception as e:
            raise

database = DataBase()
database.seleccionar_origen('Cuernavaca')
database.seleccionar_origen('Cd. México')
database.seleccionar_operador('Juan Pérez')
#database.registrar('Cuernavaca','Cd. México','Juan Pérez','2021-10-08 04:00:00',200)
database.registrar('Cd. México','Cuernavaca','Juan Pérez','2021-10-09 05:00:00',300)
