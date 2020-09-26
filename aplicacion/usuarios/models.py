from flask_login import UserMixin
from aplicacion import db

class Trabajador(UserMixin, db.Model):
    #__tablename__ = 'Trabajador' # Asigna el nombre de la tabla de forma explícita.
    cedula = db.Column(db.Integer, primary_key=True)
    id = cedula
    nombre = db.Column(db.String(50))
    puesto = db.Column(db.String(45))
    contrasenia = db.Column(db.String)
    estado = db.Column(db.String(25))

    def set_nombre(self, nombre):
        self.nombre = nombre
