// Modelo/Request/Request_Participantes.js
import { Notifications } from "../Utils/Notifications.js";

export class Request_Participante {
  constructor(options = {}) {
    this.baseUrl = options.baseUrl || window.API_BASE_URL || "http://localhost:3002";

    this.listaParticipantes = [];
    this.selectedParticipanteId = null;

    // Para tablas específicas (si cambias ids a futuro)
    this.tableSelector = options.tableSelector || null;
    this.tbodySelector = options.tbodySelector || null;

    // --- Consultar ---
    this.pageSize = 20;
    this.currentPage = 1;
    this._filteredParticipantes = [];
    this._currentPageItems = [];
    this._consultarUIBound = false;
  }

  // -------------------------
  // Helpers base
  // -------------------------
  _api(path) {
    const base = String(this.baseUrl).replace(/\/+$/, "");
    const p = String(path || "").replace(/^\/+/, "");
    return `${base}/${p}`;
  }

  async _fetchJson(url, opts = {}) {
    const res = await fetch(url, {
      headers: {
        "Content-Type": "application/json",
        ...(opts.headers || {}),
      },
      ...opts,
    });

    const ct = res.headers.get("content-type") || "";
    const isJson = ct.includes("application/json");

    if (!res.ok) {
      let detail = "";
      try {
        if (isJson) {
          const j = await res.json();
          detail = j?.error ? ` - ${j.error}` : (j?.message ? ` - ${j.message}` : "");
        } else {
          const t = await res.text();
          detail = t ? ` - ${t}` : "";
        }
      } catch { }
      throw new Error(`HTTP ${res.status}${detail || ` - ${res.statusText}`}`);
    }

    return isJson ? res.json() : res.text();
  }

  _fmt(v) {
    return v === null || v === undefined ? "" : String(v);
  }

  _toTrimmedOrNull(v) {
    if (v === undefined || v === null) return null;
    const s = String(v).trim();
    return s === "" ? null : s;
  }

  _normalizeText(v) {
    return String(v ?? "")
      .trim()
      .normalize("NFKD")
      .replace(/[\u0300-\u036f]/g, "")
      .toLowerCase();
  }

  _safeSetValue(id, value) {
    const el = document.getElementById(id);
    if (el) el.value = value ?? "";
  }

  _safeSetSelectValueByNormalizedMatch(selectId, rawValue) {
    const el = document.getElementById(selectId);
    if (!el) return;

    const target = this._normalizeText(rawValue);
    if (!target) {
      el.value = "";
      return;
    }

    const opts = Array.from(el.options || []);
    const hit = opts.find((o) => this._normalizeText(o.value) === target);
    if (hit) el.value = hit.value;
    else el.value = rawValue ?? "";
  }

