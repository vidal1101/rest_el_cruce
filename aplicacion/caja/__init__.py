from flask import Blueprint

caja = Blueprint('caja',__name__, template_folder='templates')

from . import routes