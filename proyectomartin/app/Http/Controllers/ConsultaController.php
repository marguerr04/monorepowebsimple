<?php

namespace App\Http\Controllers;

use App\Models\Consulta;
use App\Models\Paciente;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ConsultaController extends Controller
{
    public function index(Request $request)
    {
        $query = Consulta::with('paciente');

        if ($request->has('search')) {
            $search = $request->search;
            $query->whereHas('paciente', function($q) use ($search) {
                $q->where('nombre', 'ilike', "%{$search}%")
                  ->orWhere('rut', 'like', "%{$search}%");
            });
        }

        $consultas = $query->orderBy('fecha', 'desc')->paginate(15);

        return view('consultas.index', compact('consultas'));
    }

    public function create()
    {
        $pacientes = Paciente::orderBy('nombre')->get();
        return view('consultas.create', compact('pacientes'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'fecha' => 'required|date',
            'paciente_id' => 'required|integer|exists:paciente,id',
            'motivo_consulta' => 'required|string',
            'pesopaciente' => 'nullable|numeric',
            'alturapaciente' => 'nullable|numeric',
        ]);

        // Obtener ficha_medica_id buscando por paciente_id
        $fichaMedica = DB::table('ficha_medica')->where('paciente_id', $validated['paciente_id'])->first();
        if ($fichaMedica) {
            $validated['ficha_medica_id'] = $fichaMedica->id;
        } else {
            // Si no existe, crear una ficha médica nueva
            $fichaId = DB::table('ficha_medica')->insertGetId(['paciente_id' => $validated['paciente_id']]);
            $validated['ficha_medica_id'] = $fichaId;
        }
        $validated['medico_id'] = 1;
        $validated['tipo_consult_id'] = 1;

        Consulta::create($validated);

        return redirect()->route('consultas.index')
            ->with('success', 'Consulta creada exitosamente.');
    }

    public function show($id)
    {
        $consulta = Consulta::with('paciente')->findOrFail($id);
        return view('consultas.show', compact('consulta'));
    }

    public function edit($id)
    {
        $consulta = Consulta::findOrFail($id);
        $pacientes = Paciente::orderBy('nombre')->get();
        return view('consultas.edit', compact('consulta', 'pacientes'));
    }

    public function update(Request $request, $id)
    {
        $consulta = Consulta::findOrFail($id);
        
        $validated = $request->validate([
            'fecha' => 'required|date',
            'paciente_id' => 'required|integer|exists:paciente,id',
            'motivo_consulta' => 'required|string',
            'pesopaciente' => 'nullable|numeric',
            'alturapaciente' => 'nullable|numeric',
            'medico_id' => 'nullable|integer',
            'tipo_consult_id' => 'nullable|integer',
        ]);
        
        // Obtener ficha_medica_id buscando por paciente_id
        $fichaMedica = DB::table('ficha_medica')->where('paciente_id', $validated['paciente_id'])->first();
        if ($fichaMedica) {
            $validated['ficha_medica_id'] = $fichaMedica->id;
        } else {
            // Si no existe, crear una ficha médica nueva
            $fichaId = DB::table('ficha_medica')->insertGetId(['paciente_id' => $validated['paciente_id']]);
            $validated['ficha_medica_id'] = $fichaId;
        }
        
        $consulta->update($validated);
        
        return redirect()->route('consultas.index')
            ->with('success', 'Consulta actualizada exitosamente.');
    }

    public function destroy($id)
    {
        $consulta = Consulta::findOrFail($id);
        
        DB::beginTransaction();
        try {
            // Eliminar recetas asociadas
            DB::table('receta')->where('consulta_id', $id)->delete();
            
            // Eliminar la consulta
            $consulta->delete();
            
            DB::commit();
            
            return redirect()->route('consultas.index')
                ->with('success', 'Consulta eliminada exitosamente.');
        } catch (\Exception $e) {
            DB::rollBack();
            return redirect()->route('consultas.index')
                ->with('error', 'Error al eliminar la consulta: ' . $e->getMessage());
        }
    }
}
