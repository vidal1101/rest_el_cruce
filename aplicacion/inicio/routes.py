from flask import render_template
from flask_login import login_required
from . import inicio

@inicio.route('/inicio', methods=['GET', 'POST'])
@inicio.route('/', methods=['GET', 'POST'])
@login_required
def index():
    return render_template('Menu.html')