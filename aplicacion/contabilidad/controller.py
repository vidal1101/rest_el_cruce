from aplicacion.Database import Mysql

def consultar_facturas(request):
    inicio = request.form['fecha-inicio']
    final = request.form['fecha-final']
    print("Fechas obtenidas: " + inicio + " -- " + final)

