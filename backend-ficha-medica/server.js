const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

const db = require('./config/database');

app.get('/api', (req, res) => {
  res.json({ message: '✅ API de Fichas Médicas funcionando!' });
});

app.get('/api/consultas', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM consulta ORDER BY fecha DESC LIMIT 10');
    res.json(result.rows);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/examenes', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM examen ORDER BY fecha DESC LIMIT 10');
    res.json(result.rows);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/pacientes', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM paciente ORDER BY id ASC LIMIT 10');
    res.json(result.rows);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/debug/todos-pacientes', async (req, res) => {
  try {
    const result = await db.query('SELECT id, rut, nombre, apellido, correo, clave FROM paciente ORDER BY id');
    console.log('📋 TODOS los pacientes:', result.rows);
    res.json({
      total: result.rows.length,
      pacientes: result.rows
    });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/debug/buscar-rut/:rut', async (req, res) => {
  try {
    const { rut } = req.params;
    const rutLimpio = rut.replace(/[^0-9kK]/g, '');
    
    console.log('🔍 Buscando RUT:', rutLimpio);
    
    const result = await db.query(
      'SELECT * FROM paciente WHERE REPLACE(REPLACE(rut, ".", ""), "-", "") = $1',
      [rutLimpio]
    );
    
    res.json({
      rutBuscado: rut,
      rutLimpio: rutLimpio,
      encontrados: result.rows.length,
      pacientes: result.rows
    });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: error.message });
  }
});

app.listen(PORT, () => {
  console.log(`🚀 Servidor backend en http://localhost:${PORT}`);
});

app.get('/api/test-db', async (req, res) => {
  try {
    const result = await db.query('SELECT NOW() as current_time');
    res.json({ 
      success: true, 
      message: '✅ Backend y base de datos conectados correctamente',
      timestamp: result.rows[0].current_time,
      environment: 'development'
    });
  } catch (error) {
    console.error('Error en test-db:', error);
    res.status(500).json({ 
      success: false, 
      message: '❌ Error conectando con la base de datos',
      error: error.message 
    });
  }
});

app.get('/api/pacientes/rut/:rut', async (req, res) => {
  try {
    const { rut } = req.params;
    
    // Limpiar el RUT (remover puntos y guión)
    const rutLimpio = rut.replace(/[^0-9kK]/g, '');
    
    console.log('🔍 Buscando paciente con RUT:', rutLimpio);
    
    // Buscar por RUT limpio (sin formato)
    const result = await db.query(
      'SELECT * FROM paciente WHERE rut = $1', 
      [rutLimpio]
    );
    
    if (result.rows.length === 0) {
      console.log('❌ No se encontró paciente con RUT:', rutLimpio);
      return res.status(404).json({ error: 'Paciente no encontrado' });
    }
    
    console.log('✅ Paciente encontrado:', result.rows[0].nombre);
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/pacientes/login', async (req, res) => {
  try {
    const { rut, correo, clave } = req.body;
    
    console.log('🔐 Datos recibidos para login:', { 
      rut: rut, 
      correo: correo, 
      clave: clave ? '***' : 'undefined' 
    });

    // Limpiar el RUT para la búsqueda
    const rutLimpio = rut.replace(/[^0-9kK]/g, '');
    
    console.log('🔍 RUT limpio para búsqueda:', rutLimpio);

    // Buscar paciente con RUT limpio
    const result = await db.query(
      'SELECT * FROM paciente WHERE rut = $1 AND correo = $2 AND clave = $3',
      [rutLimpio, correo, clave]
    );

    console.log('📊 Resultado de la consulta:', result.rows.length, 'pacientes encontrados');

    if (result.rows.length === 0) {
      console.log('❌ Login fallido - no se encontró paciente con esas credenciales');
      return res.status(401).json({ 
        success: false, 
        message: 'Credenciales inválidas' 
      });
    }

    console.log('✅ Login exitoso para:', result.rows[0].nombre);
    res.json({
      success: true,
      message: 'Login exitoso',
      paciente: result.rows[0]
    });

  } catch (error) {
    console.error('💥 ERROR en login:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Error del servidor',
      error: error.message
    });
  }
});

