from flask import Blueprint

proformas = Blueprint('proformas',__name__, template_folder='templates')

from . import routes