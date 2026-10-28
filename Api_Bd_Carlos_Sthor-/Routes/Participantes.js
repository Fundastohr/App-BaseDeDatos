const express = require("express");
const { Pool } = require("pg");
const multer = require("multer");
const XLSX = require("xlsx");
const Routes = express.Router(); // Correcto: Crea una instancia del Router
const Class_Participante = require("../Classes/Class_Participante.js");

// Configurar multer para almacenamiento en memoria (no guarda archivos en disco)
const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 5 * 1024 * 1024 }, // Máximo 5 MB
  fileFilter: (_req, file, cb) => {
    const allowed = [
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      "application/vnd.ms-excel",
    ];
    if (allowed.includes(file.mimetype) || file.originalname.endsWith(".xlsx") || file.originalname.endsWith(".xls")) {
      cb(null, true);
    } else {
      cb(new Error("Solo se permiten archivos Excel (.xlsx / .xls)"));
    }
  },
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

// =========================================================
// POST /Participantes/ImportarExcel
// Importa participantes desde un archivo Excel (.xlsx/.xls)
// =========================================================
Routes.post("/ImportarExcel", upload.single("archivo"), async (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: "No se recibió ningún archivo." });
  }

  let workbook;
  try {
    workbook = XLSX.read(req.file.buffer, { type: "buffer", cellDates: true });
  } catch (e) {
    return res.status(400).json({ error: "El archivo no es un Excel válido.", details: e.message });
  }

  // Tomar la primera hoja del archivo
  const sheetName = workbook.SheetNames[0];
  if (!sheetName) {
    return res.status(400).json({ error: "El archivo Excel no contiene hojas." });
  }

  const sheet = workbook.Sheets[sheetName];
  const rows = XLSX.utils.sheet_to_json(sheet, { defval: "" });

  if (!rows || rows.length === 0) {
    return res.status(400).json({ error: "El archivo Excel está vacío o no tiene datos después de los encabezados." });
  }

  // Mapeo flexible de encabezados (acepta variantes comunes)
  const headerMap = {
    nombre: ["nombre", "nombre completo", "name"],
    cedula: ["cedula", "cédula", "ci", "documento"],
    fecha_nacimiento: ["fecha de nacimiento", "fecha_nacimiento", "fecha nacimiento", "nacimiento", "birthdate"],
    correo: ["correo", "email", "correo electronico", "correo electrónico", "mail"],
    ciudad: ["ciudad", "city"],
    estado: ["estado", "state", "provincia"],
    instagram: ["instagram", "ig", "red social"],
    telefono: ["telefono", "teléfono", "phone", "celular", "tlf"],
  };

  // Detectar las columnas del Excel según los encabezados reales
  const excelHeaders = Object.keys(rows[0] || {});
  const normalizeHeader = (h) => String(h).trim().normalize("NFKD").replace(/[\u0300-\u036f]/g, "").toLowerCase();

  const fieldMapping = {}; // { nuestro_campo: nombre_columna_en_excel }
  for (const [field, aliases] of Object.entries(headerMap)) {
    const found = excelHeaders.find((eh) => aliases.includes(normalizeHeader(eh)));
    if (found) fieldMapping[field] = found;
  }

  // Verificar que los campos obligatorios estén mapeados
  const required = ["nombre", "fecha_nacimiento", "correo", "ciudad", "telefono"];
  const missing = required.filter((f) => !fieldMapping[f]);
  if (missing.length > 0) {
    return res.status(400).json({
      error: `Faltan columnas obligatorias en el Excel: ${missing.join(", ")}`,
      columnas_detectadas: excelHeaders,
      columnas_esperadas: Object.entries(headerMap).map(([k, v]) => `${k}: ${v[0]}`),
    });
  }

  // Procesar cada fila
  const resultados = {
    total: rows.length,
    insertados: 0,
    ya_existian: 0,
    errores: [],
  };

  const processedDedupeKeys = new Set();
  const client = await pool.connect();

  for (let i = 0; i < rows.length; i++) {
    const row = rows[i];
    const filaNum = i + 2; // +2 porque fila 1 son encabezados y el índice empieza en 0

    const getValue = (field) => {
      const col = fieldMapping[field];
      if (!col) return null;
      const raw = row[col];
      if (raw === undefined || raw === null) return null;
      return String(raw).trim() || null;
    };

    const rawNombre = getValue("nombre");
    const cedula = getValue("cedula");
    const correo = getValue("correo");
    const ciudad = getValue("ciudad");
    const estado = getValue("estado");
    const instagram = getValue("instagram");
    const rawTelefono = getValue("telefono");

    const nombre = formatearNombre(rawNombre);
    const telefono = normalizarTelefono(rawTelefono);

    // Control de duplicados en el mismo archivo
    const dedupeKey = cedula ? `CI:${cedula}` : `NAME:${normalizeHeader(rawNombre)}`;
    if (processedDedupeKeys.has(dedupeKey)) {
      continue;
    }
    processedDedupeKeys.add(dedupeKey);

    // Procesar fecha (puede venir como Date object o string)
    let fecha_nacimiento = null;
    const rawFecha = row[fieldMapping["fecha_nacimiento"]];
    if (rawFecha instanceof Date) {
      const pad = (n) => String(n).padStart(2, "0");
      fecha_nacimiento = `${rawFecha.getFullYear()}-${pad(rawFecha.getMonth() + 1)}-${pad(rawFecha.getDate())}`;
    } else if (rawFecha) {
      const s = String(rawFecha).trim();
      // Aceptar formatos: YYYY-MM-DD, DD/MM/YYYY, DD-MM-YYYY
      const isoMatch = s.match(/^(\d{4})-(\d{1,2})-(\d{1,2})$/);
      const dmsMatch = s.match(/^(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})$/);
      if (isoMatch) {
        fecha_nacimiento = s;
      } else if (dmsMatch) {
        fecha_nacimiento = `${dmsMatch[3]}-${dmsMatch[2].padStart(2, "0")}-${dmsMatch[1].padStart(2, "0")}`;
      } else {
        // Intentar parseo genérico
        const parsed = new Date(s);
        if (!isNaN(parsed.getTime())) {
          const pad = (n) => String(n).padStart(2, "0");
          fecha_nacimiento = `${parsed.getFullYear()}-${pad(parsed.getMonth() + 1)}-${pad(parsed.getDate())}`;
        }
      }
    }

    // Validaciones
    const erroresFilaActual = [];
    if (!nombre) erroresFilaActual.push("Nombre es obligatorio");
    if (!fecha_nacimiento) erroresFilaActual.push("Fecha de nacimiento inválida o faltante");
    if (!correo) erroresFilaActual.push("Correo es obligatorio");
    if (!ciudad) erroresFilaActual.push("Ciudad es obligatoria");
    if (!telefono) erroresFilaActual.push("Teléfono es obligatorio o inválido");

    if (erroresFilaActual.length > 0) {
      resultados.errores.push({
        fila: filaNum,
        nombre: nombre || "(vacío)",
        errores: erroresFilaActual,
      });
      continue;
    }

    // Insertar con transacción individual por fila
    try {
      await client.query("BEGIN");

      // Verificar si ya existe por cédula (prioridad absoluta a la cédula)
      let id_participante = null;
      if (cedula) {
        const busqCedula = await client.query("SELECT id_participante, nombre FROM participante WHERE cedula = $1", [cedula]);
        if (busqCedula.rows.length > 0) {
          id_participante = busqCedula.rows[0].id_participante;
          const nombreEnBd = busqCedula.rows[0].nombre;
          // Si estaba todo en mayúsculas, formatear el nombre original registrado (no el apodo del Excel)
          if (nombreEnBd && nombreEnBd === nombreEnBd.toUpperCase()) {
            await client.query("UPDATE participante SET nombre = $1 WHERE id_participante = $2", [formatearNombre(nombreEnBd), id_participante]);
          }
        }
      }

      if (!id_participante) {
        const busqNombre = await client.query("SELECT id_participante, nombre FROM participante WHERE UPPER(nombre) = UPPER($1)", [nombre]);
        if (busqNombre.rows.length > 0) {
          id_participante = busqNombre.rows[0].id_participante;
          const nombreEnBd = busqNombre.rows[0].nombre;
          if (nombreEnBd && nombreEnBd === nombreEnBd.toUpperCase()) {
            await client.query("UPDATE participante SET nombre = $1 WHERE id_participante = $2", [formatearNombre(nombreEnBd), id_participante]);
          }
        }
      }

      if (id_participante) {
        resultados.ya_existian++;
      } else {
        // Insertar en tabla participante
        const queryInsert = `
          INSERT INTO participante (nombre, cedula, fecha_nacimiento, correo, ciudad, instagram, estado_id)
          VALUES ($1, $2, $3, $4, $5, $6, (SELECT id_estado FROM estado WHERE UPPER(nombre)=UPPER($7)))
          RETURNING id_participante;
        `;
        const values = [nombre, cedula, fecha_nacimiento, correo, ciudad, instagram, estado];
        const result = await client.query(queryInsert, values);
        id_participante = result.rows[0].id_participante;
        resultados.insertados++;
      }

      // Insertar o estandarizar en tabla telefono
      if (telefono && id_participante) {
        const telBusq = await client.query(
          "SELECT id_telefono, numero_telefonico FROM telefono WHERE participante_id = $1",
          [id_participante]
        );

        const existingList = telBusq.rows.map((r) => ({
          id: r.id_telefono,
          norm: normalizarTelefono(r.numero_telefonico),
          raw: r.numero_telefonico,
        }));

        const match = existingList.find((e) => e.norm === telefono);
        if (match) {
          if (match.raw !== telefono) {
            await client.query("UPDATE telefono SET numero_telefonico = $1 WHERE id_telefono = $2", [telefono, match.id]);
          }
        } else {
          const queryTel = `INSERT INTO telefono(numero_telefonico, participante_id) VALUES ($1, $2);`;
          await client.query(queryTel, [telefono, id_participante]);
        }
      }

      await client.query("COMMIT");
    } catch (err) {
      await client.query("ROLLBACK");
      resultados.errores.push({
        fila: filaNum,
        nombre: nombre || "(vacío)",
        errores: [err.message],
      });
    }
  }

  client.release();

  const status = resultados.errores.length === 0 ? 201 : 207; // 207 = Multi-Status
  return res.status(status).json({
    mensaje: `Importación completada: ${resultados.insertados} de ${resultados.total} participantes insertados.`,
    ...resultados,
  });
});

