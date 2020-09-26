from aplicacion.Database import Mysql
from .models import Trabajador
from werkzeug.security import generate_password_hash, check_password_hash
from aplicacion import db

def guardar_usuario(request):
    """
        Recibe los datos del usuario a registrar.
    """
    if (request.method == "POST"):
        cedula  = request.form['cedula']
        nombre  = request.form['nombre']
        contra  = request.form['contra1']
        contra2 = request.form['contra2']
        puesto  = request.form['puesto']
        estado  = request.form['estado']
        if contra == contra2 and contra != '':
            usuario = Trabajador.query.filter_by(cedula = cedula).first()
            db.session.commit()
            if (usuario):
                return 'cédula ya registrada'
            else:
                nuevo_usuario = Trabajador(cedula=cedula, nombre=nombre, puesto = puesto, 
                    contrasenia=generate_password_hash(contra), estado = estado)
                db.session.add(nuevo_usuario)
                db.session.commit()
                return True
        else:
            return 'contraseñas no coinciden'


def modificar_usuario(request):
    """
        Recibe los datos del usuario a modificar.
        - A pesar de recibir la cédula, esta no se modifica.
    """
    if (request.method == "POST"):
        cedula  = request.form['cedula']
        nombre  = request.form['nombre']
        contra  = request.form['contra1']
        contra2 = request.form['contra2']
        puesto  = request.form['puesto']
        estado  = request.form['estado']
        if contra == contra2 and contra != '':
            usuario = Trabajador.query.filter_by(cedula = cedula).first()
            db.session.commit()
            if (usuario):
                usuario.nombre = nombre
                usuario.contrasenia = generate_password_hash(contra)
                usuario.puesto = puesto
                usuario.estado = estado
                db.session.commit()
                return 'Usuario actualizado'
            else:
                return False
        else:
            return 'contraseñas no coinciden'


def cambiar_estado(cedula):
    """
        Cambia el estado de un usuario con la cédula enviada.
    """
    db.session.execute("CALL stp_cambiarEstadoTrabajador(:cedula)", {'cedula':cedula})
    db.session.commit()
         
 
def obtener_usuario(cedula):
    """
        Se recibe la cédula de un usuario, para identificarlo y retornar sus datos obtenidos desde la BD.
        - La cédula es de tipo int.
    """  
    if cedula != None and cedula != '' and cedula != 0:
        conexion  = Mysql()
        datos     = conexion.call_store_procedure_return("stp_mostrarTrabajador", [cedula])
        conexion._close()
        return datos
    return None


def mostrar_usuarios():
    """
        Obtiene y retorna todos los usuarios registrados en la BD.
    """
    conexion   = Mysql()
    trabajador = 'usuarios'
    datos      = conexion.call_store_procedure_return("stp_mostrarRegistros", [trabajador])
    conexion._close()
    return datos
