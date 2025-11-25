@extends('layouts.app')

@section('page-title', 'Editar Consulta')
@section('page-breadcrumb', 'Inicio / Consultas / Editar')

@section('content')
<div class="py-8">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="bg-white rounded-lg shadow-md border-2 border-purple-600 p-8">
            <h2 class="text-2xl font-bold text-gray-900 mb-6">
                <i class="fas fa-edit text-purple-700 mr-2"></i>
                Editar Consulta #{{ $consulta->id }}
            </h2>

            <form action="{{ route('consultas.update', $consulta->id) }}" method="POST">
                @csrf
                @method('PUT')

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Fecha -->
                    <div>
                        <label for="fecha" class="block text-sm font-semibold text-gray-700 mb-2">
                            <i class="fas fa-calendar text-purple-600 mr-2"></i>Fecha *
                        </label>
                        <input type="date" 
                               id="fecha" 
                               name="fecha" 
                               value="{{ old('fecha', $consulta->fecha->format('Y-m-d')) }}"
                               required
                               class="w-full px-4 py-2 border-2 border-gray-300 rounded-lg focus:border-purple-500 focus:ring-2 focus:ring-purple-200 transition-all @error('fecha') border-red-500 @enderror">
                        @error('fecha')
                            <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                        @enderror
                    </div>

                    <!-- Paciente -->
                    <div>
                        <label for="paciente_id" class="block text-sm font-semibold text-gray-700 mb-2">
                            <i class="fas fa-user text-purple-600 mr-2"></i>Paciente *
                        </label>
                        <select id="paciente_id" 
                                name="paciente_id" 
                                required
                                class="w-full px-4 py-2 border-2 border-gray-300 rounded-lg focus:border-purple-500 focus:ring-2 focus:ring-purple-200 transition-all @error('paciente_id') border-red-500 @enderror">
                            @foreach($pacientes as $paciente)
                                <option value="{{ $paciente->id }}" {{ old('paciente_id', $consulta->paciente_id) == $paciente->id ? 'selected' : '' }}>
                                    {{ $paciente->nombre }} ({{ $paciente->rut }}-{{ $paciente->dv }})
                                </option>
                            @endforeach
                        </select>
                        @error('paciente_id')
                            <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                        @enderror
                    </div>

                    <!-- Peso -->
                    <div>
                        <label for="pesopaciente" class="block text-sm font-semibold text-gray-700 mb-2">
                            <i class="fas fa-weight text-purple-600 mr-2"></i>Peso (kg)
                        </label>
                        <input type="number" 
                               step="0.01" 
                               id="pesopaciente" 
                               name="pesopaciente" 
                               value="{{ old('pesopaciente', $consulta->pesopaciente) }}"
                               placeholder="70.5"
                               class="w-full px-4 py-2 border-2 border-gray-300 rounded-lg focus:border-purple-500 focus:ring-2 focus:ring-purple-200 transition-all @error('pesopaciente') border-red-500 @enderror">
                        @error('pesopaciente')
                            <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                        @enderror
                    </div>

                    <!-- Altura -->
                    <div>
                        <label for="alturapaciente" class="block text-sm font-semibold text-gray-700 mb-2">
                            <i class="fas fa-ruler-vertical text-purple-600 mr-2"></i>Altura (m)
                        </label>
                        <input type="number" 
                               step="0.01" 
                               id="alturapaciente" 
                               name="alturapaciente" 
                               value="{{ old('alturapaciente', $consulta->alturapaciente) }}"
                               placeholder="1.75"
                               class="w-full px-4 py-2 border-2 border-gray-300 rounded-lg focus:border-purple-500 focus:ring-2 focus:ring-purple-200 transition-all @error('alturapaciente') border-red-500 @enderror">
                        @error('alturapaciente')
                            <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                        @enderror
                    </div>
                </div>

                <!-- Motivo de Consulta -->
                <div class="mt-6">
                    <label for="motivo_consulta" class="block text-sm font-semibold text-gray-700 mb-2">
                        <i class="fas fa-notes-medical text-purple-600 mr-2"></i>Motivo de Consulta *
                    </label>
                    <textarea id="motivo_consulta" 
                              name="motivo_consulta" 
                              rows="4" 
                              required
                              placeholder="Describa el motivo de la consulta..."
                              class="w-full px-4 py-2 border-2 border-gray-300 rounded-lg focus:border-purple-500 focus:ring-2 focus:ring-purple-200 transition-all @error('motivo_consulta') border-red-500 @enderror">{{ old('motivo_consulta', $consulta->motivo_consulta) }}</textarea>
                    @error('motivo_consulta')
                        <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                    @enderror
                </div>

                <!-- Buttons -->
                <div class="flex justify-end space-x-4 mt-8">
                    <a href="{{ route('consultas.index') }}" 
                       class="px-6 py-3 border-2 border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-100 transition-colors">
                        <i class="fas fa-times mr-2"></i>Cancelar
                    </a>
                    <button type="submit" 
                            class="bg-gradient-to-r from-purple-600 to-purple-700 hover:from-purple-700 hover:to-purple-800 text-white font-semibold px-6 py-3 rounded-lg shadow-lg hover:shadow-xl transition-all duration-200">
                        <i class="fas fa-save mr-2"></i>Actualizar Consulta
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
@endsection
