@extends('layouts.app')

@section('page-title', 'Consultas')
@section('page-breadcrumb', 'Inicio / Consultas')

@section('content')
<div class="py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Header -->
        <div class="flex justify-between items-center mb-6">
            <h2 class="text-3xl font-bold text-gray-900">
                <i class="fas fa-stethoscope text-purple-700 mr-2"></i>
                Gestión de Consultas
            </h2>
            <a href="{{ route('consultas.create') }}" 
               class="bg-gradient-to-r from-purple-600 to-purple-700 hover:from-purple-700 hover:to-purple-800 text-white font-semibold px-6 py-3 rounded-lg shadow-lg hover:shadow-xl transition-all duration-200">
                <i class="fas fa-plus mr-2"></i>Nueva Consulta
            </a>
        </div>

        <!-- Success Message -->
        @if(session('success'))
        <div class="mb-6 bg-emerald-50 border-l-4 border-emerald-500 p-4 rounded-lg shadow">
            <div class="flex items-center">
                <i class="fas fa-check-circle text-emerald-500 text-xl mr-3"></i>
                <p class="text-emerald-800 font-medium">{{ session('success') }}</p>
            </div>
        </div>
        @endif

        <!-- Search Bar -->
        <div class="bg-white rounded-lg shadow-md border-2 border-purple-600 p-4 mb-6">
            <form action="{{ route('consultas.index') }}" method="GET" class="flex gap-4">
                <div class="flex-1">
                    <input type="text" 
                           name="search" 
                           value="{{ request('search') }}"
                           placeholder="Buscar por nombre o RUT del paciente..."
                           class="w-full px-4 py-2 border-2 border-gray-300 rounded-lg focus:border-purple-500 focus:ring-2 focus:ring-purple-200 transition-all">
                </div>
                <button type="submit" 
                        class="bg-purple-600 hover:bg-purple-700 text-white px-6 py-2 rounded-lg font-semibold transition-colors">
                    <i class="fas fa-search mr-2"></i>Buscar
                </button>
                @if(request('search'))
                <a href="{{ route('consultas.index') }}" 
                   class="bg-gray-500 hover:bg-gray-600 text-white px-6 py-2 rounded-lg font-semibold transition-colors">
                    <i class="fas fa-times mr-2"></i>Limpiar
                </a>
                @endif
            </form>
        </div>

        <!-- Table -->
        <div class="bg-white rounded-lg shadow-md border-2 border-purple-600 overflow-hidden">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gradient-to-r from-purple-600 to-purple-700">
                    <tr>
                        <th class="px-6 py-4 text-left text-xs font-bold text-white uppercase tracking-wider">ID</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-white uppercase tracking-wider">Fecha</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-white uppercase tracking-wider">Paciente</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-white uppercase tracking-wider">Motivo</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-white uppercase tracking-wider">Peso</th>
                        <th class="px-6 py-4 text-left text-xs font-bold text-white uppercase tracking-wider">Altura</th>
                        <th class="px-6 py-4 text-center text-xs font-bold text-white uppercase tracking-wider">Acciones</th>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                    @forelse($consultas as $consulta)
                    <tr class="hover:bg-purple-50 transition-colors">
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                            #{{ $consulta->id }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                            <i class="fas fa-calendar text-purple-600 mr-2"></i>
                            {{ $consulta->fecha->format('d/m/Y') }}
                        </td>
                        <td class="px-6 py-4 text-sm text-gray-700">
                            <i class="fas fa-user text-purple-600 mr-2"></i>
                            {{ $consulta->paciente->nombre ?? 'N/A' }}
                        </td>
                        <td class="px-6 py-4 text-sm text-gray-700">
                            {{ Str::limit($consulta->motivo_consulta, 50) }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                            {{ $consulta->pesopaciente ? $consulta->pesopaciente . ' kg' : '-' }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                            {{ $consulta->alturapaciente ? $consulta->alturapaciente . ' m' : '-' }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-center text-sm font-medium">
                            <div class="flex justify-center space-x-2">
                                <a href="{{ route('consultas.show', $consulta->id) }}" 
                                   class="text-blue-600 hover:text-blue-900 transition-colors" 
                                   title="Ver">
                                    <i class="fas fa-eye text-lg"></i>
                                </a>
                                <a href="{{ route('consultas.edit', $consulta->id) }}" 
                                   class="text-yellow-600 hover:text-yellow-900 transition-colors" 
                                   title="Editar">
                                    <i class="fas fa-edit text-lg"></i>
                                </a>
                                <form action="{{ route('consultas.destroy', $consulta->id) }}" 
                                      method="POST" 
                                      class="inline"
                                      class="delete-form">
                                    @csrf
                                    @method('DELETE')
                                    <button type="button" 
                                            class="text-red-600 hover:text-red-900 transition-colors delete-btn" 
                                            title="Eliminar"
                                            data-nombre="Consulta #{{ $consulta->id }}">
                                        <i class="fas fa-trash text-lg"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="7" class="px-6 py-12 text-center">
                            <i class="fas fa-inbox text-gray-300 text-5xl mb-4"></i>
                            <p class="text-gray-500 text-lg">No hay consultas registradas</p>
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="mt-6">
            {{ $consultas->links() }}
        </div>
    </div>
</div>
@endsection

@section('scripts')
<script>
    // SweetAlert2 para confirmación de eliminación
    document.querySelectorAll('.delete-btn').forEach(button => {
        button.addEventListener('click', function(e) {
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
    });
</script>
@endsection
