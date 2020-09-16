//variables 
const btnagregar = document.getElementById('#btnAgregarP');
const formulario = document.getElementById('#formulario');
let arrays = [];

const crearitems = (idpro) => {
    let item = {
        idpro: idpro,
        estado: false
    }
    arrays.push(item);
}

formulario.addEventListener('submit', (e) => {
    e.preventDefault();
    var idproducto = parseInt(document.getElementById('#colunma0').value);

    crearitems(idproducto);
    guardarLS();
});


const guardarLS = () => {
    localStorage.setItem('productosAgregados', JSON.stringify(arrays));
}