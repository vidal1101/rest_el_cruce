from aplicacion.Database import Mysql

def guardar_proveedor(request):
    """
        Guarda un nuevo proveedor en la BD.
    """
    if (request.method == 'POST'):
        cedjuridica = request.form['cedJuridica']
        empresa     = request.form['empresa']
        telefono    = request.form['telefono']
        estado      = request.form['estado']
        direccion   = request.form['direccion']
        descripcion = request.form['descripcion']
        if (descripcion == ''):
            descripcion = 'Sin descripción...'
        if (direccion == ''):
            direccion = 'Sin dirección...'
        conexion    = Mysql()
        conexion.execute_procedure("stp_insertarProveedor", [cedjuridica,
                empresa, telefono, estado, direccion, descripcion])


def modificar_proveedor(request):
    """
        Se actualiza los datos de un proveedor, de acuerdo al ID auto incrementable y la cédula jurídica.
        - El id se recibe por el método get y los demás datos por el método POST.
    """
    id_proveedor = request.args.get("idproveedor")
    if (request.method == 'POST' and id_proveedor != ''):
        cedjuridica = request.form['cedJuridica']
        empresa     = request.form['empresa']
        telefono    = request.form['telefono']
        estado      = request.form['estado']
        direccion   = request.form['direccion']
        descripcion = request.form['descripcion']
        if (descripcion == ''):
            descripcion = 'Sin descripción...'
        if (direccion == ''):
            direccion = 'Sin dirección...'
        conexion = Mysql()
        conexion.execute_procedure("stp_modificarProveedor", [id_proveedor, cedjuridica, empresa, telefono, estado, direccion, descripcion])


def obtener_proveedor(idproveedor):
    """
        Identifica por medio del ID y retorna los datos de un proveedor registrado en la BD.
        - El ID es de tipo int.
    """
    if (id != ''):
        conexion = Mysql()
        datos    = conexion.call_store_procedure_return("stp_mostrarProveedor", [idproveedor])
        return datos
    return None

def cambiar_estado(cedula):
    """
        Cambia el estado de un proveedor al identificarlo con la cédula jurídica en la BD.
        - La cédula es de tipo str
    """
    if (cedula != '' and cedula != 0):
        conexion = Mysql()
        conexion.execute_procedure("stp_cambiarEstadoProveedor",[cedula])


def mostrar_proveedores():
    """
        Extrae todos los proveedores registrados en la BD.
    """
    conexion = Mysql()
    datos    = conexion.call_store_procedure_return("stp_mostrarRegistros", ['proveedores'])
    return datos
