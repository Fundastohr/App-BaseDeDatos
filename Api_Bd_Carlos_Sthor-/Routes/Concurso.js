const express = require("express");
const { Pool } = require("pg");
const multer = require("multer");
const XLSX = require("xlsx");
const Routes = express.Router();
const Class_Concurso = require("../Classes/Class_Concurso");

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

Routes.get("/Getconcursos", async (req, res) => {
  try {
    console.log(process.env);
    const client = await pool.connect();
    const result = await client.query("SELECT * FROM concurso"); // Consulta a la tabla 'concurso'
    const concursosData = result.rows;
    client.release(); // Libera la conexión al pool

    // Mapea los resultados de la base de datos a instancias de la clase Concurso
    const concursos = concursosData.map((data) => {
      return new Class_Concurso(
        data.id_concurso,
        data.nombre,
        data.fecha,
        data.categoria,
        data.tema
      );
    });

    console.log(concursos);

    res.json(concursos);
  } catch (err) {
    console.error("Error al conectar o consultar la base de datos para concursos:", err);
    res
      .status(500)
      .send("Error al conectar o consultar la base de datos para concursos");
  }
});

Routes.post("/InsertConcurso", async (req, res) => {
  try {
    const concurso = req.body;

    console.log(concurso.nombre);

    // Validar que los campos obligatorios estén presentes
    if (!concurso.nombre || !concurso.fecha) {
      return res
        .status(400)
        .json({ error: 'Los campos "nombre" y "fecha" son obligatorios.' });
    }

    const client = await pool.connect();
    const query = `
            INSERT INTO Concurso (nombre, fecha, Categoria, Tema)
            VALUES ($1, $2, $4, $3)
            RETURNING *`; // Agregué RETURNING * para obtener el registro insertado

    const values = [
      concurso.nombre,
      concurso.fecha,
      concurso.categoria || null, // Si no viene categoria, se inserta null
      concurso.tema || null, // Si no viene tema, se inserta null
    ];

    const result = await client.query(query, values);
    client.release();

    res.status(201).json({
      mensaje: "Concurso insertado exitosamente",
      concurso: result.rows[0], // Devuelve el concurso insertado
    });
  } catch (err) {
    console.error("Error al insertar el concurso:", err);
    res.status(500).json({
      error: "Error al insertar el concurso en la base de datos",
      details: err.message,
    });
  }
});

Routes.put("/ModificarConcurso/:id", async (req, res) => {
  const { id } = req.params; // Obtiene el ID del concurso a modificar desde los parámetros de la URL
  const concurso = req.body;

  try {
    console.log(`Intento de modificar el concurso con ID: ${id}`, concurso);

    // Validar que los campos obligatorios estén presentes en el cuerpo
    if (!concurso.nombre || !concurso.fecha) {
      return res.status(400).json({
        error:
          'Los campos "nombre" y "fecha" son obligatorios para la modificación.',
      });
    }

    const client = await pool.connect();
    const query = `
          UPDATE Concurso
          SET nombre = $1,
              fecha = $2,
              Categoria = $3,
              Tema = $4
          WHERE id_concurso = $5
          RETURNING *; 
        `;

    const values = [
      concurso.nombre,
      concurso.fecha,
      concurso.categoria || null,
      concurso.tema || null,
      id, // El ID del concurso a modificar
    ];

    const result = await client.query(query, values);
    client.release();

    if (result.rowCount === 0) {
      return res
        .status(404)
        .json({ mensaje: `No se encontró ningún concurso con el ID: ${id}` });
    }

    res.status(200).json({
      mensaje: `Concurso con ID ${id} modificado exitosamente`,
      concurso: result.rows[0], // Devuelve el concurso modificado
    });
  } catch (err) {
    console.error(`Error al modificar el concurso con ID ${id}:`, err);
    res.status(500).json({
      error: `Error al modificar el concurso con ID ${id} en la base de datos`,
      details: err.message,
    });
  }
});

Routes.delete("/EliminarConcurso/:id", async (req, res) => {
  const { id } = req.params; // Obtiene el ID del concurso a eliminar desde los parámetros de la URL

  try {
    console.log(`Intento de eliminar el concurso con ID: ${id}`);

    const client = await pool.connect();
    const query = `
      DELETE FROM Concurso
      WHERE id_concurso = $1
      RETURNING id_concurso;
    `;

    const result = await client.query(query, [id]);
    client.release();

    if (result.rowCount === 0) {
      return res.status(404).json({
        mensaje: `No se encontró ningún concurso con el ID: ${id} para eliminar.`,
      });
    }

    res.status(200).json({
      mensaje: `Concurso con ID ${id} eliminado exitosamente.`,
      id_concurso_eliminado: result.rows[0].id_concurso, // Devuelve el ID del concurso eliminado
    });
  } catch (err) {
    console.error(`Error al eliminar el concurso con ID ${id}:`, err);
    res.status(500).json({
      error: `Error al eliminar el concurso con ID ${id} de la base de datos.`,
      details: err.message,
    });
  }
});

