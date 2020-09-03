from flask import render_template, request, redirect
from . import categorias, controller

@categorias.route('/categorias', methods=['GET', 'POST'])
@categorias.route('/inventario', methods=['GET', 'POST'])
def mostrar_categorias():
    datos = controller.mostrar_categorias()
    return render_template('Inventario.html', valores=datos)

@categorias.route('/InsertCategorias', methods=['GET', 'POST'])
def guardar_categoria():
    try:
        btnvalor = request.form['btn']
        if(btnvalor=='guardar'): 
            controller.registrar_categoria(request)
        else:
            # Reparar el metodo para modificar la categoria
            controller.modificar_categoria(request)
    except Exception as error:  #falta perfecionar esa pagina de errores 
        error = 'Solicitud incompleta, Faltan Datos '
        ruta  = '/inventario'
        btn   = 'Volver a la lista De Categorias'
        print(error)
        #return render_template('Errores.html',erro=error,rut=ruta,btn=btn)
        redirect('inventario')
    return redirect('inventario')

@categorias.route('/cambiar-estado-categoria', methods=['GET', 'POST'])
def actualizar_estado():
    idcate = request.args.get("id")
    controller.cambiar_estado(idcate)
    return mostrar_categorias()

@categorias.route('/registrar-categoria', methods=['GET', 'POST'])
def formulario_registrar():
    valores=['']
    textoformulario='Registrar Categoria'
    btnText ='Guardar Nueva Categoria '
    btn='guardar'
    return render_template('RegCategoria.html',contact=valores, btn=btn,texto=textoformulario,btntext=btnText)

@categorias.route('/modificar-categoria', methods=['GET', 'POST'])
def formulario_modificar():
    idcate    = request.args.get("idcategoria")
    valores   = controller.mostrar_categoria(idcate)
    textoformulario = 'Modificar Categoria'
    btnText   ='Guardar Nueva Categoria'
    btn='modificar'
    return render_template('RegCategoria.html',contact=valores, btn=btn,texto=textoformulario,btntext=btnText)