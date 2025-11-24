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

            <!-- Alertas Críticas -->
            <div class="bg-white rounded-lg shadow-md border-2 border-red-600 p-6 hover:shadow-xl transition-shadow">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">Alertas Críticas</p>
                        <h4 class="text-3xl font-bold text-gray-900 mt-2">50</h4>
                        <p class="text-sm text-red-600 mt-2">
                            <i class="fas fa-arrow-down mr-1"></i>
                            <span class="font-semibold">-2.3%</span> pendientes
                        </p>
                    </div>
                    <div class="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center">
                        <i class="fas fa-exclamation-triangle text-red-700 text-2xl"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Gráficos -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <div class="bg-white rounded-lg shadow-md border-2 border-emerald-600 p-6">
                <h6 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                    <i class="fas fa-chart-pie text-emerald-700 mr-3"></i>
                    Consultas y Diagnósticos por Tipo
                </h6>
                <div class="flex items-center justify-center h-64 bg-gray-50 rounded-lg">
                    <p class="text-gray-500">
                        <i class="fas fa-chart-bar text-4xl mb-3 block text-center"></i>
                        Gráfico de estadísticas
                    </p>
                </div>
            </div>
            
            <div class="bg-white rounded-lg shadow-md border-2 border-emerald-600 p-6">
                <h6 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                    <i class="fas fa-chart-line text-emerald-700 mr-3"></i>
                    Consultas y Diagnósticos por Patología
                </h6>
                <div class="flex items-center justify-center h-64 bg-gray-50 rounded-lg">
                    <p class="text-gray-500">
                        <i class="fas fa-chart-area text-4xl mb-3 block text-center"></i>
                        Gráfico de patologías
                    </p>
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
            
            <a href="#" class="bg-white rounded-lg shadow-md border-2 border-orange-600 p-4 hover:bg-orange-50 transition-colors">
                <div class="flex items-center">
                    <i class="fas fa-chart-bar text-orange-700 text-2xl mr-3"></i>
                    <div>
                        <p class="text-sm text-gray-600">Ver todos</p>
                        <p class="text-lg font-semibold text-gray-900">Reportes</p>
                    </div>
                </div>
            </a>
        </div>
    </div>
</div>
@endsection
