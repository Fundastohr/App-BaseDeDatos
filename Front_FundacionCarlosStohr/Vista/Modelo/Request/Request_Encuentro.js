// File: Modelo/Request/Request_Encuentro.js

import { Encuentro } from "../Clases/Encuentro.js";
import { Notifications } from "../Utils/Notifications.js";

class Request_Encuentro {
    constructor() {
        this.listaEncuentros = [];
        this.baseUrl = window.API_BASE_URL || 'http://localhost:3002';
    }

    async InsertarEncuentro(encuentro) {
        try {
            const response = await fetch(`${this.baseUrl}/encuentro/InsertarEncuentro`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    nombre: encuentro.nombre,
                    fecha: encuentro.fecha,
                    lugar: encuentro.lugar,
                })
            });
            const data = await response.json();
            if (!response.ok) {
                throw new Error(data.error || `Error ${response.status} al insertar el encuentro.`);
            }
            Notifications.success("Encuentro de dibujo urbano registrado con éxito");
            return data.encuentro;
        } catch (error) {
            Notifications.error(`Error al registrar encuentro: ${error.message}`);
            console.error('Error en InsertarEncuentro:', error);
        }
    }

    GetFormulario() {
        const nombre = document.getElementById('nombreEncuentro')?.value?.trim();
        const fecha = document.getElementById('fechaEncuentro')?.value;
        const lugar = document.getElementById('lugarEncuentro')?.value?.trim();
        return new Encuentro(nombre, fecha, lugar, null);
    }
    
    GetFormularioConID(id_encuentro) {
        const nombre = document.getElementById('nombreEncuentro')?.value?.trim();
        const fecha = document.getElementById('fechaEncuentro')?.value;
        const lugar = document.getElementById('lugarEncuentro')?.value?.trim();
        return new Encuentro(nombre, fecha, lugar, id_encuentro);
    }

    async CargarEncuentros() {
        try {
            await this.Get_Encuentros(); 
        } catch (error) {
            console.error("Error en CargarEncuentros:", error);
            Notifications.error("Error al cargar los encuentros. Por favor, intente nuevamente.");
        }
    }

    async Get_Encuentros() {
        try {
            const response = await fetch(`${this.baseUrl}/encuentro/GetEncuentros`);
            if (!response.ok) {
                throw new Error(`Error en la petición: ${response.status} - ${response.statusText}`);
            }
            const data = await response.json();

            this.listaEncuentros = data.map(item => {
                return new Encuentro(
                    item.nombre,
                    item.fecha,
                    item.lugar,
                    item.id_encuentro
                );
            });

            this.llenarTablaEncuentros(this.listaEncuentros);
            return this.listaEncuentros;
        } catch (error) {
            console.error('Error al obtener los encuentros:', error);
            this.llenarTablaEncuentros([]);
            throw error;
        }
    }

    llenarTablaEncuentros(lista) {
        const tablaBody = document.querySelector('#tablaEncuentros tbody') || document.querySelector('.table.datatable tbody');

        if (!tablaBody) {
            console.error("El tbody de la tabla de encuentros no fue encontrado.");
            return;
        }
        
        tablaBody.innerHTML = '';

        if (lista && lista.length > 0) {
            lista.forEach(encuentro => {
                const row = tablaBody.insertRow();
                row.dataset.encuentroId = encuentro.id_encuentro;
                row.style.cursor = "pointer";
                row.title = "Haz clic para seleccionar o ver los participantes";

                const nombreCell = row.insertCell();
                nombreCell.textContent = encuentro.nombre;

                const fechaCell = row.insertCell();
                fechaCell.textContent = this.formatearFecha(encuentro.fecha);

                const lugarCell = row.insertCell();
                lugarCell.textContent = encuentro.lugar || 'N/A';
            });
        } else {
            const numColumnas = 3;
            tablaBody.innerHTML = `<tr><td colspan="${numColumnas}">No hay encuentros disponibles.</td></tr>`;
            if (document.body.id === 'BodyConsultarEncuentro') {
              Notifications.info("No hay encuentros registrados en el sistema.");
            }
        }
        
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
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }

    ObtenerDatosTablaEncuentros(event) {
        const clickedElement = event.target;
        if (clickedElement.tagName === 'TD') {
          const row = clickedElement.parentNode;
          const encuentroid = row.dataset.encuentroId; 
      
          if (row.cells.length >= 3) {
            const nombre = row.cells[0].textContent;
            const fechaTexto = row.cells[1].textContent;
      
            const partesFecha = fechaTexto.split('/');
            const fechaObjeto = new Date(
              parseInt(partesFecha[2]),
              parseInt(partesFecha[1]) - 1,
              parseInt(partesFecha[0])
            );
      
            const lugar = row.cells[2].textContent;
      
            const encuentroSeleccionado = new Encuentro(nombre, fechaObjeto, lugar === 'N/A' ? '' : lugar, encuentroid);
            this.guardarValorEnCookie("CodigoEncuentro", encuentroid);
            this.llenarFormularioEncuentro(encuentroSeleccionado);
          }
        }
    }

    llenarFormularioEncuentro(encuentro) {
        const nombreInput = document.getElementById('nombreEncuentro');
        const fechaInput = document.getElementById('fechaEncuentro');
        const lugarInput = document.getElementById('lugarEncuentro');
        const nombreEncuentroParticipanteInput = document.getElementById('nombreEncuentroParticipante');

        if (!nombreInput || !fechaInput) {
            return;
        }

        if (encuentro) {
            nombreInput.value = encuentro.nombre || '';
            fechaInput.value = this.formatearFechaParaInput(encuentro.fecha) || '';
            if (lugarInput) lugarInput.value = encuentro.lugar || '';
            if (nombreEncuentroParticipanteInput) nombreEncuentroParticipanteInput.value = encuentro.nombre;
        } else {
            nombreInput.value = '';
            fechaInput.value = '';
            if (lugarInput) lugarInput.value = '';
        }
    }

    async actualizarEncuentro(encuentroActualizado) {
        const idEncuentro = this.getCookie("CodigoEncuentro");
        if (!idEncuentro) {
            Notifications.warning("No se ha seleccionado ningún encuentro para modificar.");
            return;
        }

        try {
            const response = await fetch(`${this.baseUrl}/encuentro/ModificarEncuentro/${idEncuentro}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    nombre: encuentroActualizado.nombre,
                    fecha: encuentroActualizado.fecha,
                    lugar: encuentroActualizado.lugar,
                })
            });

            const data = await response.json();
            if (!response.ok) {
                throw new Error(data.error || `Error ${response.status} al modificar el encuentro.`);
            }

            Notifications.success("Encuentro modificado con éxito");
            this.CargarEncuentros();
        } catch (error) {
            Notifications.error(`Error al modificar encuentro: ${error.message}`);
            console.error('Error al modificar el encuentro:', error);
        }
    }

    async eliminarEncuentro() {
        const idEncuentro = this.getCookie("CodigoEncuentro");
        if (!idEncuentro) {
            Notifications.warning("No se ha seleccionado ningún encuentro para eliminar.");
            return;
        }

        const confirmed = await Notifications.confirm(`¿Está seguro de que desea eliminar este encuentro de dibujo urbano?`);
        if (!confirmed) {
            return;
        }

        try {
            const response = await fetch(`${this.baseUrl}/encuentro/EliminarEncuentro/${idEncuentro}`, {
                method: 'DELETE',
            });

            const data = await response.json();
            if (!response.ok) {
                 throw new Error(data.error || data.mensaje || `Error ${response.status} al eliminar el encuentro.`);
            }

            Notifications.success(data.mensaje || "Encuentro eliminado con éxito.");
            this.CargarEncuentros();
        } catch (error) {
            Notifications.error(`Error al eliminar encuentro: ${error.message}`);
            console.error('Error al eliminar el encuentro:', error);
        }
    }

    guardarValorEnCookie(nombreCookie, valor) {
        const fechaExpiracion = new Date();
        fechaExpiracion.setDate(fechaExpiracion.getDate() + 30);
        const expires = 'expires=' + fechaExpiracion.toUTCString();
        const path = 'path=/';
        document.cookie = `${nombreCookie}=${encodeURIComponent(valor)};${expires};${path}`;
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

    async obtenerParticipantesEncuentro(event) {
        const clickedElement = event.target;
        const row = clickedElement.closest('tr');
        if (!row) return [];
        const codigoEncuentro = row.dataset.encuentroId; 
        try {
          const response = await fetch(`${this.baseUrl}/encuentro/ParticipantesEncuentro/${codigoEncuentro}`);
          if (!response.ok) {
            throw new Error(`Error en la petición: ${response.status} - ${response.statusText}`);
          }
          const data = await response.json();
          return data;
        } catch (error) {
          console.error('Error al obtener los participantes del encuentro:', error);
          throw error;
        }
    }

    llenarTablaParticipantesEncuentro(participantes) {
        const tablaBody = document.querySelector('#tablaParticipantesEncuentro tbody');
        if (!tablaBody) return;

        // Guardar lista para copiar correos
        this._ultimosParticipantesEncuentro = participantes || [];

        if (participantes && participantes.length > 0) {
            tablaBody.innerHTML = '';
            participantes.forEach(p => {
              const row = tablaBody.insertRow();
              row.dataset.participanteId = p.id_participante || p.id;
              row.dataset.correo = p.correo || '';
              row.dataset.nombre = p.nombre || '';

              const nombreCell = row.insertCell();
              nombreCell.textContent = p.nombre;

              const cedulaCell = row.insertCell();
              cedulaCell.textContent = p.cedula || 'N/A';

              const telCell = row.insertCell();
              telCell.textContent = p.telefono || 'N/A';
            });
        } else {
            tablaBody.innerHTML = '<tr><td colspan="3">No hay participantes registrados.</td></tr>';
            Notifications.toast("Este encuentro no tiene participantes registrados", "info");
        }
    }

    // ─────────────────────────────────────────────────────────────────
    // COPIAR CORREOS — participantes del encuentro actualmente mostrado
    // Ignora correos nulos/vacíos y muestra aviso con los omitidos
    // ─────────────────────────────────────────────────────────────────
    _esFallbackCorreo(correo) {
        if (!correo) return true;
        const c = String(correo).trim().toLowerCase();
        if (!c) return true;
        // Fallbacks conocidos
        if (c.includes('fundacionstohr.org')) return true;
        if (c.includes('no-especificado')) return true;
        if (c.includes('noemail')) return true;
        if (c === 'n/a' || c === '-') return true;
        return false;
    }

    async copiarCorreosEncuentro() {
        const participantes = this._ultimosParticipantesEncuentro || [];

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
            let msg = `¡${correosUnicos.length} correo(s) copiado(s)!`;
            Notifications?.success?.(msg);
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

    async getParticipantesEncuentro(event) {
        try {
          const participantes = await this.obtenerParticipantesEncuentro(event);
          this.llenarTablaParticipantesEncuentro(participantes);
          
          if (document.body.id === "BodyConsultarEncuentro") {
            const modalElement = document.getElementById('modalParticipantes');
            if (modalElement) {
              const modal = new bootstrap.Modal(modalElement);
              modal.show();
            }
          }
        } catch (error) {
          console.error("Error al conseguir participantes: " + error);
        }
    }

    async obtenerNoParticipantes(event) {
        const clickedElement = event.target;
        const row = clickedElement.closest('tr');
        if (!row) return [];
        const codigoEncuentro = row.dataset.encuentroId; 
        try {
          const response = await fetch(`${this.baseUrl}/encuentro/NoParticipantesEncuentro/${codigoEncuentro}`);
          if (!response.ok) {
            throw new Error(`Error en la petición: ${response.status} - ${response.statusText}`);
          }
          const data = await response.json();
          return data;
        } catch (error) {
          console.error('Error al obtener participantes no vinculados:', error);
          throw error;
        }
    }

    async getNoParticipantesEncuentro(event) {
        try {
          const noPart = await this.obtenerNoParticipantes(event);
          const tablaBody = document.querySelector('#tablaParticipantesEncuentro tbody');
          if (!tablaBody) return;

          if (noPart && noPart.length > 0) {
            tablaBody.innerHTML = '';
            noPart.forEach(p => {
              const row = tablaBody.insertRow();
              row.dataset.participanteId = p.id_participante;
              row.dataset.nombre = p.nombre;
              const nombreCell = row.insertCell();
              nombreCell.textContent = p.nombre;
              const cedulaCell = row.insertCell();
              cedulaCell.textContent = p.cedula || 'N/A';
            });
          } else {
            tablaBody.innerHTML = '<tr><td colspan="2">Todos los participantes ya están vinculados.</td></tr>';
          }
        } catch (error) {
          console.error("Error al conseguir no participantes: " + error);
        }
    }

    obtenerDatosParticipante(event) {
        const clickedElement = event.target;
        const row = clickedElement.closest('tr');
        if (!row) return;
        const codigoParticipante = row.dataset.participanteId;
        const cells = row.querySelectorAll('td'); 
        if (document.getElementById('nombreParticipante')) {
            document.getElementById('nombreParticipante').value = row.dataset.nombre || cells[0].textContent.trim();
        }
        if (document.getElementById('cedulaParticipante') && cells.length > 1) {
            document.getElementById('cedulaParticipante').value = cells[1].textContent.trim();
        }
        this.guardarValorEnCookie('IdParticipante', codigoParticipante);
    }

    async agregarParticipanteEncuentro() {
        const encuentro = this.getCookie('CodigoEncuentro');
        const participante = this.getCookie('IdParticipante');
        if (!encuentro || !participante) {
            Notifications.warning('Debe seleccionar un participante y un Encuentro');
            return;
        }
        try {
            const res = await fetch(`${this.baseUrl}/encuentro/InsertarParticipanteEncuentro`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    encuentro: encuentro,
                    participante: participante
                })
            });
            const data = await res.json();
            if (res.ok) {
                Notifications.success("Participante vinculado con éxito al encuentro");
            } else {
                throw new Error(data.error || 'Error al vincular participante');
            }
        } catch (error) {
            Notifications.error('Error al insertar el participante: ' + error.message);
        }
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

    async importarExcelEncuentroApi(formData) {
        try {
          const response = await fetch(`${this.baseUrl}/encuentro/ImportarExcelEncuentro`, {
            method: 'POST',
            body: formData,
          });

          const data = await response.json();

          if (!response.ok && response.status !== 207) {
            throw new Error(data.error || `Error HTTP: ${response.status}`);
          }

          return data;
        } catch (error) {
          console.error('Error en importarExcelEncuentroApi:', error);
          throw error;
        }
    }
}

export { Request_Encuentro };
