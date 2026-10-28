const express = require('express');
const { Pool } = require('pg');
const multer = require('multer');
const XLSX = require('xlsx');
const Routes = express.Router();
const Class_Encuentro = require('../Classes/Class_Encuentro.js');

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

// ─────────────────────────────────────────────
// GET /encuentro/GetEncuentros
// ─────────────────────────────────────────────
Routes.get('/GetEncuentros', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT * FROM encuentro ORDER BY id_encuentro DESC');
    client.release();
    const encuentros = result.rows.map(r =>
      new Class_Encuentro(r.nombre, r.fecha, r.lugar, r.id_encuentro)
    );
    res.status(200).json(encuentros);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener los encuentros', details: error.message });
  }
});

// ─────────────────────────────────────────────
// POST /encuentro/InsertarEncuentro
// ─────────────────────────────────────────────
Routes.post('/InsertarEncuentro', async (req, res) => {
  const { nombre, fecha, lugar } = req.body;
  if (!nombre || !fecha) {
    return res.status(400).json({ error: 'Los campos nombre y fecha son obligatorios.' });
  }
  try {
    const client = await pool.connect();
    const result = await client.query(
      `INSERT INTO encuentro (nombre, fecha, lugar) VALUES ($1, $2, $3) RETURNING *`,
      [nombre, fecha, lugar || null]
    );
    client.release();
    res.status(201).json({ mensaje: 'Encuentro creado con éxito', encuentro: result.rows[0] });
  } catch (error) {
    res.status(500).json({ error: 'Error al insertar el encuentro', details: error.message });
  }
});

// ─────────────────────────────────────────────
// PUT /encuentro/ModificarEncuentro/:id
// ─────────────────────────────────────────────
Routes.put('/ModificarEncuentro/:id', async (req, res) => {
  const { id } = req.params;
  const { nombre, fecha, lugar } = req.body;
  try {
    const client = await pool.connect();
    const result = await client.query(
      `UPDATE encuentro SET nombre=$1, fecha=$2, lugar=$3 WHERE id_encuentro=$4 RETURNING *`,
      [nombre, fecha, lugar || null, id]
    );
    client.release();
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Encuentro no encontrado.' });
    }
    res.status(200).json({ mensaje: 'Encuentro actualizado con éxito', encuentro: result.rows[0] });
  } catch (error) {
    res.status(500).json({ error: 'Error al modificar el encuentro', details: error.message });
  }
});

// ─────────────────────────────────────────────
// DELETE /encuentro/EliminarEncuentro/:id
// ─────────────────────────────────────────────
Routes.delete('/EliminarEncuentro/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const client = await pool.connect();
    await client.query('DELETE FROM encuentro WHERE id_encuentro=$1', [id]);
    client.release();
    res.status(200).json({ mensaje: 'Encuentro eliminado con éxito' });
  } catch (error) {
    res.status(500).json({ error: 'Error al eliminar el encuentro', details: error.message });
  }
});

// ─────────────────────────────────────────────
// GET /encuentro/ParticipantesEncuentro/:id
// Lista participantes vinculados a un encuentro (sin duplicados por teléfono)
// ─────────────────────────────────────────────
Routes.get('/ParticipantesEncuentro/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const client = await pool.connect();
    const result = await client.query(
      `SELECT p.id_participante, p.nombre, p.cedula, p.correo,
              COALESCE(STRING_AGG(DISTINCT t.numero_telefonico, ', '), 'N/A') AS telefono
       FROM en_p ep
       JOIN participante p ON p.id_participante = ep.participante_id
       LEFT JOIN telefono t ON t.participante_id = p.id_participante
       WHERE ep.encuentro_id = $1
       GROUP BY p.id_participante, p.nombre, p.cedula, p.correo
       ORDER BY p.nombre ASC`,
      [id]
    );
    client.release();
    res.status(200).json(result.rows);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener participantes del encuentro', details: error.message });
  }
});

// ─────────────────────────────────────────────
// GET /encuentro/NoParticipantesEncuentro/:id
// Lista participantes NO vinculados a un encuentro
// ─────────────────────────────────────────────
Routes.get('/NoParticipantesEncuentro/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const client = await pool.connect();
    const result = await client.query(
      `SELECT p.id_participante, p.nombre, p.cedula
       FROM participante p
       WHERE p.id_participante NOT IN (
         SELECT participante_id FROM en_p WHERE encuentro_id = $1
       )
       ORDER BY p.nombre ASC`,
      [id]
    );
    client.release();
    res.status(200).json(result.rows);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener participantes no vinculados', details: error.message });
  }
});

