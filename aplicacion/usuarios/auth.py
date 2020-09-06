
from flask import Blueprint, render_template, redirect, url_for, request, flash
from werkzeug.security import generate_password_hash, check_password_hash
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
    #remember = True if request.form.get('remember') else False

    user = Trabajador.query.filter_by(cedula = cedula).first()

    if user == None or not check_password_hash(user.contrasenia, password):
        flash('Please check your login details and try again.')
        return redirect(url_for('auth.login'))

    login_user(user, remember = False)

    return redirect(url_for('inicio.index'))

@auth.route('/signup')
def signup():
    return render_template('signup.html')

@auth.route('/signup', methods=['POST'])
def signup_post():
    cedula = request.form.get('cedula')
    name = request.form.get('name')
    password = request.form.get('password')
    puesto = request.form.get('puesto')

    user = Trabajador.query.filter_by(cedula = cedula).first()
    if user:
        flash('Email address already exists.')
        return redirect(url_for('auth.signup'))

    new_user = Trabajador(cedula=cedula, nombre=name, puesto= puesto, contrasenia=generate_password_hash(password, method='sha256'), estado = 'Activo')
    db.session.add(new_user)
    db.session.commit()

    return redirect(url_for('auth.login'))

@auth.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('auth.login'))