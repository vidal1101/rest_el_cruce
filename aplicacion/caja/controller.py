
from aplicacion.Database import Mysql

#verifica el estado de la ultima caja creada , para ver si esta abierto o cerrada
def verificaEstadoCaja():
    conexion = Mysql()
    estadoActual = conexion.call_store_procedure_return("stp_verEstadoCajas", [])
    print(estadoActual)
    aux = estadoActual[0]
    if aux[0]=='cajaAbierta':
        print('caja en estado abierta ')
        print(aux)
        return True
    elif aux[0]=='cajaCerrada':
        print('caja en estado cerrrada  ')
        print(aux)
        return False
        
# para mostrar los prodcutos en la proformas 
def mostrarProductosCaja():
    conexion = Mysql()
    productos = conexion.call_store_procedure_return("stp_mostrarProductosCaja", [])
    return productos

#insertar nueva caja a usar 
def insertarNuevaCaja(usuario,montoDolar,fondoCaja):
    conexion = Mysql()
    conexion.Execute_Procedure("stp_abrirCaja", [usuario,montoDolar,fondoCaja])
    
    
def muestraPrueba():
    conexion = Mysql()
    productos = conexion.call_store_procedure_return("stp_PruebaProductos", [])
    return productos    

    