// GET /Participantes/Getusuarios
// - Sin query params: devuelve ARRAY (compatibilidad)
// - Con ?page=&limit=: devuelve OBJETO con items + metadata
// GET /Participantes/Getusuarios?page=1&limit=20&q=&estado=&ciudad=&order=&dir=
// Pagina sobre el resultado del SQL + filtros, y devuelve metadata.

Routes.get("/Getusuarios", async (req, res) => {
  const client = await pool.connect();

  try {
    const query = `
      SELECT
        p.id_participante,
        p.nombre,
        p.cedula,
        p.fecha_nacimiento,
        p.correo,
        p.ciudad,
        p.instagram,
        e.nombre AS estado,
        COALESCE(string_agg(t.numero_telefonico, ', ' ORDER BY t.numero_telefonico), NULL) AS telefono
      FROM participante p
      LEFT JOIN estado e ON e.id_estado = p.estado_id
      LEFT JOIN telefono t ON t.participante_id = p.id_participante
      GROUP BY
        p.id_participante,
        p.nombre,
        p.cedula,
        p.fecha_nacimiento,
        p.correo,
        p.ciudad,
        p.instagram,
        e.nombre
      ORDER BY p.id_participante ASC;
    `;

    const result = await client.query(query);

    // 🔹 Ahora SIEMPRE devuelve un array
    return res.status(200).json(result.rows);
  } catch (err) {
    console.error("Error en Getusuarios:", err);
    return res.status(500).json({
      error: "Error al obtener participantes.",
      details: err.message,
    });
  } finally {
    client.release();
  }
});

