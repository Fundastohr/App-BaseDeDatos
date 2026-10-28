const express = require('express');
const { Pool } = require('pg');
const multer = require('multer');
const XLSX = require('xlsx');
const Routes = express.Router();
const Class_Taller = require('../Classes/Class_Taller.js');

const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 10 * 1024 * 1024 },
});


const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT || 5432,
});

/**
 * Convierte un nombre en Title Case (Primera letra de cada palabra en mayúscula, resto en minúscula)
 * Evita que queden nombres completamente en mayúsculas.
 */
function formatearNombre(str) {
  if (!str) return '';
  return String(str)
    .replace(/\xa0/g, ' ')
    .replace(/\s+/g, ' ')
    .trim()
    .toLowerCase()
    .split(' ')
    .map(word => {
      if (!word) return '';
      return word.charAt(0).toUpperCase() + word.slice(1);
    })
    .join(' ');
}

/**
 * Normaliza y estandariza números telefónicos (especialmente celulares y fijos venezolanos):
 * - Quita espacios, caracteres no numéricos y prefijos internacionales (+58 / 58)
 * - Si tiene 10 dígitos y empieza por 4 o 2 (ej. 4242704612), antepone el '0' -> 04242704612
 * - Estandariza todo a formato uniforme de 11 dígitos (ej. 04242704612 / 02121234567)
 */
function normalizarTelefono(raw) {
  if (!raw && raw !== 0) return null;
  const str = String(raw).trim();
  if (!str) return null;

  const lower = str.toLowerCase();
  if (
    lower.includes('no aplica') ||
    lower.includes('n/a') ||
    lower === 'no' ||
    lower === 'ninguno' ||
    lower === '-' ||
    lower === 's/n'
  ) {
    return null;
  }

  let digits = str.replace(/\D/g, '');
  if (!digits) return null;

  // Si empieza con código de Venezuela 58 (ej. 584242704612)
  if (digits.startsWith('58') && (digits.length === 12 || digits.length === 13)) {
    digits = digits.slice(2);
    if (!digits.startsWith('0')) {
      digits = '0' + digits;
    }
  }

  // Si tiene 10 dígitos y empieza por 4 o 2 (ej. 4242704612 -> 04242704612)
  if (digits.length === 10 && (digits.startsWith('4') || digits.startsWith('2'))) {
    digits = '0' + digits;
  }

  if (digits.length >= 7) {
    return digits;
  }

  return null;
}
/**
 * GET /GetTalleres
 * Obtiene todos los talleres.
 */
Routes.get('/GetTalleres', async (req, res) => {
    try {
        const client = await pool.connect();
        const result = await client.query('SELECT * FROM Taller'); // Usar comillas dobles si los nombres de columnas tienen mayúsculas
        const talleresData = result.rows;
        client.release();

        const talleres = talleresData.map(data => {
            return new Class_Taller(
                data.nombre,   // Asegúrate que el case coincida con el nombre de la columna en la BD
                data.fecha,
                data.lugar,
                data.id_taller
            );
        });

        console.log(talleres);
        res.json(talleres);

    } catch (err) {
        console.error('Error al conectar o consultar la base de datos para talleres:', err);
        res.status(500).send('Error al conectar o consultar la base de datos para talleres');
    }
});

/**
 * POST /InsertarTaller
 * Inserta un nuevo taller.
 */
