// C/Controller_Participantes.js
import { Request_Participante } from "../Modelo/Request/Request_Participantes.js";
import { Notifications } from "../Modelo/Utils/Notifications.js";

const onReady = (fn) => {
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", fn, { once: true });
  } else {
    fn();
  }
};

(function () {
  const bodyId = document.body?.id ?? "";

  switch (bodyId) {
    case "index": {
      const requestParticipante = new Request_Participante();
      window.requestParticipante = requestParticipante;

      onReady(() => {
        document.querySelector("#Boton_Login")?.addEventListener("click", (e) => {
          e.preventDefault();
          e.stopPropagation();
          window.location.href = "Principal.html";
        });
      });
      break;
    }

    case "BodyConsultarParticipante": {
      const Re_P = new Request_Participante();
      window.requestParticipante = Re_P;

      onReady(async () => {
        try {
          await Re_P.cargarParticipantes(); // ✅ aquí se bindea también "Copiar correos"
        } catch (e) {
          console.error(e);
          Notifications?.error?.("No se pudo cargar la lista de participantes.");
        }

        // Click en tabla: botón "Ver participaciones" abre el modal
        const tablaBody = document.querySelector("#tbody-participantes");
        tablaBody?.addEventListener("click", async (event) => {
          // Verificar si el click fue en el botón "Ver" (o algún hijo de él)
          const btnVer = event.target.closest?.(".btn-ver-participaciones");
          if (btnVer) {
            event.stopPropagation();
            const id = btnVer.dataset?.id;
            if (!id) return;
            Re_P.selectedParticipanteId = id;
            await Re_P.abrirModalParticipaciones?.(id);
            return;
          }

          // Comportamiento original: guardar en cookie al hacer click en la fila
          const id = Re_P.ObtenerIdParticipante?.(event);
          if (!id) return;
          Re_P.guardarValorEnCookie?.("User", id);
        });

        // ✅ redundante (doble seguridad): si por alguna razón _ensureConsultarUI no corrió
        // igual el botón se queda bindeado.
        // (ya existe en Request, pero lo dejamos por seguridad)
        const btn = document.getElementById("botonCopiar");
        if (btn && !btn.dataset.bound) {
          btn.dataset.bound = "1";
          btn.addEventListener("click", async (e) => {
            e.preventDefault();
            await Re_P.copiarCorreosMostradosEnLista();
          });
        }
      });

      break;
    }

    case "BodyAgregarParticipante": {
      const R_P = new Request_Participante();

      onReady(() => {
        const btn = document.getElementById("agregarParticipante");
        if (!btn) return;

        btn.addEventListener("click", async (e) => {
          e.preventDefault();
          const nuevo = R_P.get_formulario?.();

          if (nuevo?.nombre && nuevo?.fecha_nacimiento && nuevo?.correo && nuevo?.ciudad && nuevo?.telefono) {
            await R_P.agregarParticipante(nuevo);
          } else {
            Notifications?.warning?.("Por favor, complete los campos obligatorios.");
          }
        });
      });

      break;
    }

    case "BodyEliminarParticipante": {
      const R = new Request_Participante();

      onReady(async () => {
        try {
          await R.cargarParticipantesEliminar();
        } catch (e) {
          console.error(e);
          Notifications?.error?.("No se pudo cargar la lista (Eliminar participante).");
        }

        const tbody =
          document.querySelector("#tablaParticipantes tbody") ||
          document.querySelector(".table.datatable tbody");

        tbody?.addEventListener("click", (event) => {
          R.ObtenerDatosTablaParticipantes?.(event);
        });

        document.getElementById("eliminarParticipante")?.addEventListener("click", async (e) => {
          e.preventDefault();
          try {
            await R.eliminarParticipante();
          } catch (err) {
            console.error(err);
            Notifications?.error?.("No se pudo eliminar el participante.");
          }
        });
      });

      break;
    }

    case "BodyModificarParticipante": {
      const R = new Request_Participante();

      onReady(async () => {
        try {
          await R.cargarParticipantesModificar();
        } catch (e) {
          console.error(e);
          Notifications?.error?.("No se pudo cargar la lista (Modificar participante).");
        }

        try { await R.CargarExposiciones?.(); } catch {}
        try { await R.cargarConcursos?.(); } catch {}
        try { await R.CargarTalleres?.(); } catch {}

        const tbody = document.querySelector("#tablaParticipantes tbody");
        tbody?.addEventListener("click", (event) => {
          R.ObtenerDatosTablaParticipantesModificar?.(event);
        });

        document.getElementById("modificarParticipante")?.addEventListener("click", async (e) => {
          e.preventDefault();
          try {
            await R.actualizarParticipante();
          } catch (err) {
            console.error(err);
            Notifications?.error?.("No se pudo modificar el participante.");
          }
        });

        const show = (id) => {
          ["seccionAgregarAExpo", "seccionAgregarAConcurso", "seccionAgregarATaller"].forEach((sid) => {
            const el = document.getElementById(sid);
            if (el) el.hidden = sid !== id;
          });
        };
        document.getElementById("MostrarAgregarAExpo")?.addEventListener("click", () => show("seccionAgregarAExpo"));
        document.getElementById("MostrarAgregarAConcurso")?.addEventListener("click", () => show("seccionAgregarAConcurso"));
        document.getElementById("MostrarAgregarATaller")?.addEventListener("click", () => show("seccionAgregarATaller"));
      });

      break;
    }

    case "BodyImportarParticipantes": {
      const R = new Request_Participante();
      
      onReady(() => {
        const btnDescargar = document.getElementById("btnDescargarPlantilla");
        const formImportar = document.getElementById("formImportarExcel");
        const btnImportar = document.getElementById("btnImportar");
        const inputArchivo = document.getElementById("archivoExcel");
        const resultContainer = document.getElementById("resultadosImportacion");
        
        if (btnDescargar) {
          btnDescargar.addEventListener("click", (e) => {
            e.preventDefault();
            
            // Create a simple CSV template to download
            const headers = "Nombre,Cedula,Fecha de Nacimiento,Correo,Ciudad,Estado,Instagram,Telefono\n";
            const example1 = "Juan Perez,12345678,1990-01-01,juan@ejemplo.com,Caracas,Distrito Capital,@juan,04141234567\n";
            const example2 = "Maria Garcia,,1985-05-15,maria@ejemplo.com,Valencia,Carabobo,,04241234567\n";
            const csvContent = "data:text/csv;charset=utf-8," + encodeURIComponent(headers + example1 + example2);
            
            const link = document.createElement("a");
            link.setAttribute("href", csvContent);
            link.setAttribute("download", "plantilla_participantes.csv");
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            
            Notifications?.success?.("Plantilla descargada");
          });
        }
        
        if (formImportar) {
          formImportar.addEventListener("submit", async (e) => {
            e.preventDefault();
            
            if (!inputArchivo.files || inputArchivo.files.length === 0) {
              Notifications?.warning?.("Por favor seleccione un archivo Excel.");
              return;
            }
            
            const file = inputArchivo.files[0];
            btnImportar.disabled = true;
            btnImportar.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Importando...';
            
            try {
              const result = await R.importarExcelApi(file);
              
              if (resultContainer) {
                let html = `<div class="alert alert-success">Se insertaron ${result.insertados} participantes de un total de ${result.total}.</div>`;
                
                if (result.errores && result.errores.length > 0) {
                  html += `<div class="alert alert-warning">Se encontraron errores en ${result.errores.length} filas:</div>`;
                  html += `<table class="table table-sm table-bordered">
                            <thead>
                              <tr>
                                <th>Fila</th>
                                <th>Nombre</th>
                                <th>Errores</th>
                              </tr>
                            </thead>
                            <tbody>`;
                  
                  result.errores.forEach(err => {
                    html += `<tr>
                              <td>${err.fila}</td>
                              <td>${err.nombre}</td>
                              <td><ul>${err.errores.map(e => `<li>${e}</li>`).join('')}</ul></td>
                            </tr>`;
                  });
                  
                  html += `</tbody></table>`;
                }
                
                resultContainer.innerHTML = html;
                resultContainer.style.display = "block";
              }
              
              Notifications?.success?.("Proceso de importación finalizado.");
              inputArchivo.value = ""; // clear input
            } catch (err) {
              console.error(err);
              Notifications?.error?.(`Error en la importación: ${err.message}`);
            } finally {
              btnImportar.disabled = false;
              btnImportar.innerText = "Importar";
            }
          });
        }
      });

      break;
    }

    default:
      break;
  }
})();