from flask import request, render_template, redirect , json
from flask_login import login_required
from . import caja, controller 


@caja.route('/guardarProforma', methods=['POST'])
def guardarProforma(): 
    data = request.get_json()
  
    for i in data:
        try:
            #print(i['idpro'],i['categoria'] ,i['nombre'],i['montoCliente'],i['canti'])
            nombre  = i['nombre']
            
            # print(nombre)
        except Exception as error:
            pass
        
    productos = controller.muestraPrueba()
    
    response ={}
    for i in productos:
        response[str(i[0])]={'idproducto':i[0],'categoria':i[1],
                             'nombre':i[2],'precio':i[3]}
    
    return json.dumps(response) 

 
@caja.route('/administrar-proforma', methods=['GET', 'POST'])
def administrar_proforma():
    productos = controller.mostrarProductosCaja()
    print(productos)
    return render_template('Proforma.html', productos= productos)

@caja.route('/nuevaCaja', methods=['GET', 'POST'])
def guardarNuevaCaja():
    if (request.method == 'POST'):
        usuario  = 4445
        montoDolar = request.form['ValorDolar']
        fondoCaja  = request.form['MontoTotalCaja']
        print(str(usuario),str(montoDolar),str(fondoCaja))
        controller.insertarNuevaCaja(usuario,montoDolar,fondoCaja)
        
        return render_template('Mesas-Proformas.html')
   
    #por si da algun error , que se quede en el mismo formulario    
    return render_template('AbrirCaja.html')


@caja.route('/cerrarcaja', methods=['GET', 'POST'])
def cerrarcaja(): 
    
    if controller.verificaEstadoCaja():
        print('verda , posee caja abierta')
        return render_template('CerrarCaja.html')
    else:
        print('falso')
        btnidCajaCerrada = 'cerrarCaja0'
        return render_template('Caja.html',btnidCajaCerrada=btnidCajaCerrada)
    
    return ''

@caja.route('/abrircaja', methods=['GET', 'POST'])
def abrircaja(): 
    
    if controller.verificaEstadoCaja():
        print('verdadero')
        btnIdAbrirCaja = 'accederCaja0'
        return render_template('Caja.html',btnIdCaja=btnIdAbrirCaja)   
    else:
        print('falso')
        return render_template('AbrirCaja.html')
    
    return render_template('AbrirCaja.html')


@caja.route('/caja', methods=['GET', 'POST'])
def caja(): 
    #id de los botones de caja , donde 1 es 1 es paso  , 0 no tiene acceso 
    btnIdAbrirCaja = 'acceder1'
    btnidCajaCerrada = 'cerrarCaja1'
    return render_template('Caja.html',btnIdCaja=btnIdAbrirCaja,btnidCajaCerrada=btnidCajaCerrada)