Routes.get("/ParticipantesConcurso/:idConcurso", async (req, res) => {
  const { idConcurso } = req.params;
  if (!idConcurso) {
    return res.status(400).json({ error: "id inválido" });
  }
  try {
    const client = await pool.connect();
    const query = `
        SELECT p.nombre AS nombre_p, p.cedula AS cedula_p, p.id_participante AS id, cp.posicion, cp.mencion,
               COALESCE(STRING_AGG(DISTINCT t.numero_telefonico, ', '), 'N/A') AS telefono
        FROM C_P cp JOIN concurso c ON c.id_concurso=cp.concurso_id
        JOIN participante p ON p.id_participante=cp.participante_id
        LEFT JOIN telefono t ON t.participante_id=p.id_participante
        WHERE c.id_concurso=$1
        GROUP BY p.id_participante, p.nombre, p.cedula, cp.posicion, cp.mencion
        ORDER BY cp.posicion ASC NULLS LAST, cp.mencion ASC NULLS LAST, p.nombre ASC;
      `;
    const params = [idConcurso];
    const result = await client.query(query, params);
    client.release();
    if (result.rowCount === 0) {
      return res.status(204).json({
        mensaje: `No se encontró ningún participante en el concurso ID: ${idConcurso}`,
      });
    }
    res.status(200).json({
      personas: result.rows.map((row) => ({
        id: row.id,
        nombre: row.nombre_p,
        cedula: row.cedula_p,
        posicion: row.posicion,
        mencion: row.mencion,
        telefono: row.telefono,
      })),
    });
  } catch (error) {
    res.status(500).json({
      error: `Error al obtener los participantes del concurso con ID ${idConcurso}`,
      details: error.message,
    });
  }
});

Routes.get("/NoParticipantesConcurso/:idConcurso", async (req, res) => {
  const { idConcurso } = req.params;
  if (!idConcurso) {
    return res.status(400).json({ error: "id inválido" });
  }
  try {
    const client = await pool.connect();
    const query = `
        SELECT p.nombre AS nombre_p, p.cedula AS cedula_p, p.id_participante AS id
        FROM participante p
        WHERE NOT EXISTS (SELECT * FROM C_P WHERE C_P.participante_id=p.id_participante AND C_P.concurso_id=$1);
      `;
    const params = [idConcurso];
    const result = await client.query(query, params);
    client.release();
    if (result.rowCount === 0) {
      return res.status(204).json({
        mensaje: `No se encontró ningún participante en la concurso ID: ${id}`,
      });
    }
    res.status(200).json({
      personas: result.rows.map((row) => ({
        id: row.id,
        nombre: row.nombre_p,
        cedula: row.cedula_p,
      })),
    });
  } catch (error) {
    res.status(500).json({
      error: `Error al obtener los participantes de la concurso con ID ${idConcurso} en la base de datos`,
      details: error.message,
    });
  }
});

Routes.post("/InsertarParticipanteConcurso", async (req, res) => {
  const datos = req.body;
  if (!datos.concurso || !datos.participante) {
    return res.status(400).json({ error: "Concurso o participante inválido" });
  }
  try {
    const client = await pool.connect();
    const query = `
        INSERT INTO C_P(participante_id,concurso_id) VALUES ($1,$2)
        RETURNING *;
      `;
    const params = [datos.participante, datos.concurso];
    const result = await client.query(query, params);
    client.release();
    res.status(201).json({
      mensaje: "Participante agregado con éxito",
    });
  } catch (error) {
    res.status(500).json({
      error: `Error al insertar el participante en el concurso, ${error}`,
      details: error.message,
    });
  }
});

