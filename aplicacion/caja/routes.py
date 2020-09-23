from flask import request, render_template, redirect , json
from flask_login import login_required, current_user
from . import caja, controller

@caja.route('/nuevaCaja', methods=['GET', 'POST'])
@login_required
def guardarNuevaCaja():
    if (request.method == 'POST'):
        usuario  = current_user.get_id()
        montoDolar = request.form['ValorDolar']
        fondoCaja  = request.form['MontoTotalCaja']
        print(str(usuario),str(montoDolar),str(fondoCaja))
        controller.insertarNuevaCaja(usuario,montoDolar,fondoCaja)
        return render_template('Mesas-Proformas.html')
    #por si da algun error , que se quede en el mismo formulario    
    return render_template('AbrirCaja.html')


@caja.route('/cerrar-caja', methods=['GET', 'POST'])
@login_required
def cerrarcaja(): 
    return render_template('CerrarCaja.html')
    

@caja.route('/abrir-caja', methods=['GET', 'POST'])
@login_required
def abrircaja():
    return render_template('AbrirCaja.html')


@caja.route('/caja', methods=['GET', 'POST'])
@login_required
def caja_principal(): 
    return render_template('Caja.html')


@caja.route('/verificar-caja', methods=['GET', 'POST'])
@login_required
def verificar_caja():
    """
        Ruta utilizada para AJAX
    """
    if controller.verifica_estado_caja():
        response = {'estado': True}
        return json.dumps(response) 
    else:
        response = {'estado': False}
        return json.dumps(response) 
