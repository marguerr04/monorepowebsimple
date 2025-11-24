@extends('layouts.app')

@section('page-title', 'Nuevo Examen')
@section('page-breadcrumb', 'Exámenes / Crear')

@section('content')
<div class="py-8">
    <div class="max-w-4xl mx-auto sm:px-6 lg:px-8">
        <!-- Header -->
        <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg mb-6">
            <div class="p-6 bg-white border-b border-gray-200">
                <div class="flex items-center justify-between">
                    <h2 class="font-semibold text-2xl text-gray-800 leading-tight flex items-center">
                        <svg class="w-8 h-8 mr-3 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                        </svg>
                        Nuevo Examen
                    </h2>
                    <a href="{{ route('examenes.index') }}" 
                       class="inline-flex items-center px-4 py-2 bg-gray-200 border border-transparent rounded-md font-semibold text-xs text-gray-700 uppercase tracking-widest hover:bg-gray-300 transition">
                        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
                        </svg>
                        Volver
                    </a>
                </div>
            </div>
        </div>

        <!-- Formulario -->
        <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
            <div class="p-6 bg-white border-b border-gray-200">
                <form method="POST" action="{{ route('examenes.store') }}" class="space-y-6">
                    @csrf

                    <!-- Paciente -->
                    <div>
                        <label for="paciente_id" class="block text-sm font-medium text-gray-700 mb-2">
                            Paciente <span class="text-red-500">*</span>
                        </label>
                        <select name="paciente_id" 
                                id="paciente_id"
                                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring focus:ring-blue-200 focus:ring-opacity-50 @error('paciente_id') border-red-500 @enderror"
                                required>
                            <option value="">Seleccione un paciente...</option>
                            @foreach($pacientes as $paciente)
                                <option value="{{ $paciente->id }}" {{ old('paciente_id') == $paciente->id ? 'selected' : '' }}>
                                    {{ $paciente->nombre }} - {{ $paciente->rut }}
                                </option>
                            @endforeach
                        </select>
                        @error('paciente_id')
                            <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                        @enderror
                    </div>

                    <!-- Fecha y Estado -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label for="fecha" class="block text-sm font-medium text-gray-700 mb-2">
                                Fecha del Examen <span class="text-red-500">*</span>
                            </label>
                            <input type="date" 
                                   name="fecha" 
                                   id="fecha" 
                                   value="{{ old('fecha', date('Y-m-d')) }}"
                                   class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring focus:ring-blue-200 focus:ring-opacity-50 @error('fecha') border-red-500 @enderror"
                                   required>
                            @error('fecha')
                                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                            @enderror
                        </div>

                        <div>
                            <label for="estadoexamen" class="block text-sm font-medium text-gray-700 mb-2">
                                Estado <span class="text-red-500">*</span>
                            </label>
                            <select name="estadoexamen" 
                                    id="estadoexamen"
                                    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring focus:ring-blue-200 focus:ring-opacity-50 @error('estadoexamen') border-red-500 @enderror"
                                    required>
                                <option value="">Seleccione...</option>
                                <option value="Pendiente" {{ old('estadoexamen') == 'Pendiente' ? 'selected' : '' }}>Pendiente</option>
                                <option value="En Proceso" {{ old('estadoexamen') == 'En Proceso' ? 'selected' : '' }}>En Proceso</option>
                                <option value="Completado" {{ old('estadoexamen') == 'Completado' ? 'selected' : '' }}>Completado</option>
                                <option value="Cancelado" {{ old('estadoexamen') == 'Cancelado' ? 'selected' : '' }}>Cancelado</option>
                            </select>
                            @error('estadoexamen')
                                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                            @enderror
                        </div>
                    </div>

                    <!-- IDs opcionales -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div>
                            <label for="tipo_examen_id" class="block text-sm font-medium text-gray-700 mb-2">
                                Tipo de Examen (ID)
                            </label>
                            <input type="number" 
                                   name="tipo_examen_id" 
                                   id="tipo_examen_id" 
                                   value="{{ old('tipo_examen_id') }}"
                                   placeholder="1, 2, 3..."
                                   class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring focus:ring-blue-200 focus:ring-opacity-50">
                        </div>

                        <div>
                            <label for="sucursal_id" class="block text-sm font-medium text-gray-700 mb-2">
                                Sucursal (ID)
                            </label>
                            <input type="number" 
                                   name="sucursal_id" 
                                   id="sucursal_id" 
                                   value="{{ old('sucursal_id') }}"
                                   placeholder="1, 2, 3..."
                                   class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring focus:ring-blue-200 focus:ring-opacity-50">
                        </div>

                        <div>
                            <label for="ficha_medica_id" class="block text-sm font-medium text-gray-700 mb-2">
                                Ficha Médica (ID)
                            </label>
                            <input type="number" 
                                   name="ficha_medica_id" 
                                   id="ficha_medica_id" 
                                   value="{{ old('ficha_medica_id') }}"
                                   placeholder="1, 2, 3..."
                                   class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring focus:ring-blue-200 focus:ring-opacity-50">
                        </div>
                    </div>

                    <!-- Comentarios -->
                    <div>
                        <label for="comentariosexamen" class="block text-sm font-medium text-gray-700 mb-2">
                            Comentarios del Examen
                        </label>
                        <textarea name="comentariosexamen" 
                                  id="comentariosexamen" 
                                  rows="4"
                                  placeholder="Escriba observaciones o comentarios sobre el examen..."
                                  class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring focus:ring-blue-200 focus:ring-opacity-50">{{ old('comentariosexamen') }}</textarea>
                    </div>

                    <!-- Ruta PDF -->
                    <div>
                        <label for="rutapdf" class="block text-sm font-medium text-gray-700 mb-2">
                            Ruta del PDF
                        </label>
                        <input type="text" 
                               name="rutapdf" 
                               id="rutapdf" 
                               value="{{ old('rutapdf') }}"
                               placeholder="/documentos/examenes/archivo.pdf"
                               class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring focus:ring-blue-200 focus:ring-opacity-50">
                    </div>

                    <!-- Botones -->
                    <div class="flex items-center justify-end space-x-4 pt-4 border-t border-gray-200">
                        <a href="{{ route('examenes.index') }}" 
                           class="inline-flex items-center px-4 py-2 bg-gray-200 border border-transparent rounded-md font-semibold text-xs text-gray-700 uppercase tracking-widest hover:bg-gray-300 transition">
                            Cancelar
                        </a>
                        <button type="submit" 
                                class="inline-flex items-center px-4 py-2 bg-blue-600 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-blue-700 active:bg-blue-900 focus:outline-none focus:border-blue-900 focus:ring ring-blue-300 disabled:opacity-25 transition">
                            <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                            </svg>
                            Guardar Examen
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
@endsection
