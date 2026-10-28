import { Exposicion } from "../Clases/Exposicion.js";
import { Notifications } from "../Utils/Notifications.js";

const API_BASE = window.API_BASE_URL || 'http://localhost:3002';

class Request_Exposicion {
  async InsertarExposicion(exposicion) {
    await fetch(`${API_BASE}/Exposicion/InsertarExposicion`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        nombre: exposicion.nombre,
        lugar: exposicion.lugar,
        tipo: exposicion.tipo,
        fecha: exposicion.fecha,
        tema: exposicion.tema,
      }),
    })
      .then((response) => response.json())
      .then(() => { Notifications.success("Exposición insertada con éxito"); })
      .catch((error) => { Notifications.error("Error al insertar la exposición: " + error.message); });
  }

  GetFormulario() {
    return new Exposicion(
      document.getElementById("nombreExposicion").value,
      document.getElementById("fechaExposicion").value,
      document.getElementById("lugarExposicion").value,
      document.getElementById("CategoriaExpo").value,
      "",
      document.getElementById("TemaExpo").value
    );
  }

  async CargarExposiciones() {
    try {
      await this.Get_Exposiciones();
    } catch (error) {
      console.error("Error en cargarExposiciones:", error);
      Notifications.error("Error al cargar las exposiciones. Por favor, intente nuevamente.");
      return [];
    }
  }

  async Get_Exposiciones() {
    const response = await fetch(`${API_BASE}/Exposicion/GetExposiciones`);
    if (!response.ok) throw new Error(`${response.status} - ${response.statusText}`);
    const data = await response.json();
    this.listaExposiciones = data.map((d) =>
      new Exposicion(d.nombre, d.fecha, d.lugar, d.tipo, d.id, d.tema)
    );
    this.llenarTablaExposiciones(this.listaExposiciones);
    return this.listaExposiciones;
  }

  llenarTablaExposiciones(listaDeExposiciones) {
    const tablaBody =
      document.querySelector("#tablaExposiciones tbody") ||
      document.querySelector(".table.datatable tbody");
    if (!tablaBody) return;

    if (listaDeExposiciones && listaDeExposiciones.length > 0) {
      tablaBody.innerHTML = "";
      listaDeExposiciones.forEach((exposicion) => {
        const row = tablaBody.insertRow();
        row.dataset.expoId = exposicion.id;
        row.style.cursor = "pointer";
        row.title = "Haz clic para ver los expositores y sus obras";

        const nombreCell = row.insertCell();
        nombreCell.textContent = exposicion.nombre;

        const lugarCell = row.insertCell();
        lugarCell.textContent = exposicion.lugar || "N/A";

        const fechaCell = row.insertCell();
        fechaCell.textContent = this.formatearFecha(exposicion.fecha);

        const tipoCell = row.insertCell();
        // Badge visual por tipo
        const badge = document.createElement('span');
        badge.textContent = exposicion.tipo || 'N/A';
        badge.className = 'badge rounded-pill';
        if ((exposicion.tipo || '').toLowerCase() === 'individual') {
          badge.style.cssText = 'background:#fce4ec;color:#880e4f;font-weight:600;font-size:0.78rem;padding:4px 10px;';
        } else {
          badge.style.cssText = 'background:#e3f2fd;color:#1565c0;font-weight:600;font-size:0.78rem;padding:4px 10px;';
        }
        tipoCell.appendChild(badge);

        const temaCell = row.insertCell();
        temaCell.textContent = exposicion.tema || "N/A";
      });

      if (typeof window.reinitTableSorter === 'function') {
        setTimeout(() => window.reinitTableSorter(), 100);
      }
    } else if (tablaBody) {
      tablaBody.innerHTML = '<tr><td colspan="5">No hay exposiciones disponibles.</td></tr>';
      if (document.body.id === "BodyConsultarExposicion") {
        Notifications.info("No hay exposiciones registradas en el sistema.");
      }
    }
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
    const year = date.getUTCFullYear();
    if (year <= 1000) return "No especificada";
    const month = String(date.getUTCMonth() + 1).padStart(2, "0");
    const day = String(date.getUTCDate()).padStart(2, "0");
    return `${day}/${month}/${year}`;
  }

  ObtenerDatosTablaExposiciones(event) {
    const clickedElement = event.target;
    if (clickedElement.tagName === "TD") {
      const row = clickedElement.parentNode;
      const exposicionId = row.dataset.expoId;
      if (row.cells.length === 5) {
        const nombre = row.cells[0].textContent;
        const fechaTexto = row.cells[2].textContent;
        const partesFecha = fechaTexto.split("/");
        const fechaObjeto = new Date(
          parseInt(partesFecha[2]),
          parseInt(partesFecha[1]) - 1,
          parseInt(partesFecha[0])
        );
        const lugar = row.cells[1].textContent;
        const tipo = row.cells[3].textContent;
        const tema = row.cells[4].textContent;
        const exposicionSeleccionada = new Exposicion(nombre, fechaObjeto, lugar, tipo, exposicionId, tema);
        this.guardarValorEnCookie("CodigoExposicion", exposicionId);
        this.llenarFormularioExposicion(exposicionSeleccionada);
      }
    }
  }

  llenarFormularioExposicion(exposicion) {
    const nombreExposicionInput = document.getElementById("nombreExposicion");
    const lugarExposicionInput = document.getElementById("lugarExposicion");
    const fechaExposicionInput = document.getElementById("fechaExposicion");
    const tipoExposicionSelect = document.getElementById("CategoriaExpo");
    const temaExposicionSelect = document.getElementById("TemaExpo");
    const nombreExpoParticipante = document.getElementById("nombreExposicionParticipante");

    if (exposicion) {
      if (nombreExposicionInput) nombreExposicionInput.value = exposicion.nombre || "";
      if (lugarExposicionInput) lugarExposicionInput.value = exposicion.lugar || "";
      if (fechaExposicionInput) fechaExposicionInput.value = this.formatearFechaParaFormatoYYYYmmdd(exposicion.fecha) || "";
      if (tipoExposicionSelect) tipoExposicionSelect.value = exposicion.tipo;
      if (temaExposicionSelect) temaExposicionSelect.value = exposicion.tema;
      if (nombreExpoParticipante) nombreExpoParticipante.value = exposicion.nombre;
    }
  }

  formatearFechaParaFormatoYYYYmmdd(fecha) {
    if (!fecha) return "";
    const date = new Date(fecha);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`;
  }

  guardarValorEnCookie(nombreCookie, valor) {
    const fechaExpiracion = new Date();
    fechaExpiracion.setDate(fechaExpiracion.getDate() + 30);
    document.cookie = `${nombreCookie}=${valor};expires=${fechaExpiracion.toUTCString()};path=/`;
  }

  getCookie(nombre) {
    const nombreEQ = nombre + "=";
    const cookies = document.cookie.split(";");
    for (let i = 0; i < cookies.length; i++) {
      let cookie = cookies[i].trim();
      if (cookie.indexOf(nombreEQ) === 0) return cookie.substring(nombreEQ.length);
    }
    return null;
  }

  async eliminarExposicion() {
    const CodigoExposicion = this.getCookie("CodigoExposicion");
    try {
      const response = await fetch(`${API_BASE}/Exposicion/EliminarExposicion/${CodigoExposicion}`, { method: "DELETE" });
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(`${response.status} - ${errorData.error || response.statusText}`);
      }
      Notifications.success("Exposición eliminada con éxito");
      this.CargarExposiciones();
    } catch (error) {
      Notifications.error(`Error al eliminar la exposición: ${error.message}`);
    }
  }

  async actualizarExposicion(expo) {
    const CodigoExposicion = this.getCookie("CodigoExposicion");
    try {
      const response = await fetch(`${API_BASE}/Exposicion/ModificarExposicion/${CodigoExposicion}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ Nombre: expo.nombre, fecha: expo.fecha, Tipo: expo.tipo, Lugar: expo.lugar, Tema: expo.tema }),
      });
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(`${response.status} - ${errorData.error || response.statusText}`);
      }
      Notifications.success("Exposición modificada con éxito");
      this.CargarExposiciones();
    } catch (error) {
      Notifications.error(`Error al modificar la exposición: ${error.message}`);
    }
  }

  // ─────────────────────────────────────────────────────────
  // Participantes + Obras
  // ─────────────────────────────────────────────────────────

  async obtenerParticipantesExpo(event) {
    const clickedElement = event.target;
    const row = clickedElement.parentNode;
    const codigoExpo = row.dataset.expoId;
    const response = await fetch(`${API_BASE}/Exposicion/ParticipantesExpo/${codigoExpo}`);
    if (response.status === 204) return [];
    if (!response.ok) throw new Error(`${response.status} - ${response.statusText}`);
    const data = await response.json();
    return data.personas || [];
  }

  llenarTablaParticipantesExpo(participantes) {
    const tablaBody = document.querySelector("#tablaParticipantesExpo tbody");
    if (!tablaBody) return;

    if (participantes && participantes.length > 0) {
      tablaBody.innerHTML = "";
      participantes.forEach((p) => {
        const row = tablaBody.insertRow();
        row.dataset.participanteId = p.id;

        const nombreCell = row.insertCell();
        nombreCell.textContent = p.nombre || "—";

        const cedulaCell = row.insertCell();
        cedulaCell.textContent = p.cedula || "N/A";

        const nObraCell = row.insertCell();
        nObraCell.textContent = p.numero_obra ?? "—";
        nObraCell.style.textAlign = 'center';

        const tituloCell = row.insertCell();
        tituloCell.textContent = p.titulo_obra || "—";

        const tecnicaCell = row.insertCell();
        tecnicaCell.textContent = p.tecnica_obra || "—";

        const dimCell = row.insertCell();
        dimCell.textContent = p.dimension_obra || "—";

        const anioCell = row.insertCell();
        anioCell.textContent = p.anio_obra || "—";
        anioCell.style.textAlign = 'center';
      });
    } else if (tablaBody) {
      tablaBody.innerHTML = '<tr><td colspan="7" class="text-center text-muted py-3">Esta exposición no tiene expositores/obras registradas.</td></tr>';
    }
  }

  async getParticipantesExpo(event) {
    try {
      const participantes = await this.obtenerParticipantesExpo(event);
      this.llenarTablaParticipantesExpo(participantes);
      if (document.body.id === "BodyConsultarExposicion") {
        const modalElement = document.getElementById('modalParticipantes');
        if (modalElement) {
          const modal = new bootstrap.Modal(modalElement);
          modal.show();
        }
      }
    } catch (error) {
      console.error("error al conseguir participantes: " + error);
      Notifications.error("No se pudo cargar la información de los expositores.");
    }
  }

  async obtenerNoParticipantes(event) {
    const clickedElement = event.target;
    const row = clickedElement.parentNode;
    const codigoExposicion = row.dataset.expoId;
    const response = await fetch(`${API_BASE}/Exposicion/NoParticipantesExposicion/${codigoExposicion}`);
    if (!response.ok) throw new Error(`${response.status} - ${response.statusText}`);
    const data = await response.json();
    return (data.personas || []).map((d) => ({ id: d.id, nombre: d.nombre, cedula: d.cedula }));
  }

  async getNoParticipantesExpo(event) {
    try {
      this.llenarTablaParticipantesExpo(await this.obtenerNoParticipantes(event));
    } catch (error) {
      console.error("error al conseguir no-participantes: " + error);
    }
  }

  obtenerDatosParticipante(event) {
    const clickedElement = event.target;
    const row = clickedElement.parentNode;
    const codigoParticipante = row.dataset.participanteId;
    const cells = row.querySelectorAll("td");
    const nombreEl = document.getElementById("nombreParticipante");
    const cedulaEl = document.getElementById("cedulaParticipante");
    if (nombreEl) nombreEl.value = cells[0].textContent;
    if (cedulaEl) cedulaEl.value = cells[1].textContent;
    this.guardarValorEnCookie("IdParticipante", codigoParticipante);
  }

  async agregarParticipanteExpo() {
    const exposicion = this.getCookie("CodigoExposicion");
    const participante = this.getCookie("IdParticipante");
    const obra = document.getElementById("obraParticipante")?.value;
    if (!exposicion || !participante) {
      Notifications.warning("Debe seleccionar un participante y una exposición");
      return;
    }
    await fetch(`${API_BASE}/Exposicion/InsertarParticipanteExposicion`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ exposicion, participante, obra: obra || null }),
    })
      .then((r) => r.json())
      .then((data) => {
        if (data.error) { Notifications.error(data.error); return; }
        Notifications.success("Participante insertado con éxito");
      })
      .catch((error) => { Notifications.error("Error al insertar el participante: " + error.message); });
  }

  // ─────────────────────────────────────────────────────────
  // Importar Exposición desde Excel / DOCX
  // ─────────────────────────────────────────────────────────

  async cargarEstados(selectId) {
    try {
      let estados = [];
      try {
        const res = await fetch(`${API_BASE}/Participantes/GetEstados`);
        if (res.ok) {
          const data = await res.json();
          estados = Array.isArray(data) ? data.map(e => typeof e === 'string' ? e : e.nombre) : [];
        }
      } catch (e) { }

      if (!estados.length) {
        estados = [
          'Amazonas','Anzoátegui','Apure','Aragua','Barinas','Bolívar','Carabobo',
          'Cojedes','Delta Amacuro','Distrito Capital','Falcón','Guárico','Lara',
          'Mérida','Miranda','Monagas','Nueva Esparta','Portuguesa','Sucre','Táchira',
          'Trujillo','La Guaira','Yaracuy','Zulia'
        ];
      }

      const select = document.getElementById(selectId);
      if (!select) return;
      select.innerHTML = '<option value="">— Sin especificar —</option>';
      estados.forEach(e => {
        const opt = document.createElement('option');
        opt.value = e;
        opt.textContent = e;
        select.appendChild(opt);
      });
      select.value = '';
    } catch (err) {
      console.warn('No se pudieron cargar estados:', err.message);
      const select = document.getElementById(selectId);
      if (select) {
        select.innerHTML = '<option value="">— Sin especificar —</option>';
      }
    }
  }

  async ImportarExposicion(formData) {
    const res = await fetch(`${API_BASE}/Exposicion/ImportarExposicion`, {
      method: 'POST',
      body: formData,
    });
    return await res.json();
  }

  renderResultadosImportacion(data, contenedor) {
    if (!contenedor) return;
    contenedor.style.display = 'block';

    const hayErrores = data.errores && data.errores.length > 0;
    const todoError = data.insertados === 0 && hayErrores;

    let cls = 'resultado-card';
    if (todoError) cls += ' all-errors';
    else if (hayErrores) cls += ' has-errors';

    let html = `
      <div class="card ${cls} mb-3">
        <div class="card-body">
          <div class="d-flex align-items-center gap-3 mb-3">
            <div style="font-size:2rem;">${todoError ? '❌' : hayErrores ? '⚠️' : '✅'}</div>
            <div>
              <h5 class="mb-0">${data.mensaje || 'Importación completada'}</h5>
              <p class="text-muted mb-0 small">
                Tipo: <strong>${data.tipo || 'N/A'}</strong> &nbsp;|&nbsp;
                Insertados: <strong class="text-success">${data.insertados}</strong> &nbsp;/&nbsp;
                Total detectados: <strong>${data.total}</strong>
                ${hayErrores ? `&nbsp;|&nbsp; Con errores: <strong class="text-danger">${data.errores.length}</strong>` : ''}
              </p>
            </div>
          </div>`;

    if (hayErrores) {
      html += `
          <h6 class="text-danger mt-3"><i class="bi bi-exclamation-triangle me-1"></i>Registros con error:</h6>
          <div class="table-responsive">
            <table class="table table-sm table-bordered" style="font-size:0.83rem;">
              <thead class="table-danger"><tr><th>Nombre / Identificador</th><th>Motivo</th></tr></thead>
              <tbody>
                ${data.errores.map(e => `<tr><td>${e.nombre || '—'}</td><td>${e.motivo}</td></tr>`).join('')}
              </tbody>
            </table>
          </div>`;
    }
    html += `</div></div>`;
    contenedor.innerHTML = html;
  }
}

export { Request_Exposicion };
