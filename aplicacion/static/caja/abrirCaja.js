/*todas los funcionabilidades de la caja de calculos de suma de datos
*/
 function sumaColones() {
    try {
        //jalo los datos si se reporta cambios en los input
        let a = parseInt(document.getElementById("v20c").value) || 0, //20000
            b = parseInt(document.getElementById("v50000c").value) || 0, //50000
            c = parseInt(document.getElementById("v10000c").value) || 0, //10000
            d = parseInt(document.getElementById("v5000c").value) || 0, //5000
            e = parseInt(document.getElementById("v2c").value) || 0, //2000
            f = parseInt(document.getElementById("v1c").value) || 0, //1000
            g = parseInt(document.getElementById("v500c").value) || 0, //500
            h = parseInt(document.getElementById("v100c").value) || 0, //100
            i = parseInt(document.getElementById("v50c").value) || 0, //50
            j = parseInt(document.getElementById("v25c").value) || 0, //25
            k = parseInt(document.getElementById("v10c").value) || 0, //10
            l = parseInt(document.getElementById("v5c").value) || 0; //5

        let totalColones = a * 20000 + b * 50000 + c * 10000 + d * 5000 + e * 2000 + f * 1000 +
            g * 500 + h * 100 + i * 50 + j * 25 + k * 10 + l * 5;

        document.getElementById("sumaTotalColones").value = totalColones;
        //actualiza el valor el monto de la caja para reportar cambios en tiempos real 
        TotalCaja();
    } catch (e) {}
}

//suma los colones y dolres, para dar el monto de caja con el que se abre
function TotalCaja() {
    try {
        let a = parseInt(document.getElementById("TotalDolares").value) || 0,
            b = parseInt(document.getElementById("valorDolar").value) || 0,
            c = parseInt(document.getElementById("sumaTotalColones").value) || 0;


        let montoCajaTotal = c + (a * b);


        document.getElementById("montoTotalAbrirCaja").value = montoCajaTotal;
    } catch (e) {}
}

//suma todas las monedas de dolares 
function sumaDolares() {
    try {
        //jalo los datos si se reporta cambios en los input
        let a = parseInt(document.getElementById("v100d").value) || 0, //100
            b = parseInt(document.getElementById("v50d").value) || 0, //50
            c = parseInt(document.getElementById("v20d").value) || 0, //20
            d = parseInt(document.getElementById("v10d").value) || 0, //10
            e = parseInt(document.getElementById("v5d").value) || 0, //5
            f = parseInt(document.getElementById("v1d").value) || 0, //1
            g = parseInt(document.getElementById("v0.50d").value) || 0, //0.50
            h = parseInt(document.getElementById("v0.25d").value) || 0, //0.25
            i = parseInt(document.getElementById("v0.10d").value) || 0, //0.10
            j = parseInt(document.getElementById("v0.05d").value) || 0, //0.05
            k = parseInt(document.getElementById("v0.01d").value) || 0, //0.01
            valorDola = parseInt(document.getElementById("valorDolar").value) || 0; //0.01


        let totalDolaresSumados = a * 100 + b * 50 + c * 20 + d * 10 +
            e * 5 + f * 1 +
            g * 0.50 + h * 0.25 + i * 0.10 + j * 0.05 + k * 0.01;

        document.getElementById("TotalDolares").value = totalDolaresSumados;
        //actualiza el valor el monto de la caja para reportar cambios en tiempos real 
        TotalCaja();
    } catch (e) {}
}
