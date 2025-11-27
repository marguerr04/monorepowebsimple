<?php

namespace App\Http\Controllers;

use App\Models\Paciente;
use App\Models\Examen;
use App\Models\Consulta;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    public function index()
    {
        // Total de pacientes
        $totalPacientes = Paciente::count();
        
        // Consultas del día
        $consultasHoy = Consulta::whereDate('fecha', today())->count();
        
        // Exámenes pendientes
        $examenesPendientes = Examen::where('estadoexamen', 'Pendiente')->count();
        
        // Últimas consultas (5 más recientes)
        $ultimasConsultas = Consulta::with('paciente')
            ->orderBy('fecha', 'desc')
            ->take(5)
            ->get();
        
        // Últimos exámenes (5 más recientes)
        $ultimosExamenes = Examen::with('paciente')
            ->orderBy('fecha', 'desc')
            ->take(5)
            ->get();
        
        // Estadísticas mensuales (comparación con mes anterior)
        $pacientesMesActual = Paciente::whereMonth('fechanac', now()->month)
            ->whereYear('fechanac', now()->year)
            ->count();
        
        $consultasMesActual = Consulta::whereMonth('fecha', now()->month)
            ->whereYear('fecha', now()->year)
            ->count();
        
        $consultasMesAnterior = Consulta::whereMonth('fecha', now()->subMonth()->month)
            ->whereYear('fecha', now()->subMonth()->year)
            ->count();
        
        // Calcular porcentaje de cambio
        $cambioConsultas = 0;
        if ($consultasMesAnterior > 0) {
            $cambioConsultas = (($consultasMesActual - $consultasMesAnterior) / $consultasMesAnterior) * 100;
        }
        
        return view('dashboard', compact(
            'totalPacientes',
            'consultasHoy',
            'examenesPendientes',
            'ultimasConsultas',
            'ultimosExamenes',
            'cambioConsultas'
        ));
    }
}
