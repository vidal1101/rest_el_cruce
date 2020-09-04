from flask import Blueprint

clientes = Blueprint('clientes',__name__, template_folder='templates')

from . import routes