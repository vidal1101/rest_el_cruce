
from flask import Blueprint, render_template, redirect, url_for, request, flash
from werkzeug.security import check_password_hash
from flask_login import login_user, logout_user, login_required
from .models import Trabajador
from aplicacion import db

auth = Blueprint('auth', __name__)

@auth.route('/login')
def login():
    return render_template('Login.html')

@auth.route('/login', methods=['POST'])
def login_post():
    cedula = request.form.get('cedula')
    password = request.form.get('contrasena')
    user = Trabajador.query.filter_by(cedula = cedula).first()

    if user == None or not check_password_hash(user.contrasenia, password):
        flash('Por favor verifica tus credenciales...')
        return redirect('login')

    login_user(user, remember = False)
    return redirect(url_for('inicio.index'))


@auth.route('/cerrar-sesion')
@login_required
def logout():
    logout_user()
    return redirect(url_for('auth.login'))