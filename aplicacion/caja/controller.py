
from aplicacion.Database import Mysql

#verifica el estado de la ultima caja creada , para ver si esta abierto o cerrada
def verifica_estado_caja():
    conexion = Mysql()
    estado = conexion.call_store_procedure_return("stp_verEstadoCajas", [])
    if estado[0][0]=='cajaAbierta':
        print('caja en estado abierta ')
        return True
    elif estado[0][0]=='cajaCerrada':
        print('caja en estado cerrrada  ')
        return False


#insertar nueva caja a usar 
def insertarNuevaCaja(usuario,montoDolar,fondoCaja):
    conexion = Mysql()
    conexion.execute_procedure("stp_abrirCaja", [12345,montoDolar,fondoCaja])
