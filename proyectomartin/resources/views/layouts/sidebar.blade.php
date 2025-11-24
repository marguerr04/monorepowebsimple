<!-- Sidebar -->
<aside x-data="{ collapsed: false }" 
       :class="collapsed ? 'w-20' : 'w-64'" 
       class="bg-gradient-to-b from-emerald-800 to-emerald-900 text-white transition-all duration-300 flex-shrink-0 overflow-hidden">
    
    <!-- Logo y Toggle -->
    <div class="flex items-center justify-between p-4 border-b border-emerald-700">
        <div x-show="!collapsed" class="flex items-center space-x-3">
            <div class="w-10 h-10 bg-white rounded-lg flex items-center justify-center">
                <i class="fas fa-hospital text-emerald-800 text-xl"></i>
            </div>
            <div x-cloak>
                <h2 class="text-lg font-bold">Sistema Médico</h2>
                <p class="text-xs text-emerald-200">v1.0</p>
            </div>
        </div>
        <div x-show="collapsed" class="w-full flex justify-center">
            <div class="w-10 h-10 bg-white rounded-lg flex items-center justify-center">
                <i class="fas fa-hospital text-emerald-800 text-xl"></i>
            </div>
        </div>
    </div>

    <!-- Navigation -->
    <nav class="flex-1 px-3 py-6 space-y-2 overflow-y-auto">
        <!-- Dashboard -->
        <a href="{{ route('dashboard') }}" 
           class="flex items-center px-4 py-3 rounded-lg transition-all duration-200 group {{ request()->routeIs('dashboard') ? 'bg-emerald-700 shadow-lg' : 'hover:bg-emerald-700/50' }}">
            <i class="fas fa-chart-line text-xl {{ request()->routeIs('dashboard') ? 'text-white' : 'text-emerald-200' }} group-hover:text-white transition-colors"></i>
            <span x-show="!collapsed" 
                  x-cloak
                  class="ml-4 font-medium {{ request()->routeIs('dashboard') ? 'text-white' : 'text-emerald-100' }} group-hover:text-white">
                Dashboard
            </span>
            <span x-show="collapsed" 
                  class="absolute left-20 ml-2 px-3 py-1 bg-gray-900 text-white text-sm rounded-md opacity-0 pointer-events-none group-hover:opacity-100 transition-opacity whitespace-nowrap z-50">
                Dashboard
            </span>
        </a>

        <!-- Pacientes -->
        <a href="{{ route('pacientes.index') }}" 
           class="flex items-center px-4 py-3 rounded-lg transition-all duration-200 group {{ request()->routeIs('pacientes.*') ? 'bg-emerald-700 shadow-lg' : 'hover:bg-emerald-700/50' }}">
            <i class="fas fa-user-injured text-xl {{ request()->routeIs('pacientes.*') ? 'text-white' : 'text-emerald-200' }} group-hover:text-white transition-colors"></i>
            <span x-show="!collapsed" 
                  x-cloak
                  class="ml-4 font-medium {{ request()->routeIs('pacientes.*') ? 'text-white' : 'text-emerald-100' }} group-hover:text-white">
                Pacientes
            </span>
            <span x-show="collapsed" 
                  class="absolute left-20 ml-2 px-3 py-1 bg-gray-900 text-white text-sm rounded-md opacity-0 pointer-events-none group-hover:opacity-100 transition-opacity whitespace-nowrap z-50">
                Pacientes
            </span>
        </a>

        <!-- Exámenes -->
        <a href="{{ route('examenes.index') }}" 
           class="flex items-center px-4 py-3 rounded-lg transition-all duration-200 group {{ request()->routeIs('examenes.*') ? 'bg-emerald-700 shadow-lg' : 'hover:bg-emerald-700/50' }}">
            <i class="fas fa-microscope text-xl {{ request()->routeIs('examenes.*') ? 'text-white' : 'text-emerald-200' }} group-hover:text-white transition-colors"></i>
            <span x-show="!collapsed" 
                  x-cloak
                  class="ml-4 font-medium {{ request()->routeIs('examenes.*') ? 'text-white' : 'text-emerald-100' }} group-hover:text-white">
                Exámenes
            </span>
            <span x-show="collapsed" 
                  class="absolute left-20 ml-2 px-3 py-1 bg-gray-900 text-white text-sm rounded-md opacity-0 pointer-events-none group-hover:opacity-100 transition-opacity whitespace-nowrap z-50">
                Exámenes
            </span>
        </a>

        <!-- Consultas (si existe la ruta) -->
        @if(Route::has('consultas.index'))
        <a href="{{ route('consultas.index') }}" 
           class="flex items-center px-4 py-3 rounded-lg transition-all duration-200 group {{ request()->routeIs('consultas.*') ? 'bg-emerald-700 shadow-lg' : 'hover:bg-emerald-700/50' }}">
            <i class="fas fa-stethoscope text-xl {{ request()->routeIs('consultas.*') ? 'text-white' : 'text-emerald-200' }} group-hover:text-white transition-colors"></i>
            <span x-show="!collapsed" 
                  x-cloak
                  class="ml-4 font-medium {{ request()->routeIs('consultas.*') ? 'text-white' : 'text-emerald-100' }} group-hover:text-white">
                Consultas
            </span>
            <span x-show="collapsed" 
                  class="absolute left-20 ml-2 px-3 py-1 bg-gray-900 text-white text-sm rounded-md opacity-0 pointer-events-none group-hover:opacity-100 transition-opacity whitespace-nowrap z-50">
                Consultas
            </span>
        </a>
        @endif

        <!-- Fichas Médicas (si existe la ruta) -->
        @if(Route::has('fichas-medicas.index'))
        <a href="{{ route('fichas-medicas.index') }}" 
           class="flex items-center px-4 py-3 rounded-lg transition-all duration-200 group {{ request()->routeIs('fichas-medicas.*') ? 'bg-emerald-700 shadow-lg' : 'hover:bg-emerald-700/50' }}">
            <i class="fas fa-folder-open text-xl {{ request()->routeIs('fichas-medicas.*') ? 'text-white' : 'text-emerald-200' }} group-hover:text-white transition-colors"></i>
            <span x-show="!collapsed" 
                  x-cloak
                  class="ml-4 font-medium {{ request()->routeIs('fichas-medicas.*') ? 'text-white' : 'text-emerald-100' }} group-hover:text-white">
                Fichas Médicas
            </span>
            <span x-show="collapsed" 
                  class="absolute left-20 ml-2 px-3 py-1 bg-gray-900 text-white text-sm rounded-md opacity-0 pointer-events-none group-hover:opacity-100 transition-opacity whitespace-nowrap z-50">
                Fichas Médicas
            </span>
        </a>
        @endif

        <!-- Divider -->
        <div class="pt-4 pb-2">
            <div class="border-t border-emerald-700"></div>
        </div>

        <!-- Reportes -->
        <a href="#" 
           class="flex items-center px-4 py-3 rounded-lg transition-all duration-200 group hover:bg-emerald-700/50">
            <i class="fas fa-chart-bar text-xl text-emerald-200 group-hover:text-white transition-colors"></i>
            <span x-show="!collapsed" 
                  x-cloak
                  class="ml-4 font-medium text-emerald-100 group-hover:text-white">
                Reportes
            </span>
            <span x-show="collapsed" 
                  class="absolute left-20 ml-2 px-3 py-1 bg-gray-900 text-white text-sm rounded-md opacity-0 pointer-events-none group-hover:opacity-100 transition-opacity whitespace-nowrap z-50">
                Reportes
            </span>
        </a>

        <!-- Configuración -->
        <a href="#" 
           class="flex items-center px-4 py-3 rounded-lg transition-all duration-200 group hover:bg-emerald-700/50">
            <i class="fas fa-cog text-xl text-emerald-200 group-hover:text-white transition-colors"></i>
            <span x-show="!collapsed" 
                  x-cloak
                  class="ml-4 font-medium text-emerald-100 group-hover:text-white">
                Configuración
            </span>
            <span x-show="collapsed" 
                  class="absolute left-20 ml-2 px-3 py-1 bg-gray-900 text-white text-sm rounded-md opacity-0 pointer-events-none group-hover:opacity-100 transition-opacity whitespace-nowrap z-50">
                Configuración
            </span>
        </a>
    </nav>

    <!-- User Info & Logout -->
    <div class="border-t border-emerald-700 p-4">
        <div class="flex items-center space-x-3">
            <div class="w-10 h-10 bg-emerald-600 rounded-full flex items-center justify-center flex-shrink-0">
                <i class="fas fa-user text-white"></i>
            </div>
            <div x-show="!collapsed" x-cloak class="flex-1 min-w-0">
                <p class="text-sm font-medium text-white truncate">{{ Auth::user()->name ?? 'Usuario' }}</p>
                <form method="POST" action="{{ route('logout') }}" class="inline">
                    @csrf
                    <button type="submit" class="text-xs text-emerald-200 hover:text-white transition-colors">
                        <i class="fas fa-sign-out-alt mr-1"></i>Cerrar sesión
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Toggle Button (Fixed at bottom) -->
    <div class="absolute bottom-0 right-0 transform translate-x-1/2 mb-20">
        <button @click="collapsed = !collapsed" 
                class="w-8 h-8 bg-white rounded-full shadow-lg flex items-center justify-center text-emerald-800 hover:bg-emerald-50 transition-colors">
            <i :class="collapsed ? 'fa-chevron-right' : 'fa-chevron-left'" class="fas text-sm"></i>
        </button>
    </div>
</aside>
