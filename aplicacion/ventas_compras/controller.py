#controller ventas_compras
from aplicacion.Database import Mysql

def mostrarProductosCaja():
    conexion = Mysql()
    productos = conexion.call_store_procedure_return("stp_mostrarProductosCaja", [])
    return productos


def extraer_productos_categoria():
    conexion = Mysql()
    productos = conexion.call_store_procedure_return("stp_mostrarProductos_x_categoria_caja", [2])
    return productos   


def generar_pdf():
    # https://ricardogeek.com/como-crear-documentos-pdf-usando-python/
    # https://www.reportlab.com/docs/reportlab-userguide.pdf
    # https://www.tamanosdepapel.com/c-sobre-tamanos.htm
    from reportlab.lib.pagesizes import C8
    from reportlab.pdfgen import canvas

    canvas = canvas.Canvas("impresion.pdf", pagesize=C8)
    canvas.setLineWidth(.3)
    canvas.setFont('Helvetica', 12)

    canvas.drawString(30,750,'Restaurante el Cruce')
    canvas.drawString(45,740,"27/10/2016")
    canvas.line(36,737,110,737)
    canvas.save()
    print('PDF creado!')

    # ***************** Diferentes figuras que se pueden realizar
    #canvas.grid(xlist, ylist)
    #canvas.bezier(x1, y1, x2, y2, x3, y3, x4, y4)
    #canvas.arc(x1,y1,x2,y2)
    #canvas.rect(x, y, width, height, stroke=1, fill=0)
    #canvas.ellipse(x1,y1, x2,y2, stroke=1, fill=0)
    #canvas.wedge(x1,y1, x2,y2, startAng, extent, stroke=1, fill=0)
    #canvas.circle(x_cen, y_cen, r, stroke=1, fill=0)
    #canvas.roundRect(x, y, width, height, radius, stroke=1, fill=0) 

generar_pdf()