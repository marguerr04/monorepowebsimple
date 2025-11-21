<?php

namespace App\Http\Controllers;

use App\Models\Examen;
use Illuminate\Http\Request;

class ExamenController extends Controller
{
    public function index()
{
    // Si la petición es API, devuelve JSON
    if (request()->is('api/*')) {
        $examenes = Examen::with(['paciente', 'tipoExamen', 'sucursal', 'fichaMedica'])->get();
        return response()->json($examenes);
    }

    // Si la petición es web, devuelve la vista
    $examenes = Examen::with(['paciente', 'tipoExamen', 'sucursal', 'fichaMedica'])->get();
    return view('examenes.index', compact('examenes'));
}

    public function create()
    {
        return view('examenes.create');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'fecha' => 'required|date',
            'estadoexamen' => 'required|string',
            'comentariosexamen' => 'nullable|string',
            'rutapdf' => 'nullable|string',
            'ficha_medica_id' => 'required|integer|exists:ficha_medicas,id',
            'tipo_examen_id' => 'required|integer|exists:tipo_examenes,id',
            'sucursal_id' => 'required|integer|exists:sucursales,id',
            'paciente_id' => 'required|integer|exists:pacientes,id',
        ]);
        Examen::create($validated);
        return redirect()->route('examenes.index');
    }

    public function show(Examen $examen)
    {
        return view('examenes.show', compact('examen'));
    }

    public function edit(Examen $examen)
    {
        return view('examenes.edit', compact('examen'));
    }

    public function update(Request $request, Examen $examen)
    {
        $validated = $request->validate([
            'fecha' => 'required|date',
            'estadoexamen' => 'required|string',
            'comentariosexamen' => 'nullable|string',
            'rutapdf' => 'nullable|string',
            'ficha_medica_id' => 'required|integer|exists:ficha_medicas,id',
            'tipo_examen_id' => 'required|integer|exists:tipo_examenes,id',
            'sucursal_id' => 'required|integer|exists:sucursales,id',
            'paciente_id' => 'required|integer|exists:pacientes,id',
        ]);
        $examen->update($validated);
        return redirect()->route('examenes.index');
    }

    public function destroy(Examen $examen)
    {
        $examen->delete();
        return redirect()->route('examenes.index');
    }
}