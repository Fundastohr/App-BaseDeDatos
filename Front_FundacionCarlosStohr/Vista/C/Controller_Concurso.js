import {Request_Concursos} from '../Modelo/Request/Request_Concurso.js'
import { Concurso } from '../Modelo/Clases/Concurso.js';
import { Notifications } from '../Modelo/Utils/Notifications.js';

(function() {

    let RC= new Request_Concursos()
    let Con= new Concurso()

    switch (document.body.id) {

       
       /* Consultar concursos */ 

        case 'BodyConsultarConcurso':
            RC.cargarConcursos();
            const tablaConcursosBody = document.querySelector('#tablaConcursos tbody'); // ID de tu tabla
            if (tablaConcursosBody) {
                tablaConcursosBody.addEventListener('click', function(event) {
                    RC.getParticipantesConcurso(event); 
                });
            }
        break;

        /* Insertar Concursos */ 

        case 'BodyAgregarConcurso':

            document.addEventListener('DOMContentLoaded', function() {
                const botonAgregarConcurso = document.getElementById('agregarConcurso');
                botonAgregarConcurso.addEventListener('click', function() {
                    Con=RC.GetInfoFormularios();
                    RC.InsertarConcurso(Con);
                });
            });
        
        break;

        /* Modificar Concurso*/ 

        case 'BodyModificarConcurso':

            RC.cargarConcursos();

            document.addEventListener('DOMContentLoaded', function() {

                const tablaConcursosBody = document.querySelector('#tablaConcursos tbody');  
                if (tablaConcursosBody) {
                  tablaConcursosBody.addEventListener('click', function(event) {
                    RC.ObtenerDatosTabla(event);
                    RC.getNoParticipantesConcurso(event);
                    document.querySelector('#tablaParticipantesConcurso tbody').addEventListener('click', function(event){
                        RC.obtenerDatosParticipante(event);
                    });
                  })
                };
            })
            
            document.addEventListener('DOMContentLoaded', function() {
                const botonAgregarConcurso = document.getElementById('modificarConcurso');
                botonAgregarConcurso.addEventListener('click', function() {
                    Con=RC.GetInfoFormularios();
                    RC.ModificarConcurso(Con)
                });
            });

            document.addEventListener('DOMContentLoaded', function() {
                const botonAgregarConcurso = document.getElementById('agregarParticipanteConcurso');
                botonAgregarConcurso.addEventListener('click', async function() {
                    const confirmed = await Notifications.confirm("¿Seguro que desea agregar este participante al concurso?");
                    if(confirmed){
                        RC.agregarParticipanteConcurso();
                    }
                });
            });
        
        break;

       /* Eliminar concursos */ 

       case 'BodyEliminarConcurso':

            RC.cargarConcursos();

            document.addEventListener('DOMContentLoaded', function() {

                const tablaConcursosBody = document.querySelector('.table.datatable tbody');  
                if (tablaConcursosBody) {
                  tablaConcursosBody.addEventListener('click', function(event) {
                    RC.ObtenerDatosTabla(event);
                  })
                };
            })

            document.addEventListener('DOMContentLoaded', function() {
                const botonEliminarConcurso = document.getElementById('eliminarConcurso');
                botonEliminarConcurso.addEventListener('click', function() {
                    RC.EliminarConcurso();
                });
            });
   
        break;

        /* Importar Concurso desde Excel */

        case 'BodyImportarConcurso':

            document.addEventListener('DOMContentLoaded', async function() {
                const selectEstado = document.getElementById('estadoDefecto');
                const formImportar = document.getElementById('formImportarConcurso');
                const btnImportar = document.getElementById('btnImportarConcurso');
                const resultContainer = document.getElementById('resultadosImportacion');

                // Cargar estados en el select
                if (selectEstado) {
                    try {
                        const estados = await RC.getEstados();
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

                        const nombre = document.getElementById('nombreConcurso')?.value?.trim();
                        const fecha = document.getElementById('fechaConcurso')?.value;
                        const tema = document.getElementById('temaConcurso')?.value?.trim();
                        const estadoDefecto = selectEstado?.value;
                        const inputArchivo = document.getElementById('archivoExcel');

                        if (!nombre || !fecha) {
                            Notifications.warning("Por favor ingrese el nombre y la fecha del concurso.");
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
                        formData.append('tema', tema || '');
                        formData.append('estado_defecto', estadoDefecto || '');
                        formData.append('archivo', file);

                        btnImportar.disabled = true;
                        btnImportar.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span> Procesando importación...';

                        try {
                            const response = await RC.importarExcelConcursoApi(formData);
                            
                            if (resultContainer && response.resumen) {
                                let totalInsertados = 0;
                                let totalExistian = 0;
                                let totalVinculados = 0;
                                let totalErrores = 0;

                                let cardsHtml = '<div class="row g-3 mb-4">';
                                response.resumen.forEach(item => {
                                    totalInsertados += item.insertados || 0;
                                    totalExistian += item.ya_existian || 0;
                                    totalVinculados += item.vinculados || 0;
                                    totalErrores += item.errores?.length || 0;

                                    cardsHtml += `
                                    <div class="col-md-4">
                                      <div class="card h-100 shadow-sm border-0" style="border-radius: 12px; background: #fff;">
                                        <div class="card-body p-3">
                                          <div class="d-flex align-items-center justify-content-between mb-2">
                                            <h6 class="fw-bold mb-0 text-primary">Categoría: ${item.categoria}</h6>
                                            <span class="badge bg-light text-dark border">ID #${item.concurso_id}</span>
                                          </div>
                                          <div class="small text-muted mb-2">Resumen de registros:</div>
                                          <div class="d-flex justify-content-between small py-1 border-bottom">
                                            <span>Nuevos creados:</span>
                                            <strong class="text-success">${item.insertados}</strong>
                                          </div>
                                          <div class="d-flex justify-content-between small py-1 border-bottom">
                                            <span>Ya existían:</span>
                                            <strong class="text-secondary">${item.ya_existian}</strong>
                                          </div>
                                          <div class="d-flex justify-content-between small py-1">
                                            <span>Total vinculados:</span>
                                            <strong class="text-primary">${item.vinculados}</strong>
                                          </div>
                                        </div>
                                      </div>
                                    </div>`;
                                });
                                cardsHtml += '</div>';

                                let html = `
                                <div class="card border-0 shadow-sm" style="border-radius: 16px;">
                                  <div class="card-body p-4">
                                    <div class="d-flex align-items-center justify-content-between mb-3">
                                      <h5 class="fw-bold mb-0"><i class="bi bi-check-circle-fill text-success me-2"></i>Resultados de la Importación</h5>
                                      <span class="badge bg-success-light text-success px-3 py-2" style="background:#e8f5e9;">${response.resumen.length} Concursos Creados</span>
                                    </div>
                                    <div class="alert alert-success d-flex align-items-center">
                                      <div>
                                        <strong>¡Importación exitosa!</strong> Se procesaron ${totalVinculados} participantes en total (${totalInsertados} nuevos creados en la base de datos, ${totalExistian} ya existentes reconocidos por su cédula).
                                      </div>
                                    </div>
                                    ${cardsHtml}
                                `;

                                // Tabla de errores si existen
                                if (totalErrores > 0) {
                                    html += `
                                    <div class="alert alert-warning mb-3">
                                      <i class="bi bi-exclamation-triangle-fill me-2"></i>Se encontraron errores en ${totalErrores} filas:
                                    </div>
                                    <div class="table-responsive">
                                      <table class="table table-sm table-bordered small">
                                        <thead class="table-light">
                                          <tr>
                                            <th>Categoría</th>
                                            <th>Fila</th>
                                            <th>Participante</th>
                                            <th>Detalle del Error</th>
                                          </tr>
                                        </thead>
                                        <tbody>`;

                                    response.resumen.forEach(item => {
                                        if (item.errores && item.errores.length > 0) {
                                            item.errores.forEach(err => {
                                                html += `
                                                <tr>
                                                  <td><span class="badge bg-secondary">${item.categoria}</span></td>
                                                  <td>${err.fila}</td>
                                                  <td>${err.nombre}</td>
                                                  <td class="text-danger">${err.error}</td>
                                                </tr>`;
                                            });
                                        }
                                    });

                                    html += `</tbody></table></div>`;
                                }

                                html += `</div></div>`;
                                resultContainer.innerHTML = html;
                                resultContainer.style.display = 'block';
                                resultContainer.scrollIntoView({ behavior: 'smooth' });
                            }

                            Notifications.success("¡Concurso importado exitosamente desde Excel!");
                            formImportar.reset();
                            // Restablecer el select al valor por defecto
                            if (selectEstado) {
                                for (let opt of selectEstado.options) {
                                    if (opt.text.toLowerCase().includes('nueva esparta')) {
                                        opt.selected = true;
                                        break;
                                    }
                                }
                            }
                        } catch (err) {
                            console.error(err);
                            Notifications.error(`Error en la importación: ${err.message}`);
                        } finally {
                            btnImportar.disabled = false;
                            btnImportar.innerHTML = '<i class="bi bi-cloud-arrow-up me-1"></i> Importar Concurso';
                        }
                    });
                }
            });

            break;



    }

})();