  _formatDateForInput(value) {
    if (!value) return "";
    const str = String(value).split("T")[0].trim();
    if (str.startsWith("1000") || str.startsWith("1899") || str.startsWith("1900")) return "";
    const parts = str.split("-");
    if (parts.length === 3 && parts[0].length === 4) {
      if (parseInt(parts[0], 10) <= 1000) return "";
      return str;
    }
    const d = new Date(value);
    if (Number.isNaN(d.getTime()) || d.getFullYear() <= 1000) return "";
    const pad = (x) => String(x).padStart(2, "0");
    return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`;
  }

  _getIdParticipante(p) {
    return p?.id_participante ?? p?.id ?? null;
  }

  _findParticipanteById(id) {
    if (id === null || id === undefined) return null;
    return (
      this.listaParticipantes.find((x) => String(this._getIdParticipante(x)) === String(id)) ||
      null
    );
  }

  _highlightSelectedRow(tableSelector, tr) {
    if (!tr) return;
    const table = tr.closest("table") || (tableSelector ? document.querySelector(tableSelector) : null);
    if (!table) return;

    table.querySelectorAll("tbody tr").forEach((row) => row.classList.remove("table-active"));
    tr.classList.add("table-active");
  }

  _getTbody({ tableSelector, tbodySelector } = {}) {
    const tbSel = tbodySelector || this.tbodySelector;
    if (tbSel) {
      const el = document.querySelector(tbSel);
      if (el) return el;
    }

    const tSel = tableSelector || this.tableSelector;
    if (tSel) {
      const el = document.querySelector(`${tSel} tbody`);
      if (el) return el;
    }

    return document.querySelector("#tablaParticipantes tbody");
  }

  // -------------------------
  // API
  // -------------------------
  async Get_Participantes() {
    try {
      const data = await this._fetchJson(this._api("Participantes/Getusuarios"));
      this.listaParticipantes = Array.isArray(data) ? data : [];

      // normaliza edad si no viene
      this.listaParticipantes = this.listaParticipantes.map((p) => ({
        ...p,
        edad: Number.isFinite(p?.edad) ? p.edad : this.calcularEdad(p?.fecha_nacimiento),
      }));

      return this.listaParticipantes;
    } catch (e) {
      console.error("Get_Participantes error:", e);
      Notifications?.error?.("No se pudieron cargar los participantes.");
      this.listaParticipantes = [];
      return [];
    }
  }

  async getEstados() {
    try {
      const data = await this._fetchJson(this._api("Participantes/GetEstados"));
      return Array.isArray(data) ? data.map((e) => e.nombre) : [];
    } catch (e) {
      console.error("getEstados error:", e);
      return [];
    }
  }

  async insertarParticipanteApi(payload) {
    return this._fetchJson(this._api("Participantes/InsertarParticipante"), {
      method: "POST",
      body: JSON.stringify(payload),
    });
  }

  async actualizarParticipanteApi(id, payload) {
    return this._fetchJson(this._api(`Participantes/ModificarParticipante/${id}`), {
      method: "PUT",
      body: JSON.stringify(payload),
    });
  }

  async eliminarParticipanteApi(id) {
    return this._fetchJson(this._api(`Participantes/EliminarParticipante/${id}`), {
      method: "DELETE",
    });
  }

  async importarExcelApi(file) {
    const formData = new FormData();
    formData.append("archivo", file);

    const url = this._api("Participantes/ImportarExcel");
    const res = await fetch(url, {
      method: "POST",
      body: formData,
      // No incluir Content-Type, el browser lo setea automáticamente con el boundary
    });

    const ct = res.headers.get("content-type") || "";
    const isJson = ct.includes("application/json");

    if (!res.ok && res.status !== 207) {
      let detail = "";
      try {
        if (isJson) {
          const j = await res.json();
          detail = j?.error ? ` - ${j.error}` : "";
        }
      } catch { }
      throw new Error(`HTTP ${res.status}${detail || ` - ${res.statusText}`}`);
    }

    return isJson ? res.json() : res.text();
  }

  // -------------------------
  // Render tablas Modificar/Eliminar
  // -------------------------
  renderTablaParticipantes(participantes, opts = {}) {
    const tbody = opts.tbody || this._getTbody(opts);
    if (!tbody) return;

    const mode = opts.mode || "auto";
    tbody.innerHTML = "";

    for (const p of participantes) {
      const tr = document.createElement("tr");
      const id = this._getIdParticipante(p);
      if (id !== null) tr.dataset.id_participante = String(id);

      if (mode === "modificar_8cols") {
        const fechaInput = this._formatDateForInput(p?.fecha_nacimiento);

        tr.innerHTML = `
          <td>${this._fmt(p?.nombre)}</td>
          <td>${this._fmt(p?.cedula)}</td>
          <td>${this._fmt(p?.correo)}</td>
          <td hidden>${this._fmt(fechaInput)}</td>
          <td hidden>${this._fmt(p?.ciudad)}</td>
          <td hidden>${this._fmt(p?.instagram)}</td>
          <td hidden>${this._fmt(p?.estado)}</td>
          <td hidden>${this._fmt(p?.telefono)}</td>
        `;
      } else if (mode === "eliminar_3cols") {
        tr.innerHTML = `
          <td>${this._fmt(p?.nombre)}</td>
          <td>${this._fmt(p?.cedula)}</td>
          <td>${this._fmt(p?.correo)}</td>
        `;
      } else {
        tr.innerHTML = `
          <td>${this._fmt(p?.nombre)}</td>
          <td>${this._fmt(p?.cedula)}</td>
          <td>${this._fmt(p?.correo)}</td>
        `;
      }

      tbody.appendChild(tr);
    }
  }

  async cargarParticipantes() {
    // Cargar participantes y estados en paralelo para mayor velocidad
    await Promise.all([
      this.Get_Participantes(),
      this._poblarEstados(),
    ]);

    if (this._isConsultarPage()) {
      this._ensureConsultarUI(); // bind filtros + paginación + copiar correos
      this.aplicarFiltrosYRenderizar({ resetPage: true });
    }
  }

  /**
   * Obtiene todos los estados desde la API (tabla estado) y genera
   * dinámicamente los checkboxes
   * Siempre muestra los 24 estados aunque no tengan participantes.
   */
  async _poblarEstados() {
    if (!this._isConsultarPage()) return;

    const container = document.getElementById("lista-estados-container");
    if (!container) return;

    const estados = await this.getEstados();
    if (!estados.length) return;

    // Reconstruir el contenido del contenedor
    const estadosHtml = estados
      .map((estado) => {
        const id = "estado-" + estado.toLowerCase().replace(/[^a-z0-9]/g, "-");
        return `
          <div class="form-check estado-item">
            <input class="form-check-input estado-checkbox" type="checkbox" value="${estado}" id="${id}" />
            <label class="form-check-label" for="${id}">${estado}</label>
          </div>`;
      })
      .join("");

    // Opción especial: participantes sin estado asignado
    const sinEstadoHtml = `
      <div class="form-check estado-item mt-1" style="border-top: 1px solid #dee2e6; padding-top: 6px;">
        <input class="form-check-input estado-checkbox" type="checkbox" value="__sin_estado__" id="estado-sin-estado" />
        <label class="form-check-label fst-italic text-secondary" for="estado-sin-estado">Sin estado especificado</label>
      </div>`;

    container.innerHTML = estadosHtml + sinEstadoHtml;

    // Sincronizar estado inicial: el checkbox "Todos" está marcado por defecto,
    // así que los checkboxes individuales deben quedar chequeados y deshabilitados.
    const todosEl = document.getElementById("todos-estados");
    const todosChecked = todosEl ? todosEl.checked : true;
    container.querySelectorAll(".estado-checkbox").forEach((cb) => {
      cb.checked = todosChecked;
      cb.disabled = todosChecked;
    });
  }

  async cargarParticipantesModificar() {
    await this.Get_Participantes();
    this.renderTablaParticipantes(this.listaParticipantes, {
      tableSelector: "#tablaParticipantes",
      mode: "modificar_8cols",
    });
  }

  async cargarParticipantesEliminar() {
    await this.Get_Participantes();
    this.renderTablaParticipantes(this.listaParticipantes, {
      tableSelector: "#tablaParticipantes",
      mode: "eliminar_3cols",
    });
  }

  // -------------------------
  // Click handlers Modificar/Eliminar
  // -------------------------
  ObtenerDatosTablaParticipantesModificar(event) {
    const tr = event?.target?.closest?.("tr");
    const id = tr?.dataset?.id_participante;
    if (!id) return;

    this.selectedParticipanteId = id;
    const p = this._findParticipanteById(id);
    if (!p) return;

    this._highlightSelectedRow("#tablaParticipantes", tr);

    this._safeSetValue("nombreParticipante", p.nombre ?? "");
    this._safeSetValue("cedulaParticipante", p.cedula ?? "");
    this._safeSetValue("correoParticipante", p.correo ?? "");
    this._safeSetValue("nacimientoParticipante", this._formatDateForInput(p.fecha_nacimiento));
    this._safeSetValue("ciudadParticipante", p.ciudad ?? "");
    this._safeSetValue("instagramParticipante", p.instagram ?? "");
    this._safeSetValue("telefonoParticipante", p.telefono ?? "");
    this._safeSetSelectValueByNormalizedMatch("estadoParticipante", p.estado ?? "");
  }

  ObtenerDatosTablaParticipantes(event) {
    const tr = event?.target?.closest?.("tr");
    const id = tr?.dataset?.id_participante;
    if (!id) return;

    this.selectedParticipanteId = id;
    const p = this._findParticipanteById(id);
    if (!p) return;

    this._highlightSelectedRow("#tablaParticipantes", tr);

    this._safeSetValue("nombreParticipante", p.nombre ?? "");
    this._safeSetValue("cedulaParticipante", p.cedula ?? "");
    this._safeSetValue("correoParticipante", p.correo ?? "");
  }

  // -------------------------
  // CRUD
  // -------------------------
  _getPayloadModificarDesdeForm() {
    const v = (id) => document.getElementById(id)?.value ?? "";

    return {
      nombre: String(v("nombreParticipante")).trim(),
      cedula: this._toTrimmedOrNull(v("cedulaParticipante")),
      correo: String(v("correoParticipante")).trim(),
      fecha_nacimiento: v("nacimientoParticipante"),
      ciudad: String(v("ciudadParticipante")).trim(),
      instagram: this._toTrimmedOrNull(v("instagramParticipante")),
      estado: v("estadoParticipante"),
      telefono: String(v("telefonoParticipante")).trim(),
    };
  }

  async actualizarParticipante() {
    const id = this.selectedParticipanteId ? Number(this.selectedParticipanteId) : null;
    if (!id) {
      Notifications?.warning?.("Seleccione un participante de la tabla para modificar.");
      return;
    }

    const payload = this._getPayloadModificarDesdeForm();

    if (!payload.nombre || !payload.fecha_nacimiento || !payload.correo || !payload.ciudad || !payload.telefono) {
      Notifications?.warning?.('Los campos "nombre", "fecha nacimiento", "correo", "ciudad" y "teléfono" son obligatorios.');
      return;
    }


    const ok = (await Notifications?.confirm?.("¿Seguro que desea modificar este participante?")) ?? true;
    if (!ok) return;

    try {
      await this.actualizarParticipanteApi(id, payload);
      Notifications?.success?.("Participante modificado correctamente.");

      await this.cargarParticipantesModificar();
      const p = this._findParticipanteById(id);
      if (p) {
        this._safeSetValue("nombreParticipante", p.nombre ?? "");
        this._safeSetValue("cedulaParticipante", p.cedula ?? "");
        this._safeSetValue("correoParticipante", p.correo ?? "");
        this._safeSetValue("nacimientoParticipante", this._formatDateForInput(p.fecha_nacimiento));
        this._safeSetValue("ciudadParticipante", p.ciudad ?? "");
        this._safeSetValue("instagramParticipante", p.instagram ?? "");
        this._safeSetValue("telefonoParticipante", p.telefono ?? "");
        this._safeSetSelectValueByNormalizedMatch("estadoParticipante", p.estado ?? "");
      }
    } catch (e) {
      console.error(e);
      Notifications?.error?.(`No se pudo modificar el participante. ${e.message || ""}`.trim());
    }
  }

  async eliminarParticipante() {
    const id = this.selectedParticipanteId ? Number(this.selectedParticipanteId) : null;
    if (!id) {
      Notifications?.warning?.("Seleccione un participante de la tabla para eliminar.");
      return;
    }

    const ok = (await Notifications?.confirm?.("¿Seguro que desea eliminar este participante?")) ?? true;
    if (!ok) return;

    try {
      await this.eliminarParticipanteApi(id);
      Notifications?.success?.("Participante eliminado correctamente.");

      this.selectedParticipanteId = null;
      this._safeSetValue("nombreParticipante", "");
      this._safeSetValue("cedulaParticipante", "");
      this._safeSetValue("correoParticipante", "");

      await this.cargarParticipantesEliminar();
    } catch (e) {
      console.error(e);
      Notifications?.error?.(`No se pudo eliminar el participante. ${e.message || ""}`.trim());
    }
  }

  // -------------------------
  // CONSULTAR (tabla + filtros + paginación)
  // -------------------------
  aplicarFiltrosYRenderizar({ resetPage = false } = {}) {
    this.llenarTablaConsultarParticipantes(null, { resetPage });
  }

  llenarTablaConsultarParticipantes(participantes = null, { resetPage = false } = {}) {
    if (!this._isConsultarPage()) return;

    const tbody =
      document.getElementById("tbody-participantes") ||
      document.querySelector("#tablaParticipantes tbody");

    if (!tbody) return;

    this._ensureConsultarUI();

    const lista = Array.isArray(participantes) ? participantes : this.listaParticipantes;
    const filtrados = this._applyConsultarFilters(lista);

    this._filteredParticipantes = filtrados;

    const total = filtrados.length;
    const totalPages = Math.max(1, Math.ceil(total / this.pageSize));

    if (resetPage) this.currentPage = 1;
    if (this.currentPage < 1) this.currentPage = 1;
    if (this.currentPage > totalPages) this.currentPage = totalPages;

    const startIdx = (this.currentPage - 1) * this.pageSize;
    const endIdx = Math.min(startIdx + this.pageSize, total);

    const pagina = filtrados.slice(startIdx, endIdx);
    this._currentPageItems = pagina;

    tbody.innerHTML = "";

    if (pagina.length === 0) {
      tbody.innerHTML = `
        <tr>
          <td colspan="10" class="text-center">No hay participantes para mostrar con los filtros actuales.</td>
        </tr>
      `;
      this._renderPagination({ total, totalPages, startIdx: 0, endIdx: 0 });
      return;
    }

    for (const p of pagina) {
      const tr = document.createElement("tr");
      tr.dataset.id_participante = p?.id_participante ?? "";

      const fecha = this.formatearFecha(p?.fecha_nacimiento);
      const edad = Number.isFinite(p?.edad) ? p.edad : "-";

      tr.innerHTML = `
        <td>${p?.nombre ?? ""}</td>
        <td>${p?.cedula ?? ""}</td>
        <td>${fecha}</td>
        <td>${edad}</td>
        <td>${p?.correo ?? ""}</td>
        <td>${p?.instagram ?? ""}</td>
        <td>${p?.telefono ?? ""}</td>
        <td>${p?.ciudad ?? ""}</td>
        <td>${p?.estado ?? ""}</td>
        <td>
          <button
            class="btn btn-outline-primary btn-sm btn-ver-participaciones"
            data-id="${p?.id_participante ?? ""}"
            data-nombre="${(p?.nombre ?? "").replace(/"/g, '&quot;')}"
            data-cedula="${p?.cedula ?? ""}"
            title="Ver concursos, talleres y exposiciones"
          >
            <i class="bi bi-eye me-1"></i>Ver
          </button>
        </td>
      `;

      tbody.appendChild(tr);
    }

    this._renderPagination({ total, totalPages, startIdx, endIdx });
  }

  _isConsultarPage() {
    return typeof document !== "undefined" && document.body?.id === "BodyConsultarParticipante";
  }

  _getFilterValues() {
    const searchEl = document.getElementById("search-input");
    const edadMinEl = document.getElementById("edad-minima");
    const edadMaxEl = document.getElementById("edad-maxima");

    const edadMinRaw = parseInt(edadMinEl?.value, 10);
    const edadMaxRaw = parseInt(edadMaxEl?.value, 10);

    const edadMin = Number.isFinite(edadMinRaw) ? edadMinRaw : null;
    const edadMax = Number.isFinite(edadMaxRaw) ? edadMaxRaw : null;

    const todosEl = document.getElementById("todos-estados");
    const checks = Array.from(document.querySelectorAll(".estado-checkbox"));

    let estados = null; // null => sin filtro
    if (todosEl && checks.length) {
      const todos = !!todosEl.checked;
      if (!todos) {
        // Mantener '__sin_estado__' como valor especial sin normalizar
        const seleccionados = checks
          .filter((c) => c.checked)
          .map((c) => c.value === "__sin_estado__" ? "__sin_estado__" : this._normalizeText(c.value))
          .filter((v) => v === "__sin_estado__" || v);
        estados = seleccionados.length ? seleccionados : [];
      }
    }

    return {
      search: this._normalizeText(searchEl?.value ?? ""),
      edadMin,
      edadMax,
      estados,
    };
  }

  _applyConsultarFilters(lista) {
    const { search, edadMin, edadMax, estados } = this._getFilterValues();

    return (Array.isArray(lista) ? lista : []).filter((p) => {
      const edad = Number.isFinite(p?.edad) ? p.edad : this.calcularEdad(p?.fecha_nacimiento);
      const estado = this._normalizeText(p?.estado); // cadena vacía si no tiene estado

      if (edadMin !== null && Number.isFinite(edad) && edad < edadMin) return false;
      if (edadMax !== null && Number.isFinite(edad) && edad > edadMax) return false;

      if (Array.isArray(estados)) {
        if (estados.length === 0) return false;

        const sinEstado = estados.includes("__sin_estado__");
        const estadosReales = estados.filter((e) => e !== "__sin_estado__");

        // El participante pasa si:
        //   - Su estado está entre los seleccionados, O
        //   - No tiene estado y la opción "Sin estado" está marcada
        const tieneEstado = !!estado;
        if (!tieneEstado && sinEstado) { /* pasa */ }
        else if (tieneEstado && estadosReales.includes(estado)) { /* pasa */ }
        else return false;
      }

      if (search) {
        const hay = this._normalizeText(
          `${p?.nombre} ${p?.cedula} ${p?.correo} ${p?.instagram} ${p?.telefono} ${p?.ciudad} ${p?.estado}`,
        );
        if (!hay.includes(search)) return false;
      }

      return true;
    });
  }

  _ensureConsultarUI() {
    if (this._consultarUIBound) return;
    this._consultarUIBound = true;

    this._ensurePaginationUI();
    this._bindCopiarCorreosButton();

    const trigger = () => this.aplicarFiltrosYRenderizar({ resetPage: true });
    const debounce = (fn, ms) => {
      let t = null;
      return (...args) => {
        clearTimeout(t);
        t = setTimeout(() => fn(...args), ms);
      };
    };

    const searchEl = document.getElementById("search-input");
    const edadMinEl = document.getElementById("edad-minima");
    const edadMaxEl = document.getElementById("edad-maxima");

    if (searchEl) searchEl.addEventListener("input", debounce(trigger, 120));
    if (edadMinEl) edadMinEl.addEventListener("input", debounce(trigger, 120));
    if (edadMaxEl) edadMaxEl.addEventListener("input", debounce(trigger, 120));

    const todosEl = document.getElementById("todos-estados");
    if (todosEl) todosEl.addEventListener("change", trigger);

    // ✅ Usa event delegation en el contenedor estable para capturar checkboxes
    // generados dinámicamente.
    const container = document.getElementById("lista-estados-container");
    if (container) {
      container.addEventListener("change", (e) => {
        if (e.target.classList.contains("estado-checkbox")) {
          trigger();
        }
      });
    }
  }

  _ensurePaginationUI() {
    const table = document.getElementById("tablaParticipantes");
    if (!table) return;

    let wrap = document.getElementById("participantesPagination");
    if (!wrap) {
      wrap = document.createElement("div");
      wrap.id = "participantesPagination";
      wrap.className = "d-flex flex-wrap gap-2 align-items-center justify-content-between mt-3";
      wrap.innerHTML = `
        <div class="d-flex gap-2">
          <button id="pPrev" type="button" class="btn btn-outline-primary btn-sm">Anterior</button>
          <button id="pNext" type="button" class="btn btn-outline-primary btn-sm">Siguiente</button>
        </div>
        <div id="pInfo" class="small text-muted"></div>
        <div class="d-flex gap-2 align-items-center">
          <span class="small text-muted">Página</span>
          <input id="pPage" type="number" min="1" class="form-control form-control-sm" style="width: 90px;" />
          <button id="pGo" type="button" class="btn btn-primary btn-sm">Ir</button>
        </div>
      `;
      table.parentNode.insertBefore(wrap, table.nextSibling);
    }

    const prev = document.getElementById("pPrev");
    const next = document.getElementById("pNext");
    const page = document.getElementById("pPage");
    const go = document.getElementById("pGo");

    if (prev && !prev.dataset.bound) {
      prev.dataset.bound = "1";
      prev.addEventListener("click", () => {
        this.currentPage = Math.max(1, this.currentPage - 1);
        this.llenarTablaConsultarParticipantes();
      });
    }

    if (next && !next.dataset.bound) {
      next.dataset.bound = "1";
      next.addEventListener("click", () => {
        this.currentPage++;
        this.llenarTablaConsultarParticipantes();
      });
    }

    if (go && !go.dataset.bound) {
      go.dataset.bound = "1";
      go.addEventListener("click", () => {
        const n = parseInt(page?.value, 10);
        if (!Number.isFinite(n) || n < 1) return;
        this.currentPage = n;
        this.llenarTablaConsultarParticipantes();
      });
    }
  }

  _renderPagination({ total, totalPages, startIdx, endIdx }) {
    const prev = document.getElementById("pPrev");
    const next = document.getElementById("pNext");
    const info = document.getElementById("pInfo");
    const page = document.getElementById("pPage");

    if (page) {
      page.value = String(this.currentPage);
      page.max = String(totalPages);
    }

    if (prev) prev.disabled = this.currentPage <= 1;
    if (next) next.disabled = this.currentPage >= totalPages;

    if (info) {
      if (total === 0) info.textContent = `0 resultados`;
      else info.textContent = `Mostrando ${startIdx + 1}-${endIdx} de ${total} • Página ${this.currentPage}/${totalPages}`;
    }
  }

  // ==========================================================
  // ✅ COPIAR CORREOS (NUEVO, ROBUSTO, 100% SEGÚN DOM VISIBLE)
  // ==========================================================
  _bindCopiarCorreosButton() {
    if (!this._isConsultarPage()) return;
    const btn = document.getElementById("botonCopiar");
    if (!btn || btn.dataset.bound === "1") return;

    btn.dataset.bound = "1";
    btn.addEventListener("click", async (e) => {
      e.preventDefault();
      e.stopPropagation();
      await this.copiarCorreosMostradosEnLista();
    });
  }

  async copiarCorreosMostradosEnLista() {
    try {
      const emails = this._obtenerCorreosDesdeFilasVisiblesDOM();

      if (!emails.length) {
        Notifications?.warning?.("No hay correos visibles para copiar.");
        return;
      }

      const texto = emails.join("\n");
      const ok = await this._copyTextToClipboard(texto);

      if (ok) Notifications?.success?.(`¡Copiados ${emails.length} correos!`);
      else Notifications?.error?.("No se pudo copiar (ver consola).");
    } catch (err) {
      console.error("copiarCorreosMostradosEnLista error:", err);
      Notifications?.error?.("No se pudieron copiar los correos.");
    }
  }

  _obtenerCorreosDesdeFilasVisiblesDOM() {
    const table = document.getElementById("tablaParticipantes");
    const tbody =
      document.getElementById("tbody-participantes") ||
      document.querySelector("#tablaParticipantes tbody");

    if (!table || !tbody) return [];

    // 1) Detectar índice real de columna "Correo"
    const ths = Array.from(table.querySelectorAll("thead th"));
    let correoIdx = ths.findIndex((th) => this._normalizeText(th.textContent) === "correo");
    if (correoIdx < 0) {
      // fallback por layout actual: Nombre, Cedula, Fecha, Edad, Correo...
      correoIdx = 4;
    }

    // 2) Iterar filas visibles
    const rows = Array.from(tbody.querySelectorAll("tr"));
    const out = [];
    const seen = new Set();

    const emailRegex = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}/gi;

    for (const tr of rows) {
      // saltar filas ocultas (por filtros visuales o search manual)
      if (tr.hidden) continue;
      const st = window.getComputedStyle(tr);
      if (st && st.display === "none") continue;

      const tds = tr.querySelectorAll("td");
      if (!tds || tds.length === 0) continue;

      const cell = tds[correoIdx];
      const raw = (cell?.textContent ?? "").trim();

      if (!raw) continue;

      // extrae emails aunque haya texto adicional
      const matches = raw.match(emailRegex) || [];
      for (const m of matches) {
        const email = String(m).trim().toLowerCase();
        if (!email) continue;
        if (seen.has(email)) continue;
        seen.add(email);
        out.push(email);
      }
    }

    return out;
  }

  async _copyTextToClipboard(texto) {
    // Clipboard API (si está disponible y en contexto seguro)
    try {
      if (navigator?.clipboard?.writeText && window.isSecureContext) {
        await navigator.clipboard.writeText(texto);
        return true;
      }
    } catch (e) {
      console.warn("Clipboard API falló, usando fallback.", e);
    }

    // Fallback: textarea + execCommand
    try {
      const ta = document.createElement("textarea");
      ta.value = texto;
      ta.setAttribute("readonly", "");
      ta.style.position = "fixed";
      ta.style.left = "-9999px";
      ta.style.top = "0";
      document.body.appendChild(ta);

      ta.focus();
      ta.select();
      const ok = document.execCommand("copy");
      document.body.removeChild(ta);
      return !!ok;
    } catch (e) {
      console.error("Fallback copy falló:", e);
      return false;
    }
  }

  // -------------------------
  // Helpers generales
  // -------------------------
  ObtenerIdParticipante(event) {
    const tr = event?.target?.closest?.("tr");
    return tr?.dataset?.id_participante || null;
  }

  guardarValorEnCookie(nombre, valor) {
    document.cookie = `${encodeURIComponent(nombre)}=${encodeURIComponent(valor)}; path=/`;
  }

  getCookie(nombre) {
    const name = encodeURIComponent(nombre) + "=";
    const parts = document.cookie.split(";").map((c) => c.trim());
    const hit = parts.find((p) => p.startsWith(name));
    if (!hit) return "";
    return decodeURIComponent(hit.substring(name.length));
  }

  calcularEdad(fechaString) {
    if (!fechaString) return NaN;
    const str = String(fechaString).split("T")[0].trim();
    if (str.startsWith("1000") || str.startsWith("1899") || str.startsWith("1900")) return NaN;
    const parts = str.split("-");
    if (parts.length === 3 && parts[0].length === 4) {
      const y = parseInt(parts[0], 10);
      const m = parseInt(parts[1], 10) - 1;
      const d = parseInt(parts[2], 10);
      if (y <= 1000) return NaN;
      const hoy = new Date();
      let edad = hoy.getFullYear() - y;
      const mDiff = hoy.getMonth() - m;
      if (mDiff < 0 || (mDiff === 0 && hoy.getDate() < d)) edad--;
      return edad;
    }
    const hoy = new Date();
    const fn = new Date(fechaString);
    if (Number.isNaN(fn.getTime()) || fn.getFullYear() <= 1000) return NaN;

    let edad = hoy.getFullYear() - fn.getFullYear();
    const m = hoy.getMonth() - fn.getMonth();
    if (m < 0 || (m === 0 && hoy.getDate() < fn.getDate())) edad--;
    return edad;
  }

  formatearFecha(fecha) {
    if (!fecha) return "No especificada";
    const str = String(fecha).split("T")[0].trim();
    if (str.startsWith("1000") || str.startsWith("1899") || str.startsWith("1900")) {
      return "No especificada";
    }
    const parts = str.split("-");
    if (parts.length === 3 && parts[0].length === 4) {
      if (parseInt(parts[0], 10) <= 1000) return "No especificada";
      return `${parts[2]}/${parts[1]}/${parts[0]}`;
    }
    const d = new Date(fecha);
    if (Number.isNaN(d.getTime()) || d.getFullYear() <= 1000) return "No especificada";
    const dd = String(d.getDate()).padStart(2, "0");
    const mm = String(d.getMonth() + 1).padStart(2, "0");
    const yy = d.getFullYear();
    return `${dd}/${mm}/${yy}`;
  }

  // stubs
  async CargarExposiciones() { }
  async cargarConcursos() { }
  async CargarTalleres() { }

  // -------------------------
  // Modal de Participaciones
  // -------------------------

  /**
   * Punto de entrada: abre el modal y carga los datos en paralelo.
   * Puede llamarse pasando directamente el id, o se usará selectedParticipanteId.
   */
  async abrirModalParticipaciones(id) {
    const pid = id ?? this.selectedParticipanteId;
    if (!pid) return;

    const p = this._findParticipanteById(pid);
    const nombre = p?.nombre ?? `Participante #${pid}`;
    const cedula = p?.cedula ? `Cédula: ${p.cedula}` : "";

    // Actualizar encabezado del modal
    const elNombre = document.getElementById("modal-nombre-participante");
    const elCedula = document.getElementById("modal-cedula-participante");
    const elResumen = document.getElementById("modal-resumen-total");
    if (elNombre) elNombre.textContent = nombre;
    if (elCedula) elCedula.textContent = cedula;
    if (elResumen) elResumen.textContent = "";

    // Reset badges
    ["badge-concursos", "badge-talleres", "badge-exposiciones"].forEach((bid) => {
      const el = document.getElementById(bid);
      if (el) el.textContent = "0";
    });

    // Reset spinners en cada contenedor
    const spinnerHtml = (color) => `
      <div class="d-flex justify-content-center py-4">
        <div class="spinner-border text-${color}" role="status">
          <span class="visually-hidden">Cargando...</span>
        </div>
      </div>`;
    const setContenido = (id, html) => {
      const el = document.getElementById(id);
      if (el) el.innerHTML = html;
    };
    setContenido("contenedor-concursos", spinnerHtml("primary"));
    setContenido("contenedor-talleres", spinnerHtml("success"));
    setContenido("contenedor-exposiciones", spinnerHtml("warning"));

    // Abrir el modal (Bootstrap 5)
    const modalEl = document.getElementById("modalParticipaciones");
    if (modalEl) {
      const bsModal = window.bootstrap?.Modal?.getOrCreateInstance?.(modalEl)
        ?? new bootstrap.Modal(modalEl);
      bsModal.show();
    }

    // Cargar los tres grupos en paralelo
    const [concursos, talleres, exposiciones] = await Promise.allSettled([
      this.obtenerParticipanteConcurso(pid),
      this.obtenerParticipanteTaller(pid),
      this.obtenerParticipanteExposicion(pid),
    ]);

    const cnc = concursos.status === "fulfilled" ? concursos.value : [];
    const tal = talleres.status === "fulfilled" ? talleres.value : [];
    const exp = exposiciones.status === "fulfilled" ? exposiciones.value : [];

    // Renderizar
    this._renderConcursosModal(cnc);
    this._renderTalleresModal(tal);
    this._renderExposicionesModal(exp);

    const total = cnc.length + tal.length + exp.length;
    if (elResumen) {
      elResumen.textContent = total > 0
        ? `Total de participaciones: ${total}`
        : "Este participante no tiene participaciones registradas.";
    }
  }

  async obtenerParticipanteConcurso(id) {
    try {
      const data = await this._fetchJson(this._api(`Participantes/ObtenerParticipanteConcurso/${id}`));
      return Array.isArray(data?.concursos) ? data.concursos : [];
    } catch (e) {
      // 404 = sin concursos, no es un error crítico
      if (String(e.message).includes("404")) return [];
      console.warn("obtenerParticipanteConcurso:", e);
      return [];
    }
  }

  async obtenerParticipanteTaller(id) {
    try {
      const data = await this._fetchJson(this._api(`Participantes/ObtenerParticipanteTaller/${id}`));
      return Array.isArray(data?.talleres) ? data.talleres : [];
    } catch (e) {
      if (String(e.message).includes("404") || String(e.message).includes("204")) return [];
      console.warn("obtenerParticipanteTaller:", e);
      return [];
    }
  }

  async obtenerParticipanteExposicion(id) {
    try {
      const data = await this._fetchJson(this._api(`Participantes/ObtenerParticipanteExposicion/${id}`));
      return Array.isArray(data?.exposiciones) ? data.exposiciones : [];
    } catch (e) {
      if (String(e.message).includes("404") || String(e.message).includes("204")) return [];
      console.warn("obtenerParticipanteExposicion:", e);
      return [];
    }
  }

  _formatearFechaLegible(fechaStr) {
    if (!fechaStr) return "—";
    const str = String(fechaStr).split("T")[0].trim();
    if (str.startsWith("1000") || str.startsWith("1899") || str.startsWith("1900")) return "No especificada";
    const parts = str.split("-");
    if (parts.length === 3 && parts[0].length === 4) {
      const year = parseInt(parts[0], 10);
      const month = parseInt(parts[1], 10) - 1;
      const day = parseInt(parts[2], 10);
      if (year <= 1000) return "No especificada";
      const d = new Date(year, month, day);
      return d.toLocaleDateString("es-VE", { year: "numeric", month: "long", day: "numeric" });
    }
    const d = new Date(fechaStr);
    if (isNaN(d.getTime())) return String(fechaStr);
    if (d.getFullYear() <= 1000) return "No especificada";
    return d.toLocaleDateString("es-VE", { year: "numeric", month: "long", day: "numeric" });
  }

  _emptyState(mensaje) {
    return `<div class="empty-state"><i class="bi bi-inbox"></i><p class="mb-0">${mensaje}</p></div>`;
  }

  _renderConcursosModal(concursos) {
    const el = document.getElementById("contenedor-concursos");
    const badge = document.getElementById("badge-concursos");
    if (!el) return;
    if (badge) badge.textContent = String(concursos.length);

    if (!concursos.length) {
      el.innerHTML = this._emptyState("No participó en ningún concurso.");
      return;
    }

    el.innerHTML = concursos.map((c) => {
      const posicion = c.posicion ? `<span><i class="bi bi-award"></i> Posición: <strong>${c.posicion}</strong></span>` : "";
      const mencion = c.mencion ? `<span><i class="bi bi-bookmark-star"></i> Mención: <strong>${c.mencion}</strong></span>` : "";
      const categoria = c.categoria_concurso ? `<span><i class="bi bi-tag"></i> ${c.categoria_concurso}</span>` : "";
      const tema = c.tema_concurso ? `<span><i class="bi bi-chat-quote"></i> ${c.tema_concurso}</span>` : "";
      const fecha = c.fecha_concurso ? `<span><i class="bi bi-calendar3"></i> ${this._formatearFechaLegible(c.fecha_concurso)}</span>` : "";
      return `
        <div class="participacion-card">
          <div class="d-flex align-items-start justify-content-between">
            <div class="card-titulo">${c.nombre_concurso ?? "Concurso"}</div>
            <span class="badge bg-primary badge-tipo">Concurso</span>
          </div>
          <div class="card-meta mt-2">${fecha}${categoria}${tema}${posicion}${mencion}</div>
        </div>`;
    }).join("");
  }

  _renderTalleresModal(talleres) {
    const el = document.getElementById("contenedor-talleres");
    const badge = document.getElementById("badge-talleres");
    if (!el) return;
    if (badge) badge.textContent = String(talleres.length);

    if (!talleres.length) {
      el.innerHTML = this._emptyState("No participó en ningún taller.");
      return;
    }

    el.innerHTML = talleres.map((t) => {
      const fecha = t.fecha_taller ? `<span><i class="bi bi-calendar3"></i> ${this._formatearFechaLegible(t.fecha_taller)}</span>` : "";
      const lugar = t.lugar_taller ? `<span><i class="bi bi-geo-alt"></i> ${t.lugar_taller}</span>` : "";
      return `
        <div class="participacion-card taller">
          <div class="d-flex align-items-start justify-content-between">
            <div class="card-titulo">${t.nombre_taller ?? "Taller"}</div>
            <span class="badge bg-success badge-tipo">Taller</span>
          </div>
          <div class="card-meta mt-2">${fecha}${lugar}</div>
        </div>`;
    }).join("");
  }

  _renderExposicionesModal(exposiciones) {
    const el = document.getElementById("contenedor-exposiciones");
    const badge = document.getElementById("badge-exposiciones");
    if (!el) return;

    if (!exposiciones.length) {
      if (badge) badge.textContent = "0";
      el.innerHTML = this._emptyState("No participó en ninguna exposición.");
      return;
    }

    // ── Group rows by exposicion_id ──────────────────────────────────────────
    const grouped = new Map();
    for (const row of exposiciones) {
      const key = row.exposicion_id;
      if (!grouped.has(key)) {
        grouped.set(key, {
          nombre_exposicion: row.nombre_exposicion,
          fecha_exposicion:  row.fecha_exposicion,
          tipo_exposicion:   row.tipo_exposicion,
          tema_exposicion:   row.tema_exposicion,
          lugar_exposicion:  row.lugar_exposicion,
          obras: [],
        });
      }
      if (row.obra) grouped.get(key).obras.push(row.obra);
    }

    if (badge) badge.textContent = String(grouped.size);

    // ── Render ───────────────────────────────────────────────────────────────
    const cards = [];
    let idx = 0;
    for (const [, g] of grouped) {
      const fecha  = g.fecha_exposicion  ? `<span><i class="bi bi-calendar3"></i> ${this._formatearFechaLegible(g.fecha_exposicion)}</span>` : "";
      const tipo   = g.tipo_exposicion   ? `<span><i class="bi bi-collection"></i> ${g.tipo_exposicion}</span>` : "";
      const tema   = g.tema_exposicion   ? `<span><i class="bi bi-chat-quote"></i> ${g.tema_exposicion}</span>` : "";
      const lugar  = g.lugar_exposicion  ? `<span><i class="bi bi-geo-alt"></i> ${g.lugar_exposicion}</span>` : "";

      // Obras accordion
      let obrasHtml = "";
      if (g.obras.length) {
        const obrasItems = g.obras.map((o) => {
          const dims = (o.ancho && o.alto) ? `${o.ancho} × ${o.alto} cm` : "";
          const tieneDatos = o.titulo || o.tecnica || dims || o.anio || o.tema || o.estilo;

          // Si no hay FK a obra (solo numero_obra en E_P), mostrar aviso informativo
          if (!o.id_obra) {
            return `
              <div class="obra-detalle-item obra-sin-datos">
                <div class="obra-field obra-titulo-obra">
                  <i class="bi bi-image"></i>
                  <strong>Obra N° ${o.numero ?? "—"}</strong>
                </div>
                <div class="obra-field" style="color:#999;font-style:italic;">
                  <i class="bi bi-info-circle"></i> Sin datos adicionales registrados para esta obra.
                </div>
              </div>`;
          }

          return `
            <div class="obra-detalle-item">
              ${o.numero ? `<div class="obra-field"><span class="obra-label">N°</span> ${o.numero}</div>` : ""}
              <div class="obra-field obra-titulo-obra"><i class="bi bi-image"></i> <strong>${o.titulo ?? "Sin título"}</strong></div>
              ${o.tecnica  ? `<div class="obra-field"><span class="obra-label">Técnica:</span> ${o.tecnica}</div>`  : ""}
              ${dims       ? `<div class="obra-field"><span class="obra-label">Dimensiones:</span> ${dims}</div>`   : ""}
              ${o.anio     ? `<div class="obra-field"><span class="obra-label">Año:</span> ${o.anio}</div>`         : ""}
              ${o.tema     ? `<div class="obra-field"><span class="obra-label">Tema:</span> ${o.tema}</div>`        : ""}
              ${o.estilo   ? `<div class="obra-field"><span class="obra-label">Estilo:</span> ${o.estilo}</div>`    : ""}
            </div>`;
        }).join("");

        obrasHtml = `
          <div class="obras-accordion" id="obras-acc-${idx}" style="display:none;">
            <div class="obras-accordion-inner">${obrasItems}</div>
          </div>`;
      }

      const hasObras = g.obras.length > 0;
      const toggleBtn = hasObras
        ? `<button class="btn-toggle-obras" data-target="obras-acc-${idx}" title="Ver obra(s)">
             <i class="bi bi-chevron-down toggle-icon"></i>
             <span>${g.obras.length} obra${g.obras.length > 1 ? "s" : ""}</span>
           </button>`
        : "";

      cards.push(`
        <div class="participacion-card expo${hasObras ? " expo-expandable" : ""}">
          <div class="d-flex align-items-start justify-content-between">
            <div class="card-titulo">${g.nombre_exposicion ?? "Exposición"}</div>
            <span class="badge bg-warning text-dark badge-tipo">Exposición</span>
          </div>
          <div class="card-meta mt-2">${fecha}${tipo}${tema}${lugar}</div>
          ${toggleBtn}
          ${obrasHtml}
        </div>`);
      idx++;
    }

    el.innerHTML = cards.join("");

    // ── Bind toggle clicks ───────────────────────────────────────────────────
    el.querySelectorAll(".btn-toggle-obras").forEach((btn) => {
      btn.addEventListener("click", () => {
        const targetId = btn.dataset.target;
        const acc = document.getElementById(targetId);
        if (!acc) return;
        const icon = btn.querySelector(".toggle-icon");
        const isOpen = acc.style.display !== "none";
        acc.style.display = isOpen ? "none" : "block";
        if (icon) icon.style.transform = isOpen ? "" : "rotate(180deg)";
      });
    });
  }

  // compat agregar
  get_formulario() {
    const v = (id) => document.getElementById(id)?.value ?? "";
    return {
      nombre: v("nombrePersona"),
      cedula: v("Cedula"),
      correo: v("Correo"),
      fecha_nacimiento: v("fechaNacimiento"),
      instagram: v("Instagram"),
      ciudad: v("Ciudad"),
      estado: v("Estado"),
      telefono: v("telefono"),
    };
  }

  async agregarParticipante(payload) {
    try {
      if (!payload?.nombre || !payload?.fecha_nacimiento || !payload?.correo || !payload?.ciudad || !payload?.telefono) {
        Notifications?.warning?.("Complete los campos obligatorios.");
        return;
      }
      await this.insertarParticipanteApi(payload);
      Notifications?.success?.("Participante agregado.");
    } catch (e) {
      console.error(e);
      Notifications?.error?.(`No se pudo agregar el participante. ${e.message || ""}`.trim());
    }
  }
}