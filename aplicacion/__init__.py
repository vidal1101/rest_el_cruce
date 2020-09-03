from flask import Flask
from .categorias import categorias
from .inicio import inicio
from .contabilidad import contabilidad
from .usuarios import usuarios

def create_app():
    app = Flask(__name__)
    app.config.from_pyfile('config/configuration.cfg')
    app.register_blueprint(categorias)
    app.register_blueprint(inicio)
    app.register_blueprint(contabilidad)
    app.register_blueprint(usuarios)
    return app