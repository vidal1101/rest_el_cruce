from flask import request, redirect, render_template
from . import proveedores, controller

@proveedores.route('/proveedores', methods=['GET', 'POST'])
def mostrar_proveedores(): 
    proveedores = controller.mostrar_proveedores()
    return render_template('Proveedores.html', values=proveedores)


@proveedores.route('/guardar-proveedor', methods=['GET', 'POST'])
def guardar_proveedor():
    try:
        btnvalor = request.form['btnpro']
        if(btnvalor == 'Nuevo'):
            controller.guardar_proveedor(request)
        elif(btnvalor=='editar'):
            controller.modificar_proveedor(request)
    except Exception :  #falta perfecionar esa pagina de errores 
        error  = 'Solicitud imcopleta, Faltan Datos '
        ruta   = 'proveedores'
        btn    = 'Volver a la lista de Proveedores '
        return render_template('Errores.html',erro=error,rut=ruta,btn=btn)
    return redirect('proveedores')


@proveedores.route('/cambiar-estado-proveedor', methods=['GET', 'POST'])
def cambiar_estado():
    cedula  = request.args.get('idproveedor')
    controller.cambiar_estado(cedula)
    return redirect('proveedores')


@proveedores.route('/modificar-proveedor', methods=['GET','POST'])
def modificar_proveedor():
    idproveedor = request.args.get('idproveedor')
    proveedor   = controller.obtener_proveedor(idproveedor)
    btn         = 'editar'
    btn_text    = 'Guardar Proveedor'
    textofor    = 'Modificar Proveedor'
    return render_template('RegProveedor.html',
            pro = proveedor, btn = btn, texto = textofor, btntext = btn_text)


@proveedores.route('/registrar-proveedor', methods=['GET', 'POST'])
def registrar_proveedor(): 
    btn        = 'Nuevo'
    btn_text   = 'Guardar Proveedor '
    textofor   = 'Registrar Proveedor'
    proveedor  = ['']
    return render_template('RegProveedor.html',
            pro = proveedor, btn = btn, texto = textofor, btntext = btn_text)