Routes.get("/ObtenerParticipanteConcurso/:id", async (req, res) => {
  const { id } = req.params; // Obtiene el ID del participante desde los parámetros de la URL

  try {
    console.log(
      `Obteniendo información del participante con ID: ${id} y sus concursos`,
    );

    const client = await pool.connect();
    const query = `
      SELECT 
        p.nombre as nombre_P, p.cedula as cedula_P,
        c.*,
        cp.*
      FROM 
        participante p
      JOIN 
        c_p cp ON p.id_participante = cp.participante_id
      JOIN 
        concurso c ON c.id_concurso = cp.concurso_id
      WHERE 
        p.id_participante = $1;
    `;

    const result = await client.query(query, [id]);
    client.release();

    if (result.rowCount === 0) {
      return res.status(404).json({
        mensaje: `No se encontró ningún participante con el ID: ${id} o no está registrado en concursos`,
      });
    }

    res.status(200).json({
      mensaje: `Información del participante con ID ${id} obtenida exitosamente`,
      participante: result.rows[0], // Datos del participante
      concursos: result.rows.map((row) => ({
        concurso_id: row.id_concurso,
        nombre_concurso: row.nombre,
        fecha_concurso: row.fecha,
        categoria_concurso: row.categoria,
        tema_concurso: row.tema,
        posicion: row.posicion,
        mencion: row.mencion,
      })),
    });
  } catch (err) {
    console.error(
      `Error al obtener información del participante con ID ${id}:`,
      err,
    );
    res.status(500).json({
      error: `Error al obtener información del participante con ID ${id} en la base de datos`,
      details: err.message,
    });
  }
});

