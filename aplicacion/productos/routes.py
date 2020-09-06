from flask import request, redirect, render_template
from flask_login import login_required
from . import productos, controller
from aplicacion.categorias import controller as controlador_categoria

@productos.route('/productos', methods=['GET', 'POST'])
@login_required
def mostrar_productos():
    idcate = request.args.get("idcategoria")
    datos  = controller.mostrar_productos(idcate)
    return render_template('Productos.html', datos = datos)


#a registrar productos de una categoria especifica 
@productos.route('/registrar-producto', methods=['GET', 'POST'])
@login_required
def registrar_producto(): 
    textoformulario = 'Registrar Producto'
    btn_text        = 'Guardar Producto'
    btn             = "guardar"
    producto        = ['']
    datos           = controlador_categoria.mostrar_categorias()
    return render_template('RegProducto.html',
            categorias = datos, contact = producto, btn = btn, texto = textoformulario, btntext = btn_text)


@productos.route('/cambiar-estado-producto', methods=['GET', 'POST'])
@login_required
def cambiar_estado():
    controller.cambiar_estado(request)
    return redirect("inventario")


@productos.route('/modificar-producto', methods=['GET', 'POST'])
@login_required
def modificar_producto():
    idprod          = request.args.get("idproducto")
    datos           = controlador_categoria.mostrar_categorias()
    producto        = controller.obtener_producto(idprod)
    textoformulario = 'Modificar Producto'
    btn_text        = 'Guardar Producto'
    btn             = 'editar'
    return render_template('RegProducto.html', categorias = datos, btn = btn, 
        texto = textoformulario, btntext = btn_text, contact = producto)


@productos.route('/guardar-producto', methods=['GET', 'POST'])
@login_required
def guardar_producto():
    try:
        btnvalor  = request.form['btn']
        if(btnvalor=='guardar'):
            controller.guardar_producto(request)
            return redirect("inventario")
        elif(btnvalor=='editar'):
            controller.modificar_producto(request)
            return redirect("inventario")
    except Exception as error:  #falta perfecionar esa pagina de errores 
        ruta  = '/inventario'
        btn   = 'Volver a la lista De Categorias'
        #return render_template('Errores.html', erro = error, rut = ruta, btn = btn)
        return redirect('inventario')
    return redirect('inventario')


@productos.route('/productos-completos', methods=['GET', 'POST'])
@login_required
def todos_productos():
    title = 'Todos los Productos'
    return render_template('Productos.html',titulo=title)
