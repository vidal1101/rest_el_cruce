import pymysql

class Mysql():
    """
        Clase utilizada para conectarse a la base de datos MYSQL.
        - Se requiere la librería pymysql.
    """
    __instance = None
    __host = None
    __user = None
    __password = None
    __database = None

    __session = None
    __connection = None
   

    def __new__(cls, *args, **kwargs):
        if not cls.__instance:
            cls.__instance = super(Mysql, cls).__new__(cls, *args, **kwargs)
        return cls.__instance

    def __init__(self, host='127.0.0.1', user='adminRestBar', password='Password!999', database='Bar_Rest_ElCruce'):
        self.__host = host
        self.__user = user
        self.__password = password
        self.__database = database
      

    def _open(self):
        try:
            cnx = pymysql.connect(host=self.__host, user=self.__user, password=self.__password,
                database=self.__database)
            self.__connection = cnx
            self.__session = cnx.cursor()
            print('Database conectada con exito')
        except pymysql.Error as err:
            print('Something is wrong with your user name or password')
            print(err)

    def _close(self):
        self.__session.close()
        self.__connection.close()

    def call_store_procedure_return(self, name, args):
        self._open()
        cursor = self.__session
        if args != [] :
            cursor.callproc(name, args)
        else:
            cursor.callproc(name)
        datos = cursor.fetchall()
        #self.__connection.close()
        return datos

    def execute_procedure(self, name, args):
        try:
            self._open()
            self.__session.callproc(name, args)
            self.__connection.commit()
            #self._close()
            print('consulta completada')
        except Exception as error:
            print(error)