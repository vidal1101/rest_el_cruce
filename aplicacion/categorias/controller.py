#controller inventario 
from aplicacion.Database import Mysql
import os.path as path
import base64

#insert categorias
def registrar_categoria(request):
    """
        Se registra una nueva categoría, dependiendo si tiene o no foto.
    """
    nombre_categoria = request.form['nombre']
    descrip = request.form['descripcion']
    estado = request.form['estado']
    conex = Mysql()
    foto = request.files['imagen']
    #Si tiene imagen que guardar, se realiza el procedimiento para guardar
    if (foto != None):
        nombre_foto = foto.filename
        if (nombre_foto != ''):
            foto_codificada = codificar_imagen(foto)
            conex.Execute_Procedure("stp_insertar_categoria_foto",[nombre_categoria,descrip,estado, foto_codificada, nombre_foto])
        else:
            conex.Execute_Procedure("stp_insertarCategoria",[nombre_categoria,descrip,estado])
    else:
        conex.Execute_Procedure("stp_insertarCategoria",[nombre_categoria,descrip,estado])

# Reparar el metodo para modificar la categoria
def modificar_categoria(request):
    """
        Se actualizan los campos de la categoría.
    """
    idcate = request.args.get("id-categoria")
    nombreCate = request.form['nombre']
    descrip = request.form['descripcion']
    estado = request.form['estado']
    conex = Mysql()
    conex.Execute_Procedure("stp_modificarCategoria",[idcate,nombreCate,descrip,estado])
    guardar_foto(request)
    
def mostrar_categorias():
    """
        Se extraen las categorías registradas en la BD.
    """
    cate = 'categorias'
    conex = Mysql()
    resulset  = conex.call_store_procedure_return("stp_mostrarRegistros", [cate])
    for categoria in resulset:
       verificar_foto(categoria[4], categoria[0])
    return resulset

#cambio el estado de las categorias
def cambiar_estado(idcate):
    """
        Se cambia el estado de una categoría exclusivamente por su ID.
    """
    conex = Mysql()
    conex.Execute_Procedure("stp_cambiarEstadoCategoria",[idcate]) 

def mostrar_categoria(idcate): 
    """
        Se extrae una categoría exclusivamente por su ID.
    """  
    conex = Mysql()
    rs = conex.call_store_procedure_return("stp_mostrarCategoria",[idcate])
    return rs

def guardar_foto(request):
    """
        Por medio del objeto request, se extrae la foto y el id de la categoría.
    """
    foto = request.files['imagen']
    #Realiza el proceso si la imagen recibida es diferente a Nulo
    if (foto != None):
        idcategoria = request.args.get('idcategoria')
        nombre_foto = foto.filename
        if (nombre_foto != ''):
            print('----------------------> Imagen extraída: '+ nombre_foto)
            foto_codificada = codificar_imagen(foto)
            mysql = Mysql()
            mysql.Execute_Procedure('stp_cambiar_foto_categoria',[idcategoria, foto_codificada, nombre_foto])               

def codificar_imagen(image):
    """
        Se obtiene el objeto imagen que devuelve el método
        request.files['imagen'] - de Flask.
    """
    lectura_imagen = image.read()
    foto_64 = base64.encodestring(lectura_imagen)
    return foto_64


def verificar_foto(nombre_foto, id_categoria):
    """
        - Se obtiene la foto si está en el disco duro, 
        caso contrario obtiene el codificado BASE64 y la decodifica
        para escribirla en el disco duro.
    """
    # Obtenemos la ruta de la foto
    if (nombre_foto != None and nombre_foto != ''):
        ruta = '/home/dreads/Documentos/proyectos/software_restaurante/app_rest_blueprints/aplicacion/static/img/categorias/' + nombre_foto
        
        if (path.exists(ruta)):
            print("----------------> Ya existe el archivo")
        else:
            print("----------------> No existe el archivo, entonces se extrae de la BD y se escribe nuevamente en el disco duro.")
            foto_archivo = open(ruta, 'wb')
            mysql = Mysql()
            
            # Obtenemos la foto codificada en Base64
            foto = mysql.call_store_procedure_return('stp_obtener_foto_categoria',[id_categoria])
            # Decodificamos la foto y la escribimos
            foto_decodificada = base64.decodestring(foto[0][0])
            foto_archivo.write(foto_decodificada)
            foto_archivo.close()
