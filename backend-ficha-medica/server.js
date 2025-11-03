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
          fm.id AS ficha_id,
          MAX(c.fecha) AS ultima_fecha
        FROM ficha_medica fm
        JOIN consulta c ON c.ficha_medica_id = fm.id
        GROUP BY fm.id
      ),
      DiagnosticoReciente AS (
        SELECT
          dc.consulta_id,
          (SELECT d.nombre 
           FROM diagnostico d 
           WHERE d.id = MIN(dc.diagnostico_id)) AS diagnostico_principal
        FROM diagnostico_consulta dc
        GROUP BY dc.consulta_id
      )
      SELECT
        fm.id AS "idFicha",
        c.id AS "idConsulta",
        p.nombre AS "nombrePaciente",
        p.rut AS "idPaciente",
        EXTRACT(YEAR FROM AGE(p.fechanac))::INT AS "edad",
        COALESCE(dr.diagnostico_principal, 'Sin diagnóstico') AS "diagnosticoPrincipal",
        uc.ultima_fecha AS "fechaActualizacion",
        COALESCE(m.nombre, 'No asignado') AS "especialidadACargo",
        COALESCE(s.dirSucurs, 'Sin establecimiento') AS "establecimiento",
        'Activo' AS "estado"
      FROM ficha_medica fm
      JOIN paciente p ON fm.paciente_id = p.id
      LEFT JOIN UltimaConsulta uc ON uc.ficha_id = fm.id
      LEFT JOIN consulta c ON c.ficha_medica_id = fm.id AND c.fecha = uc.ultima_fecha
      LEFT JOIN DiagnosticoReciente dr ON dr.consulta_id = c.id
      LEFT JOIN medico m ON m.id = c.medico_id
      LEFT JOIN examen e ON e.ficha_medica_id = fm.id  
      LEFT JOIN sucursal s ON e.sucursal_id = s.id     
      ORDER BY uc.ultima_fecha DESC NULLS LAST
      LIMIT 10;
    `;

    const result = await db.query(query);
    console.log(`✅ [Flutter] Fichas-resumen encontradas: ${result.rows.length}`);
    res.json(result.rows);

  } catch (error) {
    console.error('💥 ERROR en /api/fichas-resumen:', error);
    res.status(500).json({ error: error.message });
  }
});



// ============================================
// === ENDPOINT 4: Obtener Detalles de Consulta (READ - Para Editar)
// ============================================
// Proósito: Obtener los datos de UNA sola consulta para rellenar
// el formulario de EDICIÓN.
app.get('/api/consulta/:id', async (req, res) => {
  const { id } = req.params;
  console.log(`🔍 [Flutter] Petición de detalle para consulta ID: ${id}`);
  
  try {
    const query = `
      SELECT
        c.id AS "consultaId",
        c.fecha,
        c.pesoPaciente,
        c.alturaPaciente,
        p.nombre AS "pacienteNombre",
        p.rut AS "pacienteRut",
        m.nombre AS "medicoNombre",
        c.medico_id AS "medicoId",
        COALESCE(
          (
            SELECT json_agg(json_build_object('id', d.id, 'nombre', d.nombre))
            FROM diagnostico_consulta dc
            JOIN diagnostico d ON dc.diagnostico_id = d.id
            WHERE dc.consulta_id = c.id
          ),
          '[]'::json
        ) AS "diagnosticos"
      FROM consulta c
      LEFT JOIN ficha_medica fm ON c.ficha_medica_id = fm.id
      LEFT JOIN paciente p ON fm.paciente_id = p.id
      LEFT JOIN medico m ON c.medico_id = m.id
      WHERE c.id = $1;
    `;
    
    const result = await db.query(query, [id]);

    if (result.rows.length === 0) {
      console.warn(`⚠️ [Flutter] Consulta ID: ${id} no encontrada.`);
      return res.status(404).json({ error: 'Consulta no encontrada' });
    }

    console.log(`✅ [Flutter] Detalle de consulta ID: ${id} encontrado.`);
    res.json(result.rows[0]); 

  } catch (error) {
    console.error(`💥 ERROR en GET /api/consulta/${id}:`, error);
    res.status(500).json({ error: 'Error al obtener detalle de la consulta', details: error.message });
  }
});





// ============================================
// === ENDPOINT 5: Actualizar Consulta (UPDATE - Para Editar)
// ============================================
// Propósito: Actualizar el peso, altura y/o diagnósticos
// de UNA sola consulta desde el formulario de EDICIÓN.
app.put('/api/consulta/:id', async (req, res) => {
  const { id } = req.params;
  const { pesoPaciente, alturaPaciente, diagnosticos } = req.body; 

  console.log(`🔄 [Flutter] Petición de ACTUALIZACIÓN para consulta ID: ${id}`);
  console.log('Datos recibidos:', req.body);
  
  if (pesoPaciente == null || alturaPaciente == null || !Array.isArray(diagnosticos)) {
    console.warn(`⚠️ [Flutter] Datos incompletos para actualizar consulta ID: ${id}`);
    return res.status(400).json({ 
      error: 'Datos incompletos. Se requiere pesoPaciente, alturaPaciente y un array de diagnosticos (aunque esté vacío []).' 
    });
  }
  
  try {
    await db.query('BEGIN');

    // --- PASO 1: Actualizar la tabla 'consulta' ---
    const updateConsultaQuery = `
      UPDATE consulta
      SET pesoPaciente = $1, alturaPaciente = $2
      WHERE id = $3
      RETURNING *;
    `;
    const consultaResult = await db.query(updateConsultaQuery, [pesoPaciente, alturaPaciente, id]); 

    if (consultaResult.rows.length === 0) {
      throw new Error('Consulta no encontrada para actualizar');
    }

    // --- PASO 2: Borrar TODOS los diagnósticos antiguos de esa consulta ---
    const deleteDiagsQuery = `
      DELETE FROM diagnostico_consulta
      WHERE consulta_id = $1;
    `;
    await db.query(deleteDiagsQuery, [id]); 

    // --- PASO 3: Insertar los nuevos diagnósticos ---
    if (diagnosticos.length > 0) {
      const values = diagnosticos.map((diagId, index) => 
        `($1, $${index + 2})`
      ).join(', ');
      
      const insertDiagsQuery = `
        INSERT INTO diagnostico_consulta (consulta_id, diagnostico_id)
        VALUES ${values};
      `;
      
      const queryParams = [id, ...diagnosticos.map(diagId => parseInt(diagId, 10))];
      await db.query(insertDiagsQuery, queryParams);
    }
    
    await db.query('COMMIT'); 
    
    console.log(`✅ [Flutter] Consulta ID: ${id} actualizada exitosamente.`);
    res.json(consultaResult.rows[0]);

  } catch (error) {
    await db.query('ROLLBACK');
    console.error(`💥 ERROR en PUT /api/consulta/${id}:`, error);
    res.status(500).json({ error: 'Error al actualizar la consulta (transacción revertida)', details: error.message });
  }
});






// ==========================================================
// === ENDPOINT 6: Resumen Detallado de Ficha (READ - Para "Ver Ficha")
// ==========================================================
// Propósito: Obtener el historial de un paciente (consultas, exámenes)
// para la pantalla de "Ver Ficha" (el ícono del ojo).
app.get('/api/ficha/:id/resumen-detallado', async (req, res) => {
  const { id } = req.params; // Este 'id' es el ficha_medica_id
  console.log(`📊 [Flutter] Petición de Resumen Detallado para Ficha ID: ${id}`);

  try {
    // 1. Obtener datos del paciente
    const pacienteQuery = `
      SELECT
        p.nombre, 
        p.rut, 
        EXTRACT(YEAR FROM AGE(p.fechanac))::INT AS "edad", 
        p.sexo, 
        p.telefono
      FROM paciente p
      JOIN ficha_medica fm ON p.id = fm.paciente_id
      WHERE fm.id = $1;
    `;

    // 2. Obtener consultas recientes (con sus diagnósticos agrupados)
    const consultasQuery = `
      SELECT
        c.id,
        c.fecha,
        COALESCE(m.nombre, 'Sin médico') AS "medico",
        COALESCE(
          (
            -- Agrupa todos los nombres de diagnósticos de ESTA consulta en un array
            SELECT json_agg(d.nombre)
            FROM diagnostico_consulta dc
            JOIN diagnostico d ON dc.diagnostico_id = d.id
            WHERE dc.consulta_id = c.id
          ),
          '[]'::json -- Devuelve '[]' si no tiene diagnósticos
        ) AS "diagnosticos"
      FROM consulta c
      LEFT JOIN medico m ON c.medico_id = m.id
      WHERE c.ficha_medica_id = $1
      ORDER BY c.fecha DESC
      LIMIT 5; -- Traemos las últimas 5
    `;

    // 3. Obtener exámenes recientes
    const examenesQuery = `
      SELECT
        e.id,
        e.fecha,
        te.nombre AS "tipoExamen",
        COALESCE(s.dirSucurs, 'Sin sucursal') AS "sucursal"
      FROM examen e
      LEFT JOIN tipo_examen te ON e.tipo_examen_id = te.id
      LEFT JOIN sucursal s ON e.sucursal_id = s.id
      WHERE e.ficha_medica_id = $1
      ORDER BY e.fecha DESC
      LIMIT 5; -- Traemos los últimos 5
    `;

    // Ejecutamos las 3 consultas en paralelo para mayor eficiencia
    const [pacienteResult, consultasResult, examenesResult] = await Promise.all([
      db.query(pacienteQuery, [id]),
      db.query(consultasQuery, [id]),
      db.query(examenesQuery, [id])
    ]);

    if (pacienteResult.rows.length === 0) {
      console.warn(`⚠️ [Flutter] Ficha ID: ${id} no encontrada.`);
      return res.status(404).json({ error: 'Ficha médica no encontrada' });
    }

    // Combinamos todo en una sola respuesta
    const respuesta = {
      paciente: pacienteResult.rows[0],
      consultasRecientes: consultasResult.rows,
      examenesRecientes: examenesResult.rows
    };

    console.log(`✅ [Flutter] Resumen detallado para Ficha ID: ${id} generado.`);
    res.json(respuesta);

  } catch (error) {
    console.error(`💥 ERROR en GET /api/ficha/${id}/resumen-detallado:`, error);
    res.status(500).json({ error: 'Error al obtener resumen detallado', details: error.message });
  }
});