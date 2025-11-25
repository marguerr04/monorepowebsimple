@extends('layouts.app')

@section('page-title', 'Detalle de Consulta')
@section('page-breadcrumb', 'Inicio / Consultas / Detalle')

@section('content')
<div class="py-8">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="bg-white rounded-lg shadow-md border-2 border-purple-600 p-8">
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-2xl font-bold text-gray-900">
                    <i class="fas fa-stethoscope text-purple-700 mr-2"></i>
                    Consulta #{{ $consulta->id }}
                </h2>
                <div class="space-x-2">
                    <a href="{{ route('consultas.edit', $consulta->id) }}" 
                       class="bg-yellow-500 hover:bg-yellow-600 text-white px-4 py-2 rounded-lg transition-colors">
                        <i class="fas fa-edit mr-2"></i>Editar
                    </a>
                    <a href="{{ route('consultas.index') }}" 
                       class="bg-gray-500 hover:bg-gray-600 text-white px-4 py-2 rounded-lg transition-colors">
                        <i class="fas fa-arrow-left mr-2"></i>Volver
                    </a>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Fecha -->
                <div class="bg-purple-50 p-4 rounded-lg border border-purple-200">
                    <p class="text-sm text-gray-600 mb-1">
                        <i class="fas fa-calendar text-purple-600 mr-2"></i>Fecha
                    </p>
                    <p class="text-lg font-semibold text-gray-900">
                        {{ $consulta->fecha->format('d/m/Y') }}
                    </p>
                </div>

                <!-- Paciente -->
                <div class="bg-purple-50 p-4 rounded-lg border border-purple-200">
                    <p class="text-sm text-gray-600 mb-1">
                        <i class="fas fa-user text-purple-600 mr-2"></i>Paciente
                    </p>
                    <p class="text-lg font-semibold text-gray-900">
                        {{ $consulta->paciente->nombre ?? 'N/A' }}
                    </p>
                    @if($consulta->paciente)
                    <p class="text-sm text-gray-600">
                        RUT: {{ $consulta->paciente->rut }}-{{ $consulta->paciente->dv }}
                    </p>
                    @endif
                </div>

                <!-- Peso -->
                <div class="bg-purple-50 p-4 rounded-lg border border-purple-200">
                    <p class="text-sm text-gray-600 mb-1">
                        <i class="fas fa-weight text-purple-600 mr-2"></i>Peso
                    </p>
                    <p class="text-lg font-semibold text-gray-900">
                        {{ $consulta->pesopaciente ? $consulta->pesopaciente . ' kg' : 'No registrado' }}
                    </p>
                </div>

                <!-- Altura -->
                <div class="bg-purple-50 p-4 rounded-lg border border-purple-200">
                    <p class="text-sm text-gray-600 mb-1">
                        <i class="fas fa-ruler-vertical text-purple-600 mr-2"></i>Altura
                    </p>
                    <p class="text-lg font-semibold text-gray-900">
                        {{ $consulta->alturapaciente ? $consulta->alturapaciente . ' m' : 'No registrado' }}
                    </p>
                </div>
            </div>

            <!-- Motivo de Consulta -->
            <div class="mt-6 bg-purple-50 p-4 rounded-lg border border-purple-200">
                <p class="text-sm text-gray-600 mb-2">
                    <i class="fas fa-notes-medical text-purple-600 mr-2"></i>Motivo de Consulta
                </p>
                <p class="text-gray-900 whitespace-pre-wrap">
                    {{ $consulta->motivo_consulta }}
                </p>
            </div>

            <!-- Delete Button -->
            <div class="mt-8 pt-6 border-t border-gray-200">
                <form action="{{ route('consultas.destroy', $consulta->id) }}" 
                      method="POST" 
                      class="delete-form">
                    @csrf
                    @method('DELETE')
                    <button type="button" 
                            class="bg-red-600 hover:bg-red-700 text-white px-6 py-3 rounded-lg font-semibold transition-colors delete-btn"
                            data-nombre="Consulta #{{ $consulta->id }}">
                        <i class="fas fa-trash mr-2"></i>Eliminar Consulta
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>
@endsection

@section('scripts')
<script>
    // SweetAlert2 para confirmación de eliminación
    document.querySelector('.delete-btn').addEventListener('click', function(e) {
        e.preventDefault();
        const form = this.closest('.delete-form');
        const nombre = this.dataset.nombre;
        
        Swal.fire({
            title: '¿Estás seguro?',
            html: `Se eliminará <strong>${nombre}</strong>.<br><br>Esta acción no se puede deshacer.`,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc2626',
            cancelButtonColor: '#6b7280',
            confirmButtonText: 'Sí, eliminar',
            cancelButtonText: 'Cancelar',
            reverseButtons: true
        }).then((result) => {
            if (result.isConfirmed) {
                form.submit();
            }
        });
    });
</script>
@endsection
