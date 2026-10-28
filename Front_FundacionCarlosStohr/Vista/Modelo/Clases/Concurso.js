
class Concurso {
    
    constructor(id_concurso, nombre, fecha, categoria, tema) {
      this.id_concurso = id_concurso;
      this.nombre = nombre;
      this.fecha = new Date(fecha); // Asegurándonos que sea un objeto Date
      this.Categoria = categoria;
      this.Tema = tema;
    }
  
    // Métodos getter para acceder a las propiedades (opcional pero recomendado)
    getIdConcurso() {
      return this.id_concurso;
    }
  
    getNombre() {
      return this.nombre;
    }
  
    getFecha() {
      return this.fecha;
    }
  
    getCategoria() {
      return this.Categoria;
    }
  
    getTema() {
      return this.Tema;
    }
  
    // Métodos setter para modificar las propiedades (opcional)
    setId(id){
      this.id=id;
    }

    setNombre(nombre) {
      this.nombre = nombre;
    }
  
    setFecha(fecha) {
      this.fecha = new Date(fecha);
    }
  
    setCategoria(categoria) {
      this.Categoria = categoria;
    }
  
    setTema(tema) {
      this.Tema = tema;
    }
  }

  export{Concurso}