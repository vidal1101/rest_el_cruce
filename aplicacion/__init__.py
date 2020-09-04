from flask import Flask
from .categorias import categorias
from .inicio import inicio
from .contabilidad import contabilidad
from .usuarios import usuarios
from .proveedores import proveedores
from .clientes import clientes
from .productos import productos

def create_app():
    app = Flask(__name__)
    app.config.from_pyfile('config/configuration.cfg')
    app.register_blueprint(categorias)
    app.register_blueprint(inicio)
    app.register_blueprint(contabilidad)
    app.register_blueprint(usuarios)
    app.register_blueprint(proveedores)
    app.register_blueprint(clientes)
    app.register_blueprint(productos)
    return app