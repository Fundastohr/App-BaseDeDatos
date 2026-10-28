// Modelo/Request/Request_Obras.js
import { Notifications } from "../Utils/Notifications.js";

export class Request_Obra {
  constructor(options = {}) {
    this.baseUrl =
      options.baseUrl ||
      window.API_BASE_URL ||
      "http://localhost:3002";

    this.tbodyId = options.tbodyId || "tbody-obras";
    this.tableSelector = options.tableSelector || null;
    this.tbodySelector = options.tbodySelector || null;

    this.debug = Boolean(options.debug);

    this.obras = [];
    this.selectedObraId = null;
  }

  // -------------------------
  // Helpers
  // -------------------------
  _log(...args) {
    if (this.debug) console.debug("[Request_Obra]", ...args);
  }

  _api(path) {
    const base = String(this.baseUrl).replace(/\/+$/, "");
    const p = String(path || "").replace(/^\/+/, "");
    return `${base}/${p}`;
  }

  async _fetchJson(url, opts = {}) {
    const res = await fetch(url, {
      headers: {
        ...(opts.headers || {}),
        ...(opts.body ? { "Content-Type": "application/json" } : {}),
        Accept: "application/json, text/plain, */*",
      },
      ...opts,
    });

    // 204 No Content
    if (res.status === 204) return null;

    const ct = res.headers.get("content-type") || "";
    const isJson = ct.includes("application/json");

    if (!res.ok) {
      let detail = "";
      try {
        if (isJson) {
          const j = await res.json();
          detail = j?.message ? ` - ${j.message}` : (j?.error ? ` - ${j.error}` : "");
        } else {
          const t = await res.text();
          detail = t ? ` - ${t}` : "";
        }
      } catch (_) {}
      throw new Error(`HTTP ${res.status}${detail || ` - ${res.statusText}`}`);
    }

    if (isJson) {
      const text = await res.text();
      if (!text.trim()) return null;
      try {
        return JSON.parse(text);
      } catch {
        return text;
      }
    }

    return res.text();
  }

  _escapeHtml(v) {
    const s = v === null || v === undefined ? "" : String(v);
    return s
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#039;");
  }

  _fmt(v) {
    return v === null || v === undefined ? "" : String(v);
  }

  // ✅ Acepta: 23.5 | 23,5 | 1.234,56 | 1 234,56
  _toNumberOrNull(v) {
    if (v === undefined || v === null) return null;
    let s = String(v).trim();
    if (!s) return null;

    s = s.replace(/\s/g, "");

    if (s.includes(",") && s.includes(".")) {
      // 1.234,56 => 1234.56
      s = s.replace(/\./g, "").replace(",", ".");
    } else {
      // 23,5 => 23.5
      s = s.replace(",", ".");
    }

    const n = Number(s);
    return Number.isFinite(n) ? n : null;
  }

  _toIntOrNull(v) {
    const n = this._toNumberOrNull(v);
    return n === null ? null : Math.trunc(n);
  }

  _toTrimmedOrNull(v) {
    if (v === undefined || v === null) return null;
    const s = String(v).trim();
    return s === "" ? null : s;
  }

  _safeSetValue(id, value) {
    const el = document.getElementById(id);
    if (el) el.value = value ?? "";
  }

