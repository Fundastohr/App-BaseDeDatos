// File: Class_Taller.js

class Taller {
    /**
     * Constructor de la clase Taller
     * @param {string} nombre - Nombre del taller
     * @param {Date} fecha - Fecha del taller
     * @param {string} [lugar] - Lugar donde se realiza el taller (opcional)
     * @param {number} [id_taller] - ID del taller (generalmente asignado por la base de datos)
     */
    constructor(nombre, fecha, lugar, id_taller) {
        this.id_taller = id_taller; // Corresponde a ID_Taller en la BD
        this.nombre = nombre;       // Corresponde a Nombre en la BD
        this.fecha = fecha;         // Corresponde a fecha en la BD
        this.lugar = lugar;         // Corresponde a Lugar en la BD
    }

    // Métodos getters y setters

    getIdTaller() {
        return this.id_taller;
    }

    // No hay setIdTaller ya que usualmente es generado por la BD y es la PK.

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
     * @param {Date} fecha - Nueva fecha para el taller
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
}

export{Taller}

