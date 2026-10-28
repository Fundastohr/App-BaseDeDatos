import { Concurso } from "../Clases/Concurso.js";
import { Participante } from "../Clases/Participantes.js";
import { Notifications } from "../Utils/Notifications.js";

class Request_Concursos {
  /* Logica para consultar concurso*/

  async Get_Concursos() {
    try {
      const response = await fetch(
        "http://localhost:3002/Concurso/Getconcursos"
      ); // Ajusta la URL del endpoint

      if (!response.ok) {
        throw new Error(
          `Error en la petición: ${response.status} - ${response.statusText}`
        );
      }

      const data = await response.json();

      // Mapea cada objeto JSON a una instancia de la clase Concurso
      this.listaConcursos = data.map((concursoData) => {
        return new Concurso( // Asegúrate de que 'Concurso' esté definido correctamente en tu frontend
          concursoData.id_concurso,
          concursoData.nombre,
          concursoData.fecha,
          concursoData.Categoria,
          concursoData.Tema
        );
      });

      console.log(
        "Lista de concursos (objetos Concurso):",
        this.listaConcursos
      );
      this.llenarTablaConcursos(this.listaConcursos);

      return this.listaConcursos; // Devuelve la lista de objetos Concurso
    } catch (error) {
      console.error("Error al obtener los concursos:", error);
      throw error;
    }
  }

  async cargarConcursos() {
    try {
      await this.Get_Concursos();
    } catch (error) {
      console.error("Error en cargarConcursos:", error);
      // Notificar al usuario si hay un error al cargar concursos
      Notifications.error(
        "Error al cargar los concursos. Por favor, intente nuevamente."
      );
      return []; // O algún otro valor por defecto en caso de error
    }
  }

  llenarTablaConcursos(listaDeConcursos) {
    const tablaBody = document.querySelector("#tablaConcursos tbody"); // Selecciona el tbody correcto

    if (listaDeConcursos && listaDeConcursos.length > 0) {
      tablaBody.innerHTML = ""; // Limpia la tabla

      if (document.body.id === "BodyConsultarConcurso") {
        // Agrupar concursos por nombre y fecha
        const concursosAgrupados = new Map();
        listaDeConcursos.forEach((concurso) => {
          const key = `${concurso.nombre}_${concurso.fecha}`;
          if (!concursosAgrupados.has(key)) {
            concursosAgrupados.set(key, {
              nombre: concurso.nombre,
              fecha: concurso.fecha,
              Tema: concurso.Tema,
              categorias: []
            });
          }
          concursosAgrupados.get(key).categorias.push({
            nombreCat: concurso.Categoria || "General",
            id: concurso.id_concurso
          });
        });

        concursosAgrupados.forEach((grupo, key) => {
          const row = tablaBody.insertRow();
          row.dataset.categorias = JSON.stringify(grupo.categorias);
          row.style.cursor = "pointer";
          row.title = "Haz clic para ver los participantes";

          const nombreCell = row.insertCell();
          nombreCell.textContent = grupo.nombre;

          const fechaCell = row.insertCell();
          fechaCell.textContent = this.formatearFecha(grupo.fecha);

          const categoriaCell = row.insertCell();
          categoriaCell.innerHTML = grupo.categorias.map(cat => `<span class="badge bg-secondary me-1">${cat.nombreCat}</span>`).join('');

          const temaCell = row.insertCell();
          temaCell.textContent = grupo.Tema || "N/A";
        });
      } else {
        listaDeConcursos.forEach((concurso) => {
          const row = tablaBody.insertRow();
          row.dataset.concursoId = concurso.id_concurso;
          row.style.cursor = "pointer";

          const nombreCell = row.insertCell();
          nombreCell.textContent = concurso.nombre;

          const fechaCell = row.insertCell();
          fechaCell.textContent = this.formatearFecha(concurso.fecha);

          const categoriaCell = row.insertCell();
          categoriaCell.textContent = concurso.Categoria || "N/A";

          const temaCell = row.insertCell();
          temaCell.textContent = concurso.Tema || "N/A";
        });
      }
      
      // Reinicializar el ordenador de tablas después de cargar datos
      if (typeof window.reinitTableSorter === 'function') {
        setTimeout(() => window.reinitTableSorter(), 100);
      }
    } else if (tablaBody) {
      tablaBody.innerHTML =
        '<tr><td colspan="4">No hay concursos disponibles.</td></tr>';
      // Notificar al usuario que no hay datos (solo en página de consulta)
      if (document.body.id === "BodyConsultarConcurso") {
        Notifications.info("No hay concursos registrados en el sistema.");
      }
    }
  }

