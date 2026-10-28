class Class_Obra {
  /**
   * @param {number} id_obra
   * @param {string} nombre
   * @param {string} imagen
   * @param {string|Date} fecha
   * @param {string} ubicacion
   */
  constructor(id_obra, numero_obra, titulo, tecnica, ancho, alto, anio, tema, estilo, ubicacion, observacion, created_at_, updated_at) {
      this.id_obra = id_obra
      this.numero_obra = numero_obra
      this.titulo = titulo
      this.tecnica = tecnica
      this.ancho = ancho
      this.alto = alto
      this.anio = anio
      this.tema = tema
      this.estilo = estilo
      this.ubicacion = ubicacion
      this.observacion = observacion
      this.created_at_ = created_at_
      this.updated_at = updated_at
  }

  getIdObra() { return this.id_obra; }
  getNombre() { return this.nombre; }
  getImagen() { return this.imagen; }
  getFecha() { return this.fecha; }
  getUbicacion() { return this.ubicacion; }

  setNombre(nombre) { this.nombre = nombre; }
  setImagen(imagen) { this.imagen = imagen; }
  setFecha(fecha) { this.fecha = fecha; }
  setUbicacion(ubicacion) { this.ubicacion = ubicacion; }
}

module.exports = Class_Obra;


