from flask import render_template, request, redirect
from . import inicio

@inicio.route('/inicio', methods=['GET', 'POST'])
@inicio.route('/', methods=['GET', 'POST'])
def index():
    return render_template('Menu.html')