Routes.post('/InsertarTaller', async (req, res) => {
    try {
        const { nombre, fecha, lugar } = req.body; // Usamos minúsculas para las propiedades del body

        console.log('Datos recibidos para insertar taller:', req.body);

        // Validar que los campos obligatorios estén presentes
        if (!nombre || !fecha) {
            return res.status(400).json({
                error: 'Los campos "nombre" y "fecha" son obligatorios.'
            });
        }

        const client = await pool.connect();
        // Usar comillas dobles para nombres de columnas con mayúsculas o casos especiales
        const query = `
            INSERT INTO taller (nombre, fecha, lugar)
            VALUES ($1, $2, $3)
            RETURNING  *;`;

        const values = [
            nombre,
            fecha,
            lugar || null // Si lugar no viene, se inserta null
        ];

        const result = await client.query(query, values);
        client.release();

        // Crear instancia de Class_Taller con los datos retornados
        const tallerInsertadoData = result.rows[0];
        const nuevoTaller = new Class_Taller(
            tallerInsertadoData.Nombre,
            tallerInsertadoData.fecha,
            tallerInsertadoData.Lugar,
            tallerInsertadoData.ID_Taller
        );

        res.status(201).json({
            mensaje: 'Taller insertado exitosamente',
            taller: nuevoTaller
        });
    } catch (err) {
        console.error('Error al insertar el taller:', err);
        res.status(500).json({
            error: 'Error al insertar el taller en la base de datos',
            details: err.message
        });
    }
});

/**
 * DELETE /EliminarTaller/:id_taller
 * Elimina un taller por su ID.
 */
Routes.delete('/EliminarTaller/:id_taller', async (req, res) => {
    const { id_taller } = req.params;

    try {
        console.log(`Intento de eliminar el taller con ID: ${id_taller}`);

        const client = await pool.connect();
        const query = `
            DELETE FROM Taller
            WHERE id_taller = $1
            RETURNING id_taller;`; // PostgreSQL devuelve las columnas de las filas eliminadas

        const result = await client.query(query, [id_taller]);
        client.release();

        if (result.rowCount === 0) {
            return res.status(404).json({ mensaje: `No se encontró ningún taller con el ID: ${id_taller} para eliminar.` });
        }

        res.status(200).json({
            mensaje: `Taller con ID ${id_taller} eliminado exitosamente.`,
            id_taller_eliminado: result.rows[0].ID_Taller
        });

    } catch (err) {
        console.error(`Error al eliminar el taller con ID ${id_taller}:`, err);
        res.status(500).json({
            error: `Error al eliminar el taller con ID ${id_taller} de la base de datos.`,
            details: err.message
        });
    }
});

/**
 * PUT /ModificarTaller/:id_taller
 * Modifica un taller existente por su ID.
 */
Routes.put('/ModificarTaller/:id_taller', async (req, res) => {
    const { id_taller } = req.params;
    const { nombre, fecha, lugar } = req.body; // Usamos minúsculas para las propiedades del body

    try {
        console.log(`Intento de modificar el taller con ID: ${id_taller}`, req.body);

        // Validar que los campos obligatorios estén presentes en el cuerpo
        if (!nombre || !fecha) {
            return res.status(400).json({ error: 'Los campos "nombre" y "fecha" son obligatorios para la modificación.' });
        }

        const client = await pool.connect();
        const query = `
            UPDATE Taller
            SET Nombre = $1,
                fecha = $2,
                Lugar = $3
            WHERE id_taller = $4
            RETURNING id_taller, Nombre, fecha, lugar;
        `;

        const values = [
            nombre,
            fecha,
            lugar || null,
            id_taller
        ];

        const result = await client.query(query, values);
        client.release();

        if (result.rowCount === 0) {
            return res.status(404).json({ mensaje: `No se encontró ningún taller con el ID: ${id_taller}` });
        }
        
        // Crear instancia de Class_Taller con los datos retornados
        const tallerModificadoData = result.rows[0];
        const tallerModificado = new Class_Taller(
            tallerModificadoData.Nombre,
            tallerModificadoData.fecha,
            tallerModificadoData.Lugar,
            tallerModificadoData.ID_Taller
        );

        res.status(200).json({
            mensaje: `Taller con ID ${id_taller} modificado exitosamente`,
            taller: tallerModificado
        });

    } catch (err) {
        console.error(`Error al modificar el taller con ID ${id_taller}:`, err);
        res.status(500).json({
            error: `Error al modificar el taller con ID ${id_taller} en la base de datos`,
            details: err.message
        });
    }
});

