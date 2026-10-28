/**
 * TableSorter - Utilidad para ordenar tablas automáticamente
 * Soporta: String, Number, Date
 * Orden: Ascendente y Descendente
 */

class TableSorter {
  constructor() {
    this.sortDirection = {}; // Almacena el estado actual
  }

  /**
   * Inicializa el ordenamiento. Puede llamarse múltiples veces
   * de forma segura (no duplicará eventos).
   */
  init() {
    const tables = document.querySelectorAll("table");

    tables.forEach((table, tableIndex) => {
      const tableId = table.id || `table-${tableIndex}`;
      // Inicializar estado si no existe
      if (!this.sortDirection[tableId]) {
        this.sortDirection[tableId] = {};
      }

      const headers = table.querySelectorAll("thead th");

      headers.forEach((header, columnIndex) => {
        // 1. Evitar procesar columnas marcadas como no ordenables
        // 2. Evitar agregar listeners duplicados si ya se inicializó
        if (
          header.hasAttribute("data-no-sort") ||
          header.classList.contains("sortable-initialized")
        ) {
          return;
        }

        // Marcar como inicializado
        header.classList.add("sortable-initialized");
        header.classList.add("sortable");

        // Estilos básicos por JS (aunque se recomienda usar CSS externo)
        header.style.cursor = "pointer";
        header.style.userSelect = "none";
        header.style.position = "relative"; // Para posicionar iconos si es necesario

        // Agregar indicador visual si no existe
        if (!header.querySelector(".sort-indicator")) {
          const indicator = document.createElement("span");
          indicator.className = "sort-indicator";
          // Usamos iconos de Bootstrap (bi) por defecto, pero con fallback visual
          indicator.innerHTML =
            ' <i class="bi bi-arrow-down-up" style="opacity: 0.3; font-size: 0.8em;"></i>';
          header.appendChild(indicator);
        }

        // Agregar evento de clic
        header.addEventListener("click", () => {
          this.sortTable(table, columnIndex, tableId);
        });
      });
    });
  }

  /**
   * Lógica principal de ordenamiento
   */
  sortTable(table, columnIndex, tableId) {
    const tbody = table.querySelector("tbody");
    if (!tbody) return;

    // Convertir NodeList a Array para poder ordenar
    const rows = Array.from(tbody.querySelectorAll("tr"));

    // Alternar dirección
    const currentDir = this.sortDirection[tableId][columnIndex];
    const newDir = currentDir === "asc" ? "desc" : "asc";
    this.sortDirection[tableId][columnIndex] = newDir;

    // Detectar tipo de dato
    // Prioridad: 1. Atributo data-type en el TH, 2. Detección automática del contenido
    const th = table.querySelectorAll("thead th")[columnIndex];
    let type = th.getAttribute("data-type");

    if (!type) {
      // Buscar primera celda no vacía para detectar tipo
      const sampleRow = rows.find((r) => {
        const cell = r.querySelectorAll("td")[columnIndex];
        return cell && cell.textContent.trim() !== "";
      });

      const sampleValue = sampleRow
        ? sampleRow.querySelectorAll("td")[columnIndex].textContent.trim()
        : "";
      type = this.detectDataType(sampleValue);
    }

    // Función de comparación
    rows.sort((rowA, rowB) => {
      const cellA = rowA.querySelectorAll("td")[columnIndex];
      const cellB = rowB.querySelectorAll("td")[columnIndex];

      const valA = cellA ? cellA.textContent.trim() : "";
      const valB = cellB ? cellB.textContent.trim() : "";

      // Manejo de valores vacíos (siempre al final)
      if (valA === "" && valB === "") return 0;
      if (valA === "") return 1;
      if (valB === "") return -1;

      let comparison = 0;

      switch (type) {
        case "number":
          comparison = this.compareNumbers(valA, valB);
          break;
        case "date":
          comparison = this.compareDates(valA, valB);
          break;
        default:
          comparison = this.compareStrings(valA, valB);
          break;
      }

      return newDir === "asc" ? comparison : -comparison;
    });

    // Reconstrucción optimizada del DOM (evita Reflows)
    const fragment = document.createDocumentFragment();
    rows.forEach((row) => fragment.appendChild(row));

    // requestAnimationFrame asegura que el renderizado sea suave
    requestAnimationFrame(() => {
      tbody.appendChild(fragment);
      this.updateSortIndicators(table, columnIndex, newDir);
    });
  }

