<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ExamenController;
use App\Http\Controllers\NotificacionController;

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// Endpoint público para obtener exámenes
Route::get('/examenes', [ExamenController::class, 'index']);

// API de notificaciones (sin autenticación para que backend Node.js pueda usarlo)
Route::post('/notificaciones', [NotificacionController::class, 'crear']);
Route::get('/notificaciones', [NotificacionController::class, 'index']);
Route::post('/notificaciones/{id}/marcar-leida', [NotificacionController::class, 'marcarLeida']);
Route::post('/notificaciones/marcar-todas-leidas', [NotificacionController::class, 'marcarTodasLeidas']);