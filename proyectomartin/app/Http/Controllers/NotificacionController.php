<?php

namespace App\Http\Controllers;

use App\Models\Notificacion;
use Illuminate\Http\Request;

class NotificacionController extends Controller
{
    // Obtener notificaciones no leídas
    public function index()
    {
        $notificaciones = Notificacion::where('leida', false)
            ->orderBy('fecha_creacion', 'desc')
            ->take(10)
            ->get();
            
        return response()->json($notificaciones);
    }
    
    // Marcar notificación como leída
    public function marcarLeida($id)
    {
        $notificacion = Notificacion::findOrFail($id);
        $notificacion->leida = true;
        $notificacion->save();
        
        return response()->json(['success' => true]);
    }
    
    // Marcar todas como leídas
    public function marcarTodasLeidas()
    {
        Notificacion::where('leida', false)->update(['leida' => true]);
        
        return response()->json(['success' => true]);
    }
    
    // Crear notificación (desde backend Node.js o Ionic)
    public function crear(Request $request)
    {
        $validated = $request->validate([
            'tipo' => 'required|string',
            'mensaje' => 'required|string',
            'datos' => 'nullable|array'
        ]);
        
        $notificacion = Notificacion::create($validated);
        
        return response()->json($notificacion, 201);
    }
}
