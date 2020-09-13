from flask import request, redirect, render_template
from flask_login import login_required
from . import proformas

@proformas.route('/proformas', methods=['GET', 'POST'])
#@login_required
def mostrar_proformas(): 
    return render_template('Mesas-Proformas.html')


@proformas.route('/administrar-proforma', methods=['GET', 'POST'])
#@login_required
def administrar_proforma():
    return render_template('Proforma.html')


@proformas.route('/comprar', methods=['GET', 'POST'])
#@login_required
def realizar_compra():
    return render_template('Compra-Proveedor.html')