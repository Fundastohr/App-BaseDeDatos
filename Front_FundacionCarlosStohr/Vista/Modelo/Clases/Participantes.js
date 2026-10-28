
class Participante {
  
  constructor(id_participante, nombre, cedula, fecha_nacimiento, correo, Ciudad, instagram,Estado,telefono) {
    this.id_participante = id_participante;
    this.nombre = nombre;
    this.cedula = cedula;
    this.fecha_nacimiento = fecha_nacimiento;
    this.correo = correo;
    this.ciudad = Ciudad;
    this.instagram = instagram;
    this.estado = Estado
    this.telefono=telefono
  }
    
};

export {Participante};