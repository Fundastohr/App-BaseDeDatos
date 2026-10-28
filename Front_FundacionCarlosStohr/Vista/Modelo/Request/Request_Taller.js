// Posible ruta: Modelo/Request/Request_Taller.js

import { Taller } from "../Clases/Taller.js"; // Ajusta la ruta según tu estructura
import { Notifications } from "../Utils/Notifications.js";

class Request_Taller {
    constructor() {
        this.listaTalleres = [];
        // Asumimos que los endpoints del backend para Taller siguen el patrón:
        // http://localhost:3000/GetTalleres (GET)
        // http://localhost:3000/InsertarTaller (POST)
        // http://localhost:3000/ModificarTaller/:id_taller (PUT)
        // http://localhost:3000/EliminarTaller/:id_taller (DELETE)
        // Si usaste un prefijo como /api en el backend, ajústalo aquí. Ej: /api/GetTalleres
        this.baseUrl = 'http://localhost:3002'; // URL base de tu API
    }

    async InsertarTaller(taller) {
        try {
            const response = await fetch(`${this.baseUrl}/taller/InsertarTaller`, { // Endpoint del backend para insertar taller
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    nombre: taller.nombre,
                    fecha: taller.fecha,
                    lugar: taller.lugar,
                })
            });
            const data = await response.json();
            if (!response.ok) {
                throw new Error(data.error || `Error ${response.status} al insertar el taller.`);
            }
            Notifications.success("Taller insertado con éxito");
            console.log("Taller insertado:", data.taller);
            return data.taller;
        } catch (error) {
            Notifications.error(`Error al insertar taller: ${error.message}`);
            console.error('Error en InsertarTaller:', error);
        }
    }

    // Debes crear los IDs de los campos del formulario para Taller en tu HTML.
    // Ejemplo: nombreTaller, fechaTaller, lugarTaller
    GetFormulario() {
        const nombre = document.getElementById('nombreTaller').value;
        const fecha = document.getElementById('fechaTaller').value;
        const lugar = document.getElementById('lugarTaller').value;
        // El ID se deja vacío o null ya que es para una nueva inserción o se manejará diferente para modificación.
        return new Taller(nombre, fecha, lugar, null);
    }
    
    // Similar a GetFormulario pero para obtener datos para modificar, incluyendo el ID si es necesario
    GetFormularioConID(id_taller_para_modificar) {
        const nombre = document.getElementById('nombreTaller').value; // Asumiendo mismos IDs para el form de modificar
        const fecha = document.getElementById('fechaTaller').value;
        const lugar = document.getElementById('lugarTaller').value;
        return new Taller(nombre, fecha, lugar, id_taller_para_modificar);
    }


    async CargarTalleres() {
        try {
            await this.Get_Talleres(); 
        } catch (error) {
            console.error("Error en CargarTalleres:", error);
            // Notificar al usuario si hay un error al cargar talleres
            Notifications.error("Error al cargar los talleres. Por favor, intente nuevamente.");
        }
    }

    async Get_Talleres() {
        try {
            const response = await fetch(`${this.baseUrl}/taller/GetTalleres`); // Endpoint del backend
            if (!response.ok) {
                throw new Error(`Error en la petición: ${response.status} - ${response.statusText}`);
            }
            const data = await response.json();

            // Mapea cada objeto JSON a una instancia de la clase Taller
            this.listaTalleres = data.map(tallerData => {
                // El backend devuelve ID_Taller, Nombre, fecha, Lugar
                return new Taller(
                    tallerData.nombre, // Asumiendo que el backend devuelve 'nombre' (o ajusta si es 'Nombre')
                    tallerData.fecha,
                    tallerData.lugar, // Asumiendo que el backend devuelve 'lugar' (o ajusta si es 'Lugar')
                    tallerData.id_taller // Asumiendo que el backend devuelve 'id_taller' (o ajusta si es 'ID_Taller')
                );
            });

            console.log('Lista de talleres (objetos Taller):', this.listaTalleres);
            this.llenarTablaTalleres(this.listaTalleres); // Llama al método para llenar la tabla
            return this.listaTalleres;

        } catch (error) {
            console.error('Error al obtener los talleres:', error);
            this.llenarTablaTalleres([]); // Llenar tabla con vacío o mensaje de error
            throw error; // Opcional: relanzar si quieres que el llamador lo maneje
        }
    }

    llenarTablaTalleres(listaDeTalleres) {
        // Asegúrate de que el selector coincida con tu tabla de talleres
        const tablaBody = document.querySelector('#tablaTalleres tbody') || document.querySelector('.table.datatable tbody'); // Compatible con consultar y modificar

        if (!tablaBody) {
            console.error("El tbody de la tabla de talleres no fue encontrado.");
            return;
        }
        
        tablaBody.innerHTML = ''; // Limpia la tabla

        if (listaDeTalleres && listaDeTalleres.length > 0) {
            listaDeTalleres.forEach(taller => {
                const row = tablaBody.insertRow();
                row.dataset.tallerId = taller.id_taller; // Guarda el ID del taller en el dataset de la fila
                row.style.cursor = "pointer";
                row.title = "Haz clic para ver los participantes";

                const nombreCell = row.insertCell();
                nombreCell.textContent = taller.nombre;

                const fechaCell = row.insertCell();
                fechaCell.textContent = this.formatearFecha(taller.fecha);

                const lugarCell = row.insertCell();
                lugarCell.textContent = taller.lugar || 'N/A'; // Mostrar N/A si el lugar es null/undefined

                // Aquí puedes añadir celdas para botones de "Modificar" / "Eliminar" si la tabla es para eso.
                // O si la selección es por clic en la fila, como en Exposicion.
            });
        } else {
            // Ajusta el colspan según el número de columnas de tu tabla de talleres
            const numColumnas = 3; // Nombre, Fecha, Lugar
            tablaBody.innerHTML = `<tr><td colspan="${numColumnas}">No hay talleres disponibles.</td></tr>`;
            // Notificar al usuario que no hay datos (solo en página de consulta)
            if (document.body.id === 'BodyConsultarTaller') {
              Notifications.info("No hay talleres registrados en el sistema.");
            }
        }
        
        // Reinicializar el ordenador de tablas después de cargar datos
        if (typeof window.reinitTableSorter === 'function') {
          setTimeout(() => window.reinitTableSorter(), 100);
        }
    }

    formatearFecha(fechaISO) {
        if (!fechaISO) return '';
        const str = String(fechaISO).split('T')[0].trim();
        if (str.startsWith('1000') || str.startsWith('1899') || str.startsWith('1900')) return 'No especificada';
        const parts = str.split('-');
        if (parts.length === 3 && parts[0].length === 4) {
            const [year, month, day] = parts;
            if (parseInt(year, 10) <= 1000) return 'No especificada';
            return `${day.padStart(2, '0')}/${month.padStart(2, '0')}/${year}`;
        }
        const date = new Date(fechaISO);
        const day = String(date.getUTCDate()).padStart(2, '0');
        const month = String(date.getUTCMonth() + 1).padStart(2, '0');
        const year = date.getUTCFullYear();
        if (year <= 1000) return 'No especificada';
        return `${day}/${month}/${year}`;
    }

    formatearFechaParaInput(fechaISO) {
        if (!fechaISO) return '';
        const date = new Date(fechaISO);
         // Para input type="date", el formato es YYYY-MM-DD
        const year = date.getFullYear(); // Usar getFullYear normal para la zona local del input
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }

    ObtenerDatosTablaTalleres(event){
        const clickedElement = event.target;
      
        if (clickedElement.tagName === 'TD') {
          const row = clickedElement.parentNode;
          const tallerid = row.dataset.tallerId; 
      
          if (row.cells.length === 3) { // Asumiendo que tu tabla de exposiciones tiene 4 columnas (Nombre, Fecha, Lugar, Tipo)
            const nombre = row.cells[0].textContent;
            const fechaTexto = row.cells[1].textContent;
      
            const partesFecha = fechaTexto.split('/');
            // new Date(year, monthIndex, day) - monthIndex is 0-based (0 for January, 11 for December)
            const fechaObjeto = new Date(
              parseInt(partesFecha[2]),       // Año
              parseInt(partesFecha[0]) - 1,   // Mes (restamos 1 porque es 0-based)
              parseInt(partesFecha[1])        // Día
            );
      
            const lugar = row.cells[2].textContent;
      
            const tallerSeleccionado = new Taller(nombre,fechaObjeto,lugar,tallerid)
            console.log(tallerSeleccionado)
            this.guardarValorEnCookie("CodigoTaller",tallerid)
            this.llenarFormularioTaller(tallerSeleccionado); // Asumiendo que tienes un formulario para exposiciones


          } else {
            console.warn('La fila clickeada no tiene el número esperado de celdas para la exposición.');
          }
        }
      }

    llenarFormularioTaller(taller) {
        // Asegúrate de que los IDs de los campos del formulario de taller sean correctos
        const nombreInput = document.getElementById('nombreTaller'); // ej: nombreTaller
        const fechaInput = document.getElementById('fechaTaller');   // ej: fechaTaller
        const lugarInput = document.getElementById('lugarTaller');   // ej: lugarTaller
        const nombreTallerParticipanteInput= document.getElementById('nombreTallerParticipante');

        if (!nombreInput || !fechaInput || !lugarInput) {
            console.error("Uno o más campos del formulario de taller no fueron encontrados.");
            return;
        }

        if (taller) {
            nombreInput.value = taller.nombre || '';
            // Para input type="date", la fecha debe estar en formato "YYYY-MM-DD"
            fechaInput.value = this.formatearFechaParaInput(taller.fecha) || '';
            lugarInput.value = taller.lugar || '';
            nombreTallerParticipanteInput.value=taller.nombre;
            console.log("Formulario llenado con taller:", taller);
        } else {
            console.warn('Se intentó llenar el formulario de taller con un objeto vacío.');
            // Limpiar el formulario si es necesario
            nombreInput.value = '';
            fechaInput.value = '';
            lugarInput.value = '';
        }
    }

    async actualizarTaller(tallerActualizado) {
        const idTaller = this.getCookie("CodigoTaller"); // Obtener el ID del taller desde la cookie
        if (!idTaller) {
            Notifications.warning("No se ha seleccionado ningún taller para modificar.");
            return;
        }

        try {
            const response = await fetch(`${this.baseUrl}/taller/ModificarTaller/${idTaller}`, { // Endpoint del backend
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ // El backend para Taller espera minúsculas
                    nombre: tallerActualizado.nombre,
                    fecha: tallerActualizado.fecha,
                    lugar: tallerActualizado.lugar,
                })
            });

            const data = await response.json();
            if (!response.ok) {
                throw new Error(data.error || `Error ${response.status} al modificar el taller.`);
            }

            Notifications.success("Taller modificado con éxito");
            console.log("Respuesta del servidor (modificación de taller):", data);
            this.CargarTalleres(); // Recargar la lista/tabla de talleres

        } catch (error) {
            Notifications.error(`Error al modificar taller: ${error.message}`);
            console.error('Error al modificar el taller:', error);
        }
    }

    async eliminarTaller() {
        const idTaller = this.getCookie("CodigoTaller"); // Obtener el ID del taller desde la cookie
        if (!idTaller) {
            Notifications.warning("No se ha seleccionado ningún taller para eliminar.");
            return;
        }

        // Confirmación antes de eliminar (opcional pero recomendado)
        const confirmed = await Notifications.confirm(`¿Está seguro de que desea eliminar el taller con ID ${idTaller}?`);
        if (!confirmed) {
            return;
        }

        try {
            const response = await fetch(`${this.baseUrl}/taller/EliminarTaller/${idTaller}`, { // Endpoint del backend
                method: 'DELETE',
            });

            const data = await response.json(); // Intenta parsear JSON incluso para errores si el backend los envía así
            if (!response.ok) {
                 throw new Error(data.error || data.mensaje || `Error ${response.status} al eliminar el taller.`);
            }

            Notifications.success(data.mensaje || "Taller eliminado con éxito.");
            console.log("Respuesta del servidor (eliminación de taller):", data);
            this.CargarTalleres(); // Recargar la lista/tabla de talleres

        } catch (error) {
            Notifications.error(`Error al eliminar taller: ${error.message}`);
            console.error('Error al eliminar el taller:', error);
        }
    }

    // Funciones de Cookies (las mismas que tenías)
    guardarValorEnCookie(nombreCookie, valor) {
        const fechaExpiracion = new Date();
        fechaExpiracion.setDate(fechaExpiracion.getDate() + 30);
        const expires = 'expires=' + fechaExpiracion.toUTCString();
        const path = 'path=/';
        document.cookie = `${nombreCookie}=${encodeURIComponent(valor)};${expires};${path}`;
        console.log(`Valor "${valor}" guardado en la cookie "${nombreCookie}".`);
    }

    getCookie(nombre) {
        const nombreEQ = nombre + "=";
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            let cookie = cookies[i];
            while (cookie.charAt(0) === ' ') {
                cookie = cookie.substring(1);
            }
            if (cookie.indexOf(nombreEQ) === 0) {
                return decodeURIComponent(cookie.substring(nombreEQ.length, cookie.length));
            }
        }
        return null;
    }

  async obtenerParticipantesTaller(event){
    const clickedElement = event.target;
    const row = clickedElement.closest('tr') || clickedElement.parentNode;
    const codigoTaller = row?.dataset?.tallerId; 
    try {
      const response = await fetch(`http://localhost:3002/Taller/ParticipantesTaller/${codigoTaller}`);

      if (!response.ok) {
        throw new Error(`Error en la petición: ${response.status} - ${response.statusText}`);
      }

      const data = await response.json();

      let listaParticipantes = (data.personas || []).map(tallerData => {
        return {
          id: tallerData.id,
          nombre: tallerData.nombre,
          cedula: tallerData.cedula,
          correo: tallerData.correo
        };
      });

      return listaParticipantes;

    } catch (error) {
      console.error('Error al obtener los participantes:', error);
      throw error;
    }
  }

  llenarTablaParticipantesTaller(participantes) {
    const tablaBody = document.querySelector('#tablaParticipantesTaller tbody');

    // Guardar lista para copiar correos
    this._ultimosParticipantesTaller = participantes || [];

    if (participantes && participantes.length > 0) {
      tablaBody.innerHTML = ''; // Limpia la tabla
  
      participantes.forEach(participante => {
        const row = tablaBody.insertRow();
        row.dataset.participanteId = participante.id;
        row.dataset.correo = participante.correo || '';
        row.dataset.nombre = participante.nombre || '';

        const nombreCell = row.insertCell();
        nombreCell.textContent = participante.nombre;

        const cedulaCell = row.insertCell();
        cedulaCell.textContent = participante.cedula || 'N/A';

      });
    } else if (tablaBody) {
      tablaBody.innerHTML = '<tr><td colspan="2">No hay participantes registrados.</td></tr>'; // Ajusta el colspan según el número de columnas
      // Notificar al usuario de forma discreta
      Notifications.toast("Este taller no tiene participantes registrados", "info");
    }
  }

  // ──────────────────────────────────────────────────────────
  // COPIAR CORREOS — participantes del taller actualmente mostrado
  // Ignora correos nulos/vacíos y muestra aviso con los omitidos
  // ──────────────────────────────────────────────────────────
  _esFallbackCorreo(correo) {
    if (!correo) return true;
    const c = String(correo).trim().toLowerCase();
    if (!c) return true;
    if (c.includes('fundacionstohr.org')) return true;
    if (c.includes('no-especificado')) return true;
    if (c.includes('noemail')) return true;
    if (c === 'n/a' || c === '-') return true;
    return false;
  }

  async copiarCorreosTaller() {
    const participantes = this._ultimosParticipantesTaller || [];

    if (!participantes.length) {
      Notifications?.warning?.("No hay participantes para copiar.");
      return;
    }

    const conCorreo = [];
    const sinCorreo = [];

    for (const p of participantes) {
      if (!p.correo || this._esFallbackCorreo(p.correo)) {
        sinCorreo.push(p.nombre || '(sin nombre)');
      } else {
        const correosSeparados = String(p.correo)
          .split(/[,;\n]+/)
          .map(e => e.trim().toLowerCase())
          .filter(e => e && !this._esFallbackCorreo(e));

        if (correosSeparados.length > 0) {
          correosSeparados.forEach(c => conCorreo.push(c));
        } else {
          sinCorreo.push(p.nombre || '(sin nombre)');
        }
      }
    }

    const correosUnicos = [...new Set(conCorreo)];

    if (!correosUnicos.length) {
      Notifications?.warning?.("Ningún participante tiene correo registrado en el sistema.");
      return;
    }

    const texto = correosUnicos.join('\n');
    const ok = await this._copyTextToClipboard(texto);

    if (ok) {
      Notifications?.success?.(`¡${correosUnicos.length} correo(s) copiado(s)!`);
    } else {
      Notifications?.error?.("No se pudo copiar al portapapeles.");
      return;
    }

    if (sinCorreo.length > 0) {
      const listaHtml = sinCorreo.map(n => `<li style="text-align: left; margin-bottom: 4px;">${n}</li>`).join('');
      if (typeof Swal !== 'undefined') {
        await Swal.fire({
          icon: 'warning',
          title: 'Participantes sin correo registrado',
          html: `
            <p style="margin-bottom: 12px; text-align: left;">Se omitieron <strong>${sinCorreo.length} participante(s)</strong> por no tener correo electrónico en el sistema:</p>
            <ul style="max-height: 200px; overflow-y: auto; padding-left: 20px; margin-bottom: 0;">
              ${listaHtml}
            </ul>
          `,
          confirmButtonText: 'Entendido',
          confirmButtonColor: '#1a73e8'
        });
      } else {
        alert(`Participantes sin correo en el sistema omitidos:\n\n${sinCorreo.map(n => `• ${n}`).join('\n')}`);
      }
    }
  }

  async _copyTextToClipboard(texto) {
    try {
      if (navigator?.clipboard?.writeText && window.isSecureContext) {
        await navigator.clipboard.writeText(texto);
        return true;
      }
    } catch (e) {
      console.warn('Clipboard API falló, usando fallback.', e);
    }
    try {
      const ta = document.createElement('textarea');
      ta.value = texto;
      ta.setAttribute('readonly', '');
      ta.style.position = 'fixed';
      ta.style.left = '-9999px';
      ta.style.top = '0';
      document.body.appendChild(ta);
      ta.focus();
      ta.select();
      const ok = document.execCommand('copy');
      document.body.removeChild(ta);
      return !!ok;
    } catch (e) {
      console.error('Fallback copy falló:', e);
      return false;
    }
  }

  async getParticipantesTaller(event){
    try {
      this.llenarTablaParticipantesTaller(await this.obtenerParticipantesTaller(event));
      
      // Mostrar el modal de participantes si estamos en consultar-taller
      if (document.body.id === "BodyConsultarTaller") {
        const modalElement = document.getElementById('modalParticipantes');
        if (modalElement) {
          const modal = new bootstrap.Modal(modalElement);
          modal.show();
        }
      }
    } catch (error) {
      console.error("error al conseguir participantes: "+ error)
    }
  }

  async obtenerNoParticipantes(event){
    const clickedElement = event.target;
    const row = clickedElement.parentNode;
    const codigoTaller = row.dataset.tallerId; 
    try {
      console.log(codigoTaller)
      const response = await fetch(`http://localhost:3002/Taller/NoParticipantesTaller/${codigoTaller}`); // Ajusta la URL del endpoint

      if (!response.ok) {
        throw new Error(`Error en la petición: ${response.status} - ${response.statusText}`);
      }

      const data = await response.json();

      var listaParticipantes = data.personas.map(tallerData => {
        return {
          id:tallerData.id,
          nombre:tallerData.nombre,
          cedula:tallerData.cedula
        }
      });

    console.log('Lista de participantes: ', listaParticipantes);

      return listaParticipantes;

    } catch (error) {
      console.error('Error al obtener los participantes:', error);
      throw error;
    }
  }

  async getNoParticipantesTaller(event){
    try {
      this.llenarTablaParticipantesTaller(await this.obtenerNoParticipantes(event))
    } catch (error) {
      console.error("error al conseguir participantes: "+ error)
    }
  }

  obtenerDatosParticipante(event){
    const clickedElement = event.target;
    const row = clickedElement.closest('tr');
    if (!row) return;
    const codigoParticipante = row.dataset.participanteId;
    const cells = row.querySelectorAll('td'); 
    document.getElementById('nombreParticipante').value = row.dataset.nombre || cells[0].textContent.trim();
    document.getElementById('cedulaParticipante').value = cells[1].textContent.trim();
    this.guardarValorEnCookie('IdParticipante', codigoParticipante);
  }

  async agregarParticipanteTaller() {
    const taller = this.getCookie('CodigoTaller');
    const participante = this.getCookie('IdParticipante');
    if (!taller || !participante) {
      Notifications.warning('Debe seleccionar un participante y un Taller');
      return;
    }
    await fetch('http://localhost:3002/taller/InsertarParticipanteTaller', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        taller: taller,
        participante: participante
      })
    })
      .then(response => response.json())
      .then(data => {
        Notifications.success("Participante insertado con éxito");
      })
      .catch(error => {
        Notifications.error('Error al insertar el participante: ' + error.message);
      });
  }

  async getEstados() {
    try {
      const response = await fetch(`${this.baseUrl}/Participantes/GetEstados`);
      if (!response.ok) {
        throw new Error(`Error en la petición: ${response.status}`);
      }
      const data = await response.json();
      return Array.isArray(data) ? data : [];
    } catch (error) {
      console.error('Error al obtener los estados:', error);
      return [];
    }
  }

  async importarExcelTallerApi(formData) {
    try {
      const response = await fetch(`${this.baseUrl}/taller/ImportarExcelTaller`, {
        method: 'POST',
        body: formData,
      });

      const data = await response.json();

      if (!response.ok && response.status !== 207) {
        throw new Error(data.error || `Error HTTP: ${response.status}`);
      }

      return data;
    } catch (error) {
      console.error('Error en importarExcelTallerApi:', error);
      throw error;
    }
  }
}

export { Request_Taller };