app.get('/api/pacientes/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query(
      'SELECT * FROM paciente WHERE id = $1', 
      [id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Paciente no encontrado' });
    }
    
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/tipo-sangre/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query(
      'SELECT * FROM tipo_sangre WHERE id = $1', 
      [id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Tipo de sangre no encontrado' });
    }
    
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/centro-medico/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query(
      'SELECT * FROM centro_medico WHERE id = $1', 
      [id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Centro médico no encontrado' });
    }
    
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/pacientes/:id/consultas', async (req, res) => {
  try {
    const { id } = req.params;
    console.log('🔍 Buscando consultas para paciente ID:', id);
    
    const result = await db.query(
      'SELECT * FROM consulta WHERE paciente_id = $1 ORDER BY fecha DESC', 
      [id]
    );
    
    console.log('📋 Consultas encontradas:', result.rows.length);
    res.json(result.rows);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/pacientes/:id/examenes', async (req, res) => {
  try {
    const { id } = req.params;
    console.log('🔍 Buscando exámenes para paciente ID:', id);
    
    const result = await db.query(
      'SELECT * FROM examen WHERE paciente_id = $1 ORDER BY fecha DESC', 
      [id]
    );
    
    console.log('🔬 Exámenes encontrados:', result.rows.length);
    res.json(result.rows);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/tipos-examen', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM tipo_examen ORDER BY nombre');
    res.json(result.rows);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/centros-medicos', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM centro_medico ORDER BY nombrecentro');
    res.json(result.rows);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: error.message });
  }
});






// ============================================
// === ENDPOINT 1: Analitos historial Flutter ===
// ============================================
app.get("/api/analitos/historial/:pacienteId", async (req, res) => {
  const { pacienteId } = req.params;
  let { nombre, lastFetchTime } = req.query;

  if (!nombre) {
    return res.status(400).json({ error: "El parámetro 'nombre' es requerido." });
  }

  try {
    console.log(`📈 [Flutter] Petición de analitos para Paciente ID: ${pacienteId}, Analito: ${nombre}`);
    
    // Formatear los nombres para la consulta
    let nombres = Array.isArray(nombre) ? nombre : [nombre];
    let cleanNombres = nombres.map(n => n.trim());
    const nombrePlaceholders = cleanNombres.map((_, i) => `$${i + 2}`).join(", ");
    let queryParams = [pacienteId, ...cleanNombres];
    
    // Consulta principal
    let queryString = `
      SELECT 
        ra.resultado AS valor,
        e.fecha,
        e.fecha AS last_updated, 
        td.nombre AS analito
      FROM resultado_analito ra
      JOIN examen e ON ra.examen_id = e.id
      JOIN tipo_dato td ON ra.tipo_dato_id = td.id
      JOIN ficha_medica fm ON e.ficha_medica_id = fm.id
      WHERE fm.paciente_id = $1
        AND td.nombre ILIKE ANY (ARRAY[${nombrePlaceholders}])
    `;

    if (lastFetchTime) {
      queryString += ` AND e.fecha > $${queryParams.length + 1}`;
      queryParams.push(lastFetchTime);
    }

    queryString += ` ORDER BY e.fecha ASC;`;
    
    console.log("Query ejecutada:", queryString, queryParams);
    const result = await db.query(queryString, queryParams);
    res.json(result.rows);

  } catch (err) {
    console.error("💥 [Flutter] Error en /api/analitos/historial:", err);
    res.status(500).json({ error: "Error al consultar historial de analito", details: err.message });
  }
});


// ============================================
// === ENDPOINT 2: Exámenes estadísticas Flutter ===
// ============================================
app.get("/api/examenes/estadisticas", async (req, res) => {
  try {
    console.log(`📊 [Flutter] Petición de estadísticas de exámenes`);
    
    const queryString = `
      SELECT
        te.nombre AS tipo_examen,
        CAST(COUNT(CASE WHEN ra.aprobado = TRUE THEN 1 END) AS INT) AS aprobados,
        CAST(COUNT(CASE WHEN ra.aprobado = FALSE THEN 1 END) AS INT) AS reprobados,
        MAX(e.fecha) as last_updated
      FROM tipo_examen te
      LEFT JOIN examen e ON te.id = e.tipo_examen_id
      LEFT JOIN resultado_analito ra ON e.id = ra.examen_id
      GROUP BY te.nombre
      ORDER BY te.nombre ASC;
    `;
    
    const statsResult = await db.query(queryString);
    console.log(`📊 [Flutter] Estadísticas encontradas: ${statsResult.rows.length} tipos`);
    res.json(statsResult.rows);

  } catch (err) {
    console.error("💥 [Flutter] Error en /api/examenes/estadisticas:", err);
    res.status(500).json({ error: "Error al consultar estadísticas", details: err.message });
  }
});




