from flask import request, render_template, redirect
from flask_login import login_required
from . import clientes, controller

@clientes.route('/clientes', methods=['GET', 'POST'])
@login_required
def mostrar_clientes():
    datos = controller.mostrar_clientes()
    return render_template('Clientes.html', values=datos)


@clientes.route('/registrar-cliente', methods=['GET', 'POST'])
@login_required
def registrar_cliente():
    datos         = ['']
    btn           = 'Nuevo'
    btn_text      = 'Guardar'
    textofor      = 'Registrar Cliente'
    return render_template('RegCliente.html',
            contact = datos, btn = btn, texto = textofor, btntext = btn_text)


@clientes.route('/modificar-cliente', methods=['GET', 'POST'])
@login_required
def modificar_cliente(): 
    btn       = 'editar'
    btn_text  = 'Guardar Cliente'
    textofor  = 'Modificar Cliente'
    cedula    = request.args.get('idcliente')
    datos     = controller.obtener_cliente(cedula)
    return render_template('RegCliente.html',
            contact = datos, btn = btn, texto = textofor, btntext = btn_text)


@clientes.route('/guardar-cliente', methods=['GET', 'POST'])
@login_required
def guardar_cliente():
    btnvalor = request.form['btnCliente']
    if(btnvalor == 'editar'):
        controller.modificar_cliente(request)
    elif(btnvalor == 'Nuevo'): 
        controller.guardar_cliente(request)
    return redirect('clientes')


@clientes.route('/cambiar-estado-cliente', methods=['GET', 'POST'])
@login_required
def cambiar_estado():
    idcliente = request.args.get('idcliente')
    controller.modificar_estado(idcliente)
    return redirect('clientes')