  // --- Helpers de Tipos ---

  detectDataType(value) {
    if (!value) return "string";

    // Patrones de fecha
    const datePatterns = [
      /^\d{1,2}[\/\-]\d{1,2}[\/\-]\d{4}/, // DD/MM/YYYY o DD-MM-YYYY
      /^\d{4}[\/\-]\d{2}[\/\-]\d{2}/, // YYYY-MM-DD
    ];
    if (
      datePatterns.some((p) => p.test(value)) &&
      !isNaN(Date.parse(value.replace(/-/g, "/")))
    ) {
      // simple check validación
      return "date";
    }

    // Patrón numérico (Soporta moneda "$ 1,200.50" y porcentajes "50%")
    // Elimina espacios, $, %, y separadores de miles comunes para chequear si es número
    const cleanNum = value.replace(/[$,%\s]/g, "");
    if (
      (cleanNum !== "" && !isNaN(parseFloat(cleanNum.replace(",", ".")))) ||
      !isNaN(Number(cleanNum))
    ) {
      return "number";
    }

    return "string";
  }

  // --- Comparadores ---

  compareNumbers(a, b) {
    // Limpia caracteres no numéricos excepto punto y coma (para decimales) y signo menos
    const clean = (val) => {
      // Remover moneda y espacios
      let v = val.replace(/[^0-9.,-]/g, "");
      // Si tiene coma y punto, asumimos que el último es el decimal
      if (v.indexOf(",") > -1 && v.indexOf(".") > -1) {
        if (v.indexOf(",") > v.indexOf(".")) {
          // Formato 1.000,00 (EU/LATAM)
          v = v.replace(/\./g, "").replace(",", ".");
        } else {
          // Formato 1,000.00 (US)
          v = v.replace(/,/g, "");
        }
      } else if (v.indexOf(",") > -1) {
        // Solo comas: si es "1,5" puede ser decimal, si es "1,000" es mil.
        // Estrategia simple: reemplazar coma por punto para JS
        v = v.replace(",", ".");
      }
      return parseFloat(v) || 0;
    };

    return clean(a) - clean(b);
  }

  compareDates(a, b) {
    const dateA = this.parseDate(a);
    const dateB = this.parseDate(b);
    return dateA - dateB;
  }

  parseDate(dateString) {
    // Normalizar separadores
    const ds = dateString.replace(/-/g, "/");
    const parts = ds.split(/[\/\s:]/); // Divide por /, espacio o :

    // Intento de parseo manual para formatos latinos DD/MM/YYYY
    if (parts.length >= 3) {
      // Detectar si el primer número es año (YYYY/MM/DD) o día (DD/MM/YYYY)
      if (parts[0].length === 4) {
        return new Date(ds); // Formato ISO suele funcionar directo
      } else {
        // Asumir DD/MM/YYYY
        // Mes en JS es 0-indexado
        return new Date(parts[2], parts[1] - 1, parts[0]);
      }
    }
    return new Date(ds);
  }

  compareStrings(a, b) {
    return a.localeCompare(b, "es", { sensitivity: "base", numeric: true });
  }

  // --- UI ---

  updateSortIndicators(table, activeIndex, direction) {
    const headers = table.querySelectorAll("thead th");
    headers.forEach((header, index) => {
      const icon = header.querySelector(".sort-indicator i");
      if (!icon) return;

      // Resetear todos
      icon.className = "bi bi-arrow-down-up";
      icon.style.opacity = "0.3";
      header.style.backgroundColor = ""; // Reset background si hubiera

      // Activar el actual
      if (index === activeIndex) {
        icon.style.opacity = "1";
        if (direction === "asc") {
          icon.className = "bi bi-arrow-up";
        } else {
          icon.className = "bi bi-arrow-down";
        }
        // Opcional: Resaltar columna activa
        // header.style.backgroundColor = 'rgba(0,0,0,0.05)';
      }
    });
  }
}

// Inicialización automática
document.addEventListener("DOMContentLoaded", () => {
  window.tableSorter = new TableSorter();
  window.tableSorter.init();
});
