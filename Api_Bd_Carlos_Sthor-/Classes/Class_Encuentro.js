// File: Class_Encuentro.js

class Class_Encuentro {
    /**
     * Constructor de la clase Encuentro
     * @param {string} nombre - Nombre del encuentro
     * @param {Date} fecha - Fecha del encuentro
     * @param {string} [lugar] - Lugar donde se realiza (opcional)
     * @param {number} [id_encuentro] - ID del encuentro (generado por la BD)
     */
    constructor(nombre, fecha, lugar, id_encuentro) {
        this.id_encuentro = id_encuentro;
        this.nombre = nombre;
        this.fecha = fecha;
        this.lugar = lugar;
    }

    getIdEncuentro() { return this.id_encuentro; }
    getNombre() { return this.nombre; }
    setNombre(nombre) { this.nombre = nombre; }
    getFecha() { return this.fecha; }
    setFecha(fecha) { this.fecha = fecha; }
    getLugar() { return this.lugar; }
    setLugar(lugar) { this.lugar = lugar; }
}

module.exports = Class_Encuentro;