  _formatTimestamp(ts) {
    if (!ts) return "";
    const raw = String(ts).trim();
    const iso = raw.includes(" ") && !raw.includes("T") ? raw.replace(" ", "T") : raw;

    const d = new Date(iso);
    if (Number.isNaN(d.getTime())) return raw;

    const pad = (x) => String(x).padStart(2, "0");
    return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(
      d.getHours()
    )}:${pad(d.getMinutes())}`;
  }

  _getTbody({ tableSelector, tbodySelector, tbodyId } = {}) {
    if (tbodySelector) {
      const el = document.querySelector(tbodySelector);
      if (el) return el;
    }

    if (tableSelector) {
      const el = document.querySelector(`${tableSelector} tbody`);
      if (el) return el;
    }

    if (this.tbodySelector) {
      const el = document.querySelector(this.tbodySelector);
      if (el) return el;
    }

    if (this.tableSelector) {
      const el = document.querySelector(`${this.tableSelector} tbody`);
      if (el) return el;
    }

    const id = tbodyId || this.tbodyId;
    return document.getElementById(id);
  }

  _getTableFromTbody(tbody) {
    return tbody?.closest("table") || null;
  }

  _getHeaderColCount(table) {
    const ths = table?.tHead?.rows?.[0]?.cells;
    return ths ? ths.length : 0;
  }

  _getIdObra(o) {
    return o?.id_obra ?? o?.id ?? null;
  }

  _findObraById(id) {
    if (id === null || id === undefined) return null;
    return this.obras.find((x) => String(this._getIdObra(x)) === String(id)) || null;
  }

  _highlightSelectedRow(tableSelector, tr) {
    if (!tr) return;
    const table = tr.closest("table") || document.querySelector(tableSelector);
    if (!table) return;

    table.querySelectorAll("tbody tr").forEach((row) => row.classList.remove("table-active"));
    tr.classList.add("table-active");
  }

  _normalizeObrasResponse(data) {
    if (Array.isArray(data)) return data;

    const candidates = [
      data?.obras,
      data?.data,
      data?.rows,
      data?.result,
      data?.results,
      data?.payload,
    ];

    for (const c of candidates) {
      if (Array.isArray(c)) return c;
    }

    if (Array.isArray(data?.data?.rows)) return data.data.rows;
    if (Array.isArray(data?.data?.obras)) return data.data.obras;

    return [];
  }

  // -------------------------
  // API
  // -------------------------
  async obtenerObras() {
    const raw = await this._fetchJson(this._api("Obras/GetObras"));
    this._log("obtenerObras raw:", raw);
    return this._normalizeObrasResponse(raw);
  }

  async obtenerObra(id) {
    return this._fetchJson(this._api(`Obras/GetObra/${id}`));
  }

  async agregarObra(payload) {
    return this._fetchJson(this._api("Obras/AgregarObra"), {
      method: "POST",
      body: JSON.stringify(payload),
    });
  }

  async actualizarObraApi(id, payload) {
    return this._fetchJson(this._api(`Obras/ActualizarObra/${id}`), {
      method: "PUT",
      body: JSON.stringify(payload),
    });
  }

  async eliminarObraApi(id) {
    return this._fetchJson(this._api(`Obras/EliminarObra/${id}`), {
      method: "DELETE",
    });
  }

  // -------------------------
  // Render
  // -------------------------
  renderTabla(obras, opts = {}) {
    const tbody = opts.tbody || this._getTbody(opts);
    if (!tbody) {
      this._log("renderTabla: tbody no encontrado", opts);
      return;
    }

    const table = this._getTableFromTbody(tbody);
    const headerCols = this._getHeaderColCount(table);

    let mode = opts.mode || "auto";
    if (mode === "auto") {
      if (headerCols >= 13) mode = "consultar_13cols";
      else if (headerCols === 10) mode = "full10";
      else if (headerCols === 5) mode = "lista_modificar_5cols";
      else mode = "mini3";
    }

    tbody.innerHTML = "";

    if (!Array.isArray(obras) || obras.length === 0) {
      const tr = document.createElement("tr");
      const colspan = Math.max(1, headerCols || 1);
      tr.innerHTML = `<td colspan="${colspan}" class="text-center text-muted py-4">No hay obras para mostrar.</td>`;
      tbody.appendChild(tr);
      return;
    }

    for (const o of obras) {
      const tr = document.createElement("tr");
      const id = this._getIdObra(o);
      if (id !== null) tr.dataset.id = String(id);

      if (mode === "lista_modificar_5cols") {
        tr.innerHTML = `
          <td>${this._escapeHtml(this._fmt(o.id_obra))}</td>
          <td>${this._escapeHtml(this._fmt(o.titulo))}</td>
          <td class="text-end">${this._escapeHtml(this._fmt(o.anio))}</td>
          <td>${this._escapeHtml(this._fmt(o.ubicacion))}</td>
          <td>${this._escapeHtml(this._fmt(o.numero_obra))}</td>
        `;
      } else if (mode === "full10") {
        tr.innerHTML = `
          <td>${this._escapeHtml(this._fmt(o.numero_obra))}</td>
          <td>${this._escapeHtml(this._fmt(o.titulo))}</td>
          <td>${this._escapeHtml(this._fmt(o.tecnica))}</td>
          <td class="text-end">${this._escapeHtml(this._fmt(o.ancho))}</td>
          <td class="text-end">${this._escapeHtml(this._fmt(o.alto))}</td>
          <td class="text-end">${this._escapeHtml(this._fmt(o.anio))}</td>
          <td>${this._escapeHtml(this._fmt(o.tema))}</td>
          <td>${this._escapeHtml(this._fmt(o.estilo))}</td>
          <td>${this._escapeHtml(this._fmt(o.ubicacion))}</td>
          <td>${this._escapeHtml(this._fmt(o.observacion))}</td>
        `;
      } else if (mode === "consultar_13cols") {
        tr.innerHTML = `
          <td class="text-end">${this._escapeHtml(this._fmt(o.id_obra))}</td>
          <td>${this._escapeHtml(this._fmt(o.numero_obra))}</td>
          <td>${this._escapeHtml(this._fmt(o.titulo))}</td>
          <td>${this._escapeHtml(this._fmt(o.tecnica))}</td>
          <td class="text-end">${this._escapeHtml(this._fmt(o.ancho))}</td>
          <td class="text-end">${this._escapeHtml(this._fmt(o.alto))}</td>
          <td class="text-end">${this._escapeHtml(this._fmt(o.anio))}</td>
          <td>${this._escapeHtml(this._fmt(o.tema))}</td>
          <td>${this._escapeHtml(this._fmt(o.estilo))}</td>
          <td>${this._escapeHtml(this._fmt(o.ubicacion))}</td>
          <td>${this._escapeHtml(this._fmt(o.observacion))}</td>
          <td>${this._escapeHtml(this._formatTimestamp(o.created_at))}</td>
          <td>${this._escapeHtml(this._formatTimestamp(o.updated_at))}</td>
        `;
      } else {
        tr.innerHTML = `
          <td>${this._escapeHtml(this._fmt(o.id_obra))}</td>
          <td>${this._escapeHtml(this._fmt(o.titulo))}</td>
          <td>${this._escapeHtml(this._fmt(o.ubicacion))}</td>
        `;
      }

      tbody.appendChild(tr);
    }
  }

  async cargarObrasEnTabla(opts = {}) {
    try {
      const arr = await this.obtenerObras();
      this.obras = Array.isArray(arr) ? arr : [];
      this._log("cargarObrasEnTabla normalized length:", this.obras.length);

      this.renderTabla(this.obras, opts);
      return this.obras;
    } catch (e) {
      console.error(e);
      Notifications?.error?.(`No se pudieron cargar las obras. ${e?.message || ""}`.trim());

      try { this.renderTabla([], opts); } catch (_) {}
      return [];
    }
  }

  async cargarObrasModificar() {
    return this.cargarObrasEnTabla({
      tableSelector: "#tablaObrasCSModificar",
      mode: "lista_modificar_5cols",
    });
  }

  async cargarObrasEliminar() {
    return this.cargarObrasEnTabla({
      tableSelector: "#tablaObrasCSEliminar",
      mode: "lista_modificar_5cols",
    });
  }

  // -------------------------
  // Click -> llenar panel (Modificar / Eliminar)
  // -------------------------
  ObtenerDatosTablaObrasModificar(event) {
    const tr = event.target?.closest("tr");
    const id = tr?.dataset?.id;
    if (!id) return;

    this.selectedObraId = id;
    const obra = this._findObraById(id);
    if (!obra) return;

    this._highlightSelectedRow("#tablaObrasCSModificar", tr);

    this._safeSetValue("modificarIdObra", obra.id_obra ?? "");
    this._safeSetValue("modificarNumeroObra", obra.numero_obra ?? "");
    this._safeSetValue("modificarAnioObra", obra.anio ?? "");
    this._safeSetValue("modificarTituloObra", obra.titulo ?? "");
    this._safeSetValue("modificarTecnicaObra", obra.tecnica ?? "");
    this._safeSetValue("modificarAnchoObra", obra.ancho ?? "");
    this._safeSetValue("modificarAltoObra", obra.alto ?? "");
    this._safeSetValue("modificarTemaObra", obra.tema ?? "");
    this._safeSetValue("modificarEstiloObra", obra.estilo ?? "");
    this._safeSetValue("modificarUbicacionObra", obra.ubicacion ?? "");
    this._safeSetValue("modificarObservacionObra", obra.observacion ?? "");

    this._safeSetValue("modificarCreatedAtObra", this._formatTimestamp(obra.created_at));
    this._safeSetValue("modificarUpdatedAtObra", this._formatTimestamp(obra.updated_at));
  }

  ObtenerDatosTablaObrasEliminar(event) {
    const tr = event.target?.closest("tr");
    const id = tr?.dataset?.id;
    if (!id) return;

    this.selectedObraId = id;
    const obra = this._findObraById(id);
    if (!obra) return;

    this._highlightSelectedRow("#tablaObrasCSEliminar", tr);

    this._safeSetValue("eliminarIdObra", obra.id_obra ?? "");
    this._safeSetValue("eliminarNumeroObra", obra.numero_obra ?? "");
    this._safeSetValue("eliminarAnioObra", obra.anio ?? "");
    this._safeSetValue("eliminarTituloObra", obra.titulo ?? "");
    this._safeSetValue("eliminarTecnicaObra", obra.tecnica ?? "");
    this._safeSetValue("eliminarAnchoObra", obra.ancho ?? "");
    this._safeSetValue("eliminarAltoObra", obra.alto ?? "");
    this._safeSetValue("eliminarTemaObra", obra.tema ?? "");
    this._safeSetValue("eliminarEstiloObra", obra.estilo ?? "");
    this._safeSetValue("eliminarUbicacionObra", obra.ubicacion ?? "");
    this._safeSetValue("eliminarObservacionObra", obra.observacion ?? "");
  }

  // -------------------------
  // Payload Modificar
  // -------------------------
  _getPayloadModificarDesdeForm() {
    const idRaw =
      document.getElementById("modificarIdObra")?.value ||
      this.selectedObraId ||
      null;

    const id = idRaw ? Number(idRaw) : null;
    const titulo = document.getElementById("modificarTituloObra")?.value ?? "";

    return {
      id_obra: id,
      numero_obra: this._toTrimmedOrNull(document.getElementById("modificarNumeroObra")?.value),
      titulo: String(titulo).trim(),
      tecnica: this._toTrimmedOrNull(document.getElementById("modificarTecnicaObra")?.value),
      ancho: this._toNumberOrNull(document.getElementById("modificarAnchoObra")?.value),
      alto: this._toNumberOrNull(document.getElementById("modificarAltoObra")?.value),
      anio: this._toIntOrNull(document.getElementById("modificarAnioObra")?.value),
      tema: this._toTrimmedOrNull(document.getElementById("modificarTemaObra")?.value),
      estilo: this._toTrimmedOrNull(document.getElementById("modificarEstiloObra")?.value),
      ubicacion: this._toTrimmedOrNull(document.getElementById("modificarUbicacionObra")?.value),
      observacion: this._toTrimmedOrNull(document.getElementById("modificarObservacionObra")?.value),
    };
  }

  async actualizarObra() {
    const payload = this._getPayloadModificarDesdeForm();
    const id = payload?.id_obra;

    if (!id) {
      Notifications?.warning?.("Seleccione una obra de la tabla para modificar.");
      return;
    }
    if (!payload.titulo) {
      Notifications?.warning?.("El título es obligatorio.");
      return;
    }

    const ok =
      (await Notifications?.confirm?.("¿Seguro que desea modificar esta obra?")) ?? true;
    if (!ok) return;

    try {
      await this.actualizarObraApi(id, payload);
      Notifications?.success?.("Obra modificada correctamente.");

      await this.cargarObrasModificar();

      const obraNueva = this._findObraById(id);
      if (obraNueva) {
        this._safeSetValue("modificarUpdatedAtObra", this._formatTimestamp(obraNueva.updated_at));
      }
    } catch (e) {
      console.error(e);
      Notifications?.error?.(`No se pudo modificar la obra. ${e.message || ""}`.trim());
    }
  }

  async eliminarObra() {
    const idRaw =
      document.getElementById("eliminarIdObra")?.value ||
      this.selectedObraId ||
      null;

    const id = idRaw ? Number(idRaw) : null;

    if (!id) {
      Notifications?.warning?.("Seleccione una obra de la tabla para eliminar.");
      return;
    }

    const ok =
      (await Notifications?.confirm?.("¿Seguro que desea eliminar esta obra?")) ?? true;
    if (!ok) return;

    try {
      await this.eliminarObraApi(id);
      Notifications?.success?.("Obra eliminada correctamente.");
      await this.cargarObrasEliminar();
    } catch (e) {
      console.error(e);
      Notifications?.error?.(`No se pudo eliminar la obra. ${e.message || ""}`.trim());
    }
  }

  // -------------------------
  // Form (Agregar)
  // -------------------------
  get_formulario() {
    const g = (id) => document.getElementById(id);

    const ancho = this._toNumberOrNull(g("ancho")?.value);
    const alto = this._toNumberOrNull(g("alto")?.value);

    return {
      numero_obra: this._toTrimmedOrNull(g("numero_obra")?.value),
      titulo: (g("titulo")?.value ?? "").toString().trim(),
      tecnica: this._toTrimmedOrNull(g("tecnica")?.value),
      ancho: ancho !== null && ancho > 0 ? ancho : null,
      alto: alto !== null && alto > 0 ? alto : null,
      anio: this._toIntOrNull(g("anio")?.value),
      tema: this._toTrimmedOrNull(g("tema")?.value),
      estilo: this._toTrimmedOrNull(g("estilo")?.value),
      ubicacion: this._toTrimmedOrNull(g("ubicacion")?.value),
      observacion: this._toTrimmedOrNull(g("observacion")?.value),
    };
  }
}