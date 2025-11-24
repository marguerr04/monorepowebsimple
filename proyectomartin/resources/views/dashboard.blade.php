@extends('layouts.app')

@section('page-title', 'Dashboard')
@section('page-breadcrumb', 'Inicio')

@section('content')
<div class="py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <h3 class="text-2xl font-bold text-gray-800 mb-6">Panel de Control</h3>
        <!-- Tarjetas de Estadísticas -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <!-- Total Pacientes -->
            <div class="bg-white rounded-lg shadow-md border-2 border-emerald-600 p-6 hover:shadow-xl transition-shadow">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">Total de Pacientes</p>
                        <h4 class="text-3xl font-bold text-gray-900 mt-2">7,495</h4>
                        <p class="text-sm text-emerald-600 mt-2">
                            <i class="fas fa-arrow-up mr-1"></i>
                            <span class="font-semibold">+50%</span> vs mes anterior
                        </p>
                    </div>
                    <div class="w-16 h-16 bg-emerald-100 rounded-full flex items-center justify-center">
                        <i class="fas fa-user-injured text-emerald-700 text-2xl"></i>
                    </div>
                </div>
            </div>

            <!-- Consultas Diarias -->
            <div class="bg-white rounded-lg shadow-md border-2 border-blue-600 p-6 hover:shadow-xl transition-shadow">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">Consultas Diarias</p>
                        <h4 class="text-3xl font-bold text-gray-900 mt-2">45</h4>
                        <p class="text-sm text-blue-600 mt-2">
                            <i class="fas fa-arrow-up mr-1"></i>
                            <span class="font-semibold">+2.3%</span> promedio
                        </p>
                    </div>
                    <div class="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center">
                        <i class="fas fa-stethoscope text-blue-700 text-2xl"></i>
                    </div>
                </div>
            </div>

            
        </div>


        <!-- Enlaces Rápidos -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mt-8">
            <a href="{{ route('pacientes.index') }}" class="bg-white rounded-lg shadow-md border-2 border-emerald-600 p-4 hover:bg-emerald-50 transition-colors">
                <div class="flex items-center">
                    <i class="fas fa-users text-emerald-700 text-2xl mr-3"></i>
                    <div>
                        <p class="text-sm text-gray-600">Ver todos</p>
                        <p class="text-lg font-semibold text-gray-900">Pacientes</p>
                    </div>
                </div>
            </a>
            
            <a href="{{ route('examenes.index') }}" class="bg-white rounded-lg shadow-md border-2 border-blue-600 p-4 hover:bg-blue-50 transition-colors">
                <div class="flex items-center">
                    <i class="fas fa-microscope text-blue-700 text-2xl mr-3"></i>
                    <div>
                        <p class="text-sm text-gray-600">Ver todos</p>
                        <p class="text-lg font-semibold text-gray-900">Exámenes</p>
                    </div>
                </div>
            </a>
            
            <a href="#" class="bg-white rounded-lg shadow-md border-2 border-purple-600 p-4 hover:bg-purple-50 transition-colors">
                <div class="flex items-center">
                    <i class="fas fa-stethoscope text-purple-700 text-2xl mr-3"></i>
                    <div>
                        <p class="text-sm text-gray-600">Ver todas</p>
                        <p class="text-lg font-semibold text-gray-900">Consultas</p>
                    </div>
                </div>
            </a>
            
    
        </div>
    </div>
</div>
@endsection
