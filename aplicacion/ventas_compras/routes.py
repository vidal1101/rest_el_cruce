from flask import request, redirect, render_template, json
from flask_login import login_required
from . import proformas, controller

@proformas.route('/proformas', methods=['GET', 'POST'])
@login_required
def mostrar_proformas(): 
    return render_template('Mesas-Proformas.html')


@proformas.route('/obtener-productos', methods=['GET', 'POST'])
@login_required
def obtener_producto(): 
    productos = controller.extraer_productos_categoria()
    valores = request.get_json()
    print(valores)
    response ={}
    for i in productos:
        response[str(i[0])]={'idproducto':i[0],'categoria':i[1],
                             'nombre':i[2],'precio':i[3], 'stock':[4]}
    return json.dumps(response) 


@proformas.route('/administrar-proforma', methods=['GET', 'POST'])
@login_required
def administrar_proforma():
    productos = controller.mostrarProductosCaja()
    print(productos)
    return render_template('Proforma.html', productos= productos)


@proformas.route('/comprar', methods=['GET', 'POST'])
@login_required
def realizar_compra():
    return render_template('Compra-Proveedor.html')


@proformas.route('/factura', methods=['GET', 'POST'])
def mostrar_factura():
    return  render_template('factura.html')