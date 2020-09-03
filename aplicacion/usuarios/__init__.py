from flask import Blueprint

usuarios = Blueprint('usuarios',__name__, template_folder='templates')

from . import routes