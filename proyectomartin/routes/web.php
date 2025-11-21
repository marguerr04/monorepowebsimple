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
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
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