// =========================================================
// POST /Concurso/ImportarExcelConcurso
// Importa un concurso completo desde Excel (todas las hojas).
// Crea un concurso por cada hoja (Infantil, Juvenil, Adulto),
// comprueba si los participantes existen por cédula, los crea
// si no existen, y los vincula al concurso con posición/mención.
// =========================================================
Routes.post("/ImportarExcelConcurso", upload.single("archivo"), async (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: "No se recibió ningún archivo." });
  }

  // Campos del concurso que se repiten en todas las hojas
  const { nombre, fecha, tema, estado_defecto } = req.body;

  if (!nombre || !fecha) {
    return res.status(400).json({ error: 'Los campos "nombre" y "fecha" son obligatorios.' });
  }

  let workbook;
  try {
    workbook = XLSX.read(req.file.buffer, { type: "buffer", cellDates: false });
  } catch (e) {
    return res.status(400).json({ error: "El archivo no es un Excel válido.", details: e.message });
  }

  // Hojas que contienen participantes (ignorar Jueces y Pendientes)
  const hojasParticipantes = ["Infantil", "Juvenil", "Adulto"];
  const hojasDisponibles = workbook.SheetNames.filter((n) =>
    hojasParticipantes.includes(n)
  );

  if (hojasDisponibles.length === 0) {
    return res.status(400).json({
      error: "El Excel no contiene hojas reconocidas (Infantil, Juvenil, Adulto).",
      hojas_encontradas: workbook.SheetNames,
    });
  }

  // Normaliza una cédula: quita puntos, espacios y prefijo V-/E-
  function normalizarCedula(raw) {
    if (!raw && raw !== 0) return null;
    const clean = String(raw)
      .trim()
      .replace(/\./g, "")
      .replace(/\s/g, "")
      .replace(/^[VvEe]-?/i, "");
    return clean || null;
  }

  // Convierte el serial de fecha de Excel (días desde 1900-01-00) o string a YYYY-MM-DD
  function parseFechaNacimiento(raw, categoria) {
    if (!raw && raw !== 0) {
      // Fecha por defecto según categoría si no viene fecha
      if (categoria === "Infantil") return "2013-01-01";
      if (categoria === "Juvenil") return "2008-01-01";
      return "1995-01-01";
    }

    const num = parseFloat(raw);
    if (!isNaN(num) && num > 1000) {
      const msPerDay = 86400000;
      const excelEpoch = new Date(Date.UTC(1899, 11, 30));
      const date = new Date(excelEpoch.getTime() + num * msPerDay);
      if (!isNaN(date.getTime())) {
        return date.toISOString().split("T")[0];
      }
    }

    const date = new Date(raw);
    if (!isNaN(date.getTime())) {
      return date.toISOString().split("T")[0];
    }

    if (categoria === "Infantil") return "2013-01-01";
    if (categoria === "Juvenil") return "2008-01-01";
    return "1995-01-01";
  }

  // Clasifica la columna "Ganadores":
  function clasificarGanador(raw) {
    if (!raw && raw !== 0) return { posicion: null, mencion: null };
    const val = String(raw).trim();
    if (!val) return { posicion: null, mencion: null };

    // Mapa de posiciones en español
    const posMap = { "1er": 1, "1ro": 1, "1°": 1, "2do": 2, "2°": 2, "3er": 3, "3ro": 3, "3°": 3, "4to": 4, "4°": 4 };
    const posKey = val.toLowerCase().replace(/\s+/g, "");
    for (const [k, v] of Object.entries(posMap)) {
      if (posKey === k) return { posicion: v, mencion: null };
    }

    // Si es solo número (folio de inscripción), ignorar
    if (/^\d+$/.test(val.replace(/\./g, ""))) {
      return { posicion: null, mencion: null };
    }

    // Todo lo demás que no sea número puro se trata como mención
    return { posicion: null, mencion: val };
  }

  const client = await pool.connect();
  const resumen = [];

  try {
    // Obtener el id_estado del estado por defecto (o 'Nueva Esparta' o el primero)
    let id_estado_defecto = null;
    const estNombre = estado_defecto || "Nueva Esparta";
    const estRes = await client.query(
      "SELECT id_estado FROM estado WHERE UPPER(nombre) = UPPER($1)",
      [estNombre]
    );
    if (estRes.rows.length > 0) {
      id_estado_defecto = estRes.rows[0].id_estado;
    } else {
      const primerEstado = await client.query("SELECT id_estado FROM estado ORDER BY id_estado ASC LIMIT 1");
      if (primerEstado.rows.length > 0) {
        id_estado_defecto = primerEstado.rows[0].id_estado;
      }
    }

    // Diccionario de alias flexibles para los encabezados de columnas
    const headerAliases = {
      nombre: ["participante", "nombre", "nombre completo", "nombres", "name"],
      cedula: ["ci", "cedula", "cédula", "documento", "identidad", "dni", "c.i.", "c.i"],
      ganador: ["ganadores", "ganador", "lugar", "posicion", "posicion/mencion", "premio", "mencion", "mención"],
      correo: ["correo electronico", "correo electrónico", "correo", "email", "mail"],
      ciudad: ["zona donde vive", "zona", "ciudad", "municipio", "direccion", "dirección", "residencia", "sector", "localidad"],
      instagram: ["id instagram", "instagram", "ig", "usuario instagram", "red social"],
      fecha_nacimiento: ["fecha nacimiento", "fecha de nacimiento", "fecha_nacimiento", "nacimiento", "f. nac", "f. nacimiento"],
      telefono: ["telf", "telefono", "teléfono", "celular", "tlf", "movil", "móvil", "phone"],
    };

    const normalizeHeader = (h) =>
      String(h || "")
        .trim()
        .normalize("NFKD")
        .replace(/[\u0300-\u036f]/g, "")
        .toLowerCase();

    for (const hoja of hojasDisponibles) {
      const categoria = hoja; // "Infantil", "Juvenil" o "Adulto"
      const ws = workbook.Sheets[hoja];
      const rows = XLSX.utils.sheet_to_json(ws, { header: "A", defval: "" });

      if (!rows || rows.length === 0) continue;

      // 1. Detectar automáticamente la fila de encabezados buscando coincidencias con los alias
      let headerRowIndex = -1;
      let fieldColMapping = {}; // { campo: 'A' | 'B' | 'D' ... }

      for (let r = 0; r < Math.min(rows.length, 6); r++) {
        const candidateRow = rows[r];
        const tempMapping = {};
        let matchesCount = 0;

        for (const [colKey, cellVal] of Object.entries(candidateRow)) {
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

        // Si esta fila tiene 'nombre' o al menos 2 encabezados reconocidos, es la fila de encabezados
        if (tempMapping.nombre || matchesCount >= 2) {
          headerRowIndex = r;
          fieldColMapping = tempMapping;
          break;
        }
      }

      // Si no se detectó una fila de encabezados, usar columnas por defecto
      const fallbackMapping = {
        ganador: "A",
        nombre: "D",
        cedula: "E",
        fecha_nacimiento: "G",
        telefono: "I",
        correo: "J",
        ciudad: "K",
        instagram: "L",
      };

      const mapping = Object.keys(fieldColMapping).length >= 2 ? fieldColMapping : fallbackMapping;
      const dataStartIdx = headerRowIndex >= 0 ? headerRowIndex + 1 : 2;
      const dataRows = rows.slice(dataStartIdx);

      // Crear el concurso para esta categoría
      const concursoRes = await client.query(
        `INSERT INTO Concurso (nombre, fecha, Categoria, Tema)
         VALUES ($1, $2, $3, $4)
         RETURNING *`,
        [nombre, fecha, categoria, tema || null]
      );
      const concurso = concursoRes.rows[0];
      const concurso_id = concurso.id_concurso;

      const hojaResumen = {
        categoria,
        concurso_id,
        insertados: 0,
        ya_existian: 0,
        vinculados: 0,
        errores: [],
      };

      const processedDedupeKeys = new Set();

      for (let i = 0; i < dataRows.length; i++) {
        const row = dataRows[i];
        const filaNum = dataStartIdx + i + 1; // Número de fila 1-indexed en el Excel

        const getVal = (field) => {
          const col = mapping[field];
          if (!col) return "";
          const val = row[col];
          return val !== undefined && val !== null ? val : "";
        };

        const rawNombre = String(getVal("nombre") || "").trim().replace(/\xa0/g, " ").trim();
        const cedulaRaw = getVal("cedula");
        const ganadorRaw = getVal("ganador");
        const correoRaw = String(getVal("correo") || "").trim().replace(/\xa0/g, " ").trim();
        const ciudadRaw = String(getVal("ciudad") || "").trim().replace(/\xa0/g, " ").trim();
        const instagramRaw = String(getVal("instagram") || "").trim().replace(/\xa0/g, " ").trim();
        const fechaNacRaw = getVal("fecha_nacimiento");
        const telefonoRaw = getVal("telefono");

        // Saltar filas sin nombre
        if (!rawNombre || rawNombre.length < 2 || /^\d+$/.test(rawNombre)) continue;

        const cedula = normalizarCedula(cedulaRaw);
        const nombreFormateado = formatearNombre(rawNombre);

        // Control de duplicados en la misma hoja/concurso
        const dedupeKey = cedula ? `CI:${cedula}` : `NAME:${normalizeHeader(rawNombre)}`;
        if (processedDedupeKeys.has(dedupeKey)) {
          continue;
        }
        processedDedupeKeys.add(dedupeKey);

        const fechaNac = parseFechaNacimiento(fechaNacRaw, categoria);
        const { posicion, mencion } = clasificarGanador(ganadorRaw);

        // Fallbacks para campos NOT NULL
        const correo = correoRaw || `${cedula ? 'ci' + cedula : 'user' + filaNum}@fundacionstohr.org`;
        const ciudad = ciudadRaw || "Nueva Esparta";
        const instagramFinal = instagramRaw && instagramRaw.toLowerCase() !== "no aplica" ? instagramRaw : null;
        const telefono = normalizarTelefono(telefonoRaw);

        try {
          await client.query("BEGIN");

          let id_participante = null;

          // 1. Buscar si ya existe por cédula (prioridad absoluta para respetar nombre oficial registrado)
          if (cedula) {
            const busquedaCedula = await client.query(
              "SELECT id_participante, nombre FROM participante WHERE cedula = $1",
              [cedula]
            );
            if (busquedaCedula.rows.length > 0) {
              id_participante = busquedaCedula.rows[0].id_participante;
              const nombreEnBd = busquedaCedula.rows[0].nombre;
              hojaResumen.ya_existian++;
              if (nombreEnBd && nombreEnBd === nombreEnBd.toUpperCase()) {
                await client.query("UPDATE participante SET nombre = $1 WHERE id_participante = $2", [formatearNombre(nombreEnBd), id_participante]);
              }
            }
          }

          // 2. Si no tiene cédula o no se encontró por cédula, buscar por nombre exacto
          if (!id_participante) {
            const busquedaNombre = await client.query(
              "SELECT id_participante, nombre FROM participante WHERE UPPER(nombre) = UPPER($1)",
              [nombreFormateado]
            );
            if (busquedaNombre.rows.length > 0) {
              id_participante = busquedaNombre.rows[0].id_participante;
              const actualNombre = busquedaNombre.rows[0].nombre;
              hojaResumen.ya_existian++;
              if (actualNombre && actualNombre === actualNombre.toUpperCase() && nombreFormateado) {
                await client.query("UPDATE participante SET nombre = $1 WHERE id_participante = $2", [nombreFormateado, id_participante]);
              }
            }
          }

          // 3. Si no existe, crear el participante
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
                instagramFinal,
                fechaNac,
                id_estado_defecto,
              ]
            );
            id_participante = insertP.rows[0].id_participante;
            hojaResumen.insertados++;
          }

          // 4. Insertar teléfono (deduplicación inteligente y estandarización)
          if (telefono && id_participante) {
            const telBusqueda = await client.query(
              "SELECT id_telefono, numero_telefonico FROM telefono WHERE participante_id = $1",
              [id_participante]
            );

            const existingList = telBusqueda.rows.map(r => ({
              id: r.id_telefono,
              norm: normalizarTelefono(r.numero_telefonico),
              raw: r.numero_telefonico
            }));

            const match = existingList.find(e => e.norm === telefono);
            if (match) {
              if (match.raw !== telefono) {
                await client.query("UPDATE telefono SET numero_telefonico = $1 WHERE id_telefono = $2", [telefono, match.id]);
              }
            } else {
              await client.query(
                "INSERT INTO telefono(numero_telefonico, participante_id) VALUES ($1, $2)",
                [telefono, id_participante]
              );
            }
          }

          // 5. Vincular a la tabla C_P con posición y mención
          const yaVinculado = await client.query(
            "SELECT id FROM c_p WHERE participante_id = $1 AND concurso_id = $2",
            [id_participante, concurso_id]
          );
          if (yaVinculado.rows.length === 0) {
            await client.query(
              `INSERT INTO c_p (participante_id, concurso_id, posicion, mencion)
               VALUES ($1, $2, $3, $4)`,
              [id_participante, concurso_id, posicion, mencion]
            );
            hojaResumen.vinculados++;
          }

          await client.query("COMMIT");
        } catch (err) {
          await client.query("ROLLBACK");
          console.error(`Error procesando fila ${filaNum} (${rawNombre}):`, err.message);
          hojaResumen.errores.push({ fila: filaNum, nombre: rawNombre, error: err.message });
        }
      }

      resumen.push(hojaResumen);
    }

    const tieneErrores = resumen.some((h) => h.errores.length > 0);
    return res.status(tieneErrores ? 207 : 201).json({
      mensaje: `Importación completada: ${hojasDisponibles.length} categoría(s) procesada(s).`,
      resumen,
    });
  } catch (err) {
    console.error("Error general en ImportarExcelConcurso:", err);
    return res.status(500).json({ error: "Error interno al procesar la importación.", details: err.message });
  } finally {
    client.release();
  }
});

module.exports = Routes;

