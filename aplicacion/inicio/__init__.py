from flask import Blueprint

inicio = Blueprint('inicio',__name__, template_folder='templates')

from . import routes