// New Endpoint: ObtenerParticipanteTaller
Routes.get("/ObtenerParticipanteTaller/:id", async (req, res) => {
  const { id } = req.params; // Obtiene el ID del participante desde los parámetros de la URL

  try {
    console.log(
      `Obteniendo información del participante con ID: ${id} y sus talleres`,
    );

    const client = await pool.connect();
    const query = `
      SELECT
        p.nombre as nombre_P, p.cedula as cedula_P,
        t.*,
        tp.*
      FROM
        participante p
      JOIN
        t_p tp ON p.id_participante = tp.participante_id
      JOIN
        taller t ON t.id_taller = tp.taller_id
      WHERE
        p.id_participante = $1;
    `;

    const result = await client.query(query, [id]);
    client.release();

    if (result.rowCount === 0) {
      return res.status(204).json({
        mensaje: `No se encontró ningún participante con el ID: ${id} o no está registrado en talleres`,
      });
    }

    // Extract participant details from the first row (they will be the same across all rows for this participant)
    const { nombre_P, cedula_P } = result.rows[0];

    res.status(200).json({
      mensaje: `Información del participante con ID ${id} obtenida exitosamente`,
      talleres: result.rows.map((row) => ({
        nombre_p: row.nombre_p,
        cedula_p: row.cedula_p,
        taller_id: row.id_taller,
        nombre_taller: row.nombre,
        fecha_taller: row.fecha,
        lugar_taller: row.lugar,
      })),
    });
  } catch (err) {
    console.error(
      `Error al obtener información del participante con ID ${id} y sus talleres:`,
      err,
    );
    res.status(500).json({
      error: `Error al obtener información del participante con ID ${id} y sus talleres en la base de datos`,
      details: err.message,
    });
  }
});