Routes.get('/ParticipantesTaller/:idTaller', async (req,res)=>{
    const {idTaller}= req.params;
    if(!idTaller){
      return res.status(400).json({error:'id inválido'});
    }
      try {
        const client= await pool.connect();
        const query=`
          SELECT p.nombre AS nombre_p, p.cedula AS cedula_p, p.id_participante AS id, p.correo AS correo_p
          FROM T_P tp JOIN taller t ON t.id_taller=tp.taller_id
          JOIN participante p ON p.id_participante=tp.participante_id
          WHERE t.id_taller=$1
          GROUP BY p.id_participante, p.nombre, p.cedula, p.correo
          ORDER BY p.nombre ASC;
        `
        const params=[idTaller];
        const result= await client.query(query,params);
        client.release();
        if (result.rowCount === 0) {
          return res.status(204).json({
            mensaje: `No se encontró ningún participante en el taller ID: ${idTaller}`
          });
        }
        res.status(200).json({
          personas: result.rows.map(row => ({
            id: row.id,
            nombre: row.nombre_p,
            cedula: row.cedula_p,
            correo: row.correo_p,
          }))
        });
      } catch (error) {
        res.status(500).json({
          error: `Error al obtener los participantes de la taller con ID ${idTaller} en la base de datos`,
          details: error.message
        });
    }
});

Routes.get('/NoParticipantesTaller/:idTaller', async (req,res)=>{
  const {idTaller}= req.params;
  if(!idTaller){
    return res.status(400).json({error:'id inválido'});
  }
    try {
      const client= await pool.connect();
      const query=`
        SELECT p.nombre AS nombre_p, p.cedula AS cedula_p, p.id_participante AS id
        FROM participante p
        WHERE NOT EXISTS (SELECT * FROM T_P WHERE T_P.participante_id=p.id_participante AND T_P.taller_id=$1);
      `
      const params=[idTaller];
      const result= await client.query(query,params);
      client.release();
      if (result.rowCount === 0) {
        return res.status(204).json({
          mensaje: `No se encontró ningún participante en el taller ID: ${id}`
        });
      }
      res.status(200).json({
        personas: result.rows.map(row => ({
          id: row.id,
          nombre: row.nombre_p,
          cedula: row.cedula_p,
        }))
      });
    } catch (error) {
      res.status(500).json({
        error: `Error al obtener los participantes del taller con ID ${idTaller} en la base de datos`,
        details: error.message
      });
  }
});

Routes.post('/InsertarParticipanteTaller', async(req,res)=>{
  const datos=req.body;
  if(!datos.taller || !datos.participante){
    return res.status(400).json({ error: 'Exposicion o participante inválido' });
  }
  try {
      const client= await pool.connect();
      const query=`
        INSERT INTO T_P(participante_id,taller_id) VALUES ($1,$2)
        RETURNING *;
      `
      const params=[datos.participante, datos.taller];
      const result= await client.query(query,params);
      client.release();
      res.status(201).json({
        mensaje: 'Participante agregado con éxito'
      });
    } catch (error) {
      res.status(500).json({
        error: `Error al insertar el participante en el taller, ${error}`,
        details: error.message
      });
    }
});

