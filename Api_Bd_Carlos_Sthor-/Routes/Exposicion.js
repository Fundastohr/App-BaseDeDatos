const express = require('express');
const { Pool } = require('pg');
const multer = require('multer');
const XLSX = require('xlsx');
const Routes = express.Router();
const Exposicion = require('../Classes/Class_Exposicion.js');

// ──────────────────────────────────────────────────────────────
// Multer: acepta .xlsx, .xls y .docx
// ──────────────────────────────────────────────────────────────
const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 10 * 1024 * 1024 },
  fileFilter: (_req, file, cb) => {
    const allowed = [
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'application/vnd.ms-excel',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    ];
    const ok =
      allowed.includes(file.mimetype) ||
      file.originalname.endsWith('.xlsx') ||
      file.originalname.endsWith('.xls') ||
      file.originalname.endsWith('.docx');
    if (ok) cb(null, true);
    else cb(new Error('Solo se permiten archivos Excel (.xlsx/.xls) o Word (.docx)'));
  },
});

const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT || 5432,
});

// ──────────────────────────────────────────────────────────────
// Utilidades
// ──────────────────────────────────────────────────────────────

function formatearNombre(str) {
  if (!str) return '';
  return String(str)
    .replace(/\xa0/g, ' ')
    .replace(/\s+/g, ' ')
    .trim()
    .toLowerCase()
    .split(' ')
    .map(w => (w ? w.charAt(0).toUpperCase() + w.slice(1) : ''))
    .join(' ');
}

