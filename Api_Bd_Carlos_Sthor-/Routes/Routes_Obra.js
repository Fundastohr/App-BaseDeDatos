// File: Routes/Routes_Obra.js
const express = require("express");
const { Pool } = require("pg");

const router = express.Router();

// ✅ Asegura parsing JSON aunque se te olvide en app.js
router.use(express.json({ limit: "1mb" }));

const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: Number(process.env.DB_PORT || 5432),
});

function toTrimmedOrNull(v) {
  if (v === undefined || v === null) return null;
  const s = String(v).trim();
  return s === "" ? null : s;
}

// ✅ soporta coma/puntos tipo "23,5" o "1.234,56"
function toNumberOrNull(v) {
  if (v === "" || v === undefined || v === null) return null;

  let s = String(v).trim();
  if (!s) return null;

  s = s.replace(/\s/g, "");
  if (s.includes(",") && s.includes(".")) {
    s = s.replace(/\./g, "").replace(",", ".");
  } else {
    s = s.replace(",", ".");
  }

  const n = Number(s);
  return Number.isFinite(n) ? n : null;
}

function toIntOrNull(v) {
  const n = toNumberOrNull(v);
  return n === null ? null : Math.trunc(n);
}

/**
 * GET /GetObras
 * Retorna un ARRAY de obras
 */
router.get("/GetObras", async (req, res) => {
  try {
    const all = req.query.all === "true";
    let whereClause = "WHERE o.participante_id = 331";
    if (all) {
      whereClause = "";
    } else if (req.query.participante_id) {
      whereClause = `WHERE o.participante_id = ${Number(req.query.participante_id)}`;
    }

    const result = await pool.query(
      `
      SELECT
        o.id_obra, o.numero_obra, o.titulo, o.tecnica, o.ancho, o.alto, o.anio,
        o.tema, o.estilo, o.ubicacion, o.observacion, o.created_at, o.updated_at,
        o.participante_id,
        p.nombre AS nombre_participante
      FROM obra o
      LEFT JOIN participante p ON p.id_participante = o.participante_id
      ${whereClause}
      ORDER BY o.id_obra DESC
      `
    );

    return res.json(result.rows);
  } catch (e) {
    console.error("GetObras error:", e);
    return res.status(500).json({ message: "Error listando obras" });
  }
});


/**
 * GET /GetObra/:id
 */
router.get("/GetObra/:id", async (req, res) => {
  try {
    const id = Number(req.params.id);
    if (!Number.isFinite(id)) {
      return res.status(400).json({ message: "id inválido" });
    }

    const result = await pool.query(
      `
      SELECT
        o.id_obra, o.numero_obra, o.titulo, o.tecnica, o.ancho, o.alto, o.anio,
        o.tema, o.estilo, o.ubicacion, o.observacion, o.created_at, o.updated_at,
        o.participante_id,
        p.nombre AS nombre_participante
      FROM obra o
      LEFT JOIN participante p ON p.id_participante = o.participante_id
      WHERE o.id_obra = $1
      `,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Obra no encontrada" });
    }

    return res.json(result.rows[0]);
  } catch (e) {
    console.error("GetObra error:", e);
    return res.status(500).json({ message: "Error obteniendo obra" });
  }
});


/**
 * POST /AgregarObra
 */
