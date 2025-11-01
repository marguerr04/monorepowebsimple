import express from "express";
import pkg from "pg";
import dotenv from "dotenv";
import cors from "cors";

dotenv.config();

// --- Configuración Básica ---
const { Pool } = pkg;
const app = express();
app.use(express.json());
app.use(cors());

// --- Conexión a PostgreSQL ---
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_DATABASE,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
});

// ===============================================
// --- RUTAS DE TESTEO Y GENERALES ---
// ===============================================

app.get("/api", (req, res) => {
  res.send("✅ Backend Unificado (Ionic + Flutter) funcionando.");
});

app.get("/api/test-db", async (req, res) => {
  try {
    const result = await pool.query("SELECT NOW() as current_time");
    res.json({
      success: true,
      message: '✅ Base de datos conectada.',
      timestamp: result.rows[0].current_time
    });
  } catch (err) {
    console.error("Error de conexión:", err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// ===============================================
// --- RUTAS PARA IONIC (Corregidas y Adaptadas) ---
// ===============================================

app.post('/api/pacientes/login', async (req, res) => {
  try {
    const { rut, correo, clave } = req.body;
    console.log('🔐 [Ionic] Petición de login recibida:', { rut, correo, clave: '***' });

    const rutLimpio = rut.replace(/[^0-9kK]/g, '');
    
    const result = await pool.query(
      // TAMBIÉN limpiamos el RUT de la base de datos para la comparación
      "SELECT * FROM paciente WHERE REPLACE(REPLACE(rut, '.', ''), '-', '') = $1 AND correo = $2 AND clave = $3",
      [rutLimpio, correo, clave]
    );

    if (result.rows.length === 0) {
      console.log('❌ [Ionic] Login fallido para RUT:', rutLimpio);
      return res.status(401).json({ success: false, message: 'Credenciales inválidas' });
    }

    console.log('✅ [Ionic] Login exitoso para:', result.rows[0].nombre);
    res.json({
      success: true,
      message: 'Login exitoso',
      paciente: result.rows[0]
    });

  } catch (error) {
    console.error('💥 [Ionic] ERROR en login:', error);
    res.status(500).json({ success: false, message: 'Error del servidor' });
  }
});

// --- RUTA CORREGIDA ---
// Ahora usa un JOIN con ficha_medica para encontrar al paciente
// en lugar de buscar la columna 'paciente_id' que no existe.
app.get('/api/pacientes/:id/consultas', async (req, res) => {
  try {
    const { id } = req.params; // Este 'id' es el PACIENTE_id
    console.log('🔍 [Ionic] Buscando consultas para paciente ID:', id);
    
    const result = await pool.query(
      `SELECT c.* FROM consulta c
       JOIN ficha_medica fm ON c.ficha_medica_id = fm.id
       WHERE fm.paciente_id = $1 
       ORDER BY c.fecha DESC`,
      [id]
    );
    
    console.log('📋 [Ionic] Consultas encontradas:', result.rows.length);
    res.json(result.rows);
  } catch (error) {
    console.error('💥 [Ionic] Error en /api/pacientes/:id/consultas:', error);
    res.status(500).json({ error: error.message, details: "Revisar JOIN entre consulta y ficha_medica" });
  }
});

// --- (Añade aquí el resto de rutas de Ionic: /api/consultas, /api/examenes, etc. si las necesitas) ---
// --- Solo recuerda cambiar 'db.query' por 'pool.query' ---


// ===============================================
// --- RUTAS PARA FLUTTER (Corregidas) ---
// ===============================================

// Esta ruta estaba bien, solo la mantenemos.
app.get("/api/analitos/historial/:pacienteId", async (req, res) => {
  const { pacienteId } = req.params;
  let { nombre, lastFetchTime } = req.query;

  if (!nombre) {
    return res.status(400).json({ error: "El parámetro 'nombre' es requerido." });
  }

  try {
    console.log(`📈 [Flutter] Petición de analitos para Paciente ID: ${pacienteId}, Analito: ${nombre}`);
    
    let nombres = Array.isArray(nombre) ? nombre : [nombre];
    let cleanNombres = nombres.map(n => n.trim());
    const nombrePlaceholders = cleanNombres.map((_, i) => `$${i + 2}`).join(", ");
    let queryParams = [pacienteId, ...cleanNombres];
    
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
    const result = await pool.query(queryString, queryParams);
    res.json(result.rows);

  } catch (err) {
    console.error("💥 [Flutter] Error en /api/analitos/historial:", err);
    res.status(500).json({ error: "Error al consultar historial de analito", details: err.message });
  }
});

// --- RUTA CORREGIDA ---
// Esta consulta es más robusta. Usa LEFT JOIN para incluir
// tipos de examen aunque no tengan resultados, evitando fallos.
app.get("/api/examenes/estadisticas", async (req, res) => {
  try {
    console.log(`📊 [Flutter] Petición de estadísticas de exámenes`);
    
    let queryString = `
      SELECT
        te.nombre AS tipo_examen,
        CAST(COUNT(CASE WHEN ra.aprobado = TRUE THEN 1 END) AS INT) AS aprobados,
        CAST(COUNT(CASE WHEN ra.aprobado = FALSE THEN 1 END) AS INT) AS reprobados,
        MAX(e.fecha) as last_updated
      FROM tipo_examen te -- Empezamos por tipo_examen para listarlos todos
      LEFT JOIN examen e ON te.id = e.tipo_examen_id
      LEFT JOIN resultado_analito ra ON e.id = ra.examen_id
      GROUP BY te.nombre
      ORDER BY te.nombre ASC;
    `;
    
    console.log("Query ejecutada:", queryString);
    const statsResult = await pool.query(queryString);
    
    console.log(`📊 [Flutter] Estadísticas encontradas: ${statsResult.rows.length} tipos`);
    res.json(statsResult.rows);

  } catch (err) {
    console.error("💥 [Flutter] Error en /api/examenes/estadisticas:", err);
    res.status(500).json({ error: "Error al consultar estadísticas", details: err.message });
  }
});







// ===============================================
// --- INICIO DE RUTAS FALTANTES DE IONIC ---
// ===============================================

// GET /api/consultas (Lista general de consultas)
app.get('/api/consultas', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM consulta ORDER BY fecha DESC LIMIT 10');
    res.json(result.rows);
  } catch (error) {
    console.error('Error en /api/consultas:', error);
    res.status(500).json({ error: error.message });
  }
});

// GET /api/examenes (Lista general de examenes)
app.get('/api/examenes', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM examen ORDER BY fecha DESC LIMIT 10');
    res.json(result.rows);
  } catch (error) {
    console.error('Error en /api/examenes:', error);
    res.status(500).json({ error: error.message });
  }
});

