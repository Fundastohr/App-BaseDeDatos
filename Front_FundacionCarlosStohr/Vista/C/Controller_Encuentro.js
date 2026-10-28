// File: C/Controller_Encuentro.js

import { Request_Encuentro } from "../Modelo/Request/Request_Encuentro.js";
import { Notifications } from "../Modelo/Utils/Notifications.js";

(function() {
    const R_E = new Request_Encuentro();
    const bodyId = document.body.id;

    switch (bodyId) {
        case 'BodyConsultarEncuentro':
            R_E.CargarEncuentros();
            const tablaEncuentrosBody = document.querySelector('#tablaEncuentros tbody');
            if (tablaEncuentrosBody) {
                tablaEncuentrosBody.addEventListener('click', function(event) {
                    R_E.getParticipantesEncuentro(event);
                });
            }
            const btnCopiarEncuentro = document.getElementById('botonCopiarCorreosEncuentro');
            if (btnCopiarEncuentro) {
                btnCopiarEncuentro.addEventListener('click', async function() {
                    await R_E.copiarCorreosEncuentro();
                });
            }
            break;

        case 'BodyAgregarEncuentro':
            document.addEventListener('DOMContentLoaded', function() {
                const botonAgregar = document.getElementById('agregarEncuentro'); 
                if (botonAgregar) {
                    botonAgregar.addEventListener('click', async function(e) {
                        e.preventDefault();
                        const nuevoEncuentro = R_E.GetFormulario();
                        if (nuevoEncuentro.nombre && nuevoEncuentro.fecha) {
                            await R_E.InsertarEncuentro(nuevoEncuentro);
                            document.getElementById('formAgregarEncuentro')?.reset();
                        } else {
                            Notifications.warning("Por favor, complete los campos obligatorios (nombre y fecha).");
                        }
                    });
                }
            });
            break;

        case 'BodyModificarEncuentro':
            R_E.CargarEncuentros();

            document.addEventListener('DOMContentLoaded', function() {
                const tablaBody = document.querySelector('.table.datatable tbody') || document.querySelector('#tablaEncuentros tbody');
                if (tablaBody) {
                    tablaBody.addEventListener('click', function(event) {
                        R_E.ObtenerDatosTablaEncuentros(event);
                        R_E.getNoParticipantesEncuentro(event);
                    });
                }

                const tablaParticipantes = document.querySelector('#tablaParticipantesEncuentro tbody');
                if (tablaParticipantes) {
                    tablaParticipantes.addEventListener('click', function(event) {
                        R_E.obtenerDatosParticipante(event);
                    });
                }

                const botonModificar = document.getElementById('modificarEncuentro');
                if (botonModificar) {
                    botonModificar.addEventListener('click', async function() {
                        const idEncuentro = R_E.getCookie("CodigoEncuentro");
                        if (!idEncuentro) {
                            Notifications.warning("Por favor, seleccione un encuentro de la lista para modificar.");
                            return;
                        }
                        const modificado = R_E.GetFormularioConID(idEncuentro);
                        if (modificado.nombre && modificado.fecha) {
                            await R_E.actualizarEncuentro(modificado);
                        } else {
                            Notifications.warning("Por favor, complete los campos obligatorios (nombre y fecha).");
                        }
                    });
                }

                const botonAgregarPart = document.getElementById('agregarParticipanteEncuentro');
                if (botonAgregarPart) {
                    botonAgregarPart.addEventListener('click', async function() {
                        const confirmed = await Notifications.confirm("¿Seguro que desea vincular este participante al encuentro?");
                        if (confirmed) {
                            await R_E.agregarParticipanteEncuentro();
                            // refrescar no participantes
                            const rowSel = document.querySelector(`tr[data-encuentro-id="${R_E.getCookie('CodigoEncuentro')}"]`);
                            if (rowSel) {
                                R_E.getNoParticipantesEncuentro({ target: rowSel.querySelector('td') });
                            }
                        }
                    });
                }
            });
            break;

        case 'BodyEliminarEncuentro':
            R_E.CargarEncuentros();

            document.addEventListener('DOMContentLoaded', function() {
                const tablaBody = document.querySelector('.table.datatable tbody') || document.querySelector('#tablaEncuentros tbody');
                if (tablaBody) {
                    tablaBody.addEventListener('click', function(event) {
                        R_E.ObtenerDatosTablaEncuentros(event);
                    });
                }

                const botonEliminar = document.getElementById('eliminarEncuentro');
                if (botonEliminar) {
                    botonEliminar.addEventListener('click', async function() {
                        await R_E.eliminarEncuentro();
                        const form = document.getElementById('formEliminarEncuentro');
                        if (form) form.reset();
                    });
                }
            });
            break;

        case 'BodyImportarEncuentro':
            document.addEventListener('DOMContentLoaded', async function() {
                const selectEstado = document.getElementById('estadoDefecto');
                const formImportar = document.getElementById('formImportarEncuentro');
                const btnImportar = document.getElementById('btnImportarEncuentro');
                const btnDescargar = document.getElementById('btnDescargarPlantillaEncuentro');
                const resultContainer = document.getElementById('resultadosImportacion');

                // Descargar plantilla CSV
                if (btnDescargar) {
                    btnDescargar.addEventListener('click', function(e) {
                        e.preventDefault();
                        const headers = "Marca temporal,Dirección de correo electrónico,Nombre y Apellido,Fecha de Nacimiento,Cédula de Identidad,Teléfono,Correo Electrónico,Municipio donde reside,Rango de edad,Confirmo principios de dibujo\n";
                        const row1 = "2024-08-16 10:30:00,higoas@gmail.com,Hirama Moreno,15/05/1961,5891185,04142850590,mitamoreno12@gmail.com,Libertador,Adulto a partir de 21 años,Sí\n";
                        const row2 = "2024-08-16 10:35:00,osirismoreno569@gmail.com,Osiris Moreno,30/01/1959,4852569,04120320000,osirismoreno569@gmail.com,Libertador,Adulto a partir de 21 años,Sí\n";
                        const row3 = "2024-08-16 10:40:00,sinaigon41@gmail.com,Sina Gonzalez,12/11/2007,34382830,04126006807,sinaigon41@gmail.com,Libertador,Juvenil 16 a 20 años,Sí\n";
                        
                        const csvContent = "data:text/csv;charset=utf-8,\uFEFF" + encodeURIComponent(headers + row1 + row2 + row3);
                        const link = document.createElement("a");
                        link.setAttribute("href", csvContent);
                        link.setAttribute("download", "plantilla_encuentro_dibujo_urbano.csv");
                        document.body.appendChild(link);
                        link.click();
                        document.body.removeChild(link);

                        Notifications.success("Plantilla para encuentro de dibujo urbano descargada exitosamente.");
                    });
                }

                // Cargar estados
                if (selectEstado) {
                    try {
                        const estados = await R_E.getEstados();
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

                // Submit del formulario de importación
                if (formImportar) {
                    formImportar.addEventListener('submit', async function(e) {
                        e.preventDefault();

                        const nombre = document.getElementById('nombreEncuentro')?.value?.trim();
                        const fecha = document.getElementById('fechaEncuentro')?.value;
                        const lugar = document.getElementById('lugarEncuentro')?.value?.trim();
                        const estadoDefecto = selectEstado?.value;
                        const inputArchivo = document.getElementById('archivoExcel');

                        if (!nombre || !fecha) {
                            Notifications.warning("Por favor ingrese el nombre y la fecha del encuentro.");
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
                            const response = await R_E.importarExcelEncuentroApi(formData);
                            
                            if (resultContainer && response.resumen) {
                                const res = response.resumen;
                                const encuentro = res.encuentro || {};

                                let html = `
                                <div class="card border-0 shadow-sm" style="border-radius: 16px;">
                                  <div class="card-body p-4">
                                    <div class="d-flex align-items-center justify-content-between mb-3">
                                      <h5 class="fw-bold mb-0"><i class="bi bi-check-circle-fill text-success me-2"></i>Encuentro Importado con Éxito</h5>
                                      <span class="badge bg-success-light text-success px-3 py-2" style="background:#e8f5e9;">Encuentro ID #${encuentro.id_encuentro || ''}</span>
                                    </div>
                                    <div class="alert alert-success">
                                      <strong>${encuentro.nombre || nombre}</strong> — Fecha: <strong>${encuentro.fecha ? new Date(encuentro.fecha).toLocaleDateString() : fecha}</strong> ${encuentro.lugar ? ` | Lugar: <strong>${encuentro.lugar}</strong>` : ''}
                                    </div>
                                    
                                    <div class="row g-3 mb-4">
                                      <div class="col-md-4">
                                        <div class="card h-100 shadow-sm border-0" style="border-radius: 12px; background: #f8f9fa;">
                                          <div class="card-body p-3 text-center">
                                            <div class="display-6 fw-bold text-primary">${res.vinculados}</div>
                                            <div class="small text-muted text-uppercase fw-semibold mt-1">Total Vinculados</div>
                                          </div>
                                        </div>
                                      </div>
                                      <div class="col-md-4">
                                        <div class="card h-100 shadow-sm border-0" style="border-radius: 12px; background: #f8f9fa;">
                                          <div class="card-body p-3 text-center">
                                            <div class="display-6 fw-bold text-success">${res.insertados}</div>
                                            <div class="small text-muted text-uppercase fw-semibold mt-1">Nuevos Creados</div>
                                          </div>
                                        </div>
                                      </div>
                                      <div class="col-md-4">
                                        <div class="card h-100 shadow-sm border-0" style="border-radius: 12px; background: #f8f9fa;">
                                          <div class="card-body p-3 text-center">
                                            <div class="display-6 fw-bold text-secondary">${res.ya_existian}</div>
                                            <div class="small text-muted text-uppercase fw-semibold mt-1">Ya Existían</div>
                                          </div>
                                        </div>
                                      </div>
                                    </div>
                                `;

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

                            Notifications.success("¡Encuentro de dibujo urbano importado exitosamente desde Excel!");
                            formImportar.reset();
                        } catch (err) {
                            console.error(err);
                            Notifications.error(`Error en la importación: ${err.message}`);
                        } finally {
                            btnImportar.disabled = false;
                            btnImportar.innerHTML = '<i class="bi bi-cloud-arrow-up me-1"></i> Importar Encuentro';
                        }
                    });
                }
            });
            break;
    }
})();
