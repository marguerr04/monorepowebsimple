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
    const rutLimpio = rut.replace(/[^0-9kK]/g, '');
    
    console.log('🔍 Buscando paciente con RUT:', rutLimpio);
    
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

    const rutLimpio = rut.replace(/[^0-9kK]/g, '');
    
    console.log('🔍 RUT limpio para búsqueda:', rutLimpio);

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

app.get('/api/pacientes/:id/alergias', async (req, res) => {
  try {
    const { id } = req.params;
    
    console.log('🔍 Buscando alergias para paciente ID:', id);
    
    const result = await db.query(`
      SELECT a.id, a.nombre, ta.nombre as tipo
      FROM alergia a
      INNER JOIN alergia_paciente ap ON a.id = ap.alergia_id
      INNER JOIN tipo_alergia ta ON a.tipo_alergia_id = ta.id
      WHERE ap.paciente_id = $1
      ORDER BY ta.nombre, a.nombre
    `, [id]);
    
    console.log('✅ Alergias encontradas:', result.rows.length);
    res.json(result.rows);
  } catch (error) {
    console.error('❌ Error obteniendo alergias:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/pacientes/:id/diagnosticos', async (req, res) => {
  try {
    const { id } = req.params;
    
    console.log('🔍 Buscando diagnósticos para paciente ID:', id);
    
    const result = await db.query(`
      SELECT d.id, d.nombre
      FROM diagnostico d
      INNER JOIN diagnostico_consulta dc ON d.id = dc.diagnostico_id
      INNER JOIN consulta c ON dc.consulta_id = c.id
      WHERE c.paciente_id = $1
      ORDER BY d.nombre
    `, [id]);
    
    console.log('✅ Diagnósticos encontrados:', result.rows.length);
    res.json(result.rows);
  } catch (error) {
    console.error('❌ Error obteniendo diagnósticos:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/pacientes/:id/tipo-sangre', async (req, res) => {
  try {
    const { id } = req.params;
    
    console.log('🔍 Buscando tipo de sangre para paciente ID:', id);
    
    const result = await db.query(`
      SELECT ts.tiposangre
      FROM paciente p
      INNER JOIN tipo_sangre ts ON p.tipo_sangre_id = ts.id
      WHERE p.id = $1
    `, [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Tipo de sangre no encontrado para este paciente' });
    }
    
    console.log('✅ Tipo de sangre encontrado:', result.rows[0]);
    res.json(result.rows[0]);
  } catch (error) {
    console.error('❌ Error obteniendo tipo de sangre:', error);
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/consultas', async (req, res) => {
  try {
    const { fecha, centroMedico, motivoConsulta, pacienteId } = req.body;
    
    console.log('📋 Datos recibidos para consulta:', { 
      fecha, centroMedico, motivoConsulta, pacienteId 
    });

    if (!fecha || !centroMedico || !motivoConsulta || !pacienteId) {
      return res.status(400).json({ 
        error: 'Datos incompletos',
        requeridos: { fecha, centroMedico, motivoConsulta, pacienteId }
      });
    }

    const tipoConsultId = 1;
    console.log('✅ Usando tipo_consult_id por defecto:', tipoConsultId);

    console.log('🔍 Verificando paciente ID:', pacienteId);
    const pacienteResult = await db.query(
      'SELECT id FROM paciente WHERE id = $1', 
      [pacienteId]
    );

    if (pacienteResult.rows.length === 0) {
      return res.status(400).json({ 
        error: 'Paciente no encontrado',
        pacienteId: pacienteId
      });
    }

    console.log('✅ Paciente verificado');

    console.log('🔍 Obteniendo próximo ID disponible para consulta...');
    const maxIdResult = await db.query('SELECT COALESCE(MAX(id), 0) as max_id FROM consulta');
    const nextId = maxIdResult.rows[0].max_id + 1;
    console.log('✅ Próximo ID consulta:', nextId);

    console.log('💾 Insertando consulta con ID:', nextId);
    const result = await db.query(
      `INSERT INTO consulta (
        id, fecha, paciente_id, tipo_consult_id, medico_id, 
        ficha_medica_id, pesopaciente, alturapaciente, motivo_consulta
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *`,
      [
        nextId, 
        fecha, 
        pacienteId, 
        tipoConsultId,
        1,
        1,
        0,
        0,
        motivoConsulta
      ]
    );

    console.log('✅ Consulta guardada exitosamente. ID:', result.rows[0].id);
    res.json({ 
      success: true, 
      message: 'Consulta guardada correctamente',
      consulta: result.rows[0] 
    });

  } catch (error) {
    console.error('❌ Error guardando consulta:', error);
    res.status(500).json({ 
      error: 'Error del servidor al guardar consulta',
      detalle: error.message
    });
  }
});

app.post('/api/examenes', async (req, res) => {
  try {
    const { fecha, centroMedico, tipoExamen, resultadoExamen, pacienteId } = req.body;
    
    console.log('🔬 Datos recibidos para examen:', { 
      fecha, centroMedico, tipoExamen, resultadoExamen, pacienteId 
    });

    // Validaciones básicas
    if (!fecha || !centroMedico || !tipoExamen || !pacienteId) {
      return res.status(400).json({ 
        error: 'Datos incompletos',
        requeridos: { fecha, centroMedico, tipoExamen, pacienteId }
      });
    }

    // 1. Obtener ID del centro médico (sucursal)
    console.log('🔍 Buscando centro médico:', centroMedico);
    const centroResult = await db.query(
      'SELECT id FROM centro_medico WHERE nombrecentro = $1', 
      [centroMedico]
    );

    if (centroResult.rows.length === 0) {
      return res.status(400).json({ 
        error: 'Centro médico no encontrado',
        centroBuscado: centroMedico
      });
    }

    const sucursalId = centroResult.rows[0].id;
    console.log('✅ Centro médico encontrado, ID:', sucursalId);

    // 2. Obtener ID del tipo de examen
    console.log('🔍 Buscando tipo de examen:', tipoExamen);
    const tipoExamenResult = await db.query(
      'SELECT id FROM tipo_examen WHERE nombre = $1', 
      [tipoExamen]
    );

    if (tipoExamenResult.rows.length === 0) {
      return res.status(400).json({ 
        error: 'Tipo de examen no encontrado',
        tipoBuscado: tipoExamen
      });
    }

    const tipoExamenId = tipoExamenResult.rows[0].id;
    console.log('✅ Tipo de examen encontrado, ID:', tipoExamenId);

    // 3. Verificar que el paciente existe
    console.log('🔍 Verificando paciente ID:', pacienteId);
    const pacienteResult = await db.query(
      'SELECT id FROM paciente WHERE id = $1', 
      [pacienteId]
    );

    if (pacienteResult.rows.length === 0) {
      return res.status(400).json({ 
        error: 'Paciente no encontrado',
        pacienteId: pacienteId
      });
    }

    console.log('✅ Paciente verificado');

    // 4. OBTENER EL PRÓXIMO ID DISPONIBLE
    console.log('🔍 Obteniendo próximo ID disponible...');
    const maxIdResult = await db.query('SELECT COALESCE(MAX(id), 0) as max_id FROM examen');
    const nextId = maxIdResult.rows[0].max_id + 1;
    console.log('✅ Próximo ID:', nextId);

    // 5. INSERT con el ID calculado
    console.log('💾 Insertando examen con ID:', nextId);
    const result = await db.query(
      `INSERT INTO examen (id, fecha, paciente_id, sucursal_id, tipo_examen_id, comentariosexamen, estadoexamen, ficha_medica_id) 
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *`,
      [nextId, fecha, pacienteId, sucursalId, tipoExamenId, resultadoExamen || '', 'completado', 1]
    );

    console.log('✅ Examen guardado exitosamente. ID:', result.rows[0].id);
    res.json({ 
      success: true, 
      message: 'Examen guardado correctamente',
      examen: result.rows[0] 
    });

  } catch (error) {
    console.error('❌ Error guardando examen:', error);
    res.status(500).json({ 
      error: 'Error del servidor al guardar examen',
      detalle: error.message
    });
  }
});