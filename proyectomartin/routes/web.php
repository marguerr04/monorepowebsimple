<?php

use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;
use App\Models\Paciente;
use App\Http\Controllers\ExamenController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
|
*/

Route::get('/', function () {
    return redirect()->route('login');
});

Route::get('/dashboard', function () {
    return view('dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
    
    // CRUD de Pacientes
    Route::resource('pacientes', \App\Http\Controllers\PacienteController::class);
    
    // CRUD de Consultas
    Route::resource('consultas', \App\Http\Controllers\ConsultaController::class);
});

require __DIR__.'/auth.php';


// (Aquí están tus otras rutas: /, /dashboard, etc.)
// ...


// --- PEGA ESTE CÓDIGO NUEVO AQUÍ ABAJO ---

Route::get('/crear-paciente-temporal', function () {
    
    // Primero, borramos al paciente por si ya existe (para poder re-intentar)
    \App\Models\Paciente::where('correo', 'jperez@gmail.com')->delete();

    // Ahora creamos el paciente nuevo
    $paciente = \App\Models\Paciente::create([
        'rut' => '181234567',
        'dv' => '7',
        'nombre' => 'Juan Pérez González',
        'sexo' => 'Masculino',
        'fechanac' => '1992-08-15',
        'telefono' => '+56987654321',
        'direccion' => 'Av. Apoquindo 3000',
        'tipo_sangre_id' => 1,
        'email' => 'jperez@gmail.com',
        'clave' => '12345678',
        'telefono_emergencia' => '+56912345678',
        'centro_medico_id' => 2
    ]);

    return "¡PACIENTE CREADO CON ÉXITO! -> " . $paciente->nombre;
});

Route::resource('examenes', ExamenController::class);

// Ruta para resetear secuencia de paciente
Route::get('/reset-secuencia-paciente', function () {
    try {
        // Resetear la secuencia al máximo ID + 1
        $sql = "SELECT setval(pg_get_serial_sequence('paciente', 'id'), COALESCE((SELECT MAX(id) FROM paciente), 1) + 1, false)";
        DB::statement($sql);
        
        return response()->json([
            'success' => true,
            'message' => '✅ Secuencia de paciente reseteada correctamente'
        ]);
    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'message' => '❌ Error al resetear secuencia',
            'error' => $e->getMessage()
        ], 500);
    }
});

// Ruta de prueba para crear paciente
Route::get('/test-crear-paciente', function () {
    try {
        // Generar datos únicos
        $randomNum = rand(1000, 9999);
        
        $paciente = \App\Models\Paciente::create([
            'rut' => 10000000 + $randomNum,
            'dv' => rand(0, 9),
            'nombre' => 'Paciente Test ' . $randomNum,
            'sexo' => 'Masculino',
            'fechanac' => '1990-01-01',
            'telefono' => '+569' . rand(10000000, 99999999),
            'correo' => 'test' . $randomNum . '@test.cl',
            'direccion' => 'Direccion Test ' . $randomNum,
            'tipo_sangre_id' => 1,
            'clave' => 'test123456',
            'telefono_emergencia' => '+569' . rand(10000000, 99999999),
            'centro_medico_id' => 1
        ]);

        return response()->json([
            'success' => true,
            'message' => '✅ Paciente creado exitosamente',
            'data' => [
                'id' => $paciente->id,
                'rut' => $paciente->rut . '-' . $paciente->dv,
                'nombre' => $paciente->nombre,
                'correo' => $paciente->correo
            ]
        ], 201);
    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'message' => '❌ Error al crear paciente',
            'error' => $e->getMessage()
        ], 500);
    }
});