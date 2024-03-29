from flask import Flask
from flask_sqlalchemy import SQLAlchemy 
from flask_login import LoginManager 
from .categorias import categorias
from .inicio import inicio
from .contabilidad import contabilidad
from .usuarios import usuarios
from .proveedores import proveedores
from .clientes import clientes
from .productos import productos
from .ventas_compras import proformas
from .caja import caja

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)
    app.config.from_pyfile('config/configuration.cfg')

    db.init_app(app)
    login_manager = LoginManager()
    login_manager.login_view = 'auth.login'
    login_manager.init_app(app)

    from .usuarios.models import Trabajador
    @login_manager.user_loader
    def load_user(user_id):
        return Trabajador.query.get(int(user_id))

    from .usuarios.auth import auth as auth_blueprint
    app.register_blueprint(auth_blueprint)


    app.register_blueprint(categorias)
    app.register_blueprint(inicio)
    app.register_blueprint(contabilidad)
    app.register_blueprint(usuarios)
    app.register_blueprint(proveedores)
    app.register_blueprint(clientes)
    app.register_blueprint(productos)
    app.register_blueprint(proformas)
    app.register_blueprint(caja)
    return app