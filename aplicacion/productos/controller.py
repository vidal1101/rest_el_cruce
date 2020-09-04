from aplicacion.Database import Mysql

def mostrar_productos(idcategoria):
    """
        Mostrar productos exclusivamente de una categoría.
        - Recibe el ID de la categoría.
    """
    if (idcategoria != '' and idcategoria != None):
        conex = Mysql()
        datos = conex.call_store_procedure_return("stp_mostrarProductos_x_Categoria",[idcategoria])
        return datos
    return None


def obtener_producto(idproducto):
    """
        Retorna los datos de un producto identificado por medio de un ID.
        - El ID es de tipo int
    """
    if (idproducto != '' and idproducto != None):
        conex = Mysql()
        rs = conex.call_store_procedure_return("stp_mostrarProducto",[idproducto])
        return rs
    return None


def guardar_producto(request):
    """
        Registra un nuevo producto, el ID se coloca por parte del usuario.
    """
    if (request.method == 'POST'):
        idproducto   = request.form['id-producto']
        idcate       = request.form['id-categoria']
        nombre       = request.form['nombre']
        precio_venta = request.form['venta']
        estado       = request.form['estado']
        descripcion  = request.form['descripcion']
        impuesto     = request.form['impuesto']
        if (idproducto != '' and idproducto != None):
            conex = Mysql()
            conex.execute_procedure("stp_insertarProducto",[idproducto, idcate, nombre, impuesto, precio_venta,descripcion, estado])


def modificar_producto(request):
    """
        Modifica los datos de un producto.
        - El ID el producto no se modifica.
    """
    if (request.method == 'POST'):
        idproducto   = request.form['id-producto']
        idcate       = request.form['id-categoria']
        nombre       = request.form['nombre']
        precio_venta = request.form['venta']
        estado       = request.form['estado']
        descripcion  = request.form['descripcion']
        impuesto     = request.form['impuesto']
        if (idproducto != '' and idproducto != None):
            conex = Mysql()
            conex.execute_procedure("stp_modificarProducto",[idproducto, idcate, nombre, impuesto, precio_venta,descripcion, estado])


def cambiar_estado(request):
    """
        Cambia el estado de un producto seleccionado.
        - Obtiene el ID del producto.
    """
    idproducto = request.args.get('idproducto')
    if (idproducto != '' and idproducto != None):
        conex = Mysql()
        conex.execute_procedure("stp_cambiarEstadoProducto",[idproducto])
