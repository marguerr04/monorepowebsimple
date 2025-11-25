<?php

namespace App\Http\Controllers;

use App\Models\Paciente;
use Illuminate\Http\Request;

class PacienteController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Paciente::query();
        
        // Búsqueda
        if ($request->has('search') && $request->search != '') {
            $search = $request->search;
            $query->where(function($q) use ($search) {
                $q->where('nombre', 'LIKE', "%{$search}%")
                  ->orWhere('rut', 'LIKE', "%{$search}%")
                  ->orWhere('correo', 'LIKE', "%{$search}%");
            });
        }
        
        $pacientes = $query->orderBy('id', 'desc')->paginate(10);
        
        return view('pacientes.index', compact('pacientes'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('pacientes.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'rut' => 'required|integer|unique:paciente,rut',
            'dv' => 'required|integer|min:0|max:9',
            'nombre' => 'required|string|max:255',
            'sexo' => 'required|string|max:50',
            'fechanac' => 'required|date',
            'telefono' => 'nullable|string|max:20',
            'correo' => 'required|email|max:255|unique:paciente,correo',
            'direccion' => 'nullable|string|max:500',
            'tipo_sangre_id' => 'nullable|integer|exists:tipo_sangre,id',
            'clave' => 'required|string|min:6',
            'telefono_emergencia' => 'nullable|string|max:20',
        ]);

        // Asignar valores por defecto
        if (empty($validated['tipo_sangre_id'])) {
            $validated['tipo_sangre_id'] = 1;
        }
        
        // Asignar centro_medico_id por defecto si no existe
        if (!isset($validated['centro_medico_id'])) {
            $validated['centro_medico_id'] = 1;
        }

        Paciente::create($validated);

        return redirect()->route('pacientes.index')
            ->with('success', 'Paciente creado exitosamente.');
    }

    /**
     * Display the specified resource.
     */
    public function show(Paciente $paciente)
    {
        return view('pacientes.show', compact('paciente'));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Paciente $paciente)
    {
        return view('pacientes.edit', compact('paciente'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Paciente $paciente)
    {
        $validated = $request->validate([
            'rut' => 'required|integer|unique:paciente,rut,' . $paciente->id,
            'dv' => 'required|integer|min:0|max:9',
            'nombre' => 'required|string|max:255',
            'sexo' => 'required|string|max:50',
            'fechanac' => 'required|date',
            'telefono' => 'nullable|string|max:20',
            'correo' => 'required|email|max:255|unique:paciente,correo,' . $paciente->id,
            'direccion' => 'nullable|string|max:500',
            'tipo_sangre_id' => 'nullable|integer|exists:tipo_sangre,id',
            'telefono_emergencia' => 'nullable|string|max:20',
        ]);

        // Si se proporciona una nueva clave, actualízala
        if ($request->filled('clave')) {
            $validated['clave'] = $request->clave;
        }

        $paciente->update($validated);

        return redirect()->route('pacientes.index')
            ->with('success', 'Paciente actualizado exitosamente.');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Paciente $paciente)
    {
        try {
            // Eliminar registros relacionados en cascada
            \DB::transaction(function () use ($paciente) {
                // Eliminar exámenes del paciente
                \DB::table('examen')->where('paciente_id', $paciente->id)->delete();
                
                // Eliminar consultas del paciente (vía ficha_medica)
                $fichasMedicas = \DB::table('ficha_medica')->where('paciente_id', $paciente->id)->pluck('id');
                if ($fichasMedicas->isNotEmpty()) {
                    \DB::table('consulta')->whereIn('ficha_medica_id', $fichasMedicas)->delete();
                    \DB::table('ficha_medica')->where('paciente_id', $paciente->id)->delete();
                }
                
                // Finalmente eliminar el paciente
                $paciente->delete();
            });
            
            return redirect()->route('pacientes.index')
                ->with('success', 'Paciente y sus registros asociados eliminados exitosamente.');
        } catch (\Exception $e) {
            return redirect()->route('pacientes.index')
                ->with('error', 'Error al eliminar el paciente: ' . $e->getMessage());
        }
    }
}