  /* Logica paraInsertar concurso */

  async InsertarConcurso(Concurso) {
    await fetch("http://localhost:3002/Concurso/InsertConcurso", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        nombre: Concurso.nombre,
        categoria: Concurso.Categoria,
        tema: Concurso.Tema,
        fecha: Concurso.fecha,
      }),
    })
      .then((response) => response.json())
      .then((data) => {
        Notifications.success("Concurso insertado con éxito");
      })
      .catch((error) => {
        Notifications.error("Error al insertar el concurso: " + error.message);
      });
  }

  formatearFecha(fecha) {
    if (!fecha) return "";
    const str = String(fecha).split("T")[0].trim();
    if (str.startsWith("1000") || str.startsWith("1899") || str.startsWith("1900")) return "No especificada";
    const parts = str.split("-");
    if (parts.length === 3 && parts[0].length === 4) {
      const [year, month, day] = parts;
      if (parseInt(year, 10) <= 1000) return "No especificada";
      return `${day.padStart(2, "0")}/${month.padStart(2, "0")}/${year}`;
    }
    const date = new Date(fecha);
    if (isNaN(date.getTime()) || date.getFullYear() <= 1000) return "";
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");
    return `${day}/${month}/${year}`;
  }

  GetInfoFormularios() {
    let Con = new Concurso(
      "",
      document.getElementById("nombreConcurso").value,
      document.getElementById("fechaConcurso").value,
      document.getElementById("CategoriaConcurso").value,
      document.getElementById("TemaConcurso").value
    );
    return Con;
  }

  /* Logica para modificar concurso y eliminar  */

  ObtenerDatosTabla(event) {
    const clickedElement = event.target;

    if (clickedElement.tagName === "TD") {
      const row = clickedElement.parentNode;
      const cells = row.querySelectorAll("td");
      const concursoId = row.dataset.concursoId; // Obtenemos el ID del atributo data-*

      if (cells.length === 4) {
        // Aseguramos que la fila tenga 4 celdas (Nombre, Fecha, Categoria, Tema)

        const nombre = cells[0].textContent;
        const fechaTexto = cells[1].textContent;

        const partesFecha = fechaTexto.split("/");
        // new Date(year, monthIndex, day) - monthIndex is 0-based (0 for January, 11 for December)
        const fechaObjeto = new Date(
          parseInt(partesFecha[2]), // Año
          parseInt(partesFecha[0]) - 1, // Mes (restamos 1 porque es 0-based)
          parseInt(partesFecha[1]) // Día
        );

        const categoria = cells[2].textContent;
        const tema = cells[3].textContent;

        const concursoSeleccionado = new Concurso(
          concursoId,
          nombre,
          fechaObjeto,
          categoria,
          tema
        );
        this.guardarValorEnCookie("CodigoConcurso", concursoId);
        this.llenarFormularioConcurso(concursoSeleccionado);
      } else {
        console.warn(
          "La fila clickeada no tiene el número esperado de celdas."
        );
      }
    }
  }

  llenarFormularioConcurso(concurso) {
    const nombreConcursoInput = document.getElementById("nombreConcurso"); // ¡Ojo al ID!
    const fechaConcursoInput = document.getElementById("fechaConcurso");
    const temaConcursoInput = document.getElementById("TemaConcurso");
    const categoriaConcursoSelect =
      document.getElementById("CategoriaConcurso");
    const inputAgregarParticipanteConcursoNombreConcurso =
      document.getElementById("nombreConcursoParticipante");
    console.log(concurso);

    if (concurso) {
      nombreConcursoInput.value = concurso.nombre || "";
      fechaConcursoInput.value =
        this.formatearFechaParaFormatoYYYYmmdd(concurso.fecha) || ""; // Formatear la fecha para el input type="date"
      temaConcursoInput.value = concurso.Tema || "";
      categoriaConcursoSelect.value = concurso.Categoria;
      inputAgregarParticipanteConcursoNombreConcurso.value = concurso.nombre;
    } else {
      console.warn(
        "Se intentó llenar el formulario con un objeto concurso vacío."
      );
      // Aquí podrías limpiar el formulario si es necesario
      formularioModificarConcurso.reset();
    }
  }

  formatearFechaParaFormatoYYYYmmdd(fecha) {
    if (fecha) {
      const date = new Date(fecha);
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, "0");
      const day = String(date.getDate()).padStart(2, "0");
      return `${year}-${month}-${day}`;
    }
    return "";
  }

  /* Logica para las cookies */

  guardarValorEnCookie(nombreCookie, valor) {
    const fechaExpiracion = new Date();
    fechaExpiracion.setDate(fechaExpiracion.getDate() + 30); // La cookie expirará en 30 días (ajusta si es necesario)
    const expires = "expires=" + fechaExpiracion.toUTCString();
    const path = "path=/"; // La cookie es válida para toda la ruta del sitio

    document.cookie = `${nombreCookie}=${valor};${expires};${path}`;
    console.log(`Valor "${valor}" guardado en la cookie "${nombreCookie}".`);
  }

  getCookie(nombre) {
    const nombreEQ = nombre + "=";
    const cookies = document.cookie.split(";");
    for (let i = 0; i < cookies.length; i++) {
      let cookie = cookies[i];
      while (cookie.charAt(0) === " ") {
        cookie = cookie.substring(1);
      }
      if (cookie.indexOf(nombreEQ) === 0) {
        return cookie.substring(nombreEQ.length, cookie.length);
      }
    }
    return null; // Si no existe la cookie
  }

  async ModificarConcurso(Concurso) {
    const codigoConcurso = this.getCookie("CodigoConcurso");
    console.log(Concurso);

    if (!codigoConcurso) {
      Notifications.error(
        "No se encontró el código del concurso en la cookie."
      );
      return;
    }

    await fetch(
      `http://localhost:3002/Concurso/ModificarConcurso/${codigoConcurso}`,
      {
        method: "PUT", // Usamos PUT para la modificación
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          nombre: Concurso.nombre,
          categoria: Concurso.Categoria,
          tema: Concurso.Tema,
          fecha: Concurso.fecha,
          // Ya no necesitamos 'id' en el body si lo pasamos por la URL
        }),
      }
    )
      .then((response) => {
        if (!response.ok) {
          return response.json().then((err) => {
            throw new Error(
              `Error al modificar el concurso: ${response.status} - ${
                err.error || response.statusText
              }`
            );
          });
        }
        return response.json();
      })
      .then((data) => {
        Notifications.success("Concurso modificado con éxito");
        console.log("Respuesta del servidor:", data);
        this.cargarConcursos();
        // Aquí puedes realizar otras acciones después de la modificación exitosa
      })
      .catch((error) => {
        Notifications.error(`Error al modificar el concurso: ${error.message}`);
        console.error("Error al modificar el concurso:", error);
      });
  }

  async EliminarConcurso() {
    const codigoConcurso = this.getCookie("CodigoConcurso");

    if (!codigoConcurso) {
      Notifications.error(
        "No se encontró el código del concurso en la cookie para eliminar."
      );
      return;
    }

    await fetch(
      `http://localhost:3002/Concurso/EliminarConcurso/${codigoConcurso}`,
      {
        method: "DELETE", // Usamos DELETE para la eliminación
      }
    )
      .then((response) => {
        if (!response.ok) {
          return response.json().then((err) => {
            throw new Error(
              `Error al eliminar el concurso: ${response.status} - ${
                err.error || response.statusText
              }`
            );
          });
        }
        return response.json();
      })
      .then((data) => {
        Notifications.success("Concurso eliminado con éxito");
        console.log("Respuesta del servidor (eliminación):", data);
        this.cargarConcursos(); // Recarga la lista de concursos después de la eliminación
        // Aquí puedes realizar otras acciones después de la eliminación exitosa
      })
      .catch((error) => {
        Notifications.error(`Error al eliminar el concurso: ${error.message}`);
        console.error("Error al eliminar el concurso:", error);
      });
  }

  async obtenerParticipantesConcursoPorId(codigoConcurso) {
    try {
      const response = await fetch(
        `http://localhost:3002/Concurso/ParticipantesConcurso/${codigoConcurso}`
      );
      if (!response.ok) {
        throw new Error(
          `Error en la petición: ${response.status} - ${response.statusText}`
        );
      }
      const data = await response.json();
      return (data.personas || []).map((concursoData) => {
        return {
          id: concursoData.id,
          nombre: concursoData.nombre,
          cedula: concursoData.cedula,
          posicion: concursoData.posicion,
          mencion: concursoData.mencion,
        };
      });
    } catch (error) {
      console.error("Error al obtener los participantes:", error);
      throw error;
    }
  }

  // Llenar tabla de participantes en el modal de consulta y modificación
  llenarTablaParticipantesConcurso(participantes) {
    const tablaBody = document.querySelector(
      "#tablaParticipantesConcurso tbody"
    );
    if (participantes && participantes.length > 0) {
      tablaBody.innerHTML = ""; // Limpia la tabla

      participantes.forEach((participante) => {
        const row = tablaBody.insertRow();
        row.dataset.participanteId = participante.id;
        row.dataset.nombre = participante.nombre;

        const nombreCell = row.insertCell();

        // Construir badges de ganadores y menciones
        let badgesHtml = "";
        if (participante.posicion === 1) {
          badgesHtml += '<span class="badge bg-warning text-dark ms-2"><i class="bi bi-trophy-fill me-1"></i>1° Lugar</span>';
        } else if (participante.posicion === 2) {
          badgesHtml += '<span class="badge bg-secondary text-white ms-2"><i class="bi bi-award-fill me-1"></i>2° Lugar</span>';
        } else if (participante.posicion === 3) {
          badgesHtml += '<span class="badge ms-2" style="background-color: #cd7f32; color: #fff;"><i class="bi bi-award me-1"></i>3° Lugar</span>';
        } else if (participante.posicion > 3) {
          badgesHtml += `<span class="badge bg-info text-dark ms-2">${participante.posicion}° Lugar</span>`;
        }

        if (participante.mencion) {
          badgesHtml += `<span class="badge bg-primary text-white ms-2"><i class="bi bi-star-fill me-1"></i>${participante.mencion}</span>`;
        }

        nombreCell.innerHTML = `<span class="fw-semibold">${participante.nombre}</span>${badgesHtml}`;

        const cedulaCell = row.insertCell();
        cedulaCell.textContent = participante.cedula || "N/A";
      });
    } else if (tablaBody) {
      tablaBody.innerHTML =
        '<tr><td colspan="2" class="text-center text-muted py-3">No hay participantes registrados en esta competencia.</td></tr>';
      // Notificar al usuario de forma discreta
      Notifications.toast(
        "Esta categoría no tiene participantes registrados",
        "info"
      );
    }
  }

  async getParticipantesConcurso(event) {
    try {
      const clickedElement = event.target;
      const row = clickedElement.closest('tr');
      if (!row || !row.dataset.categorias) return;

      const categoriasArray = JSON.parse(row.dataset.categorias);

      // Limpiar y llenar el select de categorias en el modal
      const selectCat = document.getElementById('selectCategoriaModal');
      const contenedorSelect = document.getElementById('contenedorCategoriaModal');
      
      if (selectCat && contenedorSelect) {
        selectCat.innerHTML = '';
        if (categoriasArray.length > 1) {
          contenedorSelect.style.setProperty('display', 'flex', 'important');
          categoriasArray.forEach(cat => {
            const option = document.createElement('option');
            option.value = cat.id;
            option.textContent = cat.nombreCat;
            selectCat.appendChild(option);
          });
        } else {
          contenedorSelect.style.setProperty('display', 'none', 'important');
          const option = document.createElement('option');
          option.value = categoriasArray[0].id;
          option.textContent = categoriasArray[0].nombreCat;
          selectCat.appendChild(option);
        }
        
        selectCat.onchange = async () => {
          const data = await this.obtenerParticipantesConcursoPorId(selectCat.value);
          this.llenarTablaParticipantesConcurso(data);
        };
      }

      // Cargar participantes de la primera categoría por defecto
      const idInicial = categoriasArray[0].id;
      const dataInicial = await this.obtenerParticipantesConcursoPorId(idInicial);
      this.llenarTablaParticipantesConcurso(dataInicial);

      if (document.body.id === "BodyConsultarConcurso") {
        const modalElement = document.getElementById('modalParticipantes');
        if (modalElement) {
          const modal = new bootstrap.Modal(modalElement);
          modal.show();
        }
      }
    } catch (error) {
      Notifications.error("Error al encontrar participantes");
      console.error(error);
    }
  }

  async obtenerNoParticipantes(event) {
    const clickedElement = event.target;
    const row = clickedElement.parentNode;
    const codigoConcurso = row.dataset.concursoId;
    try {
      console.log(codigoConcurso);
      const response = await fetch(
        `http://localhost:3002/Concurso/NoParticipantesConcurso/${codigoConcurso}`
      ); // Ajusta la URL del endpoint

      if (!response.ok) {
        throw new Error(
          `Error en la petición: ${response.status} - ${response.statusText}`
        );
      }

      const data = await response.json();

      // Mapea cada objeto JSON a una instancia de la clase Concurso
      var listaParticipantes = data.personas.map((concursoData) => {
        return {
          id: concursoData.id,
          nombre: concursoData.nombre,
          cedula: concursoData.cedula,
        };
      });

      console.log("Lista de participantes: ", listaParticipantes);
      //this.llenarTablaConcursos(listaParticipantes)

      return listaParticipantes;
    } catch (error) {
      console.error("Error al obtener los participantes:", error);
      throw error;
    }
  }
  async getNoParticipantesConcurso(event) {
    try {
      this.llenarTablaParticipantesConcurso(
        await this.obtenerNoParticipantes(event)
      );
    } catch (error) {
      console.error("error al conseguir participantes: " + error);
    }
  }

  obtenerDatosParticipante(event) {
    const clickedElement = event.target;
    const row = clickedElement.closest("tr");
    if (!row) return;
    const codigoParticipante = row.dataset.participanteId;
    const cells = row.querySelectorAll("td");
    document.getElementById("nombreParticipante").value = row.dataset.nombre || cells[0].textContent;
    document.getElementById("cedulaParticipante").value = cells[1].textContent;
    this.guardarValorEnCookie("IdParticipante", codigoParticipante);
  }

  async agregarParticipanteConcurso() {
    const concurso = this.getCookie("CodigoConcurso");
    const participante = this.getCookie("IdParticipante");
    if (!concurso || !participante) {
      Notifications.warning("Debe seleccionar un participante y un concurso");
      return;
    }
    await fetch("http://localhost:3002/Concurso/InsertarParticipanteConcurso", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        concurso: concurso,
        participante: participante,
      }),
    })
      .then((response) => response.json())
      .then((data) => {
        Notifications.success("Participante insertado con éxito");
      })
      .catch((error) => {
        Notifications.error(
          "Error al insertar el participante: " + error.message
        );
      });
  }

  async getEstados() {
    try {
      const response = await fetch("http://localhost:3002/Participantes/GetEstados");
      if (!response.ok) {
        throw new Error(`Error en la petición: ${response.status}`);
      }
      const data = await response.json();
      return Array.isArray(data) ? data : [];
    } catch (error) {
      console.error("Error al obtener los estados:", error);
      return [];
    }
  }

  async importarExcelConcursoApi(formData) {
    try {
      const response = await fetch("http://localhost:3002/Concurso/ImportarExcelConcurso", {
        method: "POST",
        body: formData,
      });

      const data = await response.json();

      if (!response.ok && response.status !== 207) {
        throw new Error(data.error || `Error HTTP: ${response.status}`);
      }

      return data;
    } catch (error) {
      console.error("Error en importarExcelConcursoApi:", error);
      throw error;
    }
  }
}

export { Request_Concursos };
