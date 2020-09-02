from flask import render_template, request, redirect
from . import contabilidad

@contabilidad.route('/conta', methods=['GET', 'POST'])
@contabilidad.route('/contabilidad', methods=['GET', 'POST'])
def index():
    return render_template('Contabilidad.html')