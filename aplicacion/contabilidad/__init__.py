from flask import Blueprint

contabilidad = Blueprint('contabilidad',__name__, template_folder='templates')

from . import routes