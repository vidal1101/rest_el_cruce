from flask import render_template, request, redirect
from . import contabilidad
from . import controller

@contabilidad.route('/conta', methods=['GET', 'POST'])
@contabilidad.route('/contabilidad', methods=['GET', 'POST'])
def index():
    if (request.method == 'POST'):
        controller.consultar_facturas(request)
    return render_template('Contabilidad.html')