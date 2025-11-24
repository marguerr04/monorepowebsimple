<?php

namespace App\Http\Controllers;

use App\Models\Examen;
use App\Models\Paciente;
use Illuminate\Http\Request;

class ExamenController extends Controller
{
    public function index()
    {
        // Si la petición es API, devuelve JSON
        if (request()->is('api/*')) {
            $examenes = Examen::with(['paciente'])->get();
            return response()->json($examenes);
        }

        // Si la petición es web, devuelve la vista
        $examenes = Examen::with(['paciente'])->orderBy('id', 'desc')->get();
        return view('examenes.index', compact('examenes'));
    }

    public function create()
    {
        $pacientes = Paciente::orderBy('nombre')->get();
        return view('examenes.create', compact('pacientes'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'fecha' => 'required|date',
            'estadoexamen' => 'required|string',
            'comentariosexamen' => 'nullable|string',
            'rutapdf' => 'nullable|string',
            'ficha_medica_id' => 'nullable|integer',
            'tipo_examen_id' => 'nullable|integer',
            'sucursal_id' => 'nullable|integer',
            'paciente_id' => 'required|integer|exists:paciente,id',
        ]);
        
        Examen::create($validated);
        
        return redirect()->route('examenes.index')
            ->with('success', 'Examen creado exitosamente.');
    }

    public function show(Examen $examen)
    {
        return view('examenes.show', compact('examen'));
    }

    public function edit($id)
    {
        $examen = Examen::findOrFail($id);
        $pacientes = Paciente::orderBy('nombre')->get();
        return view('examenes.edit', compact('examen', 'pacientes'));
    }

    public function update(Request $request, $id)
    {
        $examen = Examen::findOrFail($id);
        
        $validated = $request->validate([
            'fecha' => 'required|date',
            'estadoexamen' => 'required|string',
            'comentariosexamen' => 'nullable|string',
            'rutapdf' => 'nullable|string',
            'ficha_medica_id' => 'nullable|integer',
            'tipo_examen_id' => 'nullable|integer',
            'sucursal_id' => 'nullable|integer',
            'paciente_id' => 'required|integer|exists:paciente,id',
        ]);
        
        $examen->update($validated);
        
        return redirect()->route('examenes.index')
            ->with('success', 'Examen actualizado exitosamente.');
    }

    public function destroy($id)
    {
        try {
            $examen = Examen::findOrFail($id);
            $examen->delete();
            
            return redirect()->route('examenes.index')
                ->with('success', 'Examen eliminado exitosamente.');
        } catch (\Exception $e) {
            return redirect()->route('examenes.index')
                ->with('error', 'Error al eliminar el examen: ' . $e->getMessage());
        }
    }
}