// ============================================
// === ENDPOINT 3: Fichas médicas resumen (READ) ===
// ============================================
app.get('/api/fichas-resumen', async (req, res) => {
  console.log("🔍 [Flutter] Petición recibida para /api/fichas-resumen");
  try {
    const query = `
      WITH UltimaConsulta AS (
        SELECT
          ficha_medica_id,
          MAX(fecha) AS ultima_fecha
        FROM consulta
        GROUP BY ficha_medica_id
      )
      SELECT
        fm.id AS "idFicha",
        p.nombre AS "nombrePaciente",
        p.rut AS "idPaciente",
        EXTRACT(YEAR FROM AGE(p.fechanac))::INT AS "edad",
        COALESCE(c.diagnostico, 'Sin diagnóstico') AS "diagnosticoPrincipal",
        COALESCE(s.dirSucurs, 'Sin establecimiento') AS "establecimiento",
        COALESCE(c.fecha, fm.id::TEXT) AS "fechaActualizacion"
      FROM ficha_medica fm
      JOIN paciente p ON fm.paciente_id = p.id
      LEFT JOIN UltimaConsulta uc ON uc.ficha_medica_id = fm.id
      LEFT JOIN consulta c ON c.ficha_medica_id = fm.id AND c.fecha = uc.ultima_fecha
      LEFT JOIN examen e ON e.ficha_medica_id = fm.id
      LEFT JOIN sucursal s ON e.sucursal_id = s.id
      ORDER BY c.fecha DESC NULLS LAST
      LIMIT 10;
    `;

    const result = await db.query(query);
    console.log(`Flutter] Fichas-resumen encontradas: ${result.rows.length}`);
    res.json(result.rows);

  } catch (error) {
    console.error('ERROR en /api/fichas-resumen:', error);
    res.status(500).json({ error: error.message });
  }
});










// consulta para detalle ficha medica 


app.get('/api/fichas/:id/resumen', async (req, res) => {
  try {
    const { id } = req.params; // Este es el ID de la FICHA_MEDICA
    console.log(`🔍 [Detalle] Buscando resumen para Ficha ID: ${id}`);

    // --- 1. Consulta Principal (Corregida) ---
    // Quitamos el JOIN a Sucursal y calculamos la edad.
    // Quitamos f.estado y f.fecha (no existen en la tabla ficha_medica)
    const fichaResult = await db.query(`
      SELECT 
        f.id AS "idFicha",
        f.nombre AS "nombreFicha",
        p.id AS "idPaciente",
        p.nombre AS "nombrePaciente",
        p.rut,
        p.sexo,
        p.telefono,
        p.fechanac,
        EXTRACT(YEAR FROM AGE(p.fechanac)) AS "edad"
      FROM ficha_medica f
      JOIN paciente p ON f.paciente_id = p.id
      WHERE f.id = $1
    `, [id]);

    if (fichaResult.rows.length === 0) {
      return res.status(404).json({ error: 'Ficha no encontrada' });
    }

    const ficha = fichaResult.rows[0];

    // --- 2. Consultas Médicas (Consulta Corregida) ---
    // La tabla 'consulta' no tiene 'diagnostico'.tiene tipo de consulta
    const consultasResult = await db.query(
    `SELECT 
        c.id, 
        c.fecha, 
        tc.nombre AS tipo_consulta,
        m.nombre AS nombre_medico
    FROM consulta c
    LEFT JOIN medico m ON c.medico_id = m.id
    LEFT JOIN tipo_consult tc ON c.TIPO_CONSULT_id = tc.id
    WHERE c.ficha_medica_id = $1 
    ORDER BY c.fecha DESC LIMIT 5`,
    [id]
);

    // --- 3. Exámenes Asociados (Consulta Corregida) ---
    // Hacemos JOIN para obtener el nombre del tipo de examen
    const examenesResult = await db.query(
      `SELECT 
         e.id, 
         e.fecha, 
         e.estadoexamen, 
         te.nombre AS tipo_examen
       FROM examen e
       JOIN tipo_examen te ON e.tipo_examen_id = te.id
       WHERE e.ficha_medica_id = $1 
       ORDER BY e.fecha DESC LIMIT 5`,
      [id]
    );

    // --- 4. Intervenciones/Tratamientos (Consulta Corregida) ---
    // Hacemos JOIN para obtener el nombre del tipo de intervención
    const tratamientosResult = await db.query(
      `SELECT 
         i.id, 
         i.fecha, 
         i.descripcion,
         ti.nombre AS tipo_intervencion,
         s.dirsucurs AS sucursal
       FROM intervencion i
       JOIN tipo_interv ti ON i.tipo_interv_id = ti.id
       LEFT JOIN sucursal s ON i.sucursal_id = s.id
       WHERE i.ficha_medica_id = $1 
       ORDER BY i.fecha DESC LIMIT 5`,
      [id]
    );

    console.log(`[Detalle] Resumen encontrado para Ficha ID: ${id}`);
    
    // --- 5. Ensamblaje del JSON ---
    res.json({
      ficha: ficha,
      consultas: consultasResult.rows,
      examenes: examenesResult.rows,
      tratamientos: tratamientosResult.rows
    });

  } catch (error) {
    console.error('Error al obtener resumen de ficha:', error);
    res.status(500).json({ error: error.message });
  }
});




