import { Request_Exposicion } from "../Modelo/Request/Request_Exposicion.js?v=3";
import { Exposicion } from "../Modelo/Clases/Exposicion.js";
import { Notifications } from "../Modelo/Utils/Notifications.js";

(function () {
  const R_E = new Request_Exposicion();

  switch (document.body.id) {

    /* ─── Consultar exposiciones ─── */
    case 'BodyConsultarExposicion':
      R_E.CargarExposiciones();
      const tablaConsultarBody = document.querySelector('#tablaExposiciones tbody');
      if (tablaConsultarBody) {
        tablaConsultarBody.addEventListener('click', function (event) {
          R_E.getParticipantesExpo(event);
        });
      }
      break;

    /* ─── Agregar exposición ─── */
    case 'BodyAgregarExposicion':
      document.addEventListener('DOMContentLoaded', function () {
        const botonAgregarExposicion = document.getElementById('agregarExposicion');
        if (botonAgregarExposicion) {
          botonAgregarExposicion.addEventListener('click', function () {
            let Expo = R_E.GetFormulario();
            R_E.InsertarExposicion(Expo);
          });
        }
      });
      break;

    /* ─── Modificar exposición ─── */
    case 'BodyModificarExposicion':
      R_E.CargarExposiciones();

      document.addEventListener('DOMContentLoaded', function () {
        const tablaModBody = document.querySelector('.table.datatable tbody');
        if (tablaModBody) {
          tablaModBody.addEventListener('click', function (event) {
            R_E.ObtenerDatosTablaExposiciones(event);
            R_E.getNoParticipantesExpo(event);
            const tablaParticipantes = document.querySelector('#tablaParticipantesExpo tbody');
            if (tablaParticipantes) {
              tablaParticipantes.addEventListener('click', function (event) {
                R_E.obtenerDatosParticipante(event);
              });
            }
          });
        }
      });

      document.addEventListener('DOMContentLoaded', function () {
        const botonModificar = document.getElementById('modificarExposicion');
        if (botonModificar) {
          botonModificar.addEventListener('click', function () {
            let Expo = R_E.GetFormulario();
            R_E.actualizarExposicion(Expo);
          });
        }
      });

      document.addEventListener('DOMContentLoaded', function () {
        const botonAgregarParticipante = document.getElementById('agregarParticipanteExposicion');
        if (botonAgregarParticipante) {
          botonAgregarParticipante.addEventListener('click', async function () {
            const confirmed = await Notifications.confirm("¿Seguro que desea agregar este participante a esta exposición?");
            if (confirmed) { R_E.agregarParticipanteExpo(); }
          });
        }
      });
      break;

    /* ─── Eliminar exposición ─── */
    case 'BodyEliminarExposicion':
      R_E.CargarExposiciones();

      document.addEventListener('DOMContentLoaded', function () {
        const tablaElimBody = document.querySelector('.table.datatable tbody');
        if (tablaElimBody) {
          tablaElimBody.addEventListener('click', function (event) {
            R_E.ObtenerDatosTablaExposiciones(event);
          });
        }
      });

      document.addEventListener('DOMContentLoaded', function () {
        const botonEliminar = document.getElementById('eliminarexpo');
        if (botonEliminar) {
          botonEliminar.addEventListener('click', function () {
            R_E.eliminarExposicion();
          });
        }
      });
      break;

    /* ─── Importar exposición ─── */
    case 'BodyImportarExposicion':
      // Cargar estados en el selector
      R_E.cargarEstados('estadoDefectoExpo');

      // Drag-and-drop zone
      const dropZone = document.getElementById('dropZone');
      const fileInput = document.getElementById('archivoExpoImportar');
      const dropZoneText = document.getElementById('dropZoneText');
      const btnSeleccionar = document.getElementById('btnSeleccionarArchivo');

      if (dropZone && fileInput) {
        btnSeleccionar.addEventListener('click', () => fileInput.click());

        dropZone.addEventListener('click', (e) => {
          if (e.target === dropZone || e.target.tagName === 'P' || e.target.classList.contains('drop-icon')) {
            fileInput.click();
          }
        });

        ['dragenter', 'dragover'].forEach(ev => {
          dropZone.addEventListener(ev, (e) => { e.preventDefault(); dropZone.classList.add('drag-over'); });
        });
        ['dragleave', 'drop'].forEach(ev => {
          dropZone.addEventListener(ev, (e) => { e.preventDefault(); dropZone.classList.remove('drag-over'); });
        });
        dropZone.addEventListener('drop', (e) => {
          const files = e.dataTransfer.files;
          if (files.length > 0) {
            // Asignar el archivo al input
            const dt = new DataTransfer();
            dt.items.add(files[0]);
            fileInput.files = dt.files;
            actualizarDropZone(files[0].name);
          }
        });

        fileInput.addEventListener('change', () => {
          if (fileInput.files.length > 0) {
            actualizarDropZone(fileInput.files[0].name);
          }
        });

        function actualizarDropZone(nombre) {
          dropZone.classList.add('has-file');
          dropZoneText.textContent = `✔ ${nombre}`;
          dropZoneText.style.color = '#2e7d32';
        }
      }

      // Submit del formulario de importación
      const formImportar = document.getElementById('formImportarExposicion');
      if (formImportar) {
        formImportar.addEventListener('submit', async function (e) {
          e.preventDefault();

          const archivo = fileInput?.files[0];
          if (!archivo) {
            Notifications.warning('Por favor selecciona un archivo Excel o Word.');
            return;
          }

          const nombre_expo    = document.getElementById('nombreExpoImportar').value.trim();
          const fecha_expo     = document.getElementById('fechaExpoImportar').value;
          const lugar_expo     = document.getElementById('lugarExpoImportar').value.trim();
          const tipo_expo      = document.getElementById('tipoExpoImportar').value;
          const tema_expo      = document.getElementById('temaExpoImportar').value.trim();
          const estado_defecto = document.getElementById('estadoDefectoExpo')?.value || '';

          if (!nombre_expo || !fecha_expo) {
            Notifications.warning('El nombre y la fecha son obligatorios.');
            return;
          }

          const formData = new FormData();
          formData.append('archivo', archivo);
          formData.append('nombre_expo', nombre_expo);
          formData.append('fecha_expo', fecha_expo);
          formData.append('lugar_expo', lugar_expo);
          formData.append('tipo_expo', tipo_expo);
          formData.append('tema_expo', tema_expo);
          formData.append('estado_defecto', estado_defecto);

          const btnImportar = document.getElementById('btnImportarExposicion');
          if (btnImportar) {
            btnImportar.disabled = true;
            btnImportar.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span> Importando...';
          }

          try {
            const data = await R_E.ImportarExposicion(formData);
            const contenedor = document.getElementById('resultadosImportacion');
            R_E.renderResultadosImportacion(data, contenedor);

            if (data.insertados > 0) {
              Notifications.success(
                `Exposición creada con ${data.insertados} expositor(es)/obra(s) registrado(s).`
              );
            } else if (data.error) {
              Notifications.error(data.error);
            } else {
              Notifications.warning('No se pudieron insertar registros. Revise el archivo.');
            }
          } catch (err) {
            Notifications.error('Error de conexión: ' + err.message);
          } finally {
            if (btnImportar) {
              btnImportar.disabled = false;
              btnImportar.innerHTML = '<i class="bi bi-cloud-arrow-up me-1"></i> Importar Exposición';
            }
          }
        });
      }
      break;
  }
})();