// =========================================================
// POST /taller/ImportarExcelTaller
// Importa participantes para un taller desde un archivo Excel.
// Crea el taller (un único taller para todo el archivo) y procesa
// los participantes omitiendo las filas marcadas en rojo o que
// pertenezcan a bloques de no confirmados/no participantes.
// =========================================================
Routes.post('/ImportarExcelTaller', upload.single('archivo'), async (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: 'No se recibió ningún archivo.' });
  }

  const { nombre, fecha, lugar, estado_defecto } = req.body;

  if (!nombre || !fecha) {
    return res.status(400).json({ error: 'Los campos "nombre" y "fecha" son obligatorios.' });
  }

  let workbook;
  try {
    workbook = XLSX.read(req.file.buffer, { type: 'buffer', cellDates: false, cellStyles: true });
  } catch (e) {
    return res.status(400).json({ error: 'El archivo no es un Excel válido.', details: e.message });
  }

  const sheetNames = workbook.SheetNames;
  if (!sheetNames || sheetNames.length === 0) {
    return res.status(400).json({ error: 'El archivo Excel no contiene hojas de datos.' });
  }

  // Normaliza una cédula
  function normalizarCedula(raw) {
    if (!raw && raw !== 0) return null;
    const str = String(raw).trim();
    if (str.toLowerCase().includes('no aplica') || str.toLowerCase().includes('n/a')) return null;
    const clean = str.replace(/\./g, '').replace(/\s/g, '').replace(/^[VvEe]-?/i, '');
    return clean || null;
  }

  // Normaliza encabezados
  const normalizeHeader = (h) =>
    String(h || '')
      .trim()
      .normalize('NFKD')
      .replace(/[\u0300-\u036f]/g, '')
      .toLowerCase();

  // Convierte serial de fecha o string
  function parseFechaNacimiento(raw) {
    if (!raw && raw !== 0) return '2010-01-01';

    const str = String(raw).trim();
    if (str.includes('/')) {
      const parts = str.split('/');
      if (parts.length === 3) {
        const day = parts[0].padStart(2, '0');
        const month = parts[1].padStart(2, '0');
        const year = parts[2].length === 2 ? '20' + parts[2] : parts[2];
        return `${year}-${month}-${day}`;
      }
    }

    const num = parseFloat(raw);
    if (!isNaN(num) && num > 1000 && num < 60000) {
      const msPerDay = 86400000;
      const excelEpoch = new Date(Date.UTC(1899, 11, 30));
      const date = new Date(excelEpoch.getTime() + num * msPerDay);
      if (!isNaN(date.getTime())) {
        return date.toISOString().split('T')[0];
      }
    }

    const date = new Date(raw);
    if (!isNaN(date.getTime())) {
      return date.toISOString().split('T')[0];
    }

    return '2010-01-01';
  }

  const headerAliases = {
    nombre: ['nombre', 'participante', 'nombres', 'nombre completo', 'name'],
    fecha_nacimiento: ['fecha nacimiento', 'fecha de nacimiento', 'fecha_nacimiento', 'nacimiento', 'f. nac', 'f. nacimiento'],
    cedula: ['cedula', 'cédula', 'ci', 'documento', 'identidad', 'dni', 'c.i.', 'c.i'],
    telefono: ['telf', 'telefono', 'teléfono', 'celular', 'tlf', 'movil', 'móvil', 'phone'],
    correo: ['email', 'correo', 'correo electronico', 'correo electrónico', 'mail'],
    ciudad: ['zona donde reside', 'zona donde vive', 'zona o ciudad', 'zona', 'ciudad', 'municipio', 'direccion', 'dirección', 'residencia', 'sector', 'localidad'],
    asistencia: ['asistencia', 'asistio', 'asistió', 'asistencia / estado', 'estado', 'status', 'asistencia?'],
  };

  const client = await pool.connect();

  try {
    // 1. Obtener id_estado por defecto
    let id_estado_defecto = null;
    const estNombre = estado_defecto || 'Distrito Capital';
    const estRes = await client.query(
      'SELECT id_estado FROM estado WHERE UPPER(nombre) = UPPER($1)',
      [estNombre]
    );
    if (estRes.rows.length > 0) {
      id_estado_defecto = estRes.rows[0].id_estado;
    } else {
      const primerEstado = await client.query('SELECT id_estado FROM estado ORDER BY id_estado ASC LIMIT 1');
      if (primerEstado.rows.length > 0) {
        id_estado_defecto = primerEstado.rows[0].id_estado;
      }
    }

    // 2. Crear el Taller
    const tallerRes = await client.query(
      `INSERT INTO taller (nombre, fecha, lugar)
       VALUES ($1, $2, $3)
       RETURNING *`,
      [nombre, fecha, lugar || null]
    );
    const tallerCreado = tallerRes.rows[0];
    const taller_id = tallerCreado.id_taller;

    const participantesNuevosIds = new Set();
    const participantesPreviosIds = new Set();
    const participantesVinculadosIds = new Set();
    const processedDedupeKeys = new Set();

    const resumen = {
      taller: tallerCreado,
      total_procesados: 0,
      insertados: 0,
      ya_existian: 0,
      vinculados: 0,
      omitidos_no_asistieron: 0,
      errores: [],
    };

    // 3. Procesar las hojas del Excel
    for (const sheetName of sheetNames) {
      const ws = workbook.Sheets[sheetName];
      const rows = XLSX.utils.sheet_to_json(ws, { header: 'A', defval: '' });
      if (!rows || rows.length === 0) continue;

      let inUnconfirmedBlock = false;
      let activeMapping = {
        nombre: 'B',
        fecha_nacimiento: 'C',
        cedula: 'D',
        telefono: 'E',
        correo: 'F',
        ciudad: 'G',
      };

      for (let r = 0; r < rows.length; r++) {
        const row = rows[r];
        const filaNum = r + 1;
        const allText = Object.values(row).map(v => String(v).trim()).filter(Boolean).join(' ');
        const allTextNorm = normalizeHeader(allText);

        if (!allText) continue;

        // Detectar si esta fila marca un bloque de participantes no confirmados / no asistentes
        if (
          allTextNorm.includes('no confirmaron') ||
          allTextNorm.includes('no confirm') ||
          allTextNorm.includes('no asistieron') ||
          allTextNorm.includes('no participaron') ||
          allTextNorm.includes('no respondieron') ||
          allTextNorm.includes('whatsapp') ||
          allTextNorm.includes('whastapp') ||
          allTextNorm.includes('cancelad')
        ) {
          inUnconfirmedBlock = true;
          continue;
        }

        // Detectar si esta fila es un encabezado de sección que reinicia el bloque
        if (
          allTextNorm.includes('registro de taller') ||
          (allTextNorm.includes('taller') && (allTextNorm.includes('anos') || allTextNorm.includes('grupo') || allTextNorm.includes('seccion')))
        ) {
          inUnconfirmedBlock = false;
          continue;
        }

        // Detectar si esta fila contiene los nombres de columnas
        let isHeaderRow = false;
        const tempMapping = {};
        let matchesCount = 0;

        for (const [colKey, cellVal] of Object.entries(row)) {
          const normVal = normalizeHeader(cellVal);
          if (!normVal) continue;

          for (const [field, aliases] of Object.entries(headerAliases)) {
            if (aliases.some((alias) => normVal === alias || normVal.startsWith(alias))) {
              tempMapping[field] = colKey;
              matchesCount++;
              break;
            }
          }
        }

        if (tempMapping.nombre || matchesCount >= 2) {
          activeMapping = { ...activeMapping, ...tempMapping };
          isHeaderRow = true;
          inUnconfirmedBlock = false; // Nueva tabla inicia en bloque activo
          continue;
        }

        if (isHeaderRow) continue;

        // Extraer valores según el mapeo detectado (cualquier otra columna extra se ignora)
        const getVal = (field) => {
          const col = activeMapping[field];
          if (!col) return '';
          const val = row[col];
          return val !== undefined && val !== null ? String(val).trim() : '';
        };

        let rawNombre = getVal('nombre');
        // Limpiar artefactos de fórmulas de Excel si existen (ej. K+A28:B28ristal -> Kristal)
        rawNombre = rawNombre.replace(/^.*?[A-Z]\d+:[A-Z]\d+/i, '').trim().replace(/\xa0/g, ' ').trim();

        if (!rawNombre || rawNombre.length < 2 || /^\d+$/.test(rawNombre)) {
          continue;
        }

        const rawNombreNorm = normalizeHeader(rawNombre);

        // Descartar si el "nombre" es en realidad un título de sección o mensaje
        if (
          rawNombreNorm.includes('no respondieron') ||
          rawNombreNorm.includes('no confirmaron') ||
          rawNombreNorm.includes('no asistieron') ||
          rawNombreNorm.includes('whatsapp') ||
          rawNombreNorm.includes('whastapp') ||
          rawNombreNorm.includes('registro de taller') ||
          rawNombreNorm.includes('grupo ') ||
          rawNombreNorm.includes('conocimiento') ||
          rawNombreNorm.includes('total')
        ) {
          if (rawNombreNorm.includes('no respondieron') || rawNombreNorm.includes('no confirmaron') || rawNombreNorm.includes('no asistieron')) {
            inUnconfirmedBlock = true;
          }
          continue;
        }

        // Si la fila está dentro de un bloque no confirmado, omitir
        if (inUnconfirmedBlock) {
          resumen.omitidos_no_asistieron++;
          continue;
        }

        // Verificar la columna explícita de Asistencia si existe en el archivo
        const rawAsistencia = normalizeHeader(getVal('asistencia'));
        if (
          rawAsistencia.includes('no') ||
          rawAsistencia.includes('ausente') ||
          rawAsistencia.includes('cancelad') ||
          rawAsistencia.includes('inactiv') ||
          rawAsistencia.includes('pendiente')
        ) {
          resumen.omitidos_no_asistieron++;
          continue;
        }

        const rawCedula = getVal('cedula');
        let rawFechaNac = getVal('fecha_nacimiento');
        let rawTelefono = getVal('telefono');
        const rawCorreo = getVal('correo');
        const rawCiudad = getVal('ciudad');

        // Detectar si el campo de fecha o cédula en realidad contenía un teléfono (ej. 4140235102)
        if (!rawTelefono || rawTelefono.length < 7) {
          if (rawFechaNac && /^(0?4\d{9,10}|\d{10,11})$/.test(rawFechaNac.replace(/\s+/g, ''))) {
            rawTelefono = rawFechaNac;
            rawFechaNac = '';
          } else if (rawCedula && /^(0?4\d{9,10})$/.test(rawCedula.replace(/\s+/g, ''))) {
            rawTelefono = rawCedula;
          }
        }

        const cedula = normalizarCedula(rawCedula);
        const nombreFormateado = formatearNombre(rawNombre);

        // Control de duplicados en el mismo archivo/hojas
        const dedupeKey = cedula ? `CI:${cedula}` : `NAME:${rawNombreNorm}`;
        if (processedDedupeKeys.has(dedupeKey)) {
          continue;
        }
        processedDedupeKeys.add(dedupeKey);

        const fechaNac = parseFechaNacimiento(rawFechaNac);
        const correo = rawCorreo && rawCorreo.includes('@') ? rawCorreo : `taller_${filaNum}_${Date.now().toString().slice(-4)}@fundacionstohr.org`;
        const ciudad = rawCiudad || lugar || 'Caracas';
        const telefono = normalizarTelefono(rawTelefono);

        resumen.total_procesados++;

        try {
          await client.query('BEGIN');

          let id_participante = null;

          // 1. Buscar por cédula (prioridad absoluta para respetar nombre oficial registrado)
          if (cedula) {
            const busqCedula = await client.query(
              'SELECT id_participante, nombre FROM participante WHERE cedula = $1',
              [cedula]
            );
            if (busqCedula.rows.length > 0) {
              id_participante = busqCedula.rows[0].id_participante;
              const nombreEnBd = busqCedula.rows[0].nombre;
              if (!participantesNuevosIds.has(id_participante)) {
                participantesPreviosIds.add(id_participante);
              }
              // Si el nombre en BD está todo en mayúsculas, estandarizar su nombre original (mantener nombre registrado, no el apodo del Excel)
              if (nombreEnBd && nombreEnBd === nombreEnBd.toUpperCase()) {
                await client.query('UPDATE participante SET nombre = $1 WHERE id_participante = $2', [formatearNombre(nombreEnBd), id_participante]);
              }
            }
          }

          // 2. Buscar por nombre si no tiene cédula
          if (!id_participante) {
            const busqNombre = await client.query(
              'SELECT id_participante, nombre FROM participante WHERE UPPER(nombre) = UPPER($1)',
              [nombreFormateado]
            );
            if (busqNombre.rows.length > 0) {
              id_participante = busqNombre.rows[0].id_participante;
              const actualNombre = busqNombre.rows[0].nombre;
              if (!participantesNuevosIds.has(id_participante)) {
                participantesPreviosIds.add(id_participante);
              }
              if (actualNombre && actualNombre === actualNombre.toUpperCase() && nombreFormateado) {
                await client.query('UPDATE participante SET nombre = $1 WHERE id_participante = $2', [nombreFormateado, id_participante]);
              }
            }
          }

          // 3. Crear participante si no existe
          if (!id_participante) {
            const insertP = await client.query(
              `INSERT INTO participante (nombre, cedula, correo, ciudad, instagram, fecha_nacimiento, estado_id)
               VALUES ($1, $2, $3, $4, $5, $6, $7)
               RETURNING id_participante`,
              [
                nombreFormateado,
                cedula || null,
                correo,
                ciudad,
                null,
                fechaNac,
                id_estado_defecto,
              ]
            );
            id_participante = insertP.rows[0].id_participante;
            participantesNuevosIds.add(id_participante);
          }

          // 4. Teléfono (deduplicación inteligente y estandarización)
          if (telefono && id_participante) {
            const telBusq = await client.query(
              'SELECT id_telefono, numero_telefonico FROM telefono WHERE participante_id = $1',
              [id_participante]
            );

            const existingList = telBusq.rows.map(r => ({
              id: r.id_telefono,
              norm: normalizarTelefono(r.numero_telefonico),
              raw: r.numero_telefonico
            }));

            const match = existingList.find(e => e.norm === telefono);
            if (match) {
              if (match.raw !== telefono) {
                await client.query('UPDATE telefono SET numero_telefonico = $1 WHERE id_telefono = $2', [telefono, match.id]);
              }
            } else {
              await client.query(
                'INSERT INTO telefono (numero_telefonico, participante_id) VALUES ($1, $2)',
                [telefono, id_participante]
              );
            }
          }

          // 5. Vincular al Taller en la tabla T_P
          const yaVinculado = await client.query(
            'SELECT id FROM t_p WHERE participante_id = $1 AND taller_id = $2',
            [id_participante, taller_id]
          );
          if (yaVinculado.rows.length === 0) {
            await client.query(
              'INSERT INTO t_p (participante_id, taller_id) VALUES ($1, $2)',
              [id_participante, taller_id]
            );
          }
          participantesVinculadosIds.add(id_participante);

          await client.query('COMMIT');
        } catch (err) {
          await client.query('ROLLBACK');
          console.error(`Error en fila ${filaNum} (${rawNombre}):`, err.message);
          resumen.errores.push({ fila: filaNum, nombre: rawNombre, error: err.message });
        }
      }
    }

    resumen.insertados = participantesNuevosIds.size;
    resumen.ya_existian = participantesPreviosIds.size;
    resumen.vinculados = participantesVinculadosIds.size;

    const tieneErrores = resumen.errores.length > 0;
    return res.status(tieneErrores ? 207 : 201).json({
      mensaje: `Taller "${tallerCreado.nombre}" creado con éxito. Se vincularon ${resumen.vinculados} participantes (${resumen.insertados} nuevos, ${resumen.ya_existian} ya existían).`,
      resumen,
    });
  } catch (err) {
    console.error('Error general en ImportarExcelTaller:', err);
    return res.status(500).json({ error: 'Error interno al procesar la importación.', details: err.message });
  } finally {
    client.release();
  }
});

module.exports = Routes;