// para actualizar datos en ficha medica, edit



/* 
// --- ACTUALIZAR FICHA MÉDICA --- en este se deben actualizar todos los campos necesarios
app.put('/api/fichas/:id', async (req, res) => {
  const { id } = req.params;
  const { diagnosticoPrincipal, estado, especialidadACargo, establecimiento } = req.body;

  try {
    const fichaExistente = await db.query('SELECT * FROM ficha_medica WHERE id = $1', [id]);
    if (fichaExistente.rows.length === 0) {
      return res.status(404).json({ error: 'Ficha no encontrada' });
    }

    const updateQuery = `
      UPDATE ficha_medica
      SET
        diagnostico_principal = COALESCE($1, diagnostico_principal),
        estado = COALESCE($2, estado),
        especialidad_acargo = COALESCE($3, especialidad_acargo),
        establecimiento = COALESCE($4, establecimiento)
      WHERE id = $5
      RETURNING *;
    `;
    const result = await db.query(updateQuery, [
      diagnosticoPrincipal,
      estado,
      especialidadACargo,
      establecimiento,
      id,
    ]);

    console.log(`Ficha ${id} actualizada correctamente`);
    res.status(200).json(result.rows[0]);
  } catch (error) {
    console.error(' Error al actualizar ficha:', error);
    res.status(500).json({ error: error.message });
  }
});


*/


// a diferencia del app.put arriba, este patch solo actualiza el nombre (diagnóstico) de la ficha médica
app.patch('/api/fichas/:id', async (req, res) => {
  try {
    const { id } = req.params; // ID de la ficha a editar
    const { nombre } = req.body; // El nuevo "diagnóstico"

    if (!nombre) {
      return res.status(400).json({ error: 'El campo "nombre" (diagnóstico) es requerido' });
    }

    console.log(`UPDATE] Petición para actualizar Ficha ID ${id} con nombre: ${nombre}`);

    // Usamos 'db.query' como el resto del server.js
    const result = await db.query(
      'UPDATE ficha_medica SET nombre = $1 WHERE id = $2 RETURNING *',
      [nombre, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Ficha no encontrada' });
    }

    console.log('[UPDATE] Ficha actualizada con éxito.');
    res.json(result.rows[0]); // Devuelve la ficha actualizada

  } catch (error) {
    console.error('ERROR en PATCH /api/fichas/:id:', error);
    res.status(500).json({ error: error.message });
  }
});







app.patch('/api/consultas/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { diagnostico, tipo_consulta, nombre_medico, peso_paciente, altura_paciente } = req.body;

    console.log(`✏️ [Backend] Actualizando CONSULTA ${id}:`, req.body);

    // Actualizar solo los campos básicos de consulta
    const result = await db.query(`
      UPDATE consulta 
      SET 
        diagnostico = COALESCE($1, diagnostico),
        pesoPaciente = COALESCE($2, pesoPaciente),
        alturaPaciente = COALESCE($3, alturaPaciente)
        -- tipo_consulta y medico_id requerirían updates en tablas relacionadas
      WHERE id = $4
      RETURNING *
    `, [diagnostico, peso_paciente, altura_paciente, id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Consulta no encontrada' });
    }

    console.log('✅ [Backend] CONSULTA actualizada correctamente');
    res.json({ 
      success: true,
      message: 'Consulta actualizada',
      consulta: result.rows[0] 
    });
  } catch (error) {
    console.error('Error al actualizar consulta:', error);
    res.status(500).json({ error: error.message });
  }
});

// ============================================
// === ENDPOINT: Obtener Consulta Individual ===
// ============================================
app.get('/api/consultas/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    console.log(`🔍 [Backend] Buscando consulta ID: ${id}`);
    
    const result = await db.query(`
      SELECT 
        c.id,
        c.fecha,
        c.diagnostico,
        c.peso_paciente,
        c.altura_paciente,
        c.ficha_medica_id,
        tc.nombre AS tipo_consulta,
        m.nombre AS nombre_medico
      FROM consulta c
      LEFT JOIN medico m ON c.medico_id = m.id
      LEFT JOIN tipo_consult tc ON c.TIPO_CONSULT_id = tc.id
      WHERE c.id = $1
    `, [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Consulta no encontrada' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error al obtener consulta:', error);
    res.status(500).json({ error: error.message });
  }
});