router.post("/AgregarObra", async (req, res) => {
  try {
    const payload = {
      numero_obra:    toTrimmedOrNull(req.body?.numero_obra),
      titulo:         (req.body?.titulo ?? "").toString().trim(),
      tecnica:        toTrimmedOrNull(req.body?.tecnica),
      ancho:          toNumberOrNull(req.body?.ancho),
      alto:           toNumberOrNull(req.body?.alto),
      anio:           toIntOrNull(req.body?.anio),
      tema:           toTrimmedOrNull(req.body?.tema),
      estilo:         toTrimmedOrNull(req.body?.estilo),
      ubicacion:      toTrimmedOrNull(req.body?.ubicacion),
      observacion:    toTrimmedOrNull(req.body?.observacion),
      participante_id: req.body?.participante_id ? Number(req.body.participante_id) : 331,
    };

    if (!payload.titulo) {
      return res.status(400).json({ message: "El campo 'titulo' es obligatorio" });
    }

    const result = await pool.query(
      `
      INSERT INTO obra
        (numero_obra, titulo, tecnica, ancho, alto, anio, tema, estilo, ubicacion, observacion, participante_id)
      VALUES
        ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)
      RETURNING id_obra
      `,
      [
        payload.numero_obra,
        payload.titulo,
        payload.tecnica,
        payload.ancho,
        payload.alto,
        payload.anio,
        payload.tema,
        payload.estilo,
        payload.ubicacion,
        payload.observacion,
        payload.participante_id,
      ]
    );

    return res.status(201).json({ id_obra: result.rows[0].id_obra });
  } catch (e) {
    console.error("AgregarObra error:", e);

    if (e && e.code === "23505") {
      return res.status(409).json({ message: "Ya existe una obra con ese Número de Obra" });
    }

    return res.status(500).json({ message: "Error agregando obra" });
  }
});


/**
 * PUT /ActualizarObra/:id
 */
router.put("/ActualizarObra/:id", async (req, res) => {
  try {
    const id = Number(req.params.id);
    if (!Number.isFinite(id)) {
      return res.status(400).json({ message: "id inválido" });
    }

    const payload = {
      numero_obra:    toTrimmedOrNull(req.body?.numero_obra),
      titulo:         (req.body?.titulo ?? "").toString().trim(),
      tecnica:        toTrimmedOrNull(req.body?.tecnica),
      ancho:          toNumberOrNull(req.body?.ancho),
      alto:           toNumberOrNull(req.body?.alto),
      anio:           toIntOrNull(req.body?.anio),
      tema:           toTrimmedOrNull(req.body?.tema),
      estilo:         toTrimmedOrNull(req.body?.estilo),
      ubicacion:      toTrimmedOrNull(req.body?.ubicacion),
      observacion:    toTrimmedOrNull(req.body?.observacion),
      participante_id: req.body?.participante_id ? Number(req.body.participante_id) : 331,
    };

    if (!payload.titulo) {
      return res.status(400).json({ message: "El campo 'titulo' es obligatorio" });
    }

    const result = await pool.query(
      `
      UPDATE obra
      SET
        numero_obra = $1,
        titulo = $2,
        tecnica = $3,
        ancho = $4,
        alto = $5,
        anio = $6,
        tema = $7,
        estilo = $8,
        ubicacion = $9,
        observacion = $10,
        participante_id = $11,
        updated_at = NOW()
      WHERE id_obra = $12
      RETURNING id_obra
      `,
      [
        payload.numero_obra,
        payload.titulo,
        payload.tecnica,
        payload.ancho,
        payload.alto,
        payload.anio,
        payload.tema,
        payload.estilo,
        payload.ubicacion,
        payload.observacion,
        payload.participante_id,
        id,
      ]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Obra no encontrada" });
    }

    return res.json({ ok: true });
  } catch (e) {
    console.error("ActualizarObra error:", e);

    if (e && e.code === "23505") {
      return res.status(409).json({ message: "Ya existe una obra con ese Número de Obra" });
    }

    return res.status(500).json({ message: "Error actualizando obra" });
  }
});


/**
 * DELETE /EliminarObra/:id
 */
router.delete("/EliminarObra/:id", async (req, res) => {
  try {
    const id = Number(req.params.id);
    if (!Number.isFinite(id)) {
      return res.status(400).json({ message: "id inválido" });
    }

    const result = await pool.query(
      `DELETE FROM obra WHERE id_obra = $1 RETURNING id_obra`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Obra no encontrada" });
    }

    return res.json({ ok: true });
  } catch (e) {
    console.error("EliminarObra error:", e);
    return res.status(500).json({ message: "Error eliminando obra" });
  }
});

module.exports = router;