<!-- Top Navigation Bar -->
<header class="bg-white shadow-sm border-b-2 border-emerald-600">
    <div class="flex items-center justify-between px-6 py-4">
        <!-- Page Title / Breadcrumbs -->
        <div>
            <h1 class="text-2xl font-bold text-gray-800">
                @yield('page-title', 'Dashboard')
            </h1>
            <div class="flex items-center space-x-2 text-sm text-gray-500 mt-1">
                <i class="fas fa-home"></i>
                <span>/</span>
                <span class="text-emerald-700 font-medium">@yield('page-breadcrumb', 'Inicio')</span>
            </div>
        </div>

        <!-- Right Side - Quick Actions & User -->
        <div class="flex items-center space-x-4">
            <!-- Search Bar (Optional) -->
            <div class="relative hidden md:block">
                <input type="text" 
                       placeholder="Buscar..." 
                       class="w-64 pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent text-sm">
                <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
            </div>

            <!-- Notifications -->
            <button class="relative p-2 text-gray-600 hover:text-emerald-700 transition-colors">
                <i class="fas fa-bell text-xl"></i>
                <span class="absolute top-0 right-0 w-2 h-2 bg-red-500 rounded-full"></span>
            </button>

            <!-- User Dropdown -->
            <div x-data="{ open: false }" class="relative">
                <button @click="open = !open" 
                        class="flex items-center space-x-3 px-3 py-2 rounded-lg hover:bg-gray-100 transition-colors">
                    <div class="w-8 h-8 bg-gradient-to-br from-emerald-600 to-emerald-800 rounded-full flex items-center justify-center">
                        <span class="text-white font-semibold text-sm">{{ substr(Auth::user()->name ?? 'U', 0, 1) }}</span>
                    </div>
                    <div class="text-left hidden sm:block">
                        <p class="text-sm font-medium text-gray-700">{{ Auth::user()->name ?? 'Usuario' }}</p>
                        <p class="text-xs text-gray-500">{{ Auth::user()->email ?? 'email@example.com' }}</p>
                    </div>
                    <i class="fas fa-chevron-down text-xs text-gray-400"></i>
                </button>

                <!-- Dropdown Menu -->
                <div x-show="open" 
                     @click.away="open = false"
                     x-cloak
                     class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border border-gray-200 py-2 z-50">
                    <a href="#" class="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-emerald-50 transition-colors">
                        <i class="fas fa-user-circle mr-3 text-gray-400"></i>
                        Mi Perfil
                    </a>
                    <a href="#" class="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-emerald-50 transition-colors">
                        <i class="fas fa-cog mr-3 text-gray-400"></i>
                        Configuración
                    </a>
                    <div class="border-t border-gray-200 my-2"></div>
                    <form method="POST" action="{{ route('logout') }}">
                        @csrf
                        <button type="submit" class="w-full flex items-center px-4 py-2 text-sm text-red-600 hover:bg-red-50 transition-colors">
                            <i class="fas fa-sign-out-alt mr-3"></i>
                            Cerrar Sesión
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</header>
