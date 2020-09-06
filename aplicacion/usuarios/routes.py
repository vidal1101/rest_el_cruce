from flask import request, redirect, render_template
from flask_login import login_required
from . import usuarios, controller

@usuarios.route('/guardar-usuario', methods=['GET', 'POST'])
@login_required
def  guardar_usuario():
    if(request.method == 'POST'):
        try:
            btnvalor = request.form['btnG']
            print(btnvalor)        
            if(btnvalor == 'editar'):
                controller.modificar_usuario(request)
            elif(btnvalor == 'guardar'):
                controller.guardar_usuario(request)
        except Exception :  # falta perfecionar esa pagina de errores 
            error = 'Solicitud imcopleta, Faltan Datos '
            ruta  = '/usuarios'
            btn   = 'Volver a la lista de Usuarios'
            return render_template('Errores.html', erro = error, rut = ruta, btn = btn)
    return redirect('usuarios')


@usuarios.route('/usuarios', methods=['GET', 'POST'])
@login_required
def mostrar_usuarios():
    datos = controller.mostrar_usuarios()
    return render_template('Usuarios.html', values=datos)

 
@usuarios.route('/cambiar-estado-usuario', methods=['GET', 'POST'])
@login_required
def cambiar_estado():
    cedula = request.args.get('idusuario')
    controller.cambiar_estado(cedula)
    return redirect('usuarios')


@usuarios.route('/nuevo-usuario', methods=['GET', 'POST'])
@login_required
def nuevo_usuario():
    valores         = ['']
    textoformulario = 'Registrar usuario'
    btn_text        = 'Guardar Usuario'
    btn             = 'guardar'
    return render_template('RegUsuario.html',
            contact = valores, btn = btn, texto = textoformulario, btntext = btn_text)


@usuarios.route('/modificar-usuario', methods=['GET', 'POST'])
@login_required
def modificar_usuario(): 
    btn      = 'editar'
    btn_text = 'Guardar Edicion'
    textofor = 'Editando Usuario'
    cedula   = request.args.get('idusuario')
    valores  = controller.obtener_usuario(cedula)
    return render_template('RegUsuario.html', 
            contact = valores, btn = btn, texto = textofor, btntext = btn_text)