function esNombreValidoDePersona(nombre) {
  if (!nombre || typeof nombre !== 'string') return false;
  const s = nombre.trim();
  if (s.length < 3 || s.length > 50) return false;
  if (/[\d\(\)\[\]\{\}\/\\\"«»“”]/.test(s)) return false;
  const stopWords = [
    'fotografia', 'fotografía', 'formica', 'mariposa', 'oleo', 'óleo', 'acuarela',
    'tinta', 'papel', 'lienzo', 'tecnica', 'técnica', 'obra', 'dibujo', 'mixta',
    'grafito', 'creyon', 'creyón', 'gouache', 'opalina', 'base', 'clip', 'rincon',
    'rincón', 'raspado', 'recuerdo', 'compremos', 'sierra', 'empanada', 'plaza',
    'artesano', 'espiritu', 'espíritu', 'camino', 'milagro', 'calle', 'sol', 'venta',
    'vendedor', 'vendedora', 'flores', 'bonito', 'insitu', 'cuadro', 'enmarcado', 'montaje'
  ];
  const words = s.toLowerCase().split(/\s+/);
  if (words.some(w => stopWords.includes(w))) return false;
  return true;
}

function limpiarTexto(v) {
  if (v === null || v === undefined) return '';
  return String(v).replace(/\xa0/g, ' ').trim();
}

/**
 * Busca un participante existente utilizando cascada de identificadores:
 * 1. Cédula (si se suministra)
 * 2. Correo electrónico válido (si se suministra)
 * 3. Teléfono (si se suministra)
 * 4. Nombre exacto o con unaccent (si se suministra)
 * 5. Coincidencia por primer nombre y primer apellido con unaccent
 * Devuelve id_participante si encuentra coincidencia, o null si no.
 */
async function buscarParticipanteExistente(client, { cedula, nombre, correo, telefono }) {
  // 1. Búsqueda por cédula
  if (cedula && String(cedula).trim()) {
    const ciLimpia = String(cedula).replace(/\D/g, '');
    if (ciLimpia.length >= 4) {
      const res = await client.query(
        'SELECT id_participante, nombre FROM participante WHERE cedula = $1 ORDER BY id_participante ASC LIMIT 1',
        [ciLimpia]
      );
      if (res.rows.length > 0) return res.rows[0].id_participante;
    }
  }

  // 2. Búsqueda por correo (si es un correo real, no genérico)
  if (correo && String(correo).trim()) {
    const cLimpio = String(correo).trim().toLowerCase();
    if (cLimpio.includes('@') && !cLimpio.includes('no-especificado') && !cLimpio.endsWith('@example.com')) {
      const res = await client.query(
        `SELECT id_participante
         FROM participante
         WHERE LOWER(TRIM(correo)) = $1
         ORDER BY (cedula IS NOT NULL AND cedula != '') DESC, id_participante ASC LIMIT 1`,
        [cLimpio]
      );
      if (res.rows.length > 0) return res.rows[0].id_participante;
    }
  }

  // 3. Búsqueda por teléfono
  if (telefono && String(telefono).trim()) {
    const tLimpio = String(telefono).replace(/\D/g, '');
    if (tLimpio.length >= 7) {
      const ultimosDigitos = tLimpio.length >= 10 ? tLimpio.slice(-10) : tLimpio.slice(-7);
      const res = await client.query(
        `SELECT p.id_participante
         FROM participante p
         JOIN telefono t ON t.participante_id = p.id_participante
         WHERE REGEXP_REPLACE(t.numero_telefonico, '\\D', '', 'g') LIKE '%' || $1
         ORDER BY (p.cedula IS NOT NULL AND p.cedula != '') DESC, p.id_participante ASC LIMIT 1`,
        [ultimosDigitos]
      );
      if (res.rows.length > 0) return res.rows[0].id_participante;
    }
  }

  // 4. Búsqueda por nombre (exacto o compuesto, priorizando siempre registros con cédula y correo real)
  if (nombre && String(nombre).trim()) {
    const nLimpio = String(nombre).trim();
    if (nLimpio.length >= 3) {
      const partes = nLimpio.split(/\s+/).filter(Boolean);
      let queryNombre;
      let paramsNombre;

      if (partes.length >= 2) {
        const primerNombre = partes[0];
        const primerApellido = partes[partes.length - 1];
        queryNombre = `
          SELECT id_participante, nombre, cedula
          FROM participante
          WHERE unaccent(LOWER(TRIM(nombre))) = unaccent(LOWER(TRIM($1)))
             OR (unaccent(LOWER(nombre)) ILIKE unaccent(LOWER($2 || '%'))
                 AND unaccent(LOWER(nombre)) ILIKE unaccent(LOWER('%' || $3 || '%')))
          ORDER BY (cedula IS NOT NULL AND cedula != '') DESC,
                   (correo IS NOT NULL AND correo NOT LIKE '%no-especificado%') DESC,
                   id_participante ASC
          LIMIT 1`;
        paramsNombre = [nLimpio, primerNombre, primerApellido];
      } else {
        queryNombre = `
          SELECT id_participante, nombre, cedula
          FROM participante
          WHERE unaccent(LOWER(TRIM(nombre))) = unaccent(LOWER(TRIM($1)))
          ORDER BY (cedula IS NOT NULL AND cedula != '') DESC,
                   (correo IS NOT NULL AND correo NOT LIKE '%no-especificado%') DESC,
                   id_participante ASC
          LIMIT 1`;
        paramsNombre = [nLimpio];
      }

      const resNombre = await client.query(queryNombre, paramsNombre);
      if (resNombre.rows.length > 0) return resNombre.rows[0].id_participante;
    }
  }

  return null;
}

/**
 * Parsea un archivo Excel de exposición (.xlsx / .xls).
 * Soporta exposiciones Colectivas e Individuales.
 * Devuelve { tipo, nombre, lugar, fecha, artistaIndividual, participantes[] }
 */
function parsearExcelExposicion(buffer) {
  const wb = XLSX.read(buffer, { type: 'buffer', cellDates: true });
  const sheetName = wb.SheetNames[0];
  const ws = wb.Sheets[sheetName];
  const rawRows = XLSX.utils.sheet_to_json(ws, { header: 1, defval: '' });

  let tipo = 'Colectiva';
  let nombre = '';
  let lugar = '';
  let fecha = null;
  let artistaIndividual = '';

  // Escanear primeras 6 filas para metadatos
  for (let i = 0; i < Math.min(6, rawRows.length); i++) {
    const rowStr = rawRows[i].map(c => limpiarTexto(c)).join(' ').toUpperCase();
    if (rowStr.includes('INDIVIDUAL')) tipo = 'Individual';
    if (rowStr.includes('COLECTIVA')) tipo = 'Colectiva';
    for (let j = 0; j < rawRows[i].length; j++) {
      const v = rawRows[i][j];
      if (v instanceof Date && !isNaN(v) && !fecha) {
        fecha = v;
      } else if (typeof v === 'string' && /\d{1,2}\/\d{1,2}\/\d{2,4}/.test(v) && !fecha) {
        fecha = v;
      }
    }
  }

  // Nombre de expo y artista individual
  for (let i = 0; i < Math.min(5, rawRows.length); i++) {
    for (let j = 0; j < rawRows[i].length; j++) {
      const v = limpiarTexto(rawRows[i][j]);
      if (!v) continue;
      const up = v.toUpperCase();
      if (up.includes('EXPOSICI')) {
        const cleanV = v.replace(/^EXPOSICI[OÓ]N\s+(COLECTIVA|INDIVIDUAL)\s*[\.\-:]*\s*/i, '').trim();
        if (cleanV && !nombre) nombre = cleanV;
      } else if (v.includes('-') && !artistaIndividual) {
        const parts = v.split('-').map(p => p.trim());
        for (const p of parts) {
          if (/^[A-Za-zÁÉÍÓÚÜÑ\s]{3,35}$/.test(p) && !/MUSEO|GALERIA|ARTE|PROGRAMA/i.test(p)) {
            artistaIndividual = formatearNombre(p);
            break;
          }
        }
      }
    }
  }

  const ALIAS_TITULO  = ['titulo', 'título', 'obra', 'title'];
  const ALIAS_AUTOR   = ['autor', 'nombre del participante', 'nombre y apellido', 'nombres y apellidos', 'nombre', 'artista', 'participante'];
  const ALIAS_TECNICA = ['tecnica', 'técnica', 'technique', 'medio'];
  const ALIAS_DIM     = ['dimension', 'dimensión', 'dimensiones', 'medidas', 'tamaño'];
  const ALIAS_ANIO    = ['año', 'anio', 'year'];
  const ALIAS_CEDULA  = ['ci', 'cedula', 'cédula', 'c.i', 'dni'];
  const ALIAS_TELF    = ['telf', 'telefono', 'teléfono', 'celular', 'phone'];
  const ALIAS_CORREO  = ['correo', 'email', 'mail'];

  let headerRowIdx = -1;
  let colMap = {};

  for (let i = 0; i < Math.min(10, rawRows.length); i++) {
    const rowVals = rawRows[i].map(c => limpiarTexto(c).toLowerCase());
    const hasTitulo = rowVals.some(c => ALIAS_TITULO.some(a => c.includes(a)));
    const hasAutor  = rowVals.some(c => ['autor', 'nombre'].some(a => c.includes(a)));
    if (hasTitulo || hasAutor) {
      headerRowIdx = i;
      rowVals.forEach((cell, idx) => {
        if (!cell) return;
        const isNumCol = /^(#|n[°º\.]|num|no\.)/i.test(cell.trim());
        if (isNumCol) return;

        if (ALIAS_TITULO.some(a => cell.includes(a)) && colMap.titulo === undefined) {
          colMap.titulo = idx;
        } else if (ALIAS_AUTOR.some(a => cell.includes(a)) && colMap.autor === undefined) {
          colMap.autor = idx;
        } else if (ALIAS_TECNICA.some(a => cell.includes(a)) && colMap.tecnica === undefined) {
          colMap.tecnica = idx;
        } else if (ALIAS_DIM.some(a => cell.includes(a)) && colMap.dim === undefined) {
          colMap.dim = idx;
        } else if (ALIAS_ANIO.some(a => cell.includes(a)) && colMap.anio === undefined) {
          colMap.anio = idx;
        } else if ((/\b(ci|c\.i\.?)\b/i.test(cell) || ALIAS_CEDULA.some(a => cell.includes(a))) && colMap.cedula === undefined) {
          colMap.cedula = idx;
        } else if (ALIAS_TELF.some(a => cell.includes(a)) && colMap.telf === undefined) {
          colMap.telf = idx;
        } else if (ALIAS_CORREO.some(a => cell.includes(a)) && colMap.correo === undefined) {
          colMap.correo = idx;
        }
      });
      break;
    }
  }

  const participantes = [];
  if (headerRowIdx >= 0) {
    for (let i = headerRowIdx + 1; i < rawRows.length; i++) {
      const row = rawRows[i];
      let titulo = colMap.titulo !== undefined ? limpiarTexto(row[colMap.titulo]) : '';
      let autor  = colMap.autor !== undefined ? limpiarTexto(row[colMap.autor]) : '';

      if (!autor && tipo === 'Individual') {
        autor = artistaIndividual;
      }

      if (!titulo && !autor) continue;
      if (autor && /fotografías|formica|clip\s*mariposa/i.test(autor)) continue;
      if (tipo === 'Individual' && !titulo) continue;

      let numObra = null;
      const c0 = limpiarTexto(row[0]);
      const c1 = limpiarTexto(row[1]);
      if (/^\d+$/.test(c0)) numObra = parseInt(c0);
      else if (/^\d+$/.test(c1)) numObra = parseInt(c1);
      else numObra = participantes.length + 1;

      const tecnica = colMap.tecnica !== undefined ? limpiarTexto(row[colMap.tecnica]) : null;
      const dim     = colMap.dim !== undefined ? limpiarTexto(row[colMap.dim]) : null;
      const anioRaw = colMap.anio !== undefined ? limpiarTexto(row[colMap.anio]) : null;
      let anio = null;
      if (anioRaw && /^(20|19)\d{2}$/.test(anioRaw)) anio = parseInt(anioRaw);

      const cedula  = colMap.cedula !== undefined ? limpiarTexto(row[colMap.cedula]) : null;
      const telf    = colMap.telf !== undefined ? limpiarTexto(row[colMap.telf]) : null;
      const correo  = colMap.correo !== undefined ? limpiarTexto(row[colMap.correo]) : null;

      participantes.push({
        nombre: formatearNombre(autor),
        cedula: cedula || null,
        telefono: telf || null,
        correo: correo || null,
        titulo_obra: formatearNombre(titulo) || null,
        tecnica_obra: tecnica || null,
        dimension_obra: dim || null,
        anio_obra: anio,
        numero_obra: numObra,
      });
    }
  }

  return { tipo, nombre, lugar, fecha, artistaIndividual, participantes };
}

/**
 * Parsea un archivo DOCX de exposición usando adm-zip para leer document.xml.
 * Soporta todos los formatos de exposiciones individuales y colectivas de la fundación.
 */
async function parsearDocxExposicion(buffer) {
  const AdmZip = require('adm-zip');
  let parrafos = [];
  try {
    const zip = new AdmZip(buffer);
    const docXml = zip.readAsText('word/document.xml');
    const pMatches = [...docXml.matchAll(/<w:p[ >][\s\S]*?<\/w:p>/g)];
    for (const pm of pMatches) {
      const ts = [...pm[0].matchAll(/<w:t[^>]*>([^<]*)<\/w:t>/g)].map(m => m[1]).join('');
      const txt = ts.replace(/\xa0/g, ' ').trim();
      if (txt) parrafos.push(txt);
    }
  } catch (e) {
    console.error('Error parseando docx con adm-zip:', e.message);
    return { tipo: 'Individual', nombre: '', lugar: '', fecha: null, participantes: [] };
  }

  let tipo = 'Individual';
  if (parrafos.slice(0, 6).some(p => p.toUpperCase().includes('COLECTIVA'))) {
    tipo = 'Colectiva';
  }

  let nombre = '';
  let lugar = '';
  let fecha = null;
  let artistaIndividual = '';

  for (let i = 0; i < Math.min(6, parrafos.length); i++) {
    const p = parrafos[i];
    const up = p.toUpperCase();
    if (up.includes('LUGAR:') || up.includes('MUSEO') || up.includes('CENTRO DE ARTE') || up.includes('GALERIA') || up.includes('GALERÍA')) {
      if (!lugar) lugar = p.replace(/^Lugar:\s*/i, '').trim();
    }
    if (/\b(20\d{2}|19\d{2})\b/.test(p) && !fecha) {
      fecha = p;
    }
    if (!nombre && p.length > 3 && !/^(EXPOSICI[OÓ]N|INDIVIDUAL|COLECTIVA)\b/i.test(up)) {
      nombre = p.replace(/^EXPOSICI[OÓ]N\s+(COLECTIVA|INDIVIDUAL)\s*[\.\-:]*\s*/i, '').trim();
    }
  }

  if (tipo === 'Individual') {
    for (let i = 0; i < Math.min(6, parrafos.length); i++) {
      const p = parrafos[i];
      const up = p.toUpperCase();
      if (up.includes('EXPOSICI') || up.includes('LUGAR') || up.includes('MUSEO') || up.includes('CENTRO') || up.includes('GALERIA') || up.includes('OBRAS:')) continue;
      if (/\b(enero|febrero|marzo|abril|mayo|junio|julio|agosto|septiembre|octubre|noviembre|diciembre)\b/i.test(p)) continue;
      
      if (p.includes('-') || p.includes('–')) {
        const parts = p.split(/[-–]/).map(pt => pt.trim());
        for (const pt of parts) {
          if (/^[A-Za-zÁÉÍÓÚÜÑ\s]{3,35}$/.test(pt) && !/EXPOSICION|MUSEO|GALERIA|ARTE|PROGRAMA|ESTADO/i.test(pt)) {
            const words = pt.split(/\s+/);
            if (words.length >= 2 || /DARLENYS|DANIELA|SANDRA|YURENNY|MILLAN|CASTILLO|OLIVEROS|JIMENEZ/i.test(pt)) {
              artistaIndividual = formatearNombre(pt);
              break;
            }
          }
        }
        if (artistaIndividual) break;
      } else {
        if (/^[A-Za-zÁÉÍÓÚÜÑ\s]{4,35}$/.test(p) && p !== nombre) {
          const words = p.split(/\s+/);
          if (words.length >= 2) {
            artistaIndividual = formatearNombre(p);
            break;
          }
        }
      }
    }
  }

  const participantes = [];
  const hasNumberedLines = parrafos.slice(3).some(p => /^(\d+)(?:\.|\s+(?=t[íi]tulo\b))\s*([A-Za-zÁÉÍÓÚÜÑ"“'«].*)/i.test(p) && !/^\d+\s+de\s+/i.test(p));
  const hasIsolatedNumbers = parrafos.slice(3).some(p => /^\d+\.$/.test(p));

  if (tipo === 'Individual') {
    if (hasIsolatedNumbers) {
      // Formato Sandra Jimenez (1. en línea separada)
      let curWork = null;
      let i = 0;
      while (i < parrafos.length) {
        const p = parrafos[i];
        const mNum = p.match(/^(\d+)\.$/);
        if (mNum) {
          if (curWork) participantes.push(curWork);
          const num = parseInt(mNum[1]);
          let j = i + 1;
          const block = [];
          while (j < parrafos.length && !/^\d+\.$/.test(parrafos[j])) {
            block.push(parrafos[j]);
            j++;
          }
          const titulo = block[0] || `Obra ${num}`;
          let tecnica = '', dim = '', anio = null;
          for (const b of block.slice(1)) {
            if (/^(20|19)\d{2}$/.test(b)) anio = parseInt(b);
            else if (/\d+[\.,]?\d*\s*[xX×]\s*\d+/.test(b)) dim = b;
            else if (/sobre|papel|tela|óleo|oleo|tinta|mixta|grafito|pastel|acuarela/i.test(b)) tecnica = b;
          }
          curWork = {
            nombre: artistaIndividual,
            cedula: null, telefono: null, correo: null,
            numero_obra: num,
            titulo_obra: formatearNombre(titulo),
            tecnica_obra: tecnica || null,
            dimension_obra: dim || null,
            anio_obra: anio,
          };
          i = j - 1;
        }
        i++;
      }
      if (curWork) participantes.push(curWork);

    } else if (hasNumberedLines) {
      // Formato Yurenny Oliveros / Darlenys Castillo
      for (const p of parrafos) {
        if (/^\d+\s+de\s+[a-z]+/i.test(p)) continue;
        const mLine = p.match(/^(\d+)(?:\.|\s+(?=t[íi]tulo\b))\s*([A-Za-zÁÉÍÓÚÜÑ"“'«].*)/i);
        if (!mLine) continue;
        const num = parseInt(mLine[1]);
        const rest = mLine[2].trim();

        let titulo = '', tecnica = '', dim = '', anio = null;

        if (rest.includes('/') || /T[íi]tulo\s*:/i.test(rest)) {
          const parts = rest.split('/').map(pt => pt.trim());
          for (const pt of parts) {
            if (/^T[íi]tulo\s*:\s*/i.test(pt)) {
              titulo = pt.replace(/^T[íi]tulo\s*:\s*/i, '').trim();
            } else if (/^(T[ée]cnica|Tinta)\s*:\s*/i.test(pt)) {
              tecnica = pt.replace(/^(T[ée]cnica|Tinta)\s*:\s*/i, '').trim();
            } else if (/^Dimension(es)?\s*:\s*/i.test(pt)) {
              dim = pt.replace(/^Dimension(es)?\s*:\s*/i, '').trim();
            } else if (/^A[ñn]o\s*:\s*/i.test(pt)) {
              const mYr = pt.match(/\b(20|19)\d{2}\b/);
              if (mYr) anio = parseInt(mYr[0]);
            } else {
              if (!titulo) titulo = pt;
              else if (!tecnica && /papel|tela|tinta|acuarela|grafito/i.test(pt)) tecnica = pt;
              else if (!dim && /\d+\s*[xX×]\s*\d+/.test(pt)) dim = pt;
            }
          }
        } else {
          const lineNorm = rest.replace(/(\d+),(\d+)/g, '$1.$2');
          const parts = lineNorm.split(',').map(pt => pt.trim());
          titulo = parts[0] || '';
          for (const pt of parts.slice(1)) {
            if (/^(20|19)\d{2}$/.test(pt)) {
              anio = parseInt(pt);
            } else if (/\d+[\.,]?\d*\s*[xX×]\s*\d+/.test(pt)) {
              dim = pt;
            } else if (/acuarela|tinta|creyon|grafito|digital|mixta|gouache|papel/i.test(pt)) {
              tecnica = (tecnica + ' ' + pt).trim();
            }
          }
        }

        participantes.push({
          nombre: artistaIndividual,
          cedula: null, telefono: null, correo: null,
          numero_obra: num,
          titulo_obra: formatearNombre(titulo),
          tecnica_obra: tecnica || null,
          dimension_obra: dim || null,
          anio_obra: anio,
        });
      }

    } else {
      // Formato Daniela Millan (bloques de párrafos delimitados por dimensiones)
      let i = 4;
      let num = 1;
      while (i < parrafos.length) {
        const p = parrafos[i];
        const block = [p];
        let j = i + 1;
        while (j < parrafos.length && j < i + 5) {
          block.push(parrafos[j]);
          if (/\d+[\.,]?\d*\s*[xX×\u00d7]\s*\d+.*cm/i.test(parrafos[j]) || /cm$/i.test(parrafos[j].trim())) {
            if (j + 1 < parrafos.length && (/Obra/i.test(parrafos[j + 1]) || /Concurso/i.test(parrafos[j + 1]))) {
              j++;
              block.push(parrafos[j]);
            }
            break;
          }
          j++;
        }

        const titulo = block[0] || '';
        let tecnica = '', dim = '', anio = null;

        for (const b of block.slice(1)) {
          const mYr = b.match(/\b(20\d{2}|19\d{2})\b/);
          if (mYr && !anio) anio = parseInt(mYr[0]);
          if (/\d+[\.,]?\d*\s*[xX×\u00d7]\s*\d+/.test(b) && !dim) dim = b;
          else if (/acuarela|tinta|gouache|mixta|papel|opalina|lienzo/i.test(b) && !tecnica) tecnica = b;
        }

        if (titulo) {
          participantes.push({
            nombre: artistaIndividual,
            cedula: null, telefono: null, correo: null,
            numero_obra: num,
            titulo_obra: formatearNombre(titulo),
            tecnica_obra: tecnica || null,
            dimension_obra: dim || null,
            anio_obra: anio,
          });
          num++;
        }
        i = j + 1;
      }
    }

  } else {
    // Detectar si sigue el patrón de 4 líneas (Título, Técnica, Dimensión, Autor) como en El Valle
    const isPattern4Lines = parrafos.length >= 6 && 
      (/\d+[\.,]?\d*\s*[xX×\u00d7]\s*\d+.*cm/i.test(parrafos[4]) || /cm$/i.test(parrafos[4])) &&
      (parrafos[5] && /^[A-Za-zÁÉÍÓÚÜÑ\s–-]+(\d+\s*años)?/i.test(parrafos[5])) &&
      (/\d+[\.,]?\d*\s*[xX×\u00d7]\s*\d+.*cm/i.test(parrafos[8]) || /cm$/i.test(parrafos[8]));

    if (isPattern4Lines) {
      let i = 2;
      while (i + 3 < parrafos.length) {
        const titulo = parrafos[i];
        const tecnica = parrafos[i + 1];
        const dim = parrafos[i + 2];
        const autorRaw = parrafos[i + 3];
        let autor = autorRaw.replace(/\s*[–-]\s*\d+\s*años?.*$/i, '').trim();
        if (autor.toLowerCase() === 'edgar jiméne') autor = 'Edgar Jiménez';
        if (autor.toLowerCase() === 'franco e. valdivieso') autor = 'Franco Emilio Valdivieso';

        participantes.push({
          nombre: esNombreValidoDePersona(autor) ? formatearNombre(autor) : null,
          cedula: null, telefono: null, correo: null,
          numero_obra: participantes.length + 1,
          titulo_obra: formatearNombre(titulo),
          tecnica_obra: tecnica || null,
          dimension_obra: dim || null,
          anio_obra: null,
        });
        i += 4;
      }
    } else {
      // Formato Colectiva por bloques delimitados por dimensión (Pampatar docx)
      let currentBlock = [];
      const blocks = [];
      for (let pIdx = 3; pIdx < parrafos.length; pIdx++) {
        const p = parrafos[pIdx];
        currentBlock.push(p);
        if (/\d+[\.,]?\d*\s*[xX×\u00d7]\s*\d+.*cm/i.test(p) || /cm$/i.test(p.trim())) {
          blocks.push(currentBlock);
          currentBlock = [];
        }
      }

      for (const b of blocks) {
        let titulo = b[0] || '';
        let autorLine = b[1] || '';
        let autor = '';
        let remLines = b.slice(2);

        if (/el rincón de las empanadas/i.test(titulo) && /yulianngy|rodríguez|rodriguez/i.test(titulo)) {
          titulo = 'El Rincón de las Empanadas';
          autor = 'Yulianngy Rodríguez';
          remLines = b.slice(1);
        } else if (/el rincón de las empanadas/i.test(autorLine)) {
          titulo = 'El Rincón de las Empanadas';
          autor = autorLine.replace(/el rincón de las empanadas/i, '').replace(/\s*[–-]\s*\d+\s*años?.*$/i, '').trim();
        } else {
          autor = autorLine.replace(/\s*[–-]\s*\d+\s*años?.*$/i, '').trim();
        }

        let ig = null, anio = null, tecnica = null, dim = b[b.length - 1];
        for (const line of remLines.slice(0, -1)) {
          if (/@|^\s*IG\b/i.test(line)) {
            ig = line.replace(/IG/i, '').replace('@', '').trim();
          } else if (/^(20|19)\d{2}$/.test(line)) {
            anio = parseInt(line);
          } else {
            tecnica = line;
          }
        }

        participantes.push({
          nombre: esNombreValidoDePersona(autor) ? formatearNombre(autor) : null,
          cedula: null, telefono: null, correo: null, instagram: ig,
          numero_obra: participantes.length + 1,
          titulo_obra: formatearNombre(titulo),
          tecnica_obra: tecnica || null,
          dimension_obra: dim || null,
          anio_obra: anio,
        });
      }
    }
  }

  return { tipo, nombre, lugar, fecha, artistaIndividual, participantes };
}

// ──────────────────────────────────────────────────────────────
// RUTAS EXISTENTES
// ──────────────────────────────────────────────────────────────

Routes.get('/GetExposiciones', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT * FROM Exposicion');
    const exposicionesData = result.rows;
    client.release();
    const exposiciones = exposicionesData.map(data =>
      new Exposicion(data.nombre, data.fecha, data.lugar, data.tipo, data.id_expo, data.tema)
    );
    res.json(exposiciones);
  } catch (err) {
    console.error('Error al consultar exposiciones:', err);
    res.status(500).send('Error al consultar la base de datos para exposiciones');
  }
});

Routes.post('/InsertarExposicion', async (req, res) => {
  try {
    const exposicion = req.body;
    if (!exposicion.nombre || !exposicion.fecha) {
      return res.status(400).json({ error: 'Los campos "nombre" y "fecha" son obligatorios.' });
    }
    const client = await pool.connect();
    const query = `
      INSERT INTO Exposicion (Nombre, fecha, Lugar, Tipo, Tema)
      VALUES ($1, $2, $3, $4, $5)
      RETURNING id_expo, Nombre, fecha, Lugar, Tipo, Tema`;
    const values = [
      exposicion.nombre, exposicion.fecha,
      exposicion.lugar || null, exposicion.tipo || null, exposicion.tema || null,
    ];
    const result = await client.query(query, values);
    client.release();
    res.status(201).json({ mensaje: 'Exposición insertada exitosamente', exposicion: result.rows[0] });
  } catch (err) {
    console.error('Error al insertar la exposición:', err);
    res.status(500).json({ error: 'Error al insertar la exposición', details: err.message });
  }
});

Routes.delete('/EliminarExposicion/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const client = await pool.connect();
    const result = await client.query(
      'DELETE FROM Exposicion WHERE id_expo = $1 RETURNING id_expo;', [id]
    );
    client.release();
    if (result.rowCount === 0)
      return res.status(404).json({ mensaje: `No se encontró ninguna exposición con el ID: ${id}` });
    res.status(200).json({ mensaje: `Exposición con ID ${id} eliminada exitosamente.` });
  } catch (err) {
    res.status(500).json({ error: `Error al eliminar la exposición con ID ${id}`, details: err.message });
  }
});

Routes.put('/ModificarExposicion/:id_expo', async (req, res) => {
  const { id_expo } = req.params;
  const exposicion = req.body;
  try {
    if (!exposicion.Nombre || !exposicion.fecha) {
      return res.status(400).json({ error: 'Los campos "Nombre" y "fecha" son obligatorios para la modificación.' });
    }
    const client = await pool.connect();
    const query = `
      UPDATE Exposicion
      SET Nombre = $1, fecha = $2, Tipo = $3, Lugar = $4, Tema = $6
      WHERE id_expo = $5 RETURNING *;`;
    const values = [exposicion.Nombre, exposicion.fecha, exposicion.Tipo || null, exposicion.Lugar || null, id_expo, exposicion.Tema || null];
    const result = await client.query(query, values);
    client.release();
    if (result.rowCount === 0)
      return res.status(404).json({ mensaje: `No se encontró ninguna exposición con el ID: ${id_expo}` });
    res.status(200).json({ mensaje: `Exposición con ID ${id_expo} modificada exitosamente`, exposicion: result.rows[0] });
  } catch (err) {
    res.status(500).json({ error: `Error al modificar la exposición con ID ${id_expo}`, details: err.message });
  }
});

// Participantes de una exposición — hace JOIN con la tabla obra normalizada
Routes.get('/ParticipantesExpo/:idExpo', async (req, res) => {
  const { idExpo } = req.params;
  if (!idExpo) return res.status(400).json({ error: 'id inválido' });
  try {
    const client = await pool.connect();
    const query = `
      SELECT
        p.nombre         AS nombre_p,
        p.cedula         AS cedula_p,
        p.id_participante AS id,
        ep.obra_id,
        COALESCE(o.numero_obra, ep.numero_obra::varchar) AS numero_obra,
        o.titulo         AS titulo_obra,
        o.tecnica        AS tecnica_obra,
        o.observacion    AS dimension_obra,
        o.anio           AS anio_obra
      FROM E_P ep
      JOIN exposicion e  ON e.id_expo        = ep.exposicion_id
      JOIN participante p ON p.id_participante = ep.participante_id
      LEFT JOIN obra o   ON o.id_obra         = ep.obra_id
      WHERE e.id_expo = $1
      ORDER BY p.nombre ASC;
    `;
    const result = await client.query(query, [idExpo]);
    client.release();
    if (result.rowCount === 0) {
      return res.status(200).json({ personas: [], mensaje: `No se encontró ningún participante en la exposición ID: ${idExpo}` });
    }
    res.status(200).json({
      personas: result.rows.map(row => ({
        id:             row.id,
        nombre:         row.nombre_p,
        cedula:         row.cedula_p,
        obra_id:        row.obra_id,
        titulo_obra:    row.titulo_obra,
        tecnica_obra:   row.tecnica_obra,
        dimension_obra: row.dimension_obra,
        anio_obra:      row.anio_obra,
        numero_obra:    row.numero_obra,
      })),
    });
  } catch (error) {
    res.status(500).json({ error: `Error al obtener los participantes de la exposición`, details: error.message });
  }
});

Routes.get('/NoParticipantesExposicion/:idExposicion', async (req, res) => {
  const { idExposicion } = req.params;
  if (!idExposicion) return res.status(400).json({ error: 'id inválido' });
  try {
    const client = await pool.connect();
    const query = `
      SELECT p.nombre AS nombre_p, p.cedula AS cedula_p, p.id_participante AS id
      FROM participante p
      WHERE NOT EXISTS (SELECT * FROM E_P WHERE E_P.participante_id = p.id_participante AND E_P.exposicion_id = $1);
    `;
    const result = await client.query(query, [idExposicion]);
    client.release();
    if (result.rowCount === 0) {
      return res.status(204).json({ mensaje: `No se encontraron participantes fuera de la exposición ID: ${idExposicion}` });
    }
    res.status(200).json({ personas: result.rows.map(row => ({ id: row.id, nombre: row.nombre_p, cedula: row.cedula_p })) });
  } catch (error) {
    res.status(500).json({ error: `Error al obtener participantes`, details: error.message });
  }
});

Routes.post('/InsertarParticipanteExposicion', async (req, res) => {
  const datos = req.body;
  if (!datos.exposicion || !datos.participante) {
    return res.status(400).json({ error: 'Exposicion o participante inválido' });
  }
  try {
    const client = await pool.connect();
    let obraId = datos.obra_id || null;

    // Si se mandan datos de obra sin obra_id, crear la obra primero
    if (!obraId && datos.titulo_obra) {
      const obraRes = await client.query(
        `INSERT INTO obra (numero_obra, titulo, tecnica, observacion, anio, participante_id)
         VALUES ($1,$2,$3,$4,$5,$6) RETURNING id_obra`,
        [
          datos.numero_obra || null,
          datos.titulo_obra,
          datos.tecnica_obra || null,
          datos.dimension_obra || null,
          datos.anio_obra || null,
          datos.participante,
        ]
      );
      obraId = obraRes.rows[0].id_obra;
    }

    await client.query(
      `INSERT INTO E_P (participante_id, exposicion_id, obra_id) VALUES ($1,$2,$3)`,
      [datos.participante, datos.exposicion, obraId]
    );
    client.release();
    res.status(201).json({ mensaje: 'Participante agregado con éxito', obra_id: obraId });
  } catch (error) {
    res.status(500).json({ error: `Error al insertar el participante en la exposicion`, details: error.message });
  }
});

// ──────────────────────────────────────────────────────────────
// NUEVO: Importar Exposición desde Excel o DOCX
// ──────────────────────────────────────────────────────────────
Routes.post('/ImportarExposicion', upload.single('archivo'), async (req, res) => {
  if (!req.file) return res.status(400).json({ error: 'No se recibió ningún archivo.' });

  const {
    nombre_expo, fecha_expo, lugar_expo, tipo_expo, tema_expo, estado_defecto,
  } = req.body;

  if (!nombre_expo || !fecha_expo) {
    return res.status(400).json({ error: 'El nombre y la fecha de la exposición son obligatorios.' });
  }

  const esDocx = req.file.originalname.toLowerCase().endsWith('.docx');
  let parsed;
  try {
    if (esDocx) {
      parsed = await parsearDocxExposicion(req.file.buffer);
    } else {
      parsed = parsearExcelExposicion(req.file.buffer);
    }
  } catch (parseErr) {
    console.error('Error al parsear archivo:', parseErr);
    return res.status(400).json({ error: 'No se pudo leer el archivo. Verifique el formato.', details: parseErr.message });
  }

  // Usar tipo del formulario si se especificó explícitamente
  const tipoFinal  = tipo_expo || parsed.tipo || 'Colectiva';
  const nombreFinal = nombre_expo;
  const lugarFinal  = lugar_expo || parsed.lugar || null;
  const fechaFinal  = fecha_expo;
  const temaFinal   = tema_expo || null;

  const client = await pool.connect();
  let insertados = 0;
  let errores = [];
  let expoId = null;

  try {
    // 1. Crear la exposición
    const expoResult = await client.query(
      `INSERT INTO Exposicion (Nombre, fecha, Lugar, Tipo, Tema) VALUES ($1,$2,$3,$4,$5) RETURNING id_expo`,
      [nombreFinal, fechaFinal, lugarFinal, tipoFinal, temaFinal]
    );
    expoId = expoResult.rows[0].id_expo;

    // 2. Procesar cada participante/obra
    for (const p of parsed.participantes) {
      try {
        await client.query('BEGIN');

        // Nombre del participante (fallback al artista individual si es expo individual)
        const nombreFinalP = p.nombre || (tipoFinal === 'Individual' ? parsed.artistaIndividual : null);

        // Relacionar participante por cascada: Cédula -> Correo -> Teléfono -> Nombre (con unaccent y nombres compuestos)
        let participanteId = await buscarParticipanteExistente(client, {
          cedula: p.cedula,
          nombre: nombreFinalP,
          correo: p.correo,
          telefono: p.telefono,
        });

        // Si ya existe, enriquecer opcionalmente teléfono, correo, cédula, nombre o campos faltantes
        if (participanteId) {
          const pActRes = await client.query(
            `SELECT nombre, cedula, correo, ciudad, instagram, estado_id, fecha_nacimiento
             FROM participante WHERE id_participante = $1`,
            [participanteId]
          );
          const pAct = pActRes.rows[0];

          // 1. Teléfono: anexar nuevo si no existe
          if (p.telefono) {
            const telLimpio = p.telefono.toString().replace(/\D/g, '');
            if (telLimpio.length >= 7) {
              const telExiste = await client.query(
                `SELECT id_telefono FROM telefono WHERE participante_id = $1 AND REGEXP_REPLACE(numero_telefonico, '\\D', '', 'g') LIKE '%' || $2`,
                [participanteId, telLimpio.slice(-7)]
              );
              if (telExiste.rows.length === 0) {
                await client.query(
                  'INSERT INTO telefono (numero_telefonico, participante_id) VALUES ($1, $2)',
                  [telLimpio, participanteId]
                );
              }
            }
          }

          // 2. Correo: si no tiene, asignar. Si tiene uno diferente, anexarlo (separado por coma)
          if (p.correo && !p.correo.includes('no-especificado') && p.correo.includes('@')) {
            const nuevoCorreo = p.correo.trim().toLowerCase();
            const correoActual = (pAct?.correo || '').trim();

            if (!correoActual || correoActual.includes('no-especificado')) {
              await client.query(
                'UPDATE participante SET correo = $1 WHERE id_participante = $2',
                [nuevoCorreo, participanteId]
              );
            } else {
              const existentes = correoActual.split(',').map(c => c.trim().toLowerCase());
              if (!existentes.includes(nuevoCorreo)) {
                const combinado = `${correoActual}, ${nuevoCorreo}`;
                await client.query(
                  'UPDATE participante SET correo = $1 WHERE id_participante = $2',
                  [combinado, participanteId]
                );
              }
            }
          }

          // 3. Cédula: si el participante no tenía cédula y el archivo la trae
          if (p.cedula) {
            const ciLimpia = p.cedula.toString().replace(/\D/g, '');
            if (ciLimpia.length >= 4 && (!pAct?.cedula || pAct.cedula.trim() === '')) {
              await client.query(
                'UPDATE participante SET cedula = $1 WHERE id_participante = $2',
                [ciLimpia, participanteId]
              );
            }
          }

          // 4. Nombre: si el nuevo nombre es más completo (más largo y contiene al actual, o si el actual estaba en mayúsculas)
          if (nombreFinalP && nombreFinalP.length > 2) {
            const nActual = (pAct?.nombre || '').trim();
            if (!nActual || nActual === nActual.toUpperCase() ||
               (nombreFinalP.length > nActual.length && nombreFinalP.toLowerCase().includes(nActual.toLowerCase()))) {
              await client.query(
                'UPDATE participante SET nombre = $1 WHERE id_participante = $2',
                [formatearNombre(nombreFinalP), participanteId]
              );
            }
          }

          // 5. Ciudad / Estado si faltaban
          if (p.ciudad && p.ciudad !== 'No especificada' && (!pAct?.ciudad || pAct.ciudad === 'No especificada')) {
            await client.query(
              'UPDATE participante SET ciudad = $1 WHERE id_participante = $2',
              [p.ciudad.trim(), participanteId]
            );
          }
          if (!pAct?.estado_id && estado_defecto) {
            const estRes = await client.query(
              'SELECT id_estado FROM estado WHERE UPPER(nombre) = UPPER($1) LIMIT 1',
              [estado_defecto]
            );
            if (estRes.rows.length > 0) {
              await client.query(
                'UPDATE participante SET estado_id = $1 WHERE id_participante = $2',
                [estRes.rows[0].id_estado, participanteId]
              );
            }
          }
        }

        // Si NO coincide con ninguno de esos valores, entonces se crea un participante nuevo (solo si es nombre válido de persona)
        if (!participanteId && nombreFinalP && esNombreValidoDePersona(nombreFinalP)) {
          let estadoId = null;
          if (estado_defecto) {
            const estadoRes = await client.query(
              'SELECT id_estado FROM estado WHERE UPPER(nombre) = UPPER($1) LIMIT 1',
              [estado_defecto]
            );
            if (estadoRes.rows.length > 0) estadoId = estadoRes.rows[0].id_estado;
          }

          // Insertar participante con datos mínimos (año 1000 indica no especificada)
          const newP = await client.query(
            `INSERT INTO participante (nombre, cedula, fecha_nacimiento, correo, ciudad, estado_id)
             VALUES ($1, $2, '1000-01-01', $3, 'No especificada', $4)
             RETURNING id_participante`,
            [
              nombreFinalP,
              (p.cedula && p.cedula.toString().replace(/\D/g, '')) || null,
              p.correo || 'no-especificado@fundacionstohr.org',
              estadoId,
            ]
          );
          participanteId = newP.rows[0].id_participante;

          // Insertar teléfono si hay
          if (p.telefono) {
            const telLimpio = p.telefono.toString().replace(/\D/g, '');
            if (telLimpio.length >= 7) {
              await client.query(
                'INSERT INTO telefono (numero_telefonico, participante_id) VALUES ($1,$2)',
                [telLimpio, participanteId]
              );
            }
          }
        }

        if (!participanteId) {
          await client.query('ROLLBACK');
          errores.push({ nombre: nombreFinalP || '(Sin nombre)', motivo: 'No se pudo identificar al participante/artista' });
          continue;
        }

        // Verificar si esta obra específica ya está vinculada a esta exposición
        let yaVinculado;
        if (p.titulo_obra) {
          yaVinculado = await client.query(
            `SELECT ep.id FROM E_P ep
             LEFT JOIN obra o ON o.id_obra = ep.obra_id
             WHERE ep.exposicion_id=$1 AND ep.participante_id=$2
               AND LOWER(o.titulo)=LOWER($3)`,
            [expoId, participanteId, p.titulo_obra]
          );
        } else if (p.numero_obra) {
          yaVinculado = await client.query(
            `SELECT ep.id FROM E_P ep
             LEFT JOIN obra o ON o.id_obra = ep.obra_id
             WHERE ep.exposicion_id=$1 AND ep.participante_id=$2
               AND o.numero_obra::text = $3::text`,
            [expoId, participanteId, p.numero_obra]
          );
        } else {
          yaVinculado = await client.query(
            'SELECT id FROM E_P WHERE exposicion_id=$1 AND participante_id=$2 AND obra_id IS NULL',
            [expoId, participanteId]
          );
        }

        if (yaVinculado.rows.length > 0) {
          await client.query('ROLLBACK');
          errores.push({ nombre: nombreFinalP, motivo: `Ya estaba vinculado a esta exposición con la obra "${p.titulo_obra || p.numero_obra || ''}"` });
          continue;
        }

        // Insertar obra en la tabla obra y luego vincular en E_P
        let obraIdFinal = null;
        if (p.titulo_obra) {
          const obraRes = await client.query(
            `INSERT INTO obra (numero_obra, titulo, tecnica, observacion, anio, participante_id)
             VALUES ($1,$2,$3,$4,$5,$6) RETURNING id_obra`,
            [
              p.numero_obra !== undefined ? String(p.numero_obra) : null,
              p.titulo_obra,
              p.tecnica_obra || null,
              p.dimension_obra || null,
              p.anio_obra || null,
              participanteId,
            ]
          );
          obraIdFinal = obraRes.rows[0].id_obra;
        }

        // Vincular participante + obra a exposición
        await client.query(
          `INSERT INTO E_P (participante_id, exposicion_id, obra_id) VALUES ($1,$2,$3)`,
          [participanteId, expoId, obraIdFinal]
        );

        await client.query('COMMIT');
        insertados++;
      } catch (rowErr) {
        await client.query('ROLLBACK');
        console.error('Error en fila:', p.nombre, rowErr.message);
        errores.push({ nombre: p.nombre || '(Sin nombre)', motivo: rowErr.message });
      }
    }
  } catch (globalErr) {
    // Eliminar exposición creada si falló todo
    try { await client.query(`DELETE FROM Exposicion WHERE id_expo=${expoId}`); } catch (_) {}
    client.release();
    return res.status(500).json({ error: 'Error al crear la exposición', details: globalErr.message });
  }

  client.release();

  const status = errores.length > 0 && insertados === 0 ? 500 : (errores.length > 0 ? 207 : 201);
  res.status(status).json({
    mensaje: `Exposición "${nombreFinal}" creada con ${insertados} participante(s)/obra(s) registrado(s).`,
    id_exposicion: expoId,
    tipo: tipoFinal,
    insertados,
    total: parsed.participantes.length,
    errores,
  });
});

module.exports = Routes;