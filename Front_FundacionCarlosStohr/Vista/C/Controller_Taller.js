
import { Request_Taller } from "../Modelo/Request/Request_Taller.js"; // Ajusta la ruta
import { Notifications } from "../Modelo/Utils/Notifications.js";


(function() {
    const R_T = new Request_Taller(); // Instancia de Request_Taller

    const bodyId = document.body.id;

    switch (bodyId) {
        case 'BodyConsultarTaller': // Para la página de consultar talleres
            R_T.CargarTalleres();
            const tablaTalleresBody=document.querySelector('#tablaTalleres tbody');
            if(tablaTalleresBody){
                tablaTalleresBody.addEventListener('click', function(event){
                    R_T.getParticipantesTaller(event);
                })
            }
            const btnCopiarTaller = document.getElementById('botonCopiarCorreosTaller');
            if (btnCopiarTaller) {
                btnCopiarTaller.addEventListener('click', async function() {
                    await R_T.copiarCorreosTaller();
                });
            }
            break;

        case 'BodyAgregarTaller': // Para la página de agregar talleres
            document.addEventListener('DOMContentLoaded', function() {
                const botonAgregarTaller = document.getElementById('agregarTaller'); 
                if (botonAgregarTaller) {
                    botonAgregarTaller.addEventListener('click', async function() {
                        const nuevoTaller = R_T.GetFormulario();
                        if (nuevoTaller.nombre && nuevoTaller.fecha) { // Validación básica
                            await R_T.InsertarTaller(nuevoTaller);
                        } else {
                            Notifications.warning("Por favor, complete los campos obligatorios (nombre y fecha).");
                        }
                    });
                }
            });
            break;

        case 'BodyModificarTaller': // Para la página de modificar talleres
            R_T.CargarTalleres(); // Carga talleres para listarlos y permitir selección

            document.addEventListener('DOMContentLoaded', function() {
                const tablaTalleresBody = document.querySelector('.table.datatable tbody'); // ID de tu tabla
                if (tablaTalleresBody) {
                    tablaTalleresBody.addEventListener('click', function(event) {
                        R_T.ObtenerDatosTablaTalleres(event); // Llena el formulario con el taller seleccionado
                        R_T.getNoParticipantesTaller(event);
                        document.querySelector('#tablaParticipantesTaller tbody').addEventListener('click', function(event){
                            R_T.obtenerDatosParticipante(event);
                        });
                    });
                }

                const botonModificarTaller = document.getElementById('modificarTaller'); // ID del botón de modificar
                if (botonModificarTaller) {
                    botonModificarTaller.addEventListener('click', async function() {
                        const idTallerAModificar = R_T.getCookie("CodigoTaller");
                        if (!idTallerAModificar){
                            Notifications.warning("Por favor, seleccione un taller de la lista para modificar.");
                            return;
                        }
                        const tallerModificado = R_T.GetFormularioConID(idTallerAModificar); // Obtiene datos del formulario
                        if (tallerModificado.nombre && tallerModificado.fecha) {
                             await R_T.actualizarTaller(tallerModificado);
                            // Opcional: Limpiar formulario o recargar datos
                        } else {
                            Notifications.warning("Por favor, complete los campos obligatorios (nombre y fecha).");
                        }
                    });
                }
            });

            document.addEventListener('DOMContentLoaded', function() {
                const botonAgregarTaller = document.getElementById('agregarParticipanteTaller');
                botonAgregarTaller.addEventListener('click', async function() {
                    const confirmed = await Notifications.confirm("¿Seguro que desea agregar este participante al taller?");
                    if(confirmed){
                        R_T.agregarParticipanteTaller();
                    }
                });
            });
            break;

        case 'BodyEliminarTaller': // Para la página de eliminar talleres
            R_T.CargarTalleres(); // Carga talleres para listarlos y permitir selección

            document.addEventListener('DOMContentLoaded', function() {
                const tablaTalleresBody = document.querySelector('.table.datatable tbody'); // ID de tu tabla
                if (tablaTalleresBody) {
                    tablaTalleresBody.addEventListener('click', function(event) {

                        R_T.ObtenerDatosTablaTalleres(event); 

                    });
                }

                const botonEliminarTaller = document.getElementById('eliminarTaller'); // ID del botón de eliminar
                if (botonEliminarTaller) {
                    botonEliminarTaller.addEventListener('click', async function() {
                         R_T.eliminarTaller();

                    });
                }
            });
            break;

        case 'BodyImportarTaller': // Para la página de importar taller desde Excel
            document.addEventListener('DOMContentLoaded', async function() {
                const selectEstado = document.getElementById('estadoDefecto');
                const formImportar = document.getElementById('formImportarTaller');
                const btnImportar = document.getElementById('btnImportarTaller');
                const btnDescargar = document.getElementById('btnDescargarPlantillaTaller');
                const resultContainer = document.getElementById('resultadosImportacion');

                // Descargar plantilla CSV
                if (btnDescargar) {
                    btnDescargar.addEventListener('click', function(e) {
                        e.preventDefault();
                        const headers = "Nombre Completo,Cedula,Fecha Nacimiento,Telefono,Correo Electronico,Zona o Ciudad,Asistencia,Rango de Edad,Observaciones\n";
                        const row1 = "Andrea Cruz,26476982,21/04/1998,04120211818,andreacruz@gmail.com,Libertador,Asistió,Adulto,Conocimiento previo poco\n";
                        const row2 = "Osiris Moreno,4852569,30/01/1959,04120320000,osirismoreno@gmail.com,Libertador,No asistió,Adulto,No respondió mensajes\n";
                        const row3 = "Wilangel Ávila,21090683,15/09/2014,04125394974,home24@gmail.com,El Valle,Asistió,Infantil,\n";
                        
                        const csvContent = "data:text/csv;charset=utf-8,\uFEFF" + encodeURIComponent(headers + row1 + row2 + row3);
                        const link = document.createElement("a");
                        link.setAttribute("href", csvContent);
                        link.setAttribute("download", "plantilla_taller.csv");
                        document.body.appendChild(link);
                        link.click();
                        document.body.removeChild(link);

                        Notifications.success("Plantilla de taller descargada exitosamente.");
                    });
                }

                // Cargar estados en el select
                if (selectEstado) {
                    try {
                        const estados = await R_T.getEstados();
                        const blankOpt = '<option value="">— Sin especificar —</option>';
                        if (estados && estados.length > 0) {
                            selectEstado.innerHTML = blankOpt + estados.map(est =>
                                `<option value="${est.nombre}">${est.nombre}</option>`
                            ).join('');
                        } else {
                            selectEstado.innerHTML = blankOpt;
                        }
                    } catch (e) {
                        selectEstado.innerHTML = '<option value="">— Sin especificar —</option>';
                    }
                }

                // Manejar submit del formulario
                if (formImportar) {
                    formImportar.addEventListener('submit', async function(e) {
                        e.preventDefault();

                        const nombre = document.getElementById('nombreTaller')?.value?.trim();
                        const fecha = document.getElementById('fechaTaller')?.value;
                        const lugar = document.getElementById('lugarTaller')?.value?.trim();
                        const estadoDefecto = selectEstado?.value;
                        const inputArchivo = document.getElementById('archivoExcel');

                        if (!nombre || !fecha) {
                            Notifications.warning("Por favor ingrese el nombre y la fecha del taller.");
                            return;
                        }

                        if (!inputArchivo.files || inputArchivo.files.length === 0) {
                            Notifications.warning("Por favor seleccione un archivo Excel.");
                            return;
                        }

                        const file = inputArchivo.files[0];
                        const formData = new FormData();
                        formData.append('nombre', nombre);
                        formData.append('fecha', fecha);
                        formData.append('lugar', lugar || '');
                        formData.append('estado_defecto', estadoDefecto || '');
                        formData.append('archivo', file);

                        btnImportar.disabled = true;
                        btnImportar.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span> Procesando importación...';

                        try {
                            const response = await R_T.importarExcelTallerApi(formData);
                            
                            if (resultContainer && response.resumen) {
                                const res = response.resumen;
                                const taller = res.taller || {};

                                let html = `
                                <div class="card border-0 shadow-sm" style="border-radius: 16px;">
                                  <div class="card-body p-4">
                                    <div class="d-flex align-items-center justify-content-between mb-3">
                                      <h5 class="fw-bold mb-0"><i class="bi bi-check-circle-fill text-success me-2"></i>Taller Importado con Éxito</h5>
                                      <span class="badge bg-success-light text-success px-3 py-2" style="background:#e8f5e9;">Taller ID #${taller.id_taller || taller.ID_Taller || ''}</span>
                                    </div>
                                    <div class="alert alert-success">
                                      <strong>${taller.nombre || nombre}</strong> — Fecha: <strong>${taller.fecha ? new Date(taller.fecha).toLocaleDateString() : fecha}</strong> ${taller.lugar ? ` | Lugar: <strong>${taller.lugar}</strong>` : ''}
                                    </div>
                                    
                                    <div class="row g-3 mb-4">
                                      <div class="col-md-3">
                                        <div class="card h-100 shadow-sm border-0" style="border-radius: 12px; background: #f8f9fa;">
                                          <div class="card-body p-3 text-center">
                                            <div class="display-6 fw-bold text-primary">${res.vinculados}</div>
                                            <div class="small text-muted text-uppercase fw-semibold mt-1">Total Vinculados</div>
                                          </div>
                                        </div>
                                      </div>
                                      <div class="col-md-3">
                                        <div class="card h-100 shadow-sm border-0" style="border-radius: 12px; background: #f8f9fa;">
                                          <div class="card-body p-3 text-center">
                                            <div class="display-6 fw-bold text-success">${res.insertados}</div>
                                            <div class="small text-muted text-uppercase fw-semibold mt-1">Nuevos Creados</div>
                                          </div>
                                        </div>
                                      </div>
                                      <div class="col-md-3">
                                        <div class="card h-100 shadow-sm border-0" style="border-radius: 12px; background: #f8f9fa;">
                                          <div class="card-body p-3 text-center">
                                            <div class="display-6 fw-bold text-secondary">${res.ya_existian}</div>
                                            <div class="small text-muted text-uppercase fw-semibold mt-1">Ya Existían</div>
                                          </div>
                                        </div>
                                      </div>
                                      <div class="col-md-3">
                                        <div class="card h-100 shadow-sm border-0" style="border-radius: 12px; background: #f8f9fa;">
                                          <div class="card-body p-3 text-center">
                                            <div class="display-6 fw-bold text-danger">${res.omitidos_no_asistieron}</div>
                                            <div class="small text-muted text-uppercase fw-semibold mt-1">Omitidos (No asistieron)</div>
                                          </div>
                                        </div>
                                      </div>
                                    </div>
                                `;

                                // Tabla de errores si existen
                                if (res.errores && res.errores.length > 0) {
                                    html += `
                                    <div class="alert alert-warning mb-3">
                                      <i class="bi bi-exclamation-triangle-fill me-2"></i>Se encontraron advertencias/errores en ${res.errores.length} registros:
                                    </div>
                                    <div class="table-responsive">
                                      <table class="table table-sm table-bordered small">
                                        <thead class="table-light">
                                          <tr>
                                            <th>Fila</th>
                                            <th>Participante</th>
                                            <th>Detalle</th>
                                          </tr>
                                        </thead>
                                        <tbody>`;

                                    res.errores.forEach(err => {
                                        html += `
                                        <tr>
                                          <td>${err.fila}</td>
                                          <td>${err.nombre}</td>
                                          <td class="text-danger">${err.error}</td>
                                        </tr>`;
                                    });

                                    html += `</tbody></table></div>`;
                                }

                                html += `</div></div>`;
                                resultContainer.innerHTML = html;
                                resultContainer.style.display = 'block';
                                resultContainer.scrollIntoView({ behavior: 'smooth' });
                            }

                            Notifications.success("¡Taller importado exitosamente desde Excel!");
                            formImportar.reset();
                        } catch (err) {
                            console.error(err);
                            Notifications.error(`Error en la importación: ${err.message}`);
                        } finally {
                            btnImportar.disabled = false;
                            btnImportar.innerHTML = '<i class="bi bi-cloud-arrow-up me-1"></i> Importar Taller';
                        }
                    });
                }
            });
            break;
    }
})();