Routes.get("/ObtenerParticipanteExposicion/:id", async (req, res) => {
  const { id } = req.params; // Obtiene el ID del participante desde los parámetros de la URL

  try {
    console.log(
      `Obteniendo información del participante con ID: ${id} y sus exposiciones`,
    );

    const client = await pool.connect();
    const query = `
      SELECT
        p.nombre as nombre_P, p.cedula as cedula_P,
        e.id_expo, e.nombre AS nombre_exposicion, e.fecha AS fecha_exposicion,
        e.tipo AS tipo_exposicion, e.lugar AS lugar_exposicion, e.tema AS tema_exposicion,
        ep.id AS ep_id, ep.numero_obra,
        o.id_obra, o.titulo AS obra_titulo, o.tecnica AS obra_tecnica,
        o.ancho AS obra_ancho, o.alto AS obra_alto, o.anio AS obra_anio,
        o.tema AS obra_tema, o.estilo AS obra_estilo, o.numero_obra AS obra_numero
      FROM
        participante p
      JOIN
        e_p ep ON p.id_participante = ep.participante_id
      JOIN
        exposicion e ON e.id_expo = ep.exposicion_id
      LEFT JOIN
        obra o ON o.id_obra = ep.obra_id
      WHERE
        p.id_participante = $1
      ORDER BY e.fecha DESC, e.id_expo;
    `;

    const result = await client.query(query, [id]);
    client.release();

    if (result.rowCount === 0) {
      return res.status(204).json({
        mensaje: `No se encontró ningún participante con el ID: ${id} o no está registrado en exposiciones`,
      });
    }

    const { nombre_P, cedula_P } = result.rows[0];

    res.status(200).json({
      mensaje: `Información del participante con ID ${id} obtenida exitosamente`,
      exposiciones: result.rows.map((row) => ({
        nombre: row.nombre_p,
        cedula: row.cedula_p,
        exposicion_id: row.id_expo,
        nombre_exposicion: row.nombre_exposicion,
        tipo_exposicion: row.tipo_exposicion,
        fecha_exposicion: row.fecha_exposicion,
        tema_exposicion: row.tema_exposicion,
        lugar_exposicion: row.lugar_exposicion,
        ep_id: row.ep_id,
        numero_obra: row.numero_obra,
        obra: row.id_obra ? {
          id_obra: row.id_obra,
          numero: row.obra_numero,
          titulo: row.obra_titulo,
          tecnica: row.obra_tecnica,
          ancho: row.obra_ancho,
          alto: row.obra_alto,
          anio: row.obra_anio,
          tema: row.obra_tema,
          estilo: row.obra_estilo,
        } : (row.numero_obra != null ? {
          id_obra: null,
          numero: row.numero_obra,
          titulo: null,
          tecnica: null,
          ancho: null,
          alto: null,
          anio: null,
          tema: null,
          estilo: null,
        } : null),
      })),
    });
  } catch (err) {
    console.error(
      `Error al obtener información del participante con ID ${id}:`,
      err,
    );
    res.status(500).json({
      error: `Error al obtener información del participante con ID ${id} en la base de datos`,
      details: err.message,
    });
  }
});

Routes.post("/InsertarParticipante", async (req, res) => {
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    const participante = req.body;
    console.log("Datos recibidos:", participante);
    if (
      !participante.nombre ||
      !participante.fecha_nacimiento ||
      !participante.correo ||
      !participante.ciudad ||
      !participante.telefono
    ) {
      return res.status(400).json({
        error:
          'Los campos "nombre", "fecha nacimiento", "correo", "ciudad" y teléfono son obligatorios.',
      });
    }

    const nombreFormateado = formatearNombre(participante.nombre);
    const telefonoFormateado = normalizarTelefono(participante.telefono) || String(participante.telefono).trim();
    const cedulaLimpia = participante.cedula ? String(participante.cedula).trim().replace(/\./g, '').replace(/\s/g, '').replace(/^[VvEe]-?/i, '') : null;

    // Verificar si la cédula ya está registrada
    if (cedulaLimpia) {
      const cedulaExistente = await client.query(
        "SELECT id_participante, nombre FROM participante WHERE cedula = $1",
        [cedulaLimpia]
      );
      if (cedulaExistente.rows.length > 0) {
        await client.query("ROLLBACK");
        return res.status(409).json({
          error: `Ya existe un participante registrado con la cédula ${cedulaLimpia} a nombre de "${cedulaExistente.rows[0].nombre}".`,
          participante_existente: cedulaExistente.rows[0],
        });
      }
    }

    const query = `

      INSERT INTO participante (nombre, cedula, fecha_nacimiento, correo, ciudad, instagram, estado_id)
      VALUES ($1, $2, $3, $4, $5, $6, (SELECT id_estado FROM estado WHERE UPPER(nombre)=UPPER($7)))
      RETURNING id_participante, nombre, cedula, fecha_nacimiento, correo, ciudad, instagram, estado_id;
    `;
    const values = [
      nombreFormateado,
      cedulaLimpia || null,
      participante.fecha_nacimiento,
      participante.correo,
      participante.ciudad,
      participante.instagram || null,
      participante.estado || null,
    ];

    const result = await client.query(query, values);
    const id_participante = result.rows[0].id_participante;
    const query2 = `
      INSERT INTO telefono(numero_telefonico, participante_id)
      VALUES ($1, $2);
    `;
    await client.query(query2, [telefonoFormateado, id_participante]);
    await client.query("COMMIT");
    res.status(201).json({
      mensaje: "Participante insertado exitosamente",
      exposicion: result.rows[0],
    });
  } catch (err) {
    await client.query("ROLLBACK");
    console.error("Error al insertar el participante:", err);
    res.status(500).json({
      error: "Error al insertar el participante en la base de datos",
      details: err.message,
    });
  } finally {
    client.release();
  }
});