// ─────────────────────────────────────────────
// POST /encuentro/InsertarParticipanteEncuentro
// ─────────────────────────────────────────────
Routes.post('/InsertarParticipanteEncuentro', async (req, res) => {
  const { encuentro, participante } = req.body;
  if (!encuentro || !participante) {
    return res.status(400).json({ error: 'Encuentro o participante inválido.' });
  }
  try {
    const client = await pool.connect();
    const yaExiste = await client.query(
      'SELECT id FROM en_p WHERE participante_id = $1 AND encuentro_id = $2',
      [participante, encuentro]
    );
    if (yaExiste.rows.length === 0) {
      await client.query(
        'INSERT INTO en_p (participante_id, encuentro_id) VALUES ($1, $2)',
        [participante, encuentro]
      );
    }
    client.release();
    res.status(201).json({ mensaje: 'Participante vinculado con éxito al encuentro.' });
  } catch (error) {
    res.status(500).json({ error: 'Error al vincular participante al encuentro', details: error.message });
  }
});

// ─────────────────────────────────────────────
// POST /encuentro/ImportarExcelEncuentro
// ─────────────────────────────────────────────
Routes.post('/ImportarExcelEncuentro', upload.single('archivo'), async (req, res) => {
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

  // ── helpers ──────────────────────────────────────────────
  function normalizarCedula(raw) {
    if (!raw && raw !== 0) return null;
    const str = String(raw).trim();
    if (str.toLowerCase().includes('no aplica') || str.toLowerCase().includes('n/a')) return null;
    const clean = str.replace(/\./g, '').replace(/\s/g, '').replace(/^[VvEe]-?/i, '');
    return clean || null;
  }

  const normalizeHeader = (h) =>
    String(h || '').trim().normalize('NFKD').replace(/[\u0300-\u036f]/g, '').toLowerCase();

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
      const excelEpoch = new Date(Date.UTC(1899, 11, 30));
      const date = new Date(excelEpoch.getTime() + num * 86400000);
      if (!isNaN(date.getTime())) return date.toISOString().split('T')[0];
    }
    const date = new Date(raw);
    if (!isNaN(date.getTime())) return date.toISOString().split('T')[0];
    return '2010-01-01';
  }

  const headerAliases = {
    nombre:           ['nombre', 'nombre y apellido', 'participante', 'nombres', 'nombre completo', 'name'],
    fecha_nacimiento: ['fecha nacimiento', 'fecha de nacimiento', 'fecha_nacimiento', 'nacimiento', 'f. nac', 'f. nacimiento'],
    cedula:           ['cedula', 'cedula de identidad', 'cédula de identidad', 'cédula', 'ci', 'c.i.', 'c.i', 'documento', 'identidad', 'dni'],
    telefono:         ['telf', 'telefono', 'teléfono', 'celular', 'tlf', 'movil', 'móvil', 'phone'],
    correo:           ['email', 'correo', 'correo electronico', 'correo electrónico', 'mail', 'dirección de correo electrónico', 'direccion de correo electronico'],
    ciudad:           ['zona donde reside', 'zona donde vive', 'municipio donde reside', 'zona o ciudad', 'zona', 'ciudad', 'municipio', 'direccion', 'dirección', 'residencia', 'sector', 'localidad'],
    asistencia:       ['asistencia', 'asistio', 'asistió', 'estado', 'status'],
  };

  const defaultMapping = {
    nombre: 'C',
    fecha_nacimiento: 'D',
    cedula: 'E',
    telefono: 'F',
    correo: 'G',
    ciudad: 'H',
  };

  const client = await pool.connect();

  try {
    // 1. Estado por defecto
    let id_estado_defecto = null;
    const estNombre = estado_defecto || 'Distrito Capital';
    const estRes = await client.query(
      'SELECT id_estado FROM estado WHERE UPPER(nombre) = UPPER($1)', [estNombre]
    );
    if (estRes.rows.length > 0) {
      id_estado_defecto = estRes.rows[0].id_estado;
    } else {
      const first = await client.query('SELECT id_estado FROM estado ORDER BY id_estado ASC LIMIT 1');
      if (first.rows.length > 0) id_estado_defecto = first.rows[0].id_estado;
    }

    // 2. Crear el Encuentro
    const enRes = await client.query(
      `INSERT INTO encuentro (nombre, fecha, lugar) VALUES ($1, $2, $3) RETURNING *`,
      [nombre, fecha, lugar || null]
    );
    const encuentroCreado = enRes.rows[0];
    const encuentro_id = encuentroCreado.id_encuentro;

    // Sets para deduplicación entre hojas
    const participantesNuevosIds = new Set();
    const participantesPreviosIds = new Set();
    const participantesVinculadosIds = new Set();
    const processedDedupeKeys = new Set();

    const resumen = {
      encuentro: encuentroCreado,
      total_procesados: 0,
      insertados: 0,
      ya_existian: 0,
      vinculados: 0,
      omitidos: 0,
      errores: [],
    };

    // 3. Procesar todas las hojas
    for (const sheetName of sheetNames) {
      const ws = workbook.Sheets[sheetName];
      const rows = XLSX.utils.sheet_to_json(ws, { header: 'A', defval: '' });
      if (!rows || rows.length === 0) continue;

      let activeMapping = { ...defaultMapping };

      for (let r = 0; r < rows.length; r++) {
        const row = rows[r];
        const filaNum = r + 1;

        // Intentar detectar fila de encabezado
        const tempMapping = {};
        let matchesCount = 0;
        for (const [colKey, cellVal] of Object.entries(row)) {
          const normVal = normalizeHeader(cellVal);
          if (!normVal) continue;
          for (const [field, aliases] of Object.entries(headerAliases)) {
            if (aliases.some(alias => normVal === alias || normVal.startsWith(alias))) {
              tempMapping[field] = colKey;
              matchesCount++;
              break;
            }
          }
        }
        if (tempMapping.nombre || matchesCount >= 2) {
          activeMapping = { ...activeMapping, ...tempMapping };
          continue; // saltar la fila de encabezado
        }

        const getVal = (field) => {
          const col = activeMapping[field];
          if (!col) return '';
          const val = row[col];
          return val !== undefined && val !== null ? String(val).trim() : '';
        };

        let rawNombre = getVal('nombre').replace(/\xa0/g, ' ').trim();
        if (!rawNombre || rawNombre.length < 2 || /^\d+$/.test(rawNombre)) continue;

        const rawNombreNorm = normalizeHeader(rawNombre);
        if (
          rawNombreNorm.includes('no confirm') ||
          rawNombreNorm.includes('no asist') ||
          rawNombreNorm.includes('no respondieron') ||
          rawNombreNorm.includes('marca temporal') ||
          rawNombreNorm.includes('nombre y apellido') ||
          rawNombreNorm.includes('registro de') ||
          rawNombreNorm.includes('grupo ') ||
          rawNombreNorm.includes('total')
        ) continue;

        // Columna de asistencia explícita
        const rawAsistencia = normalizeHeader(getVal('asistencia'));
        if (
          rawAsistencia &&
          (rawAsistencia.includes('no') || rawAsistencia.includes('ausente') ||
           rawAsistencia.includes('cancelad') || rawAsistencia.includes('pendiente'))
        ) {
          resumen.omitidos++;
          continue;
        }

        let rawCedula = getVal('cedula');
        let rawFechaNac = getVal('fecha_nacimiento');
        let rawTelefono = getVal('telefono');
        const rawCorreo = getVal('correo');
        const rawCiudad = getVal('ciudad');

        // Detección de teléfono en campo de fecha
        if (!rawTelefono || rawTelefono.length < 7) {
          if (rawFechaNac && /^(0?4\d{9,10}|\d{10,11})$/.test(rawFechaNac.replace(/\s+/g, ''))) {
            rawTelefono = rawFechaNac;
            rawFechaNac = '';
          } else if (rawCedula && /^(0?4\d{9,10})$/.test(rawCedula.replace(/\s+/g, ''))) {
            rawTelefono = rawCedula;
            rawCedula = '';
          }
        }

        const cedula = normalizarCedula(rawCedula);
        const nombreEstandarizado = formatearNombre(rawNombre);
        const fechaNac = parseFechaNacimiento(rawFechaNac);
        const correo = rawCorreo && rawCorreo.includes('@')
          ? rawCorreo
          : `encuentro_${filaNum}_${Date.now().toString().slice(-4)}@fundacionstohr.org`;
        const ciudad = rawCiudad || lugar || 'Caracas';
        const telefono = normalizarTelefono(rawTelefono);

        // Deduplicación en memoria para no repetir dentro del mismo Excel
        const dedupeKey = cedula ? `CI:${cedula}` : `NAME:${normalizeHeader(nombreEstandarizado)}`;
        if (processedDedupeKeys.has(dedupeKey)) {
          continue;
        }
        processedDedupeKeys.add(dedupeKey);

        resumen.total_procesados++;

        try {
          await client.query('BEGIN');

          let id_participante = null;

          // 1. Buscar por cédula (prioridad absoluta para respetar nombre oficial registrado)
          if (cedula) {
            const bq = await client.query(
              'SELECT id_participante, nombre FROM participante WHERE cedula = $1', [cedula]
            );
            if (bq.rows.length > 0) {
              id_participante = bq.rows[0].id_participante;
              const nombreEnBd = bq.rows[0].nombre;
              if (!participantesNuevosIds.has(id_participante)) {
                participantesPreviosIds.add(id_participante);
              }
              // Si el nombre registrado en BD estaba todo en mayúsculas, pasarlo a Title Case manteniendo su nombre original
              if (nombreEnBd && nombreEnBd === nombreEnBd.toUpperCase()) {
                await client.query(
                  'UPDATE participante SET nombre = $1 WHERE id_participante = $2',
                  [formatearNombre(nombreEnBd), id_participante]
                );
              }
            }
          }

          // 2. Buscar por nombre (insensible a mayúsculas/minúsculas)
          if (!id_participante) {
            const bqN = await client.query(
              'SELECT id_participante, nombre FROM participante WHERE UPPER(TRIM(nombre)) = UPPER(TRIM($1))',
              [nombreEstandarizado]
            );
            if (bqN.rows.length > 0) {
              id_participante = bqN.rows[0].id_participante;
              if (!participantesNuevosIds.has(id_participante)) {
                participantesPreviosIds.add(id_participante);
              }
              if (bqN.rows[0].nombre === bqN.rows[0].nombre.toUpperCase()) {
                await client.query(
                  'UPDATE participante SET nombre = $1 WHERE id_participante = $2',
                  [nombreEstandarizado, id_participante]
                );
              }
            }
          }

          // 3. Crear si no existe
          if (!id_participante) {
            const ins = await client.query(
              `INSERT INTO participante (nombre, cedula, correo, ciudad, instagram, fecha_nacimiento, estado_id)
               VALUES ($1,$2,$3,$4,$5,$6,$7) RETURNING id_participante`,
              [nombreEstandarizado, cedula || null, correo, ciudad, null, fechaNac, id_estado_defecto]
            );
            id_participante = ins.rows[0].id_participante;
            participantesNuevosIds.add(id_participante);
          }

          // 4. Teléfono (deduplicación inteligente y estandarización a 0424... / 0212...)
          if (telefono && id_participante) {
            const telBq = await client.query(
              'SELECT id_telefono, numero_telefonico FROM telefono WHERE participante_id=$1',
              [id_participante]
            );

            const existingList = telBq.rows.map(r => ({
              id: r.id_telefono,
              norm: normalizarTelefono(r.numero_telefonico),
              raw: r.numero_telefonico
            }));

            const match = existingList.find(e => e.norm === telefono);
            if (match) {
              if (match.raw !== telefono) {
                await client.query('UPDATE telefono SET numero_telefonico=$1 WHERE id_telefono=$2', [telefono, match.id]);
              }
            } else {
              await client.query(
                'INSERT INTO telefono (numero_telefonico, participante_id) VALUES ($1,$2)',
                [telefono, id_participante]
              );
            }
          }

          // 5. Vincular al encuentro
          const yaVinc = await client.query(
            'SELECT id FROM en_p WHERE participante_id=$1 AND encuentro_id=$2',
            [id_participante, encuentro_id]
          );
          if (yaVinc.rows.length === 0) {
            await client.query(
              'INSERT INTO en_p (participante_id, encuentro_id) VALUES ($1,$2)',
              [id_participante, encuentro_id]
            );
          }
          participantesVinculadosIds.add(id_participante);

          await client.query('COMMIT');
        } catch (err) {
          await client.query('ROLLBACK');
          console.error(`Error fila ${filaNum} (${nombreEstandarizado}):`, err.message);
          resumen.errores.push({ fila: filaNum, nombre: nombreEstandarizado, error: err.message });
        }
      }
    }

    resumen.insertados   = participantesNuevosIds.size;
    resumen.ya_existian  = participantesPreviosIds.size;
    resumen.vinculados   = participantesVinculadosIds.size;

    return res.status(resumen.errores.length > 0 ? 207 : 201).json({
      mensaje: `Encuentro "${encuentroCreado.nombre}" creado con éxito. Se vincularon ${resumen.vinculados} participantes (${resumen.insertados} nuevos, ${resumen.ya_existian} ya existían).`,
      resumen,
    });
  } catch (err) {
    console.error('Error general ImportarExcelEncuentro:', err);
    return res.status(500).json({ error: 'Error interno al procesar la importación.', details: err.message });
  } finally {
    client.release();
  }
});

module.exports = Routes;
