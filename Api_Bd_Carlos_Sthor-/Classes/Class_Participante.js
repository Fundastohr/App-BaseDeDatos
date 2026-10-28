
class Class_Participante {

  constructor(id_participante, nombre, cedula, fecha_nacimiento, correo, ciudad, instagram,estado,telefono) {
    this.id_participante = id_participante;
    this.nombre = nombre;
    this.cedula = cedula;
    this.fecha_nacimiento = new Date(fecha_nacimiento);
    this.correo = correo;
    this.ciudad = ciudad;
    this.instagram = instagram;
    this.estado = estado
    this.telefono=telefono
  }

  getIdParticipante() { return this.id_participante; }
  getNombre() { return this.nombre; }
  getCedula() { return this.cedula; }
  getFechaNacimiento() { return this.fecha_nacimiento; }
  getCorreo() { return this.correo; }
  getciudad() { return this.ciudad; }
  getInstagram() { return this.instagram; }

  setNombre(nombre) { this.nombre = nombre; }
  setCedula(cedula) { this.cedula = cedula; }
  setFechaNacimiento(fecha_nacimiento) { this.fecha_nacimiento = new Date(fecha_nacimiento); }
  setCorreo(correo) { this.correo = correo; }
  setciudad(ciudad) { this.ciudad = ciudad; }
  setInstagram(instagram) { this.instagram = instagram; }
}

module.exports = Class_Participante;