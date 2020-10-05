from flask import request, redirect, render_template, json
from flask_login import login_required
from . import proformas, controller

@proformas.route('/proformas', methods=['GET', 'POST'])
@login_required
def mostrar_proformas(): 
    return render_template('Mesas-Proformas.html')


@proformas.route('/insertar-Proformas', methods=['GET', 'POST'])
@login_required
def insertar_proformas(): 
    print(' insertar datos de la proforma')
    valores = request.get_json()
    
    zonaConsumo = valores['consu']
    descripcion = valores['descr']
    print(descripcion)
    
    if(descripcion !=''):
        controller.insertarProformas(zonaConsumo,descripcion)
        response ={}
        return json.dumps(response)
    else:
        #response ={'status':404}
        return json.dumps(response)         
    


@proformas.route('/dibujar-proformas', methods=['GET', 'POST'])
@login_required
def dibujar_proformas(): 
    print('llamando a la ruta ...')
    proformas = controller.mostrarProformas()
    print(proformas)
    response ={}
    if (proformas):
        print('entrada de datos de la proformas')
        print(proformas)
        for i in proformas:
            response[str(i)]={'idFactura':i[0],'idcaja':i[1],
                                'idtrabajador':i[2],'zona':i[3], 'descrip':i[4],'estado':i[5] }
        return json.dumps(response) 
    else :
        print('no hay datos ... ')
        return json.dumps(response)
        

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