Routes.delete("/EliminarParticipante/:id", async (req, res) => {
  const { id } = req.params;
  try {
    console.log(`Intentando eliminar el participante con ID:${id}`);
    const client = await pool.connect();
    //Las relaciones están definidas con ON DELETE CASCADE, así que no es necesario
    //estar borrando las tablas a las que el participante está relacionado manualmente
    const query = `
      DELETE FROM participante
      WHERE id_participante=$1
      RETURNING id_participante;
    `;
    const result = await client.query(query, [id]);
    client.release();
    if (result.rowCount === 0) {
      return res.status(404).json({
        mensaje: `No se encontró ningun participante con el ID: ${id} para eliminar.`,
      });
    }
    res.status(200).json({
      mensaje: `Participante con ID ${id} eliminado exitosamente.`,
      id_participante_eliminado: result.rows[0].id_participante,
    });
  } catch (err) {
    console.error(`Error al eliminar el participante con ID ${id}:`, err);
    res.status(500).json({
      error: `Error al eliminar el participante con ID ${id} de la base de datos.`,
      details: err.message,
    });
  }
});

Routes.put("/ModificarParticipante/:id", async (req, res) => {
  const { id } = req.params;
  const participante = req.body;

  const client = await pool.connect();

  // Helpers
  const trimOrNull = (v) => {
    if (v === undefined || v === null) return null;
    const s = String(v).trim();
    return s.length ? s : null;
  };

  try {
    await client.query("BEGIN");

    console.log(
      `Intento de modificar el participante con ID: ${id}`,
      participante,
    );

    // Validación mínima (mantengo tu regla)
    const rawNombre = trimOrNull(participante.nombre);
    const fecha_nacimiento = trimOrNull(participante.fecha_nacimiento);
    const correo = trimOrNull(participante.correo);
    const ciudad = trimOrNull(participante.ciudad);
    const rawTelefono = trimOrNull(participante.telefono);

    if (!rawNombre || !fecha_nacimiento || !correo || !ciudad || !rawTelefono) {
      await client.query("ROLLBACK");
      return res.status(400).json({
        error:
          'Los campos "nombre", "fecha nacimiento", "correo", "ciudad" y "teléfono" son obligatorios.',
      });
    }

    const nombre = formatearNombre(rawNombre);
    const telefono = normalizarTelefono(rawTelefono) || rawTelefono;

    // --- Resolver estado_id (opcional) ---
    const estadoNombre = trimOrNull(participante.estado);
    let estado_id = null;
    if (estadoNombre) {
      const estadoRes = await client.query(
        `SELECT id_estado FROM estado WHERE UPPER(TRIM(nombre)) = UPPER(TRIM($1)) LIMIT 1;`,
        [estadoNombre],
      );
      if (estadoRes.rowCount === 0) {
        await client.query("ROLLBACK");
        return res.status(400).json({
          error: `Estado inválido: "${estadoNombre}". No existe en la tabla estado.`,
        });
      }
      estado_id = estadoRes.rows[0].id_estado;
    }

    // Update participante
    const query = `
      UPDATE participante
      SET nombre=$1,
          cedula=$2,
          fecha_nacimiento=$3,
          correo=$4,
          ciudad=$5,
          instagram=$6,
          estado_id=$7
      WHERE id_participante=$8
      RETURNING *;
    `;

    const values = [
      nombre,
      trimOrNull(participante.cedula),
      fecha_nacimiento,
      correo,
      ciudad,
      trimOrNull(participante.instagram),
      estado_id,
      id,
    ];

    const result = await client.query(query, values);

    if (result.rowCount === 0) {
      await client.query("ROLLBACK");
      return res.status(404).json({
        mensaje: `No se encontró ningun participante con el ID: ${id} para modificar.`,
      });
    }

    // Update or Insert telefono
    const telCheck = await client.query("SELECT id_telefono FROM telefono WHERE participante_id = $1 LIMIT 1;", [id]);
    let result2;
    if (telCheck.rowCount > 0) {
      const query2 = `
        UPDATE telefono
        SET numero_telefonico=$1
        WHERE participante_id=$2
        RETURNING *;
      `;
      result2 = await client.query(query2, [telefono, id]);
    } else {
      const query2 = `
        INSERT INTO telefono (numero_telefonico, participante_id)
        VALUES ($1, $2)
        RETURNING *;
      `;
      result2 = await client.query(query2, [telefono, id]);
    }

    await client.query("COMMIT");

    return res.status(200).json({
      mensaje: `Participante con ID ${id} modificado exitosamente.`,
      participante: result.rows[0],
      telefono: result2.rows?.[0] ?? null,
    });
  } catch (err) {
    // Importante: rollback si algo falla
    try {
      await client.query("ROLLBACK");
    } catch (_) {}

    console.error(`Error al modificar el participante con ID ${id}:`, err);

    return res.status(500).json({
      error: `Error al modificar el participante con ID ${id} de la base de datos.`,
      details: err.message,
    });
  } finally {
    client.release();
  }
});

