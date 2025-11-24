<x-guest-layout>
    <!-- Session Status -->
    @if (session('status'))
        <div class="mb-4 p-4 rounded-lg bg-emerald-50 border border-emerald-200 text-emerald-800">
            {{ session('status') }}
        </div>
    @endif

    <form method="POST" action="{{ route('login') }}">
        @csrf

        <!-- Email Address -->
        <div class="mb-5">
            <label for="email" class="block text-sm font-semibold text-gray-700 mb-2">
                <i class="fas fa-envelope text-emerald-600 mr-2"></i>Email
            </label>
            <input id="email" 
                   type="email" 
                   name="email" 
                   value="{{ old('email') }}" 
                   required 
                   autofocus 
                   autocomplete="username"
                   class="w-full px-4 py-3 rounded-lg border-2 border-gray-300 focus:border-emerald-500 focus:ring-2 focus:ring-emerald-200 transition-all duration-200 outline-none {{ $errors->get('email') ? 'border-red-500' : '' }}"
                   placeholder="admin@example.com">
            @if($errors->get('email'))
                <p class="mt-2 text-sm text-red-600">
                    <i class="fas fa-exclamation-circle mr-1"></i>{{ $errors->first('email') }}
                </p>
            @endif
        </div>

        <!-- Password -->
        <div class="mb-5">
            <label for="password" class="block text-sm font-semibold text-gray-700 mb-2">
                <i class="fas fa-lock text-emerald-600 mr-2"></i>Contraseña
            </label>
            <input id="password" 
                   type="password" 
                   name="password" 
                   required 
                   autocomplete="current-password"
                   class="w-full px-4 py-3 rounded-lg border-2 border-gray-300 focus:border-emerald-500 focus:ring-2 focus:ring-emerald-200 transition-all duration-200 outline-none {{ $errors->get('password') ? 'border-red-500' : '' }}"
                   placeholder="••••••••">
            @if($errors->get('password'))
                <p class="mt-2 text-sm text-red-600">
                    <i class="fas fa-exclamation-circle mr-1"></i>{{ $errors->first('password') }}
                </p>
            @endif
        </div>

        <!-- Remember Me & Forgot Password -->
        <div class="flex items-center justify-between mb-6">
            <label for="remember_me" class="flex items-center cursor-pointer">
                <input id="remember_me" 
                       type="checkbox" 
                       name="remember"
                       class="w-4 h-4 rounded border-gray-300 text-emerald-600 focus:ring-emerald-500 focus:ring-2 cursor-pointer">
                <span class="ml-2 text-sm text-gray-600 hover:text-gray-900">Recordarme</span>
            </label>

            @if (Route::has('password.request'))
                <a href="{{ route('password.request') }}" 
                   class="text-sm text-emerald-700 hover:text-emerald-900 font-medium transition-colors">
                    ¿Olvidaste tu contraseña?
                </a>
            @endif
        </div>

        <!-- Submit Button -->
        <button type="submit" 
                class="w-full bg-gradient-to-r from-emerald-700 to-emerald-800 hover:from-emerald-800 hover:to-emerald-900 text-white font-semibold py-3 px-6 rounded-lg shadow-lg hover:shadow-xl transform hover:-translate-y-0.5 transition-all duration-200">
            <i class="fas fa-sign-in-alt mr-2"></i>Iniciar Sesión
        </button>
    </form>

    <!-- Additional Info -->
    <div class="mt-6 text-center">
        <p class="text-xs text-gray-500">
            <i class="fas fa-shield-alt text-emerald-600 mr-1"></i>
            Tus datos están protegidos y seguros
        </p>
    </div>
</x-guest-layout>
