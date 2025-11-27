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
            <div x-data="notificaciones()" x-init="init()" class="relative">
                <button @click="toggleDropdown()" class="relative p-2 text-gray-600 hover:text-emerald-700 transition-colors">
                    <i class="fas fa-bell text-xl"></i>
                    <span x-show="unreadCount > 0" 
                          x-text="unreadCount" 
                          class="absolute -top-1 -right-1 w-5 h-5 bg-red-500 text-white text-xs rounded-full flex items-center justify-center font-semibold"></span>
                </button>
                
                <!-- Dropdown de notificaciones -->
                <div x-show="open" 
                     @click.away="open = false"
                     x-cloak
                     class="absolute right-0 mt-2 w-80 bg-white rounded-lg shadow-lg border border-gray-200 z-50 max-h-96 overflow-y-auto">
                    <!-- Header -->
                    <div class="flex items-center justify-between px-4 py-3 border-b">
                        <h3 class="font-semibold text-gray-800">Notificaciones</h3>
                        <button @click="marcarTodasLeidas()" class="text-xs text-emerald-600 hover:text-emerald-800">
                            Marcar todas como leídas
                        </button>
                    </div>
                    
                    <!-- Lista de notificaciones -->
                    <div class="divide-y">
                        <template x-for="notif in notificaciones" :key="notif.id">
                            <div class="px-4 py-3 hover:bg-gray-50 cursor-pointer" 
                                 @click="marcarLeida(notif.id)"
                                 :class="!notif.leida ? 'bg-emerald-50' : ''">
                                <div class="flex items-start">
                                    <div class="flex-shrink-0">
                                        <i class="fas fa-flask text-emerald-600 text-lg"></i>
                                    </div>
                                    <div class="ml-3 flex-1">
                                        <p class="text-sm font-medium text-gray-800" x-text="notif.mensaje"></p>
                                        <p class="text-xs text-gray-500 mt-1" x-text="formatFecha(notif.fecha_creacion)"></p>
                                    </div>
                                    <span x-show="!notif.leida" class="w-2 h-2 bg-emerald-500 rounded-full ml-2 mt-1"></span>
                                </div>
                            </div>
                        </template>
                        
                        <!-- Mensaje si no hay notificaciones -->
                        <div x-show="notificaciones.length === 0" class="px-4 py-8 text-center text-gray-500">
                            <i class="fas fa-bell-slash text-3xl mb-2"></i>
                            <p class="text-sm">No hay notificaciones</p>
                        </div>
                    </div>
                </div>
            </div>

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

<script>
function notificaciones() {
    return {
        open: false,
        notificaciones: [],
        unreadCount: 0,
        
        init() {
            this.cargarNotificaciones();
            // Recargar cada 10 segundos
            setInterval(() => this.cargarNotificaciones(), 10000);
        },
        
        async cargarNotificaciones() {
            try {
                const response = await fetch('/api/notificaciones');
                const data = await response.json();
                this.notificaciones = data;
                this.unreadCount = data.filter(n => !n.leida).length;
            } catch (error) {
                console.error('Error cargando notificaciones:', error);
            }
        },
        
        toggleDropdown() {
            this.open = !this.open;
        },
        
        async marcarLeida(id) {
            try {
                await fetch(`/api/notificaciones/${id}/marcar-leida`, {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'}
                });
                await this.cargarNotificaciones();
            } catch (error) {
                console.error('Error marcando notificación:', error);
            }
        },
        
        async marcarTodasLeidas() {
            try {
                await fetch('/api/notificaciones/marcar-todas-leidas', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'}
                });
                await this.cargarNotificaciones();
            } catch (error) {
                console.error('Error marcando todas:', error);
            }
        },
        
        formatFecha(fecha) {
            const date = new Date(fecha);
            const ahora = new Date();
            const diff = ahora - date;
            const minutos = Math.floor(diff / 60000);
            const horas = Math.floor(diff / 3600000);
            
            if (minutos < 1) return 'Ahora';
            if (minutos < 60) return `Hace ${minutos} min`;
            if (horas < 24) return `Hace ${horas} h`;
            return date.toLocaleDateString();
        }
    }
}
</script>