Routes.post("/agregrarParticipanteExpo/:idParticipante", async (req, res) => {
  const { idParticipante } = req.params;
  const datos = req.body;
  const client = await pool.connect();
  try {
    if (!idParticipante || !datos.idExpo || !datos.numObra) {
      return res.status(400).json({
        error:
          "No se ha especificado participante, exposición o número de obra",
      });
    }
    const query = `
      INSERT INTO E_P(numero_obra, exposicion_id, participante_id)
      VALUES ($1, $2, $3)
      RETURNING *;
    `;
    values = [datos.numObra, datos.idExpo, idParticipante];
    const result = await client.query(query, values);
    res.status(201).json({
      mensaje: "Operación exitosa",
      resultado: result.rows[0],
    });
  } catch (error) {
    res.status(500).json({
      error: `Error al asignarle la exposicion al participante.`,
      details: error.message,
    });
  } finally {
    client.release();
  }
});

Routes.post(
  "/agregarParticipanteConcurso/:idParticipante",
  async (req, res) => {
    const { idParticipante } = req.params;
    const datos = req.body;
    const client = await pool.connect();
    try {
      if (!idParticipante || !datos.idConcurso) {
        return res.status(400).json({
          error: "No se ha especificado participante o concurso",
        });
      }
      const query = `
      INSERT INTO C_P(mencion, posicion, concurso_id, participante_id)
      VALUES ($1, $2, $3, $4)
      RETURNING *;
    `;
      values = [
        datos.mencion,
        datos.posicion,
        datos.idConcurso,
        idParticipante,
      ];
      const result = await client.query(query, values);
      res.status(201).json({
        mensaje: "Operación exitosa",
        resultado: result.rows[0],
      });
    } catch (error) {
      res.status(500).json({
        error: `Error al asignarle la exposicion al participante.`,
        details: error.message,
      });
    } finally {
      client.release();
    }
  },
);

Routes.post("/agregarParticipanteTaller/:idParticipante", async (req, res) => {
  const { idParticipante } = req.params;
  const datos = req.body;
  const client = await pool.connect();
  try {
    if (!idParticipante || !datos.idTaller) {
      return res.status(400).json({
        error: "No se ha especificado participante o taller",
      });
    }
    const query = `
      INSERT INTO T_P(taller_id, participante_id)
      VALUES ($1, $2)
      RETURNING *;
    `;
    values = [datos.idTaller, idParticipante];
    const result = await client.query(query, values);
    res.status(201).json({
      mensaje: "Operación exitosa",
      resultado: result.rows[0],
    });
  } catch (error) {
    res.status(500).json({
      error: `Error al asignarle la exposicion al participante.`,
      details: error.message,
    });
  } finally {
    client.release();
  }
});

// =========================================================
// GET /Participantes/GetEstados
// Devuelve todos los estados de la tabla estado ordenados alfabéticamente
// =========================================================
Routes.get("/GetEstados", async (req, res) => {
  const client = await pool.connect();
  try {
    const result = await client.query(
      "SELECT id_estado, nombre FROM estado ORDER BY nombre ASC;"
    );
    return res.status(200).json(result.rows);
  } catch (err) {
    console.error("Error en GetEstados:", err);
    return res.status(500).json({
      error: "Error al obtener los estados.",
      details: err.message,
    });
  } finally {
    client.release();
  }
});

module.exports = Routes;