// GET /api/pacientes (Lista general de pacientes)
app.get('/api/pacientes', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM paciente ORDER BY id ASC LIMIT 10');
    res.json(result.rows);
  } catch (error) {
    console.error('Error en /api/pacientes:', error);
    res.status(500).json({ error: error.message });
  }
});

// GET /api/pacientes/rut/:rut (Buscar paciente por RUT)
app.get('/api/pacientes/rut/:rut', async (req, res) => {
  try {
    const { rut } = req.params;
    const rutLimpio = rut.replace(/[^0-9kK]/g, '');
    console.log('🔍 [Ionic] Buscando paciente con RUT:', rutLimpio);
    
    const result = await pool.query(
      "SELECT * FROM paciente WHERE REPLACE(REPLACE(rut, '.', ''), '-', '') = $1",
      [rutLimpio]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Paciente no encontrado' });
    }
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error en /api/pacientes/rut/:rut:', error);
    res.status(500).json({ error: error.message });
  }
});

// GET /api/pacientes/:id (Obtener perfil de paciente)
app.get('/api/pacientes/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM paciente WHERE id = $1', [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Paciente no encontrado' });
    }
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error en /api/pacientes/:id:', error);
    res.status(500).json({ error: error.message });
  }
});

// GET /api/tipo-sangre/:id
app.get('/api/tipo-sangre/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM tipo_sangre WHERE id = $1', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Tipo de sangre no encontrado' });
    }
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error en /api/tipo-sangre/:id:', error);
    res.status(500).json({ error: error.message });
  }
});

// GET /api/centro-medico/:id
app.get('/api/centro-medico/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM centro_medico WHERE id = $1', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Centro médico no encontrado' });
    }
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error en /api/centro-medico/:id:', error);
    res.status(500).json({ error: error.message });
  }
});

// GET /api/pacientes/:id/examenes
app.get('/api/pacientes/:id/examenes', async (req, res) => {
  try {
    const { id } = req.params; // Este es PACIENTE_id
    console.log('🔍 [Ionic] Buscando exámenes para paciente ID:', id);

    const result = await pool.query(
       `SELECT e.* FROM examen e
        JOIN ficha_medica fm ON e.ficha_medica_id = fm.id
        WHERE fm.paciente_id = $1 
        ORDER BY e.fecha DESC`, 
      [id]
    );
    
    console.log('🔬 [Ionic] Exámenes encontrados:', result.rows.length);
    res.json(result.rows);
  } catch (error) {
    console.error('Error en /api/pacientes/:id/examenes:', error);
    res.status(500).json({ error: error.message });
  }
});

// GET /api/tipos-examen
app.get('/api/tipos-examen', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM tipo_examen ORDER BY nombre');
    res.json(result.rows);
  } catch (error) {
    console.error('Error en /api/tipos-examen:', error);
    res.status(500).json({ error: error.message });
  }
});

// GET /api/centros-medicos
app.get('/api/centros-medicos', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM centro_medico ORDER BY nombrecentro');
    res.json(result.rows);
  } catch (error) {
    console.error('Error en /api/centros-medicos:', error);
    res.status(500).json({ error: error.message });
  }
});

// ===============================================
// --- FIN DE RUTAS FALTANTES DE IONIC ---












// ===============================================
// --- INICIAR SERVIDOR ---
// ===============================================
app.listen(process.env.PORT, () =>
  console.log(`🚀 Servidor UNIFICADO corriendo en http://localhost:${process.env.PORT}`)
);

