from aplicacion.Database import Mysql

def guardar_cliente(request):
    """
        Registra un nuevo cliente.
    """
    if (request.method == 'POST'):
        nombre  = request.form['nombre']
        empresa = request.form['empresa']
        cedula  = request.form['cedula']
        obser   = request.form['observacion']
        estado  = request.form['estado']
        email   = request.form['email']
        if (obser == '' or obser == None):
            obser = 'Sin observaciones...'
        if (cedula != None and cedula != '0' and cedula != '' and empresa != '' and empresa != None):
            conexion = Mysql()
            conexion.execute_procedure("stp_insertarCliente", [cedula,nombre,empresa,email,obser,estado])


def modificar_cliente(request):
    """
        Modifica los datos de un cliente, se identifica por medio de la cédula.
    """
    if (request.method == 'POST'):
        nombre  = request.form['nombre']
        empresa = request.form['empresa']
        cedula  = request.form['cedula']
        obser   = request.form['observacion']
        estado  = request.form['estado']
        email   = request.form['email']
        if (obser == '' or obser == None):
            obser = 'Sin observaciones...'
        if (cedula != None and cedula != '0' and cedula != '' and empresa != '' and empresa != None):
            conexion = Mysql()
            conexion.execute_procedure("stp_modificarCliente", [cedula,nombre,empresa,email,obser,estado])


def modificar_estado(cedula):
    """
        Recibe la cédula para identificar un cliente en la BD y cambiar su estado.
        - La cédula debe ser de tipo str.
    """
    if (cedula != None and cedula != 0 and cedula != ''):
        conexion = Mysql()
        conexion.execute_procedure("stp_cambiarEstadoCliente", [cedula])


def obtener_cliente(cedula):
    """
        Retorna los datos de un cliente que se identifique con la cédula recibida en la BD.
        - La cédula es de tipo str.
    """
    if (cedula != None and cedula != ''):
        conexion = Mysql()
        datos = conexion.call_store_procedure_return("stp_mostrarCliente", [cedula])
        return datos
    return None


def mostrar_clientes():
    """
        Extrae los datos de todos los clientes registrados en la BD.
    """
    conexion  = Mysql()
    datos = conexion.call_store_procedure_return("stp_mostrarRegistros", ['clientes'])
    return datos
