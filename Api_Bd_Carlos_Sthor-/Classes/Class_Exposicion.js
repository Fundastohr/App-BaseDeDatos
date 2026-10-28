
class Class_Exposicion {
    /**
     * Constructor de la clase Exposicion
     * @param {string} nombre - Nombre de la exposición
     * @param {Date} fecha - Fecha de la exposición
     * @param {string} lugar - Lugar donde se realiza la exposición
     * @param {string} tipo - Tipo de exposición
     * @param {string} tema 
     * 
     */
    constructor(nombre, fecha, lugar , tipo,id_expo,tema ) {
        this.nombre = nombre;
        this.fecha = fecha;
        this.lugar = lugar;
        this.tipo = tipo;
        this.id = id_expo;
        this.tema= tema;
    }

    // Métodos getters y setters

    getIdExpo() {
        return this.id_expo;
    }

    getNombre() {
        return this.nombre;
    }

    setNombre(nombre) {
        this.nombre = nombre;
    }

    getFecha() {
        return this.fecha;
    }

    /**
     * @param {Date} fecha - Nueva fecha para la exposición
     */
    setFecha(fecha) {
        this.fecha = fecha;
    }

    getLugar() {
        return this.lugar;
    }

    setLugar(lugar) {
        this.lugar = lugar;
    }

    getTipo() {
        return this.tipo;
    }

    setTipo(tipo) {
        this.tipo = tipo;
    }

}    

module.exports = Class_Exposicion;